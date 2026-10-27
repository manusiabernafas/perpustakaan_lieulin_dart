import 'package:flutter/material.dart';
import '../main.dart';
import '../data/book_store.dart';
import 'admin_shell.dart';

// ============================================================
// ADMIN: RIWAYAT PEMINJAMAN (NEOBRUTALISM STYLE)
// ============================================================
class AdminLoansPage extends StatelessWidget {
  const AdminLoansPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = BookStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final loans = store.loans;
        return PageFrame(
          title: 'Peminjaman',
          subtitle: '${store.borrowedCount} buku sedang dalam masa peminjaman',
          child: loans.isEmpty
              ? Container(
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
                      'Belum ada transaksi peminjaman buku.',
                      style: TextStyle(
                        color: kBlack,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: loans.length,
                  itemBuilder: (_, i) {
                    final l = loans[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: neoDecoration(
                        color: Colors.white,
                        radius: 16,
                        borderWidth: 2.2,
                        shadowOffset: 3.5,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
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
                              size: 22,
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
                                    fontSize: 15,
                                    color: kBlack,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Peminjam: ${l.borrower}\n'
                                  'Dipinjam: ${formatDate(l.date)}'
                                  '${l.returned ? '\nDikembalikan: ${formatDate(l.returnedAt!)}' : ''}',
                                  style: const TextStyle(
                                    color: kMuted,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (!l.returned)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimary,
                                foregroundColor: kBlack,
                                elevation: 0,
                                side: const BorderSide(color: kBlack, width: 2),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                final idx = store.books
                                    .indexWhere((b) => b.id == l.bookId);
                                if (idx != -1) {
                                  store.giveBack(store.books[idx]);
                                  showAppSnack(
                                    context,
                                    '"${l.bookTitle}" ditandai sudah kembali!',
                                    kSuccess,
                                    Icons.check_circle_rounded,
                                  );
                                }
                              },
                              child: const Text(
                                'TANDAI KEMBALI',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: kSuccess,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: kBlack, width: 1.5),
                              ),
                              child: const Text(
                                'SELESAI',
                                style: TextStyle(
                                  color: kBlack,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}