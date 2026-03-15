import 'dart:convert';
import 'dart:html' as html;
import 'package:http/http.dart' as http;

class GithubAuthService {
  static const String clientId = 'Ov23lipOpiWSLYtOIRx4';

  String get _baseUrl {
    final location = html.window.location;
    return '${location.protocol}//${location.host}';
  }

  void redirectToGithub() {
    final redirectUri = '$_baseUrl/';
    final url = 'https://github.com/login/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUri&scope=read:user';
    html.window.location.href = url;
  }

  Future<String?> handleCallback(String code) async {
    try {
      // CALL THE VERCEL PROXY instead of GitHub directly to bypass CORS
      final proxyUrl = '$_baseUrl/api/auth?code=$code';
      
      final tokenResponse = await http.get(
        Uri.parse(proxyUrl),
        headers: {'Accept': 'application/json'},
      );

      if (tokenResponse.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(tokenResponse.body);
        final String? accessToken = data['access_token'];

        if (accessToken != null) {
          final userResponse = await http.get(
            Uri.parse('https://api.github.com/user'),
            headers: {
              'Authorization': 'token $accessToken',
              'Accept': 'application/json',
            },
          );

          if (userResponse.statusCode == 200) {
            final Map<String, dynamic> userData = json.decode(userResponse.body);
            return userData['login'];
          }
        }
      }
      return null;
    } catch (e) {
      print('AUTH_EXC: $e');
      return null;
    }
  }
}
