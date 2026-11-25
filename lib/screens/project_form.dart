import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

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
  String _imageUrl = '';
  int _year = 0;
  bool _isSaving = false;

  static const _unconfirmedSave =
      'Penyimpanan belum terkonfirmasi. Periksa daftar proyek sebelum mencoba lagi.';

  Future<void> _saveProject() async {
    if (_isSaving) return;
    final form = _formKey.currentState!;
    if (!form.validate()) return;

    form.save();
    final project = Project(
      title: _projectName,
      category: _category,
      description: _description,
      techStack: _technologies,
      year: _year,
      externalUrl: _projectLink,
      image: _imageUrl,
    );
    final auth = context.read<AuthState>();
    final api = context.read<ApiClient>();
    FocusScope.of(context).unfocus();
    setState(() {
      _isSaving = true;
    });

    String? requestToken;
    try {
      if (!await ensureLoggedIn(context) || !mounted) return;
      final token = auth.token;
      if (token == null || auth.isLoggingOut) return;
      requestToken = token;

      final savedProject = await api.createProject(project, token: token);
      if (!mounted || ModalRoute.of(context)?.isCurrent != true) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      form.reset();
      _showConfirmation(savedProject);
    } on ApiException catch (error) {
      if (!mounted) return;
      if (error.statusCode == 401 && requestToken != null) {
        auth.invalidateToken(requestToken);
        if (ModalRoute.of(context)?.isCurrent != true) return;
        _showMessage('Sesi berakhir. Silakan login kembali.');
        if (await ensureLoggedIn(context) && mounted) {
          _showMessage('Login berhasil. Tekan Save untuk mengirim ulang.');
        }
        return;
      }
      if (ModalRoute.of(context)?.isCurrent != true) return;
      _showMessage(switch (error.statusCode) {
        400 => 'Django menolak isian proyek. Periksa data lalu coba lagi.',
        403 => 'Akun ini tidak punya izin untuk menambahkan proyek.',
        < 300 || >= 500 => _unconfirmedSave,
        _ => 'Proyek gagal disimpan (${error.statusCode}).',
      });
    } catch (_) {
      if (mounted && ModalRoute.of(context)?.isCurrent == true) {
        _showMessage(_unconfirmedSave);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _showConfirmation(Project project) {
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
                Text('Nama Proyek: ${project.title}'),
                Text('Deskripsi: ${project.description}'),
                Text('Kategori: ${project.category}'),
                Text('Tahun: ${project.year}'),
                Text('Teknologi: ${project.techStack}'),
                Text(
                  'Tautan: ${project.externalUrl.isEmpty ? '-' : project.externalUrl}',
                ),
                if (project.image.isNotEmpty) Text('Gambar: ${project.image}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String? _requiredText(String? value, String label, {int? maxLength}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return '$label tidak boleh kosong!';
    if (maxLength != null && text.runes.length > maxLength) {
      return '$label maksimal $maxLength karakter.';
    }
    return null;
  }

  String? _validateUrl(String? value, int maxLength) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    if (text.runes.length > maxLength) {
      return 'URL maksimal $maxLength karakter.';
    }
    final uri = Uri.tryParse(text);
    if (uri == null ||
        (uri.scheme != 'https' && uri.scheme != 'http') ||
        uri.host.isEmpty ||
        RegExp(r'\s').hasMatch(text)) {
      return 'Masukkan URL HTTP atau HTTPS yang valid.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Project Form')),
      drawer: const LeftDrawer(),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: _isSaving ? null : _saveProject,
          child: _isSaving
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  enabled: !_isSaving,
                  onSaved: (value) => _projectName = value?.trim() ?? '',
                  decoration: const InputDecoration(
                    labelText: 'Nama Proyek',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      _requiredText(value, 'Nama proyek', maxLength: 255),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  enabled: !_isSaving,
                  maxLines: 5,
                  onSaved: (value) => _description = value?.trim() ?? '',
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi Proyek',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      _requiredText(value, 'Deskripsi proyek'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  enabled: !_isSaving,
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
                  enabled: !_isSaving,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Tahun',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final year = int.tryParse(value?.trim() ?? '', radix: 10);
                    if (year == null || year < 0 || year > 2147483647) {
                      return 'Masukkan tahun dengan angka yang valid.';
                    }
                    return null;
                  },
                  onSaved: (value) =>
                      _year = int.parse(value!.trim(), radix: 10),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  enabled: !_isSaving,
                  onSaved: (value) => _technologies = value?.trim() ?? '',
                  validator: (value) => _requiredText(
                    value,
                    'Teknologi yang digunakan',
                    maxLength: 255,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Teknologi yang Digunakan',
                    hintText: 'Contoh: Flutter, Django, Figma',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  enabled: !_isSaving,
                  keyboardType: TextInputType.url,
                  onSaved: (value) => _projectLink = value?.trim() ?? '',
                  validator: (value) => _validateUrl(value, 200),
                  decoration: const InputDecoration(
                    labelText: 'Tautan Proyek',
                    hintText: 'URL Proyek (opsional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  enabled: !_isSaving,
                  keyboardType: TextInputType.url,
                  onSaved: (value) => _imageUrl = value?.trim() ?? '',
                  validator: (value) => _validateUrl(value, 255),
                  decoration: const InputDecoration(
                    labelText: 'URL Gambar (opsional)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
