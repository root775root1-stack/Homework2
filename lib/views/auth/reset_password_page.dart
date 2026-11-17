import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../models/auth_requests.dart';
import '../../repositories/auth_repository_impl.dart';
import '../../utils/form_validators.dart';
import 'auth_widgets.dart';
import 'login_page.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});
  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _key = GlobalKey<FormState>();
  final _otp = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _controller = AuthController(AuthRepositoryImpl.shared);

  @override
  void dispose() {
    _otp.dispose(); _password.dispose(); _confirm.dispose(); _controller.dispose();
    super.dispose();
  }

  Future<void> _reset() async {
    if (!_key.currentState!.validate()) return;
    final ok = await _controller.resetPassword(ResetPasswordRequest(
      otp: _otp.text.trim(), newPassword: _password.text));
    if (!mounted) return;
    if (ok) {
      await showDialog<void>(context: context, builder: (_) => AlertDialog(
        title: const Text('تم التحديث بنجاح'),
        content: const Text('تم تغيير كلمة المرور. يمكنك الآن تسجيل الدخول.'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('حسناً'))],
      ));
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => const LoginPage()), (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_controller.errorMessage!), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) => AuthScaffold(
    title: 'تعيين كلمة مرور جديدة',
    subtitle: 'أدخل رمز التحقق ثم أنشئ كلمة مرور آمنة',
    child: Form(
      key: _key,
      child: Column(children: [
        TextFormField(controller: _otp, keyboardType: TextInputType.number,
          validator: FormValidators.otp,
          decoration: const InputDecoration(labelText: 'رمز التحقق (6 أرقام)', prefixIcon: Icon(Icons.password))),
        const SizedBox(height: 14),
        PasswordField(controller: _password, label: 'كلمة المرور الجديدة', validator: FormValidators.strongPassword),
        const SizedBox(height: 14),
        PasswordField(controller: _confirm, label: 'تأكيد كلمة المرور',
          validator: (v) => FormValidators.confirmPassword(v, _password.text)),
        const SizedBox(height: 18),
        ListenableBuilder(
          listenable: _controller,
          builder: (context, _) => SizedBox(width: double.infinity,
            child: FilledButton(
              onPressed: _controller.isLoading ? null : _reset,
              child: _controller.isLoading
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('تحديث كلمة المرور'),
            )),
        ),
      ]),
    ),
  );
}
