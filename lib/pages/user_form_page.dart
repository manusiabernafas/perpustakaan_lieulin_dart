import 'package:flutter/material.dart';
import '../main.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

// ============================================================
// FORM ANGGOTA (NEOBRUTALISM STYLE)
// ============================================================
class UserFormPage extends StatefulWidget {
  final UserModel? user;
  const UserFormPage({super.key, this.user});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _service = UserService();
  late final _first = TextEditingController(text: widget.user?.firstName);
  late final _last = TextEditingController(text: widget.user?.lastName);
  late final _email = TextEditingController(text: widget.user?.email);
  final _lastFocus = FocusNode();
  final _emailFocus = FocusNode();
  bool _loading = false;

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    _email.dispose();
    _lastFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final input = UserModel(
      email: _email.text.trim(),
      firstName: _first.text.trim(),
      lastName: _last.text.trim(),
      avatar: widget.user?.avatar ?? '',
    );

    try {
      final isEdit = widget.user != null;
      final result = isEdit
          ? await _service.updateUser(widget.user!.id!, input)
          : await _service.createUser(input);
      if (!mounted) return;
      showAppSnack(
        context,
        isEdit
            ? 'Data ${result.fullName} berhasil diperbarui!'
            : '${result.fullName} berhasil ditambahkan! (id: ${result.id})',
        kSuccess,
        Icons.check_circle_rounded,
      );
      Navigator.pop(context, result);
    } on ApiException catch (e) {
      if (!mounted) return;
      showAppSnack(
        context,
        'Gagal: ${e.message}',
        kError,
        Icons.error_outline_rounded,
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.user != null;
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: kBlack,
        title: Text(
          (isEdit ? 'EDIT ANGGOTA' : 'TAMBAH ANGGOTA').toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
            color: kBlack,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: neoDecoration(
                color: Colors.white,
                radius: 18,
                borderWidth: 3,
                shadowOffset: 6,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _first,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      decoration:
                          inputStyle('Nama Depan', Icons.person_rounded),
                      validator: (v) => v!.trim().isEmpty
                          ? 'Nama depan tidak boleh kosong'
                          : null,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_lastFocus),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _last,
                      focusNode: _lastFocus,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      decoration: inputStyle(
                          'Nama Belakang', Icons.person_outline_rounded),
                      validator: (v) => v!.trim().isEmpty
                          ? 'Nama belakang tidak boleh kosong'
                          : null,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_emailFocus),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _email,
                      focusNode: _emailFocus,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      decoration: inputStyle('Email', Icons.email_rounded),
                      validator: (v) {
                        if (v!.trim().isEmpty) {
                          return 'Email tidak boleh kosong';
                        }
                        if (!v.contains('@')) {
                          return 'Email harus mengandung "@"';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _submit(),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimary,
                          foregroundColor: kBlack,
                          elevation: 0,
                          side: const BorderSide(color: kBlack, width: 2.8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _loading ? null : _submit,
                        child: _loading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2.8, color: kBlack))
                            : Text(
                                (isEdit
                                        ? 'SIMPAN PERUBAHAN ➜'
                                        : 'TAMBAH ANGGOTA ➜')
                                    .toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}