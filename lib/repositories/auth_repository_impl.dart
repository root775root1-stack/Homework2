import '../models/auth_requests.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  static final AuthRepositoryImpl shared = AuthRepositoryImpl._();
  AuthRepositoryImpl._();

  final List<UserModel> _users = [
    const UserModel(
      fullName: 'طالب تجريبي',
      academicId: '123456789',
      universityEmail: 'student@university.edu',
      password: 'Student1',
    ),
  ];

  String? _lastResetIdentifier;

  Future<void> _simulateNetwork() =>
      Future.delayed(const Duration(seconds: 1));

  @override
  Future<UserModel> login(LoginRequest request) async {
    await _simulateNetwork();
    final user = _users.where((u) =>
      (u.academicId == request.identifier ||
       u.universityEmail.toLowerCase() == request.identifier.toLowerCase()) &&
      u.password == request.password
    );
    if (user.isEmpty) {
      throw Exception('بيانات الدخول غير صحيحة');
    }
    return user.first;
  }

  @override
  Future<void> register(RegisterRequest request) async {
    await _simulateNetwork();
    final exists = _users.any((u) =>
      u.academicId == request.academicId ||
      u.universityEmail.toLowerCase() == request.email.toLowerCase()
    );
    if (exists) throw Exception('الرقم الأكاديمي أو البريد مسجل مسبقاً');

    _users.add(UserModel(
      fullName: request.fullName,
      academicId: request.academicId,
      universityEmail: request.email,
      password: request.password,
    ));
  }

  @override
  Future<void> sendPasswordResetCode(PasswordResetRequest request) async {
    await _simulateNetwork();
    final found = _users.any((u) =>
      u.academicId == request.identifier ||
      u.universityEmail.toLowerCase() == request.identifier.toLowerCase()
    );
    if (!found) throw Exception('لم يتم العثور على حساب بهذه البيانات');
    _lastResetIdentifier = request.identifier;
  }

  @override
  Future<void> resetPassword(ResetPasswordRequest request) async {
    await _simulateNetwork();
    if (request.otp != '123456') {
      throw Exception('رمز التحقق غير صحيح (للتجربة استخدم 123456)');
    }
    if (_lastResetIdentifier == null) {
      throw Exception('يرجى طلب رمز تحقق أولاً');
    }

    final index = _users.indexWhere((u) =>
      u.academicId == _lastResetIdentifier ||
      u.universityEmail.toLowerCase() == _lastResetIdentifier!.toLowerCase()
    );
    if (index < 0) throw Exception('الحساب غير موجود');

    final old = _users[index];
    _users[index] = UserModel(
      fullName: old.fullName,
      academicId: old.academicId,
      universityEmail: old.universityEmail,
      password: request.newPassword,
    );
    _lastResetIdentifier = null;
  }
}
