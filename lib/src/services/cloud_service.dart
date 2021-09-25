import 'package:password_manager/src/models/UserDetails.dart';
import 'package:password_manager/src/models/password_storage.dart';

abstract class CloudService {
  Future<UserDetails> createSpace({required String email});
  Future<UserDetails> verifyUser({required email, required otp});
  Future<PasswordStorage> createPasswords(
      {required String key, required PasswordStorage data});
  Future<List<PasswordStorage>> fetchAllPasswords({required key});
  Future updateClick({required key, required PasswordStorage passwordStorage});
  Future deletePassword({required key, required id});
}
