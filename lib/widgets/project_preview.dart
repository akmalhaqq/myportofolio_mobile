import 'package:material_ui/material_ui.dart';

class ProjectPreview extends StatelessWidget {
  const ProjectPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MyPortfolio Mobile',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Aplikasi portofolio pribadi untuk mata kuliah '
              'Pemrograman Berbasis Platform.',
            ),
            const SizedBox(height: 12),
            const Text('Dibangun dengan Flutter dan Dart.'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tutup'),
            ),
          ],
        ),
      ),
    );
  }
}
