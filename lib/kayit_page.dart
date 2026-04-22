import 'package:flutter/material.dart';
import 'auth_servisi.dart';
import 'home_page.dart';

class KayitPage extends StatefulWidget {
  const KayitPage({super.key});

  @override
  State<KayitPage> createState() => _KayitPageState();
}

class _KayitPageState extends State<KayitPage> {
  final _formKey = GlobalKey<FormState>();
  final _adController = TextEditingController();
  final _emailController = TextEditingController();
  final _sifreController = TextEditingController();
  final _sifreTekrarController = TextEditingController();
  bool _yukleniyor = false;
  bool _sifreGizli = true;

  @override
  void dispose() {
    _adController.dispose();
    _emailController.dispose();
    _sifreController.dispose();
    _sifreTekrarController.dispose();
    super.dispose();
  }

  Future<void> _kayitOl() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _yukleniyor = true);
    try {
      await AuthServisi.kayitOl(
        _adController.text,
        _emailController.text,
        _sifreController.text,
      );
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        (_) => false,
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
    if (hata.contains('email-already-in-use')) {
      return 'Bu e-posta zaten kullanımda.';
    }
    if (hata.contains('weak-password')) return 'Şifre çok zayıf.';
    if (hata.contains('invalid-email')) return 'Geçersiz e-posta adresi.';
    return 'Kayıt yapılamadı. Tekrar deneyin.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'Hesap Oluştur',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Lokatist\'e katıl',
                    style: TextStyle(color: Colors.white38, fontSize: 14),
                  ),
                  const SizedBox(height: 36),
                  // Ad Soyad
                  TextFormField(
                    controller: _adController,
                    style: const TextStyle(color: Colors.white),
                    textCapitalization: TextCapitalization.words,
                    decoration: _inputDeco('Ad Soyad', Icons.person_outline),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Ad gerekli';
                      if (v.trim().length < 2) return 'En az 2 karakter';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
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
                  const SizedBox(height: 14),
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
                      if (v.length < 6) return 'En az 6 karakter olmalı';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  // Şifre Tekrar
                  TextFormField(
                    controller: _sifreTekrarController,
                    obscureText: _sifreGizli,
                    style: const TextStyle(color: Colors.white),
                    decoration:
                        _inputDeco('Şifre Tekrar', Icons.lock_outline),
                    validator: (v) {
                      if (v != _sifreController.text) {
                        return 'Şifreler eşleşmiyor';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),
                  // Kayıt Butonu
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _yukleniyor ? null : _kayitOl,
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
                              'Kayıt Ol',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  const SizedBox(height: 30),
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
