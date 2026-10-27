import 'package:flutter/material.dart';
import '../main.dart';
import 'login_page.dart';

// ============================================================
// HALAMAN AWAL (NEOBRUTALISM HERO)
// ============================================================
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  Widget _buildNeoLogo() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutBack,
      builder: (context, v, child) => Transform.scale(
        scale: v,
        child: child,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: neoDecoration(
              color: kPrimary,
              radius: 60,
              borderWidth: 3.5,
              shadowOffset: 6,
            ),
            child: const Center(
              child: Icon(
                Icons.local_library_rounded,
                color: kBlack,
                size: 58,
              ),
            ),
          ),
          Positioned(
            top: -10,
            right: -14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: neoDecoration(
                color: kPink,
                radius: 8,
                borderWidth: 2,
                shadowOffset: 2.5,
              ),
              child: const Text(
                '★ v2.0 ★',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                  color: kBlack,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _neoBadge(String text, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: neoDecoration(
        color: bg,
        radius: 8,
        borderWidth: 2,
        shadowOffset: 2,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 12,
          letterSpacing: 0.5,
          color: kBlack,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Header sticker
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _neoBadge('📚 DIGITAL LIBRARY', kCyan),
                      const SizedBox(width: 8),
                      _neoBadge('NEO-BRUTALISM', kOrange),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Hero Card Container
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 32),
                    decoration: neoDecoration(
                      color: Colors.white,
                      radius: 24,
                      borderWidth: 3.5,
                      shadowOffset: 7,
                    ),
                    child: Column(
                      children: [
                        _buildNeoLogo(),
                        const SizedBox(height: 24),
                        const Text(
                          'PERPUSTAKAAN\nDIGITAL',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                            height: 1.1,
                            color: kBlack,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: kSoft,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: kBlack, width: 1.5),
                          ),
                          child: const Text(
                            'm.lie ulin nuha',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              color: kBlack,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Halo Sahabat Pembaca! Selamat datang di katalog ilmu & literatur. Pinjam dan kelola buku dengan mudah.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: kMuted,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Action Button 1: Daftar Baru
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimary,
                              foregroundColor: kBlack,
                              elevation: 0,
                              side: const BorderSide(color: kBlack, width: 3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const RegisterPage()),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.how_to_reg_rounded,
                                    size: 22, color: kBlack),
                                SizedBox(width: 10),
                                Text(
                                  'DAFTAR ANGGOTA BARU ➜',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Action Button 2: Masuk Anggota
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: kBlack,
                              side: const BorderSide(color: kBlack, width: 3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginPage()),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.login_rounded,
                                    size: 22, color: kBlack),
                                SizedBox(width: 10),
                                Text(
                                  'MASUK SEBAGAI ANGGOTA ➜',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Quick Account Info / Demo Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: neoDecoration(
                      color: kSoft,
                      radius: 14,
                      borderWidth: 2,
                      shadowOffset: 3,
                    ),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.info_outline_rounded,
                                size: 16, color: kBlack),
                            SizedBox(width: 6),
                            Text(
                              'AKUN DEMO CEPAT',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: kBlack,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Anggota: ulin@gmail.com / ulin123 (m.lie ulin nuha)\nAdmin: adminperpus / password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: kBlack,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}