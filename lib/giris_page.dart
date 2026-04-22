import 'package:flutter/material.dart';
import 'auth_servisi.dart';
import 'kayit_page.dart';
import 'home_page.dart';

class GirisPage extends StatefulWidget {
  const GirisPage({super.key});

  @override
  State<GirisPage> createState() => _GirisPageState();
}

class _GirisPageState extends State<GirisPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _sifreController = TextEditingController();
  bool _yukleniyor = false;
  bool _sifreGizli = true;

  @override
  void dispose() {
    _emailController.dispose();
    _sifreController.dispose();
    super.dispose();
  }

  Future<void> _girisYap() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _yukleniyor = true);
    try {
      await AuthServisi.girisYap(_emailController.text, _sifreController.text);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_hataMetni(e.toString())),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _yukleniyor = false);
    }
  }

  String _hataMetni(String hata) {
    if (hata.contains('user-not-found')) return 'Bu e-posta ile hesap bulunamadı.';
    if (hata.contains('wrong-password')) return 'Şifre yanlış.';
    if (hata.contains('invalid-email')) return 'Geçersiz e-posta adresi.';
    if (hata.contains('too-many-requests')) return 'Çok fazla deneme. Lütfen bekleyin.';
    if (hata.contains('invalid-credential')) return 'E-posta veya şifre hatalı.';
    return 'Giriş yapılamadı. Tekrar deneyin.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // Logo
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD4A574).withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset('assets/images/app_icon.png',
                          fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'LOKATİST',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD4A574),
                      letterSpacing: 6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Hesabına giriş yap',
                    style: TextStyle(color: Colors.white38, fontSize: 14),
                  ),
                  const SizedBox(height: 40),
                  // E-posta
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDeco('E-posta', Icons.email_outlined),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'E-posta gerekli';
                      if (!v.contains('@')) return 'Geçerli e-posta girin';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Şifre
                  TextFormField(
                    controller: _sifreController,
                    obscureText: _sifreGizli,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDeco(
                      'Şifre',
                      Icons.lock_outline,
                      suffix: IconButton(
                        icon: Icon(
                          _sifreGizli
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white38,
                          size: 20,
                        ),
                        onPressed: () =>
                            setState(() => _sifreGizli = !_sifreGizli),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Şifre gerekli';
                      if (v.length < 6) return 'En az 6 karakter';
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),
                  // Giriş Butonu
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _yukleniyor ? null : _girisYap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0056b3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _yukleniyor
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Giriş Yap',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Kayıt ol linki
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Hesabın yok mu?',
                          style: TextStyle(color: Colors.white38)),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const KayitPage()),
                          );
                        },
                        child: const Text(
                          'Kayıt Ol',
                          style: TextStyle(
                            color: Color(0xFF0056b3),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String hint, IconData icon, {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38),
      prefixIcon: Icon(icon, color: const Color(0xFF0056b3), size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFF161616),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      errorStyle: const TextStyle(color: Colors.redAccent),
    );
  }
}
