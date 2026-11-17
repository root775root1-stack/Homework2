import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../models/auth_requests.dart';
import '../../repositories/auth_repository_impl.dart';
import '../../utils/form_validators.dart';
import 'auth_widgets.dart';
import 'reset_password_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _key = GlobalKey<FormState>();
  final _identifier = TextEditingController();
  final _controller = AuthController(AuthRepositoryImpl.shared);

  @override
  void dispose() { _identifier.dispose(); _controller.dispose(); super.dispose(); }

  Future<void> _send() async {
    if (!_key.currentState!.validate()) return;
    final ok = await _controller.sendPasswordResetCode(
      PasswordResetRequest(identifier: _identifier.text.trim()));
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('تم إرسال رمز التحقق (رمز التجربة: 123456)'),
        backgroundColor: Colors.green));
      Navigator.push(context, MaterialPageRoute(builder: (_) => const ResetPasswordPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_controller.errorMessage!), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) => AuthScaffold(
    title: 'استعادة كلمة المرور',
    subtitle: 'استعد الوصول إلى حسابك الأكاديمي',
    child: Form(
      key: _key,
      child: Column(children: [
        Card(
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Row(children: [
              Icon(Icons.mark_email_read_outlined, size: 32, color: Color(0xFF2457C5)),
              SizedBox(width: 12),
              Expanded(child: Text('سنرسل رمز تحقق إلى بيانات الحساب المسجلة. أدخل بريدك الجامعي أو رقمك الأكاديمي للمتابعة.')),
            ]),
          ),
        ),
        const SizedBox(height: 18),
        TextFormField(controller: _identifier, validator: FormValidators.loginIdentifier,
          decoration: const InputDecoration(labelText: 'البريد أو الرقم الأكاديمي', prefixIcon: Icon(Icons.person_outline))),
        const SizedBox(height: 16),
        ListenableBuilder(
          listenable: _controller,
          builder: (context, _) => SizedBox(width: double.infinity,
            child: FilledButton(
              onPressed: _controller.isLoading ? null : _send,
              child: _controller.isLoading
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('إرسال رمز التحقق'),
            )),
        ),
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('العودة لتسجيل الدخول')),
      ]),
    ),
  );
}
