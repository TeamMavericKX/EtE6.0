abstract class GithubAuthBase {
  void redirectToGithub();
  Future<String?> handleCallback(String code);
}
