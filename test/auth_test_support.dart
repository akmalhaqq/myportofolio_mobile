import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

MyApp appWithAuthApi(Future<http.Response> Function(http.Request) respond) {
  return MyApp(createApiClient: () => ApiClient(client: MockClient(respond)));
}

MyApp appWithSuccessfulLogin() {
  return appWithAuthApi((request) async {
    expect(request.url.path, '/api/v1/auth/token/');
    return http.Response('{"token":"test-token"}', 200);
  });
}

Future<void> enterTestCredentials(WidgetTester tester) async {
  final fields = find.byType(TextFormField);
  await tester.enterText(fields.at(0), 'tester');
  await tester.enterText(fields.at(1), 'test-password');
}

Future<void> loginWithTestCredentials(WidgetTester tester) async {
  await enterTestCredentials(tester);
  await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
  await tester.pumpAndSettle();
}
