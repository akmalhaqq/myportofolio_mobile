import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

const _project = {
  'title': 'Portofolio Django',
  'category': 'Web',
  'description': 'Deskripsi proyek dari Django',
  'tech_stack': 'Django, Flutter',
  'year': 2026,
  'external_url': 'https://example.com/portfolio',
  'github_url': 'https://example.com/source',
};

MyApp _appWithProjects(Future<http.Response> Function() respond) {
  return MyApp(
    createApiClient: () => ApiClient(
      baseUrl: 'http://portfolio.test:8000',
      client: MockClient((request) {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/v1/projects/');
        expect(request.headers['Authorization'], isNull);
        return respond();
      }),
    ),
  );
}

void main() {
  testWidgets('Home opens public projects, details, and pull-to-refresh', (
    tester,
  ) async {
    final initial = Completer<http.Response>();
    var requests = 0;
    await tester.pumpWidget(
      _appWithProjects(() async {
        requests++;
        if (requests == 1) return initial.future;
        return http.Response(
          jsonEncode([
            {..._project, 'title': 'Proyek Terbaru'},
          ]),
          200,
        );
      }),
    );
    expect(requests, 0);

    await tester.tap(find.text('Lihat Proyek'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(requests, 1);

    initial.complete(http.Response(jsonEncode([_project]), 200));
    await tester.pumpAndSettle();
    expect(find.text('Daftar Proyek'), findsOneWidget);
    expect(
      find.text('Django, Flutter\nDeskripsi proyek dari Django'),
      findsOneWidget,
    );

    await tester.tap(find.text('Portofolio Django'));
    await tester.pumpAndSettle();
    expect(find.text('Detail Proyek'), findsOneWidget);
    expect(find.text('Web • 2026'), findsOneWidget);
    expect(find.text('Deskripsi proyek dari Django'), findsOneWidget);
    expect(find.text('Django, Flutter'), findsOneWidget);
    expect(find.text('https://example.com/portfolio'), findsOneWidget);
    expect(find.text('https://example.com/source'), findsOneWidget);
    expect(find.byType(Image), findsNothing);

    expect(await tester.binding.handlePopRoute(), isTrue);
    await tester.pumpAndSettle();
    expect(requests, 1);

    await tester.drag(find.byType(ListView), const Offset(0, 450));
    await tester.pumpAndSettle();
    expect(find.text('Proyek Terbaru'), findsOneWidget);
    expect(requests, 2);

    expect(await tester.binding.handlePopRoute(), isTrue);
    await tester.pumpAndSettle();
    expect(find.text('Lihat Proyek').hitTestable(), findsOneWidget);
  });

  testWidgets(
    'drawer opens projects and refreshes an empty list before retry',
    (tester) async {
      var requests = 0;
      await tester.pumpWidget(
        _appWithProjects(() async {
          requests++;
          return switch (requests) {
            1 => http.Response('[]', 200),
            2 => http.Response('Server error details', 500),
            _ => http.Response(
              jsonEncode([
                {..._project, 'image': 'img/GAADA_Paper.png'},
              ]),
              200,
            ),
          };
        }),
      );

      Future<void> selectProjects() async {
        await tester.tap(find.byType(DrawerButton));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(ListTile, 'Lihat Proyek'));
        await tester.pumpAndSettle();
      }

      await selectProjects();
      expect(find.text('Belum ada proyek.'), findsOneWidget);

      await selectProjects();
      expect(requests, 1);

      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, 450),
      );
      await tester.pumpAndSettle();
      expect(find.text('Daftar proyek gagal dimuat.'), findsOneWidget);
      expect(find.text('Server error details'), findsNothing);

      await tester.tap(find.text('Coba Lagi'));
      await tester.pumpAndSettle();
      expect(requests, 3);
      await tester.tap(find.text('Portofolio Django'));
      await tester.pumpAndSettle();
      final image = tester.widget<Image>(find.byType(Image));
      expect(
        image.image,
        const NetworkImage(
          'http://portfolio.test:8000/static/img/GAADA_Paper.png',
        ),
      );
    },
  );
}
