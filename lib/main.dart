import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.createApiClient = ApiClient.new});

  final ApiClient Function() createApiClient;

  @override
  Widget build(BuildContext context) {
    return Provider<ApiClient>(
      create: (_) => createApiClient(),
      dispose: (_, client) => client.close(),
      child: MaterialApp(
        title: 'MyPortfolio',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF7EA87A),
            brightness: Brightness.dark,
            surface: const Color(0xFF12181F),
            onSurface: const Color(0xFFF2F0E8),
          ),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}
