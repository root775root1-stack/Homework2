import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../models/auth_requests.dart';
import '../../repositories/auth_repository_impl.dart';
import '../../utils/form_validators.dart';
import 'auth_widgets.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _key = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _id = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _controller = AuthController(AuthRepositoryImpl.shared);
  bool _accepted = false;

  @override
  void dispose() {
    for (final c in [_name, _id, _email, _password, _confirm]) { c.dispose(); }
    _controller.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_key.currentState!.validate()) return;
    if (!_accepted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يجب الموافقة على اللوائح والشروط')));
      return;
    }
    final ok = await _controller.register(RegisterRequest(
      fullName: _name.text.trim(), academicId: _id.text.trim(),
      email: _email.text.trim(), password: _password.text,
    ));
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('تم إنشاء الحساب بنجاح'), backgroundColor: Colors.green));
      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => const LoginPage()), (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_controller.errorMessage!), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'إنشاء حساب طالب',
      subtitle: 'أدخل بياناتك الأكاديمية لإتمام التسجيل',
      child: Form(
        key: _key,
        child: Column(children: [
          TextFormField(controller: _name, validator: FormValidators.fullName,
            decoration: const InputDecoration(labelText: 'الاسم الكامل', prefixIcon: Icon(Icons.badge_outlined))),
          const SizedBox(height: 12),
          TextFormField(controller: _id, keyboardType: TextInputType.number,
            validator: FormValidators.academicId,
            decoration: const InputDecoration(labelText: 'الرقم الأكاديمي', prefixIcon: Icon(Icons.numbers))),
          const SizedBox(height: 12),
          TextFormField(controller: _email, keyboardType: TextInputType.emailAddress,
            validator: FormValidators.universityEmail,
            decoration: const InputDecoration(labelText: 'البريد الجامعي', prefixIcon: Icon(Icons.email_outlined))),
          const SizedBox(height: 12),
          PasswordField(controller: _password, label: 'كلمة المرور الجديدة', validator: FormValidators.strongPassword),
          const SizedBox(height: 12),
          PasswordField(controller: _confirm, label: 'تأكيد كلمة المرور',
            validator: (v) => FormValidators.confirmPassword(v, _password.text)),
          const SizedBox(height: 8),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _accepted,
            onChanged: (v) => setState(() => _accepted = v ?? false),
            title: const Text('أوافق على اللوائح والشروط الأكاديمية'),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: 12),
          ListenableBuilder(
            listenable: _controller,
            builder: (context, _) => SizedBox(width: double.infinity,
              child: FilledButton(
                onPressed: _controller.isLoading ? null : _register,
                child: _controller.isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('إنشاء الحساب'),
              )),
          ),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('لديك حساب؟ تسجيل الدخول')),
        ]),
      ),
    );
  }
}
