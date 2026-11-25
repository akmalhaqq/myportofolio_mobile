import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';

import 'auth_test_support.dart';

Finder _field(String label) => find.byWidgetPredicate(
  (widget) => widget is TextField && widget.decoration?.labelText == label,
);

Future<void> _enter(WidgetTester tester, String label, String value) async {
  final field = _field(label);
  await tester.ensureVisible(field);
  await tester.enterText(field, value);
  await tester.pumpAndSettle();
}

Future<void> _tapSave(WidgetTester tester) async {
  final save = find.widgetWithText(ElevatedButton, 'Save');
  await tester.ensureVisible(save);
  expect(save.hitTestable(), findsOneWidget);
  await tester.tap(save);
}

Future<void> _openProjectForm(WidgetTester tester) async {
  await tester.tap(find.byType(DrawerButton));
  await tester.pumpAndSettle();
  await tester.tap(find.widgetWithText(ListTile, 'Add Project'));
  await tester.pumpAndSettle();
  await loginWithTestCredentials(tester);
  expect(find.text('Add Project Form'), findsOneWidget);
}

void main() {
  testWidgets(
    'validates, posts once, and confirms the project saved by Django',
    (tester) async {
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.binding.setSurfaceSize(const Size(400, 550));
      final description = List.filled(
        45,
        'Detail implementasi proyek.',
      ).join('\n');
      final payload = {
        'title': 'MyPortfolio Mobile',
        'category': 'Mobile Development',
        'description': description,
        'tech_stack': 'Flutter, Dart',
        'year': 2026,
        'external_url': 'https://example.com/portfolio',
        'github_url': '',
        'image': 'https://example.com/project.png',
      };
      final saved = {
        ...payload,
        'id': 'server-project-id',
        'title': 'Proyek dari Django',
      };
      final confirmSave = Completer<http.Response>();
      var postCount = 0;
      await tester.pumpWidget(
        appWithAuthApi((request) async {
          if (request.url.path == '/api/v1/auth/token/') {
            return http.Response('{"token":"test-token"}', 200);
          }
          expect(request.url.path, '/api/v1/projects/');
          if (request.method == 'GET') {
            expect(confirmSave.isCompleted, isTrue);
            expect(request.headers['Authorization'], isNull);
            return http.Response(jsonEncode([saved]), 200);
          }
          expect(request.method, 'POST');
          expect(request.headers['Authorization'], 'Token test-token');
          expect(jsonDecode(request.body), payload);
          postCount++;
          if (postCount == 1) return http.Response(jsonEncode(saved), 200);
          return confirmSave.future;
        }),
      );

      await _openProjectForm(tester);
      await _tapSave(tester);
      await tester.pumpAndSettle();
      final dialog = find.byType(AlertDialog);
      expect(dialog, findsNothing);
      expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
      expect(find.text('Deskripsi proyek tidak boleh kosong!'), findsOneWidget);
      expect(
        find.text('Teknologi yang digunakan tidak boleh kosong!'),
        findsOneWidget,
      );

      await _enter(tester, 'Nama Proyek', '  MyPortfolio Mobile  ');
      await _enter(tester, 'Deskripsi Proyek', description);
      final category = find.byType(DropdownButtonFormField<String>);
      await tester.ensureVisible(category);
      await tester.tap(category);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mobile Development').hitTestable());
      await tester.pumpAndSettle();
      await _enter(tester, 'Tahun', '-1');
      await _enter(tester, 'Teknologi yang Digunakan', 'Flutter, Dart');
      await _enter(tester, 'Tautan Proyek', 'example.com/portfolio');
      await _enter(
        tester,
        'URL Gambar (opsional)',
        'ftp://example.com/project.png',
      );
      await _tapSave(tester);
      await tester.pumpAndSettle();
      expect(
        find.text('Masukkan tahun dengan angka yang valid.'),
        findsOneWidget,
      );
      expect(
        find.text('Masukkan URL HTTP atau HTTPS yang valid.'),
        findsNWidgets(2),
      );
      expect(postCount, 0);

      await _enter(tester, 'Tahun', '2026');
      await _enter(tester, 'Tautan Proyek', 'https://example.com/portfolio');
      await _enter(
        tester,
        'URL Gambar (opsional)',
        'https://example.com/project.png',
      );
      await _tapSave(tester);
      await tester.pumpAndSettle();
      expect(dialog, findsNothing);
      expect(
        find.textContaining('Penyimpanan belum terkonfirmasi.'),
        findsOneWidget,
      );
      expect(
        tester.widget<TextField>(_field('Nama Proyek')).controller!.text,
        '  MyPortfolio Mobile  ',
      );

      await _tapSave(tester);
      await tester.pump();
      expect(postCount, 2);
      expect(
        tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
        isNull,
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(dialog, findsNothing);

      confirmSave.complete(http.Response(jsonEncode(saved), 201));
      await tester.pumpAndSettle();
      Finder inDialog(String text) =>
          find.descendant(of: dialog, matching: find.text(text));

      expect(inDialog('Proyek berhasil ditambahkan!'), findsOneWidget);
      expect(inDialog('Nama Proyek: Proyek dari Django'), findsOneWidget);
      expect(inDialog('Deskripsi: $description'), findsOneWidget);
      expect(inDialog('Tahun: 2026'), findsOneWidget);
      final image = inDialog('Gambar: https://example.com/project.png');
      expect(image.hitTestable(), findsNothing);
      await tester.ensureVisible(image);
      await tester.pumpAndSettle();
      expect(image.hitTestable(), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, 'OK'));
      await tester.pumpAndSettle();
      final fields = tester.widgetList<EditableText>(find.byType(EditableText));
      expect(
        fields.map((field) => field.controller.text),
        everyElement(isEmpty),
      );
      expect(
        tester.state<FormFieldState<String>>(category).value,
        'Web Development',
      );

      expect(await tester.binding.handlePopRoute(), isTrue);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Lihat Proyek'));
      await tester.pumpAndSettle();
      expect(find.text('Proyek dari Django'), findsOneWidget);
    },
  );

  testWidgets('keeps the draft on 403 and reauthenticates after a 401', (
    tester,
  ) async {
    var loginCount = 0;
    var postCount = 0;
    await tester.pumpWidget(
      appWithAuthApi((request) async {
        if (request.url.path == '/api/v1/auth/token/') {
          loginCount++;
          return http.Response(
            jsonEncode({'token': 'test-token-$loginCount'}),
            200,
          );
        }
        expect(request.url.path, '/api/v1/projects/');
        expect(request.method, 'POST');
        expect(
          request.headers['Authorization'],
          'Token test-token-$loginCount',
        );
        final payload = jsonDecode(request.body) as Map<String, dynamic>;
        expect(payload, {
          'title': 'Draf proyek',
          'category': 'Web Development',
          'description': 'Ini deskripsi draf.',
          'tech_stack': 'Flutter',
          'year': 2026,
          'external_url': '',
          'github_url': '',
          'image': '',
        });

        postCount++;
        return switch (postCount) {
          1 => http.Response('{}', 403),
          2 => http.Response('{}', 401),
          _ => http.Response(
            jsonEncode({...payload, 'id': 'server-project-id'}),
            201,
          ),
        };
      }),
    );

    await _openProjectForm(tester);
    await _enter(tester, 'Nama Proyek', 'Draf proyek');
    await _enter(tester, 'Deskripsi Proyek', 'Ini deskripsi draf.');
    await _enter(tester, 'Tahun', '2026');
    await _enter(tester, 'Teknologi yang Digunakan', 'Flutter');

    await _tapSave(tester);
    await tester.pumpAndSettle();
    expect(
      find.text('Akun ini tidak punya izin untuk menambahkan proyek.'),
      findsOneWidget,
    );
    expect(find.byType(LoginScreen), findsNothing);
    expect(
      tester.widget<TextField>(_field('Nama Proyek')).controller!.text,
      'Draf proyek',
    );

    await _tapSave(tester);
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    await loginWithTestCredentials(tester);
    expect(find.byType(LoginScreen), findsNothing);
    expect(
      find.text('Login berhasil. Tekan Save untuk mengirim ulang.'),
      findsOneWidget,
    );
    expect(postCount, 2);
    expect(
      tester.widget<TextField>(_field('Nama Proyek')).controller!.text,
      'Draf proyek',
    );

    await _tapSave(tester);
    await tester.pumpAndSettle();
    expect(find.text('Proyek berhasil ditambahkan!'), findsOneWidget);
    expect(postCount, 3);
    expect(loginCount, 2);
  });
}
