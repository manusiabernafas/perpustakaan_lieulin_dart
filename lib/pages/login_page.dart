import 'package:flutter/material.dart';
import '../main.dart';

// ============================================================
// HALAMAN LOGIN (NEOBRUTALISM STYLE)
// ============================================================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passController = TextEditingController();
  final _passFocus = FocusNode();
  bool _obscure = true;

  @override
  void dispose() {
    _idController.dispose();
    _passController.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;

    final member =
        MemberRegistry.login(_idController.text, _passController.text);

    if (member == null) {
      showAppSnack(
        context,
        'Username/NIM/Email atau password salah!',
        kError,
        Icons.error_outline_rounded,
      );
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => HomePage(name: member.name)),
      (route) => false,
    );
  }

  void _fillMemberDemo() {
    setState(() {
      _idController.text = 'ulin@gmail.com';
      _passController.text = 'ulin123';
    });
  }

  void _fillAdminDemo() {
    setState(() {
      _idController.text = 'adminperpus';
      _passController.text = 'password';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Center(
            child: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: neoDecoration(
                  color: Colors.white,
                  radius: 10,
                  borderWidth: 2,
                  shadowOffset: 2,
                ),
                child: const Icon(Icons.arrow_back_rounded, color: kBlack, size: 20),
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: neoDecoration(
                        color: kPrimary,
                        radius: 14,
                        borderWidth: 2.5,
                        shadowOffset: 3,
                      ),
                      child: const Icon(Icons.local_library_rounded,
                          color: kBlack, size: 30),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: neoDecoration(
                        color: kCyan,
                        radius: 8,
                        borderWidth: 2,
                        shadowOffset: 2,
                      ),
                      child: const Text(
                        '★ MASUK PORTAL ★',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 11,
                          color: kBlack,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Text(
                  'MASUK AKUN',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    color: kBlack,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Perpustakaan Digital • m.lie ulin nuha',
                  style: TextStyle(
                    color: kMuted,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),

                // Main Form Card
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: neoDecoration(
                    color: Colors.white,
                    radius: 20,
                    borderWidth: 3,
                    shadowOffset: 6,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _idController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: inputStyle(
                            'Username, NIM, atau Email',
                            Icons.account_circle_rounded,
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Username, NIM, atau email tidak boleh kosong'
                              : null,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).requestFocus(_passFocus),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passController,
                          focusNode: _passFocus,
                          obscureText: _obscure,
                          textInputAction: TextInputAction.done,
                          decoration: inputStyle(
                            'Password',
                            Icons.lock_rounded,
                            suffix: IconButton(
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                color: kBlack,
                              ),
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                            ),
                          ),
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'Password tidak boleh kosong'
                              : null,
                          onFieldSubmitted: (_) => _login(),
                        ),
                        const SizedBox(height: 22),
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
                                borderRadius: BorderRadius.circular(12),
                              ),
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: _login,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.login_rounded,
                                    color: kBlack, size: 22),
                                SizedBox(width: 10),
                                Text(
                                  'MASUK SEKARANG ➜',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Quick Demo Autofill Card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: neoDecoration(
                    color: const Color(0xFFFFFDF5),
                    radius: 14,
                    borderWidth: 2,
                    shadowOffset: 3,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'KLIK UNTUK ISI OTOMATIS DEMO:',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                          color: kBlack,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: _fillMemberDemo,
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: neoDecoration(
                                  color: kCyan,
                                  radius: 8,
                                  borderWidth: 1.8,
                                  shadowOffset: 2,
                                ),
                                child: const Center(
                                  child: Text(
                                    '👤 m.lie ulin nuha',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 11.5,
                                      color: kBlack,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: InkWell(
                              onTap: _fillAdminDemo,
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: neoDecoration(
                                  color: kPink,
                                  radius: 8,
                                  borderWidth: 1.8,
                                  shadowOffset: 2,
                                ),
                                child: const Center(
                                  child: Text(
                                    '⚙️ Admin Perpus',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 11.5,
                                      color: kBlack,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}