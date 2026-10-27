import 'package:flutter/material.dart';
import '../main.dart';
import '../data/book_store.dart';
import 'admin_shell.dart';

// ============================================================
// ADMIN: DATA BUKU CRUD (NEOBRUTALISM STYLE)
// ============================================================
class AdminBooksPage extends StatefulWidget {
  const AdminBooksPage({super.key});

  @override
  State<AdminBooksPage> createState() => _AdminBooksPageState();
}

class _AdminBooksPageState extends State<AdminBooksPage> {
  final _store = BookStore.instance;
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ---------------- FORM TAMBAH / UBAH ----------------
  Future<void> _openForm({Book? book}) async {
    final formKey = GlobalKey<FormState>();
    final title = TextEditingController(text: book?.title ?? '');
    final author = TextEditingController(text: book?.author ?? '');
    String category = book?.category ?? kGenres.first;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: kBlack, width: 3),
          ),
          title: Text(
            (book == null ? 'TAMBAH BUKU' : 'UBAH BUKU').toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              letterSpacing: 0.5,
              color: kBlack,
            ),
          ),
          content: SizedBox(
            width: 440,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: title,
                    textCapitalization: TextCapitalization.words,
                    decoration:
                        inputStyle('Judul Buku', Icons.menu_book_rounded),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Judul tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: author,
                    textCapitalization: TextCapitalization.words,
                    decoration: inputStyle('Penulis', Icons.person_rounded),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Penulis tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: category,
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: kBlack),
                    decoration: inputStyle('Kategori', Icons.category_rounded),
                    items: kGenres
                        .map((g) => DropdownMenuItem(
                              value: g,
                              child: Text(
                                g,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700),
                              ),
                            ))
                        .toList(),
                    onChanged: (v) => setS(() => category = v ?? category),
                  ),
                ],
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
                    borderRadius: BorderRadius.circular(10)),
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
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                if (book == null) {
                  _store.add(title.text, author.text, category);
                  showAppSnack(context, 'Buku berhasil ditambahkan!', kSuccess,
                      Icons.check_circle_rounded);
                } else {
                  _store.update(book, title.text, author.text, category);
                  showAppSnack(context, 'Buku berhasil diperbarui!', kCyan,
                      Icons.check_circle_rounded);
                }
                Navigator.pop(ctx);
              },
              child: const Text(
                'SIMPAN ➜',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      ),
    );

    title.dispose();
    author.dispose();
  }

  // ---------------- HAPUS ----------------
  Future<void> _confirmDelete(Book b) async {
    if (b.borrowed) {
      showAppSnack(
        context,
        '"${b.title}" sedang dipinjam ${b.borrowedBy}, tidak bisa dihapus!',
        kOrange,
        Icons.warning_amber_rounded,
      );
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: kBlack, width: 3),
        ),
        title: const Text(
          'HAPUS BUKU?',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: kBlack,
            letterSpacing: 0.5,
          ),
        ),
        content: Text(
          'Yakin ingin menghapus "${b.title}" dari katalog perpustakaan?',
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
    if (ok == true) {
      _store.delete(b);
      if (mounted) {
        showAppSnack(
          context,
          'Buku berhasil dihapus!',
          kError,
          Icons.delete_forever_rounded,
        );
      }
    }
  }

  // ---------------- UI ----------------
  Widget _bookCard(Book b) {
    final catColor = kGenreColors[b.category] ?? kYellow;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: neoDecoration(
        color: Colors.white,
        radius: 14,
        borderWidth: 2.2,
        shadowOffset: 3.5,
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 68,
            decoration: neoDecoration(
              color: catColor,
              radius: 10,
              borderWidth: 2,
              shadowOffset: 2,
            ),
            child: Icon(
              kGenreIcons[b.category] ?? Icons.book_rounded,
              color: kBlack,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  b.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14.5,
                    color: kBlack,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  b.author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: kMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _chip(b.category.toUpperCase(), catColor, kBlack),
                    b.borrowed
                        ? _chip('DIPINJAM: ${b.borrowedBy}', kOrange, kBlack)
                        : _chip('TERSEDIA', kSuccess, kBlack),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          // Edit Neo Button
          InkWell(
            onTap: () => _openForm(book: b),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: neoDecoration(
                color: kCyan,
                radius: 8,
                borderWidth: 1.8,
                shadowOffset: 2,
              ),
              child: const Icon(Icons.edit_rounded, color: kBlack, size: 18),
            ),
          ),
          const SizedBox(width: 8),
          // Delete Neo Button
          InkWell(
            onTap: () => _confirmDelete(b),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: neoDecoration(
                color: kPink,
                radius: 8,
                borderWidth: 1.8,
                shadowOffset: 2,
              ),
              child: const Icon(Icons.delete_rounded, color: kBlack, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text, Color bg, Color fg) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: kBlack, width: 1.5),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: fg,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.3,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _store,
      builder: (context, _) {
        final q = _query.toLowerCase();
        final list = _store.books.where((b) {
          return q.isEmpty ||
              b.title.toLowerCase().contains(q) ||
              b.author.toLowerCase().contains(q) ||
              b.category.toLowerCase().contains(q);
        }).toList();

        return PageFrame(
          title: 'Data Buku',
          subtitle: '${_store.books.length} buku terdaftar dalam katalog',
          action: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimary,
              foregroundColor: kBlack,
              elevation: 0,
              side: const BorderSide(color: kBlack, width: 2.5),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => _openForm(),
            icon: const Icon(Icons.add_rounded, size: 20),
            label: const Text(
              'TAMBAH BUKU',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
            ),
          ),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: kBlack,
                      offset: Offset(3, 3),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _query = v),
                  decoration: inputStyle(
                    'Cari Judul, Penulis, atau Kategori...',
                    Icons.search_rounded,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: list.isEmpty
                    ? Container(
                        padding: const EdgeInsets.all(32),
                        decoration: neoDecoration(
                          color: Colors.white,
                          radius: 14,
                          borderWidth: 2,
                          shadowOffset: 3,
                        ),
                        child: const Center(
                          child: Text(
                            'Buku tidak ditemukan.',
                            style: TextStyle(
                              color: kBlack,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      )
                    : ListView(children: list.map(_bookCard).toList()),
              ),
            ],
          ),
        );
      },
    );
  }
}