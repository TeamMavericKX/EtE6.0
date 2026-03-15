import 'auth_base.dart';

class GithubAuthImplementation implements GithubAuthBase {
  @override
  void redirectToGithub() {
    // Native platforms would use url_launcher here
    // For CI/CD to pass, we provide a stub
  }

  @override
  Future<String?> handleCallback(String code) async {
    return null;
  }
}
