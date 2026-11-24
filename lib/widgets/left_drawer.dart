import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key, this.viewingProjects = false});

  final bool viewingProjects;

  void _openPage(NavigatorState navigator, WidgetBuilder builder) {
    navigator.pushAndRemoveUntil<void>(
      MaterialPageRoute<void>(builder: builder),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthState>();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Portfolio',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Explore personal projects and experiences!',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              final navigator = Navigator.of(context);
              navigator.pop();
              navigator.popUntil((route) => route.isFirst);
            },
          ),
          ListTile(
            leading: const Icon(Icons.folder_outlined),
            title: const Text('Lihat Proyek'),
            selected: viewingProjects,
            onTap: () {
              final navigator = Navigator.of(context);
              navigator.pop();
              if (viewingProjects) return;
              _openPage(navigator, (_) => const ProjectListScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Add Project'),
            onTap: () async {
              final navigator = Navigator.of(context);
              final page = ModalRoute.of(context);
              navigator.pop();
              if (!await ensureLoggedIn(context) ||
                  !navigator.mounted ||
                  page?.isCurrent != true) {
                return;
              }
              _openPage(navigator, (_) => const ProjectFormPage());
            },
          ),
          ListTile(
            leading: const Icon(Icons.work_outline),
            title: const Text('Add Experience'),
            onTap: () {
              final navigator = Navigator.of(context);
              navigator.pop();
              _openPage(navigator, (_) => const ExperienceFormPage());
            },
          ),
          ListTile(
            leading: Icon(auth.isLoggedIn ? Icons.logout : Icons.login),
            title: Text(auth.isLoggedIn ? 'Logout' : 'Login'),
            onTap: auth.isLoggingOut
                ? null
                : () async {
                    Navigator.of(context).pop();
                    if (auth.isLoggedIn) {
                      await logoutAndReturnHome(context);
                    } else {
                      await ensureLoggedIn(context);
                    }
                  },
          ),
        ],
      ),
    );
  }
}
