import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (_isSubmitting) return;
    final form = _formKey.currentState!;
    if (!form.validate()) return;
    form.save();

    setState(() {
      _isSubmitting = true;
    });

    try {
      await context.read<AuthState>().login(_username, _password);
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      Navigator.of(context).pop(true);
    } on ApiException catch (error) {
      final message = switch (error.statusCode) {
        400 || 401 => 'Username atau password salah. (${error.statusCode})',
        _ => 'Login gagal. (${error.statusCode})',
      };
      _showError(message);
    } catch (_) {
      _showError('Login gagal. Periksa koneksi dan coba lagi.');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<bool>(
      canPop: !_isSubmitting,
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  enabled: !_isSubmitting,
                  onSaved: (value) => _username = value!.trim(),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Username wajib diisi.'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  enabled: !_isSubmitting,
                  onSaved: (value) => _password = value!,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Password wajib diisi.'
                      : null,
                  onFieldSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
