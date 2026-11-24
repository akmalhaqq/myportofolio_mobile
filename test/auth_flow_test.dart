import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

import 'auth_test_support.dart';

void main() {
  testWidgets('Home guards the form and logs out through the API', (
    tester,
  ) async {
    final invalidLogin = Completer<http.Response>();
    var loginRequests = 0;
    var logoutRequests = 0;
    await tester.pumpWidget(
      appWithAuthApi((request) async {
        expect(request.method, 'POST');
        if (request.url.path == '/api/v1/auth/token/') {
          expect(jsonDecode(request.body), {
            'username': 'tester',
            'password': 'test-password',
          });
          loginRequests++;
          if (loginRequests == 1) return invalidLogin.future;
          return http.Response('{"token":"test-token"}', 200);
        }
        expect(request.url.path, '/api/v1/auth/logout/');
        expect(request.headers['Authorization'], 'Token test-token');
        logoutRequests++;
        return http.Response('', 204);
      }),
    );

    final addProject = find.text('Tambah Proyek');
    final loginScreen = find.byType(LoginScreen);
    final projectForm = find.byType(ProjectFormPage);
    final loginButton = find.widgetWithText(ElevatedButton, 'Login');

    await tester.tap(addProject);
    await tester.pumpAndSettle();
    expect(loginScreen, findsOneWidget);
    expect(projectForm, findsNothing);
    expect(
      tester.widget<TextField>(find.byType(TextField).last).obscureText,
      isTrue,
    );

    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    expect(find.text('Username wajib diisi.'), findsOneWidget);
    expect(find.text('Password wajib diisi.'), findsOneWidget);
    expect(loginRequests, 0);

    expect(await tester.binding.handlePopRoute(), isTrue);
    await tester.pumpAndSettle();
    expect(loginScreen, findsNothing);
    expect(projectForm, findsNothing);

    await tester.tap(addProject);
    await tester.pumpAndSettle();
    await enterTestCredentials(tester);
    await tester.tap(loginButton);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(
      tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
      isNull,
    );
    expect(await tester.binding.handlePopRoute(), isTrue);
    await tester.pump();
    expect(loginScreen, findsOneWidget);

    invalidLogin.complete(
      http.Response('{"detail":"Invalid credentials"}', 400),
    );
    await tester.pumpAndSettle();
    expect(find.text('Username atau password salah. (400)'), findsOneWidget);
    expect(projectForm, findsNothing);

    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    expect(projectForm, findsOneWidget);
    expect(loginRequests, 2);
    expect(await tester.binding.handlePopRoute(), isTrue);
    await tester.pumpAndSettle();

    await tester.tap(addProject);
    await tester.pumpAndSettle();
    expect(projectForm, findsOneWidget);
    expect(loginScreen, findsNothing);
    expect(loginRequests, 2);
    expect(await tester.binding.handlePopRoute(), isTrue);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();
    expect(logoutRequests, 1);
    expect(find.text('Berhasil logout.'), findsOneWidget);
    expect(find.text('Login').hitTestable(), findsOneWidget);
  });

  testWidgets(
    'drawer keeps one Home and clears the session when logout fails',
    (tester) async {
      await tester.pumpWidget(
        appWithAuthApi((request) async {
          if (request.url.path == '/api/v1/projects/') {
            expect(request.headers['Authorization'], isNull);
            return http.Response('[]', 200);
          }
          if (request.url.path == '/api/v1/auth/token/') {
            return http.Response('{"token":"test-token"}', 200);
          }
          expect(request.url.path, '/api/v1/auth/logout/');
          expect(request.headers['Authorization'], 'Token test-token');
          throw http.ClientException('Offline');
        }),
      );

      Future<void> pickDrawer(String label) async {
        await tester.tap(find.byType(DrawerButton));
        await tester.pumpAndSettle();
        final item = find.widgetWithText(ListTile, label);
        await tester.ensureVisible(item);
        await tester.tap(item);
        await tester.pumpAndSettle();
      }

      final home = find.byType(MyHomePage);
      await tester.tap(find.text('Lihat Proyek'));
      await tester.pumpAndSettle();
      expect(find.text('Daftar Proyek'), findsOneWidget);
      await pickDrawer('Home');
      expect(Navigator.of(tester.element(home)).canPop(), isFalse);

      await pickDrawer('Lihat Proyek');
      expect(find.text('Belum ada proyek.'), findsOneWidget);
      await pickDrawer('Add Project');
      expect(find.byType(LoginScreen), findsOneWidget);
      await loginWithTestCredentials(tester);
      expect(find.byType(ProjectFormPage), findsOneWidget);

      await pickDrawer('Logout');
      expect(home, findsOneWidget);
      expect(Navigator.of(tester.element(home)).canPop(), isFalse);
      expect(find.text('Login').hitTestable(), findsOneWidget);
      expect(
        find.text(
          'Sesi di perangkat diakhiri. Logout server gagal dikonfirmasi.',
        ),
        findsOneWidget,
      );

      await pickDrawer('Add Project');
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(ProjectFormPage), findsNothing);
    },
  );
}
