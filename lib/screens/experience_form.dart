import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/validators/experience_validators.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _company = '';
  String _period = '';
  String _category = experienceDefaultCategory;
  String _description = '';
  String _tags = '';

  void _saveExperience() {
    final form = _formKey.currentState!;
    if (!form.validate()) return;

    form.save();
    FocusScope.of(context).unfocus();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          scrollable: true,
          title: const Text('Ringkasan Pengalaman'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Jabatan / Nama Pengalaman: $_title'),
              Text('Perusahaan / Organisasi: $_company'),
              Text('Periode: $_period'),
              Text('Kategori: $_category'),
              Text('Deskripsi: $_description'),
              Text('Tags: $_tags'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Pengalaman')),
      drawer: const LeftDrawer(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Jabatan / Nama Pengalaman',
                    helperText: 'Maksimal 255 karakter.',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => validateExperienceText(
                    value,
                    label: 'Jabatan / Nama Pengalaman',
                    maxLength: experienceTextMaxLength,
                  ),
                  onSaved: (value) => _title = value!.trim(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Perusahaan / Organisasi',
                    helperText: 'Maksimal 255 karakter.',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => validateExperienceText(
                    value,
                    label: 'Perusahaan / Organisasi',
                    maxLength: experienceTextMaxLength,
                  ),
                  onSaved: (value) => _company = value!.trim(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Periode',
                    hintText: 'Agustus–Desember 2026',
                    helperText: 'Maksimal 100 karakter.',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => validateExperienceText(
                    value,
                    label: 'Periode',
                    maxLength: experiencePeriodMaxLength,
                  ),
                  onSaved: (value) => _period = value!.trim(),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  enabled: true,
                  initialValue: experienceDefaultCategory,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (final category in experienceCategories)
                      DropdownMenuItem(
                        value: category,
                        child: Text(category, overflow: TextOverflow.ellipsis),
                      ),
                  ],
                  validator: validateExperienceCategory,
                  onSaved: (value) => _category = value!,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      validateExperienceText(value, label: 'Deskripsi'),
                  onSaved: (value) => _description = value!.trim(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Tags',
                    hintText: 'Flutter, Leadership, Mentoring',
                    helperText: 'Pisahkan dengan koma. Maksimal 255 karakter.',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => validateExperienceText(
                    value,
                    label: 'Tags',
                    maxLength: experienceTextMaxLength,
                  ),
                  onSaved: (value) => _tags = value!.trim(),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveExperience,
                  child: const Text('Simpan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
