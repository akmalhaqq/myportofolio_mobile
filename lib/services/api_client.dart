import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/config.dart';
import 'package:myportofolio_mobile/models/project.dart';

class ApiException implements Exception {
  const ApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() => 'ApiException($statusCode)';
}

class ApiClient {
  ApiClient({http.Client? client, String baseUrl = apiBaseUrl})
    : _client = client ?? http.Client(),
      baseUri = Uri.parse(baseUrl);

  static const _projectPath = '/api/v1/projects/';
  static const _jsonHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json; charset=UTF-8',
  };

  final http.Client _client;
  final Uri baseUri;

  Future<List<Project>> getProjects() async {
    final response = await _client.get(
      baseUri.resolve(_projectPath),
      headers: const {'Accept': 'application/json'},
    );
    _ensureSuccess(response);
    final projects =
        jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
    return projects
        .map((item) => Project.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Project> createProject(
    Project project, {
    required String token,
  }) async {
    final response = await _client.post(
      baseUri.resolve(_projectPath),
      headers: {..._jsonHeaders, 'Authorization': 'Token $token'},
      body: jsonEncode(project.toJson()),
    );
    if (response.statusCode != 201) {
      throw ApiException(response.statusCode, response.body);
    }
    final json =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return Project.fromJson(json);
  }

  Future<String> obtainToken(String username, String password) async {
    final response = await _client.post(
      baseUri.resolve('/api/v1/auth/token/'),
      headers: _jsonHeaders,
      body: jsonEncode({'username': username, 'password': password}),
    );
    _ensureSuccess(response);
    final json =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return json['token'] as String;
  }

  Future<void> logout({required String token}) async {
    final response = await _client.post(
      baseUri.resolve('/api/v1/auth/logout/'),
      headers: {'Accept': 'application/json', 'Authorization': 'Token $token'},
    );
    _ensureSuccess(response);
  }

  void close() => _client.close();

  void _ensureSuccess(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(response.statusCode, response.body);
    }
  }
}
