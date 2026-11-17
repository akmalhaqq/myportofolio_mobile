import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();

  static const _categories = [
    'Web Development',
    'Mobile Development',
    'Machine Learning',
    'Data Science',
    'Other',
  ];

  String _projectName = '';
  String _description = '';
  String _category = _categories.first;
  String _technologies = '';
  String _projectLink = '';

  void _saveProject() {
    final form = _formKey.currentState!;
    if (!form.validate()) return;

    form.save();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Proyek berhasil ditambahkan!'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nama Proyek: $_projectName'),
                Text('Deskripsi: $_description'),
                Text('Kategori: $_category'),
                Text(
                  'Teknologi: ${_technologies.isEmpty ? '-' : _technologies}',
                ),
                Text('Tautan: ${_projectLink.isEmpty ? '-' : _projectLink}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                form.reset();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Project Form')),
      drawer: const LeftDrawer(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  onSaved: (value) => _projectName = value?.trim() ?? '',
                  decoration: const InputDecoration(
                    labelText: 'Nama Proyek',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama proyek tidak boleh kosong!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  maxLines: 5,
                  onSaved: (value) => _description = value?.trim() ?? '',
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi Proyek',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Deskripsi proyek tidak boleh kosong!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  enabled: true,
                  initialValue: _categories.first,
                  isExpanded: true,
                  onSaved: (value) => _category = value ?? _categories.first,
                  decoration: const InputDecoration(
                    labelText: 'Kategori Proyek',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (final category in _categories)
                      DropdownMenuItem(
                        value: category,
                        child: Text(category, overflow: TextOverflow.ellipsis),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  onSaved: (value) => _technologies = value?.trim() ?? '',
                  decoration: const InputDecoration(
                    labelText: 'Teknologi yang Digunakan',
                    hintText: 'Contoh: Flutter, Django, Figma',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  keyboardType: TextInputType.url,
                  onSaved: (value) => _projectLink = value?.trim() ?? '',
                  decoration: const InputDecoration(
                    labelText: 'Tautan Proyek',
                    hintText: 'URL Proyek (opsional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveProject,
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
