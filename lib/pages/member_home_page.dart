import 'package:flutter/material.dart';
import '../main.dart';
import '../data/book_store.dart';
import 'welcome_page.dart';

// ============================================================
// BERANDA ANGGOTA (NEOBRUTALISM STYLE)
// ============================================================
class MemberHomePage extends StatefulWidget {
  final String name;
  const MemberHomePage({super.key, required this.name});

  @override
  State<MemberHomePage> createState() => _MemberHomePageState();
}

class _MemberHomePageState extends State<MemberHomePage> {
  final _store = BookStore.instance;
  final _searchController = TextEditingController();
  String _query = '';
  String _category = 'Semua';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Book> get _filtered {
    final q = _query.toLowerCase();
    return _store.books.where((b) {
      final matchCat = _category == 'Semua' || b.category == _category;
      final matchQuery = q.isEmpty ||
          b.title.toLowerCase().contains(q) ||
          b.author.toLowerCase().contains(q);
      return matchCat && matchQuery;
    }).toList();
  }

  void _borrow(Book b) {
    _store.borrow(b, widget.name);
    showAppSnack(
      context,
      '"${b.title}" berhasil dipinjam!',
      kSuccess,
      Icons.bookmark_added_rounded,
    );
  }

  void _giveBack(Book b) {
    _store.giveBack(b);
    showAppSnack(
      context,
      '"${b.title}" sudah dikembalikan!',
      kCyan,
      Icons.check_circle_rounded,
    );
  }

  void _logout() {
    MemberRegistry.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WelcomePage()),
      (route) => false,
    );
  }

  Widget _buildStatsCard() {
    final mine = _store.borrowedBy(widget.name);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: neoDecoration(
        color: kPrimary,
        radius: 18,
        borderWidth: 3,
        shadowOffset: 5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: neoDecoration(
                  color: Colors.white,
                  radius: 8,
                  borderWidth: 2,
                  shadowOffset: 2,
                ),
                child: const Text(
                  '★ KOLEKSI BUKU ★',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                    color: kBlack,
                  ),
                ),
              ),
              const Text(
                'Perpustakaan Digital',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: kBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${_store.books.length} BUKU TERDAFTAR',
            style: const TextStyle(
              color: kBlack,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _miniStat(
                  'Tersedia',
                  _store.availableCount,
                  Icons.library_books_rounded,
                  kCyan,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _miniStat(
                  'Dipinjam Saya',
                  mine,
                  Icons.bookmark_rounded,
                  kPink,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, int value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: neoDecoration(
        color: Colors.white,
        radius: 12,
        borderWidth: 2,
        shadowOffset: 2.5,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: kBlack, width: 2),
            ),
            child: Icon(icon, color: kBlack, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    color: kBlack,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '$value',
                  style: const TextStyle(
                    color: kBlack,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    final cats = ['Semua', ...kGenres];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: cats.map((c) {
          final selected = _category == c;
          final color = c == 'Semua' ? kPrimary : (kGenreColors[c] ?? kYellow);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => setState(() => _category = c),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: neoDecoration(
                  color: selected ? color : Colors.white,
                  radius: 10,
                  borderWidth: 2,
                  shadowOffset: selected ? 3 : 1.5,
                ),
                child: Text(
                  c,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
                    color: kBlack,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _actionButton(Book b) {
    if (!b.borrowed) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimary,
          foregroundColor: kBlack,
          elevation: 0,
          side: const BorderSide(color: kBlack, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () => _borrow(b),
        child: const Text(
          'PINJAM ➜',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
        ),
      );
    }
    if (b.borrowedBy == widget.name) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPink,
          foregroundColor: kBlack,
          elevation: 0,
          side: const BorderSide(color: kBlack, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () => _giveBack(b),
        child: const Text(
          'KEMBALIKAN',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900),
        ),
      );
    }
    // Dipinjam anggota lain
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kBlack, width: 1.5),
      ),
      child: const Text(
        'DIPINJAM',
        style: TextStyle(
          color: kMuted,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildBookTile(Book b) {
    final catColor = kGenreColors[b.category] ?? kYellow;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: neoDecoration(
        color: Colors.white,
        radius: 16,
        borderWidth: 2.5,
        shadowOffset: 4,
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 76,
            decoration: neoDecoration(
              color: catColor,
              radius: 10,
              borderWidth: 2,
              shadowOffset: 2,
            ),
            child: Icon(
              kGenreIcons[b.category] ?? Icons.book_rounded,
              color: kBlack,
              size: 32,
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
                    fontSize: 15,
                    color: kBlack,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.edit_note_rounded,
                        size: 15, color: kMuted),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        b.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: kMuted,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: catColor,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: kBlack, width: 1.5),
                  ),
                  child: Text(
                    b.category.toUpperCase(),
                    style: const TextStyle(
                      color: kBlack,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _actionButton(b),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _store,
      builder: (context, _) {
        final books = _filtered;
        return Scaffold(
          backgroundColor: kBg,
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 820),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
                  children: [
                    // Member Profile Header Card
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: neoDecoration(
                        color: Colors.white,
                        radius: 16,
                        borderWidth: 2.5,
                        shadowOffset: 3.5,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: kPrimary,
                              shape: BoxShape.circle,
                              border: Border.all(color: kBlack, width: 2.2),
                            ),
                            child: Center(
                              child: Text(
                                widget.name.isNotEmpty
                                    ? widget.name[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: kBlack,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'ANGGOTA PERPUSTAKAAN',
                                  style: TextStyle(
                                    color: kMuted,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Text(
                                  widget.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: kBlack,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: _logout,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: neoDecoration(
                                color: kPink,
                                radius: 10,
                                borderWidth: 2,
                                shadowOffset: 2,
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.logout_rounded,
                                      size: 16, color: kBlack),
                                  SizedBox(width: 4),
                                  Text(
                                    'KELUAR',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 11,
                                      color: kBlack,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    _buildStatsCard(),
                    const SizedBox(height: 20),

                    // Neo Search Input
                    Container(
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: kBlack,
                            offset: Offset(3.5, 3.5),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (v) => setState(() => _query = v),
                        decoration: inputStyle(
                          'Cari Judul atau Penulis Buku...',
                          Icons.search_rounded,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildCategoryChips(),
                    const SizedBox(height: 22),

                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: neoDecoration(
                            color: kOrange,
                            radius: 8,
                            borderWidth: 2,
                            shadowOffset: 2,
                          ),
                          child: const Text(
                            'KATALOG BUKU',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                              color: kBlack,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '(${books.length} ditemukan)',
                          style: const TextStyle(
                            color: kMuted,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    if (books.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: neoDecoration(
                          color: Colors.white,
                          radius: 16,
                          borderWidth: 2,
                          shadowOffset: 3,
                        ),
                        child: const Center(
                          child: Text(
                            'Buku tidak ditemukan dalam katalog.',
                            style: TextStyle(
                              color: kBlack,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    else
                      ...books.map(_buildBookTile),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}