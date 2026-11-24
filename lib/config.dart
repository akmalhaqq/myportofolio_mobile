/// Django's base URL. Android emulators reach the host through 10.0.2.2.
/// Use `--dart-define=API_BASE_URL=http://localhost:8000` for local Chrome.
const apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.0.2.2:8000',
);
