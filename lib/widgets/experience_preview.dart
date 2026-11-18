import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/utils/experience_tags.dart';

class ExperiencePreview extends StatelessWidget {
  final String title;
  final String company;
  final String period;
  final String category;
  final String description;
  final String tags;

  const ExperiencePreview({
    super.key,
    required this.title,
    required this.company,
    required this.period,
    required this.category,
    required this.description,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    String displayValue(String value) {
      final text = value.trim();
      return text.isEmpty ? '-' : text;
    }

    final tagLabels = parseExperienceTags(tags);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jabatan / Nama Pengalaman: ${displayValue(title)}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text('Perusahaan / Organisasi: ${displayValue(company)}'),
          const SizedBox(height: 8),
          Text('Periode: ${displayValue(period)}'),
          const SizedBox(height: 8),
          Text('Kategori: $category'),
          const SizedBox(height: 8),
          Text('Deskripsi: ${displayValue(description)}'),
          const SizedBox(height: 8),
          if (tagLabels.isEmpty)
            const Text('Tags: -')
          else ...[
            const Text('Tags'),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final tag in tagLabels)
                  Chip(label: Text(tag, overflow: TextOverflow.ellipsis)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
