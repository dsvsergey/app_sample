import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/form_repository.dart';

final formStateProvider =
    StateNotifierProvider<FormStateNotifier, FormData>((ref) {
  return FormStateNotifier();
});

final formRepositoryProvider = Provider<FormRepository>((ref) {
  return FormRepository();
});

class FormData {
  final String name;
  final String email;
  final String phone;
  final bool isLoading;

  FormData({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.isLoading = false,
  });

  FormData copyWith({
    String? name,
    String? email,
    String? phone,
    bool? isLoading,
  }) {
    return FormData(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class FormStateNotifier extends StateNotifier<FormData> {
  FormStateNotifier() : super(FormData());

  void updateName(String name) => state = state.copyWith(name: name);
  void updateEmail(String email) => state = state.copyWith(email: email);
  void updatePhone(String phone) => state = state.copyWith(phone: phone);
  void setLoading(bool isLoading) =>
      state = state.copyWith(isLoading: isLoading);

  void resetForm() => state = FormData();
}

class FormScreen extends ConsumerWidget {
  FormScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final formState = ref.watch(formStateProvider);

    Future<void> submitForm() async {
      if (_formKey.currentState!.validate()) {
        ref.read(formStateProvider.notifier).setLoading(true);
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        final result = await ref.read(formRepositoryProvider).submitForm(
              name: formState.name,
              email: formState.email,
              phone: formState.phone,
            );

        // Remove the mounted check and use scaffoldMessenger
        ref.read(formStateProvider.notifier).setLoading(false);

        if (result) {
          _showSuccessSnackBar(scaffoldMessenger, l10n);
          ref.read(formStateProvider.notifier).resetForm();
        } else {
          _showErrorSnackBar(scaffoldMessenger, l10n, submitForm);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.formTitle),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildTextField(
                              label: l10n.userName,
                              icon: Icons.person,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return l10n.nameRequired;
                                }
                                if (value.length < 2) {
                                  return l10n.nameMinLength;
                                }
                                return null;
                              },
                              onChanged: ref
                                  .read(formStateProvider.notifier)
                                  .updateName,
                              initialValue: formState.name,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              label: l10n.email,
                              icon: Icons.email,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return l10n.emailRequired;
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(value)) {
                                  return l10n.emailInvalid;
                                }
                                return null;
                              },
                              onChanged: ref
                                  .read(formStateProvider.notifier)
                                  .updateEmail,
                              initialValue: formState.email,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              label: l10n.phone,
                              icon: Icons.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return l10n.phoneRequired;
                                }
                                if (!RegExp(r'^\+?[0-9]{10,14}$')
                                    .hasMatch(value)) {
                                  return l10n.phoneInvalid;
                                }
                                return null;
                              },
                              onChanged: ref
                                  .read(formStateProvider.notifier)
                                  .updatePhone,
                              initialValue: formState.phone,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: formState.isLoading ? null : submitForm,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: formState.isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                l10n.submit,
                                style: const TextStyle(fontSize: 18),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    required void Function(String) onChanged,
    required String initialValue,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }

  void _showSuccessSnackBar(
      ScaffoldMessengerState scaffoldMessenger, AppLocalizations l10n) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(l10n.formSubmittedSuccessfully),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(ScaffoldMessengerState scaffoldMessenger,
      AppLocalizations l10n, VoidCallback onRetry) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(l10n.formSubmissionError),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: l10n.tryAgain,
          onPressed: onRetry,
          textColor: Colors.white,
        ),
      ),
    );
  }
}
