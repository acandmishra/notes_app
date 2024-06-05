import 'package:notes_app/services/auth/auth_exceptions.dart';
import 'package:notes_app/services/auth/auth_provider.dart';
import 'package:notes_app/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group("Mock Authentication Test Group", () {
    final provider = MockAuthProvider();
    test("Should not be initialized to begin with", () {
      expect(
        provider.isInitialized,
        false,
      );
    });
    test("Can not log out without being initialized", () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });
    test("Should be able to initilaize", () async {
      await provider.initialize();
      expect(
        provider.isInitialized,
        true,
      );
    });
    test("User should be null after initialization", () {
      expect(
        provider.currentUser,
        null,
      );
    });
    test(
      "Should be able to initialize within 2 second",
      () async {
        await provider.initialize();
        expect(
          provider.isInitialized,
          true,
        );
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );
    test("Creating a user should delegate to login function", () async {
      // for below two subtests, first with faulty email and second with faulty password:-
      // await is not needed as we are not actually using firebase ,
      // it's just a mock and we are forecfully throwing exceptions using if else statements
      final badEmailUser = provider.createUser(
        email: "acand",
        password: "random",
      );
      expect(
        badEmailUser,
        throwsA(const TypeMatcher<UserNotFoundAuthException>()),
      );

      final badPasswordUser = provider.createUser(
        email: "acand@gmail.com",
        password: "123",
      );
      expect(
        badPasswordUser,
        throwsA(const TypeMatcher<WrongPasswordAuthException>()),
      );

      final goodUser = await provider.createUser(
        email: "acand@gmail.com",
        password: "random",
      );
      expect(
        provider.currentUser,
        goodUser,
      );
      expect(
        goodUser.isEmailVerified,
        false,
      );
    });
    test(
      "User should be able to verify itself",
      () async {
        await provider.sendEmailVerification();
        final user = provider.currentUser;
        expect(user, isNotNull);
        expect(user!.isEmailVerified, true);
      },
    );

    test(
      "Should be able to log out and log in again",
      () async {
        await provider.logOut();
        await provider.login(
          email: "email",
          password: "password",
        );
        final user = provider.currentUser;
        expect(user, isNotNull);
      },
    );
  });
}

class NotInitializedException implements Exception {}

// Delayed function is used for fake waiting to mock the firebase processing time

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return login(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == "acand") throw UserNotFoundAuthException();
    if (password == "123") throw WrongPasswordAuthException();
    const user = AuthUser(
      id: "id",
      isEmailVerified: false,
      email: 'acandmishra',
    );
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(
      id: "id",
      isEmailVerified: true,
      email: 'acandmishra',
    );
    _user = newUser;
  }
}
