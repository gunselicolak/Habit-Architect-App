import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Projeniz için Firebase yapılandırmasını içeren dosyayı buraya ekleyin.
// firebase_options.dart dosyasını oluşturmak için Firebase CLI'yı kullanmanız gerekir.
// flutterfire configure komutunu çalıştırın.
import 'firebase_options.dart';

// Ana işlev, uygulamanın başladığı yerdir.
void main() async {
  // Firebase'i başlatmadan önce Flutter'ın hazır olduğundan emin olun.
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Firebase uygulamasını başlatın.
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Firebase başlatma hatasını konsola yazdırın.
    print("Firebase başlatılırken bir hata oluştu: $e");
  }
  runApp(const MyApp());
}

// Uygulamanın temelini oluşturan ana widget.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // Kullanıcının oturum açıp açmadığını kontrol eden widget.
      home: const AuthWrapper(),
    );
  }
}

// Oturum durumuna göre yönlendirme yapan widget.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // StreamBuilder, FirebaseAuth'ın oturum durumunu dinler.
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Bağlantı bekleme durumundaysa yükleme göstergesi gösterin.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        // Kullanıcı oturum açmışsa ana sayfaya yönlendirin.
        if (snapshot.hasData) {
          return const HomePage();
        }
        // Kullanıcı oturum açmamışsa giriş sayfasına yönlendirin.
        return const LoginPage();
      },
    );
  }
}

// Giriş sayfası widget'ı.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // E-posta ve şifre için kontrolcüler.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // Yükleme durumunu yönetir.
  String? _errorMessage; // Hata mesajını tutar.

  // Kullanıcı giriş yapma işlevi.
  Future<void> _signInWithEmailAndPassword() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      // Firebase kimlik doğrulama hatalarını yakalar.
      String message;
      if (e.code == 'user-not-found') {
        message = 'Bu e-posta adresine sahip bir kullanıcı bulunamadı.';
      } else if (e.code == 'wrong-password') {
        message = 'Yanlış şifre. Lütfen tekrar deneyin.';
      } else {
        message = 'Giriş yaparken bir hata oluştu: ${e.message}';
      }
      setState(() {
        _errorMessage = message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Bilinmeyen bir hata oluştu.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giriş Yap'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // E-posta giriş alanı.
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-posta',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16.0),
            // Şifre giriş alanı.
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Şifre',
                border: OutlineInputBorder(),
              ),
              obscureText: true, // Şifreyi gizler.
            ),
            const SizedBox(height: 24.0),
            // Hata mesajı gösterimi.
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            // Giriş yap butonu.
            _isLoading
                ? const CircularProgressIndicator() // Yükleme göstergesi.
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _signInWithEmailAndPassword,
                      child: const Text('Giriş Yap'),
                    ),
                  ),
            const SizedBox(height: 16.0),
            // Kayıt sayfasına gitme butonu.
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const RegistrationPage()),
                );
              },
              child: const Text('Hesabın yok mu? Kayıt Ol'),
            ),
          ],
        ),
      ),
    );
  }
}

// Kayıt sayfası widget'ı.
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  // Yeni kullanıcı kaydetme işlevi.
  Future<void> _registerWithEmailAndPassword() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Başarılı kayıt sonrası bir önceki sayfaya dönün.
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'weak-password') {
        message = 'Şifre çok zayıf.';
      } else if (e.code == 'email-already-in-use') {
        message = 'Bu e-posta adresi zaten kullanılıyor.';
      } else {
        message = 'Kayıt olurken bir hata oluştu: ${e.message}';
      }
      setState(() {
        _errorMessage = message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Bilinmeyen bir hata oluştu.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kayıt Ol'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // E-posta giriş alanı.
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-posta',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16.0),
            // Şifre giriş alanı.
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Şifre',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24.0),
            // Hata mesajı gösterimi.
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            // Kayıt ol butonu.
            _isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _registerWithEmailAndPassword,
                      child: const Text('Kayıt Ol'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

// Başarılı giriş sonrası gösterilecek ana sayfa.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Oturumu kapatma işlevi.
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
        actions: [
          // Çıkış yap butonu.
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hoş geldiniz!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            // Kullanıcının e-posta adresini gösterin.
            if (user != null)
              Text(
                'Oturum açmış kullanıcı: ${user.email}',
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
