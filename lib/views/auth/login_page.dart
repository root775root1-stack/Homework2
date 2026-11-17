import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../models/auth_requests.dart';
import '../../repositories/auth_repository_impl.dart';
import '../../utils/form_validators.dart';
import 'auth_widgets.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  final _controller = AuthController(AuthRepositoryImpl.shared);
  bool _rememberMe = false;
  bool _obscure = true;

  @override
  void dispose() {
    _identifier.dispose();
    _password.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await _controller.login(LoginRequest(
      identifier: _identifier.text.trim(),
      password: _password.text,
      rememberMe: _rememberMe,
    ));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(ok ? 'مرحباً ${_controller.currentUser!.fullName}' : _controller.errorMessage!),
      backgroundColor: ok ? Colors.green : Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'تسجيل دخول الطالب',
      subtitle: 'بوابة الخدمات الأكاديمية',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _identifier,
              validator: FormValidators.loginIdentifier,
              decoration: const InputDecoration(
                labelText: 'المعرف الأكاديمي أو البريد',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _password,
              obscureText: _obscure,
              validator: FormValidators.loginPassword,
              decoration: InputDecoration(
                labelText: 'كلمة المرور',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ),
            Row(
              children: [
                Checkbox(value: _rememberMe, onChanged: (v) => setState(() => _rememberMe = v ?? false)),
                const Text('تذكرني'),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordPage())),
                  child: const Text('نسيت كلمة المرور؟'),
                ),
              ],
            ),
            ListenableBuilder(
              listenable: _controller,
              builder: (context, _) => SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _controller.isLoading ? null : _login,
                  child: _controller.isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('تسجيل الدخول'),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage())),
              child: const Text('ليس لديك حساب؟ إنشاء حساب جديد'),
            ),
            const SizedBox(height: 12),
            const Text('للتجربة: 123456789 / Student1', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
