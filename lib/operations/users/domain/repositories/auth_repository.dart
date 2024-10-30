
import '../entities/user_data_entity.dart';

abstract class AuthRepository {
// Single Responsibility: Each Repository has a single responsibility,
// which is to provide data for a specific type of entity.

  Stream<UserData> get currentUser;

  Future<UserData> signUp({
    required String email,
    required String password,
  });

  Future<UserData> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();
}