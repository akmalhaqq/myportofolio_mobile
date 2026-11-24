import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:provider/provider.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final imagePath = project.image.trim();
    // Existing Django data stores some images relative to its static directory.
    final image = Uri.tryParse(
      imagePath.startsWith('img/') ? '/static/$imagePath' : imagePath,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Proyek')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(project.title, style: textTheme.headlineSmall),
            Text('${project.category} • ${project.year}'),
            if (imagePath.isNotEmpty && image != null) ...[
              const SizedBox(height: 16),
              Image.network(
                context.read<ApiClient>().baseUri.resolveUri(image).toString(),
                height: 240,
                fit: BoxFit.contain,
                webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
                semanticLabel: 'Gambar proyek ${project.title}',
                errorBuilder: (context, error, stackTrace) =>
                    const Text('Gambar gagal dimuat.'),
              ),
            ],
            const SizedBox(height: 16),
            Text('Deskripsi', style: textTheme.titleMedium),
            Text(project.description),
            const SizedBox(height: 16),
            Text('Teknologi', style: textTheme.titleMedium),
            Text(project.techStack),
            if (project.externalUrl.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('Tautan Proyek', style: textTheme.titleMedium),
              SelectableText(project.externalUrl),
            ],
            if (project.githubUrl.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('GitHub', style: textTheme.titleMedium),
              SelectableText(project.githubUrl),
            ],
          ],
        ),
      ),
    );
  }
}
