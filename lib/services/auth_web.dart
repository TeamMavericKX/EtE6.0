import 'dart:html' as html;
import 'auth_base.dart';

class GithubAuthImplementation implements GithubAuthBase {
  static const String clientId = 'Ov23lipOpiWSLYtOIRx4';

  @override
  void redirectToGithub() {
    final location = html.window.location;
    final baseUrl = '${location.protocol}//${location.host}';
    final url = 'https://github.com/login/oauth/authorize?client_id=$clientId&redirect_uri=$baseUrl/&scope=read:user';
    html.window.location.href = url;
  }

  @override
  Future<String?> handleCallback(String code) async {
    // Simulated handle for the frontend-only release
    await Future.delayed(const Duration(milliseconds: 500));
    return 'authenticated_user';
  }
}
