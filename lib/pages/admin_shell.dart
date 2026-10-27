import 'package:flutter/material.dart';
import '../main.dart';
import '../data/book_store.dart';
import 'welcome_page.dart';
import 'user_list_page.dart';
import 'admin_books_page.dart';
import 'admin_loans_page.dart';

// ============================================================
// KERANGKA HALAMAN ADMIN (NEOBRUTALISM STYLE)
// ============================================================
class PageFrame extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? action;
  final Widget child;

  const PageFrame({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBg,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                        color: kBlack,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          color: kMuted,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              ?action,
            ],
          ),
          const SizedBox(height: 18),
          Expanded(child: child),
        ],
      ),
    );
  }
}

// ============================================================
// SHELL ADMIN + SIDEBAR (NEOBRUTALISM STYLE)
// ============================================================
class AdminShell extends StatefulWidget {
  final String name;
  const AdminShell({super.key, required this.name});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _index = 0;

  static const _menu = <(IconData, String, Color)>[
    (Icons.dashboard_rounded, 'Dashboard', kPrimary),
    (Icons.menu_book_rounded, 'Data Buku', kCyan),
    (Icons.groups_rounded, 'Data Anggota', kPurple),
    (Icons.swap_horiz_rounded, 'Peminjaman', kPink),
  ];

  final List<Widget> _pages = [
    const AdminDashboard(),
    const AdminBooksPage(),
    const UserListPage(),
    const AdminLoansPage(),
  ];

  void _logout() {
    MemberRegistry.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WelcomePage()),
      (route) => false,
    );
  }

  Widget _navTile({
    required IconData icon,
    required String label,
    required Color color,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: neoDecoration(
            color: selected ? color : Colors.white,
            radius: 12,
            borderWidth: 2.2,
            shadowOffset: selected ? 3.5 : 1.5,
          ),
          child: Row(
            children: [
              Icon(icon, size: 22, color: kBlack),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
                    color: kBlack,
                  ),
                ),
              ),
              if (selected)
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: kBlack),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sidebar({required bool inDrawer}) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFFDF5),
        border: Border(
          right: BorderSide(color: kBlack, width: 3.5),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Admin Logo & Title
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: neoDecoration(
                  color: kPrimary,
                  radius: 14,
                  borderWidth: 2.5,
                  shadowOffset: 3,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: kBlack, width: 2),
                      ),
                      child: const Icon(Icons.local_library_rounded,
                          color: kBlack, size: 22),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PERPUSTAKAAN',
                            style: TextStyle(
                              color: kBlack,
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            'Panel Admin',
                            style: TextStyle(
                              color: kBlack,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Profile info
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: neoDecoration(
                color: Colors.white,
                radius: 12,
                borderWidth: 2,
                shadowOffset: 2,
              ),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: kPink,
                      shape: BoxShape.circle,
                      border: Border.all(color: kBlack, width: 2),
                    ),
                    child: const Center(
                      child: Text(
                        'U',
                        style: TextStyle(
                          color: kBlack,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'M. Lie Ulin Nuha',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: kBlack,
                            fontWeight: FontWeight.w900,
                            fontSize: 12.5,
                          ),
                        ),
                        Text(
                          'Administrator',
                          style: TextStyle(
                            color: kMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Navigation Menu
            for (int i = 0; i < _menu.length; i++)
              _navTile(
                icon: _menu[i].$1,
                label: _menu[i].$2,
                color: _menu[i].$3,
                selected: _index == i,
                onTap: () {
                  setState(() => _index = i);
                  if (inDrawer) Navigator.pop(context);
                },
              ),

            const Spacer(),
            const Divider(color: kBlack, thickness: 2),
            const SizedBox(height: 6),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: _logout,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: neoDecoration(
                    color: kPink,
                    radius: 12,
                    borderWidth: 2.2,
                    shadowOffset: 2.5,
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.logout_rounded, size: 20, color: kBlack),
                      SizedBox(width: 10),
                      Text(
                        'KELUAR AKUN',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: kBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final wide = c.maxWidth >= 900;

        if (wide) {
          return Scaffold(
            backgroundColor: kBg,
            body: Row(
              children: [
                SizedBox(width: 280, child: _sidebar(inDrawer: false)),
                Expanded(
                  child: IndexedStack(index: _index, children: _pages),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          backgroundColor: kBg,
          appBar: AppBar(
            backgroundColor: kPrimary,
            foregroundColor: kBlack,
            elevation: 0,
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(3),
              child: Divider(color: kBlack, thickness: 3, height: 3),
            ),
            title: Text(
              _menu[_index].$2.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                letterSpacing: 0.5,
              ),
            ),
          ),
          drawer: Drawer(
            width: 280,
            shape: const RoundedRectangleBorder(),
            child: _sidebar(inDrawer: true),
          ),
          body: IndexedStack(index: _index, children: _pages),
        );
      },
    );
  }
}

// ============================================================
// DASHBOARD ADMIN (NEOBRUTALISM STYLE)
// ============================================================
class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  Widget _stat(IconData icon, String label, String value, Color color) {
    return Container(
      width: 210,
      padding: const EdgeInsets.all(18),
      decoration: neoDecoration(
        color: color,
        radius: 16,
        borderWidth: 2.8,
        shadowOffset: 4.5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: kBlack, width: 2.2),
                ),
                child: Icon(icon, color: kBlack, size: 22),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: kBlack, width: 1.5),
                ),
                child: const Text(
                  'LIVE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: kBlack,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              color: kBlack,
              letterSpacing: -1,
            ),
          ),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: kBlack,
              fontWeight: FontWeight.w800,
              fontSize: 12,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = BookStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final recent = store.loans.take(5).toList();
        return PageFrame(
          title: 'Dashboard',
          subtitle: 'Ringkasan sistem perpustakaan • M. Lie Ulin Nuha',
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _stat(Icons.menu_book_rounded, 'Total Buku',
                        '${store.books.length}', kPrimary),
                    _stat(Icons.library_books_rounded, 'Tersedia',
                        '${store.availableCount}', kCyan),
                    _stat(Icons.bookmark_rounded, 'Sedang Dipinjam',
                        '${store.borrowedCount}', kPink),
                    _stat(Icons.history_rounded, 'Total Transaksi',
                        '${store.loans.length}', kPurple),
                  ],
                ),
                const SizedBox(height: 28),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: neoDecoration(
                    color: kOrange,
                    radius: 8,
                    borderWidth: 2,
                    shadowOffset: 2,
                  ),
                  child: const Text(
                    'TRANSAKSI TERBARU',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                      color: kBlack,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                if (recent.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: neoDecoration(
                      color: Colors.white,
                      radius: 14,
                      borderWidth: 2,
                      shadowOffset: 3,
                    ),
                    child: const Center(
                      child: Text(
                        'Belum ada riwayat transaksi peminjaman.',
                        style: TextStyle(
                          color: kBlack,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                else
                  for (final l in recent)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: neoDecoration(
                        color: Colors.white,
                        radius: 14,
                        borderWidth: 2.2,
                        shadowOffset: 3,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: l.returned ? kSuccess : kPrimary,
                              shape: BoxShape.circle,
                              border: Border.all(color: kBlack, width: 2),
                            ),
                            child: Icon(
                              l.returned
                                  ? Icons.check_circle_rounded
                                  : Icons.bookmark_rounded,
                              color: kBlack,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l.bookTitle,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14.5,
                                    color: kBlack,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Peminjam: ${l.borrower} • ${formatDate(l.date)}',
                                  style: const TextStyle(
                                    color: kMuted,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: l.returned ? kSuccess : kSoft,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: kBlack, width: 1.5),
                            ),
                            child: Text(
                              l.returned ? 'DIKEMBALIKAN' : 'DIPINJAM',
                              style: const TextStyle(
                                color: kBlack,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              ],
            ),
          ),
        );
      },
    );
  }
}