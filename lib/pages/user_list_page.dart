import 'package:flutter/material.dart';
import '../main.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import 'admin_shell.dart' show PageFrame;

// ============================================================
// ADMIN: DATA ANGGOTA VIA REST API (NEOBRUTALISM STYLE)
// ============================================================
class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final _service = UserService();

  List<UserModel> _users = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  // ---------------- READ ----------------
  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await _service.getUsers();
      if (!mounted) return;
      setState(() => _users = data);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Terjadi kesalahan: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _snack(String msg, {bool error = false}) {
    showAppSnack(
      context,
      msg,
      error ? kError : kSuccess,
      error ? Icons.error_outline_rounded : Icons.check_circle_rounded,
    );
  }

  // ---------------- FORM (tambah / ubah) ----------------
  Future<UserModel?> _showForm({UserModel? user}) {
    final formKey = GlobalKey<FormState>();
    final firstCtrl = TextEditingController(text: user?.firstName ?? '');
    final lastCtrl = TextEditingController(text: user?.lastName ?? '');
    final emailCtrl = TextEditingController(text: user?.email ?? '');

    return showDialog<UserModel>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: kBlack, width: 3),
        ),
        title: Text(
          (user == null ? 'TAMBAH ANGGOTA' : 'UBAH ANGGOTA').toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20,
            letterSpacing: 0.5,
            color: kBlack,
          ),
        ),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: SizedBox(
              width: 380,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: firstCtrl,
                    decoration: inputStyle('Nama Depan', Icons.person_rounded),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Nama depan wajib diisi'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: lastCtrl,
                    decoration:
                        inputStyle('Nama Belakang', Icons.person_outline_rounded),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Nama belakang wajib diisi'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: inputStyle('Email Anggota', Icons.email_rounded),
                    validator: (v) {
                      final t = v?.trim() ?? '';
                      if (t.isEmpty) return 'Email wajib diisi';
                      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(t)) {
                        return 'Format email tidak valid';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: kBlack,
              side: const BorderSide(color: kBlack, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimary,
              foregroundColor: kBlack,
              elevation: 0,
              side: const BorderSide(color: kBlack, width: 2.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              Navigator.pop(
                ctx,
                UserModel(
                  id: user?.id ?? 0,
                  firstName: firstCtrl.text.trim(),
                  lastName: lastCtrl.text.trim(),
                  email: emailCtrl.text.trim(),
                  avatar: user?.avatar ?? '',
                ),
              );
            },
            child: const Text(
              'SIMPAN ➜',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- CREATE ----------------
  Future<void> _add() async {
    final input = await _showForm();
    if (input == null) return;
    try {
      final created = await _service.createUser(input);
      if (!mounted) return;
      setState(() => _users.insert(0, created));
      _snack('Anggota berhasil ditambahkan!');
    } on ApiException catch (e) {
      if (mounted) _snack(e.message, error: true);
    }
  }

  // ---------------- UPDATE ----------------
  Future<void> _edit(UserModel old) async {
    final input = await _showForm(user: old);
    if (input == null) return;
    final oldId = old.id;
    if (oldId == null) return;
    try {
      final updated = await _service.updateUser(oldId, input);
      if (!mounted) return;
      setState(() {
        final i = _users.indexWhere((u) => u.id == old.id);
        if (i != -1) _users[i] = updated;
      });
      _snack('Data anggota berhasil diubah!');
    } on ApiException catch (e) {
      if (mounted) _snack(e.message, error: true);
    }
  }

  // ---------------- DELETE ----------------
  Future<void> _delete(UserModel u) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: kBlack, width: 3),
        ),
        title: const Text(
          'HAPUS ANGGOTA?',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: kBlack,
            letterSpacing: 0.5,
          ),
        ),
        content: Text(
          'Yakin ingin menghapus anggota "${u.fullName}"?',
          style: const TextStyle(fontWeight: FontWeight.w600, color: kBlack),
        ),
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: kBlack,
              side: const BorderSide(color: kBlack, width: 2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kError,
              foregroundColor: Colors.white,
              elevation: 0,
              side: const BorderSide(color: kBlack, width: 2.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('HAPUS',
                style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final uid = u.id;
    if (uid == null) return;
    try {
      await _service.deleteUser(uid);
      if (!mounted) return;
      setState(() => _users.removeWhere((x) => x.id == u.id));
      _snack('Anggota berhasil dihapus!');
    } on ApiException catch (e) {
      if (mounted) _snack(e.message, error: true);
    }
  }

  // ---------------- UI ----------------
  Widget _avatar(UserModel u) {
    final initial =
        u.firstName.isNotEmpty ? u.firstName[0].toUpperCase() : '?';
    if (u.avatar.isEmpty) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: kSoft,
          shape: BoxShape.circle,
          border: Border.all(color: kBlack, width: 2),
        ),
        child: Center(
          child: Text(
            initial,
            style: const TextStyle(
              color: kBlack,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
        ),
      );
    }
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: kBlack, width: 2),
      ),
      child: ClipOval(
        child: Image.network(
          u.avatar,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(
            color: kSoft,
            child: Center(
              child: Text(
                initial,
                style: const TextStyle(
                  color: kBlack,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _body() {
    if (_loading) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: neoDecoration(
            color: Colors.white,
            radius: 14,
            borderWidth: 2.5,
            shadowOffset: 4,
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: kBlack, strokeWidth: 3),
              SizedBox(height: 14),
              Text(
                'Memuat Data Anggota...',
                style: TextStyle(fontWeight: FontWeight.w800, color: kBlack),
              ),
            ],
          ),
        ),
      );
    }
    if (_error != null) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: neoDecoration(
            color: Colors.white,
            radius: 16,
            borderWidth: 2.5,
            shadowOffset: 4,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_rounded, size: 48, color: kError),
              const SizedBox(height: 12),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: kBlack, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimary,
                  foregroundColor: kBlack,
                  elevation: 0,
                  side: const BorderSide(color: kBlack, width: 2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _load,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text(
                  'COBA LAGI',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (_users.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: neoDecoration(
          color: Colors.white,
          radius: 16,
          borderWidth: 2.5,
          shadowOffset: 4,
        ),
        child: const Center(
          child: Text(
            'Belum ada data anggota perpustakaan.',
            style: TextStyle(
              color: kBlack,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      color: kBlack,
      child: ListView.separated(
        itemCount: _users.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final u = _users[i];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: neoDecoration(
              color: Colors.white,
              radius: 14,
              borderWidth: 2.2,
              shadowOffset: 3,
            ),
            child: Row(
              children: [
                _avatar(u),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        u.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14.5,
                          color: kBlack,
                        ),
                      ),
                      Text(
                        u.email,
                        style: const TextStyle(
                          color: kMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                // Edit Neo button
                InkWell(
                  onTap: () => _edit(u),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: neoDecoration(
                      color: kCyan,
                      radius: 8,
                      borderWidth: 1.8,
                      shadowOffset: 2,
                    ),
                    child:
                        const Icon(Icons.edit_rounded, color: kBlack, size: 18),
                  ),
                ),
                const SizedBox(width: 8),
                // Delete Neo button
                InkWell(
                  onTap: () => _delete(u),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: neoDecoration(
                      color: kPink,
                      radius: 8,
                      borderWidth: 1.8,
                      shadowOffset: 2,
                    ),
                    child: const Icon(Icons.delete_rounded,
                        color: kBlack, size: 18),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: 'Data Anggota',
      subtitle: 'Kelola anggota perpustakaan (REST API) • M. Lie Ulin Nuha',
      action: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimary,
          foregroundColor: kBlack,
          elevation: 0,
          side: const BorderSide(color: kBlack, width: 2.5),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: _add,
        icon: const Icon(Icons.person_add_alt_1_rounded, size: 20),
        label: const Text(
          'TAMBAH ANGGOTA',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
        ),
      ),
      child: _body(),
    );
  }
}