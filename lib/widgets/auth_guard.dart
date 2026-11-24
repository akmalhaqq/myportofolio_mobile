import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

Future<bool> ensureLoggedIn(BuildContext context) async {
  final auth = context.read<AuthState>();
  if (auth.isLoggingOut) return false;
  if (auth.isLoggedIn) return true;

  final loggedIn = await Navigator.of(context)
      .push<bool>(MaterialPageRoute<bool>(builder: (_) => const LoginScreen()));
  return loggedIn == true;
}

Future<void> logoutAndReturnHome(BuildContext context) async {
  final auth = context.read<AuthState>();
  if (!auth.isLoggedIn || auth.isLoggingOut) return;
  final navigator = Navigator.of(context);
  final messenger = ScaffoldMessenger.of(context);

  var message = 'Berhasil logout.';
  try {
    await auth.logout();
  } catch (_) {
    message = 'Sesi di perangkat diakhiri. Logout server gagal dikonfirmasi.';
  }
  if (!navigator.mounted || !messenger.mounted) return;

  navigator.popUntil((route) => route.isFirst);
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
