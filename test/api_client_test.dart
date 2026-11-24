import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  test(
    'uses the Django project schema and authenticates write requests',
    () async {
      const project = {
        'id': '6e0f1f10-60bf-44de-80f4-36b67d640f35',
        'title': 'Portofolio 🚀',
        'category': 'Web',
        'description': 'Portofolio pribadi',
        'tech_stack': 'Flutter, Django',
        'year': 2026,
        'external_url': 'https://example.com/portfolio',
        'image': null,
      };
      final api = ApiClient(
        baseUrl: 'http://localhost:8000/',
        client: MockClient((request) async {
          expect(request.url.authority, 'localhost:8000');
          expect(request.headers['Accept'], 'application/json');
          switch ((request.method, request.url.path)) {
            case ('GET', '/api/v1/projects/'):
              expect(request.headers['Authorization'], isNull);
              return http.Response.bytes(
                utf8.encode(jsonEncode([project])),
                200,
              );
            case ('POST', '/api/v1/auth/token/'):
              expect(jsonDecode(request.body), {
                'username': 'owner',
                'password': 'test-password',
              });
              return http.Response('{"token":"test-token"}', 200);
            case ('POST', '/api/v1/projects/'):
              expect(request.headers['Authorization'], 'Token test-token');
              expect(
                request.headers['Content-Type'],
                'application/json; charset=UTF-8',
              );
              expect(jsonDecode(request.body), {
                'title': 'Portofolio 🚀',
                'category': 'Web',
                'description': 'Portofolio pribadi',
                'tech_stack': 'Flutter, Django',
                'year': 2026,
                'external_url': 'https://example.com/portfolio',
                'github_url': '',
                'image': '',
              });
              return http.Response.bytes(utf8.encode(jsonEncode(project)), 201);
            case ('POST', '/api/v1/auth/logout/'):
              expect(request.headers['Authorization'], 'Token test-token');
              expect(request.body, isEmpty);
              return http.Response('', 204);
            default:
              throw StateError('Unexpected ${request.method} ${request.url}');
          }
        }),
      );
      addTearDown(api.close);

      final fetched = (await api.getProjects()).single;
      expect(fetched.title, project['title']);
      expect(fetched.image, isEmpty);
      expect(fetched.githubUrl, isEmpty);
      final token = await api.obtainToken('owner', 'test-password');
      final created = await api.createProject(fetched, token: token);
      expect(created.id, project['id']);
      await api.logout(token: token);
    },
  );

  test('preserves the HTTP status when the server rejects a token', () async {
    final api = ApiClient(
      client: MockClient(
        (_) async => http.Response('{"detail":"Invalid token."}', 401),
      ),
    );
    addTearDown(api.close);

    await expectLater(
      api.logout(token: 'revoked-token'),
      throwsA(
        isA<ApiException>().having(
          (error) => error.statusCode,
          'statusCode',
          401,
        ),
      ),
    );
  });
}
