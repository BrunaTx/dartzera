import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../core/messages/auth_error_messages.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/typedefs/types_defs.dart';
import '../../../core/validators/email_str_validator.dart';
import '../../../core/validators/empty_str_validator.dart';
import '../../../core/validators/passwor_full_validator.dart';
import '../../../data/services/auth_service_interface.dart';
import '../../functions/ui_functions.dart';
import '../../widgets/input_text_field.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final IAuthService _authService;

  final _formKey = GlobalKey<FormState>();
  final _nameField = _createField();
  final _emailField = _createField();
  final _currentPasswordField = _createField();
  final _newPasswordField = _createField();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authService = injector.get<IAuthService>();
    _loadUserData();
  }

  void _loadUserData() {
    final user = _authService.currentUser;
    if (user == null) return;

    _nameField.controller.text = user.displayName ?? '';
    _emailField.controller.text = user.email ?? '';
  }

  @override
  void dispose() {
    for (final field in [
      _nameField,
      _emailField,
      _currentPasswordField,
      _newPasswordField,
    ]) {
      field.focus.dispose();
      field.controller.dispose();
    }
    super.dispose();
  }

  static FormFieldControl _createField() {
    return (
      key: GlobalKey<FormFieldState>(),
      focus: FocusNode(),
      controller: TextEditingController(),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final user = _authService.currentUser;
    if (user == null) return;

    final newName = _nameField.controller.text.trim();
    final newEmail = _emailField.controller.text.trim();
    final currentPassword = _currentPasswordField.controller.text;
    final newPassword = _newPasswordField.controller.text.trim();

    final nameChanged = newName != (user.displayName ?? '');
    final emailChanged = newEmail != (user.email ?? '');
    final passwordChanged = newPassword.isNotEmpty;

    if (!nameChanged && !emailChanged && !passwordChanged) {
      showAuthSnackBar(context, 'Nenhuma alteração foi feita.');
      return;
    }

    if ((emailChanged || passwordChanged) && currentPassword.isEmpty) {
      showAuthSnackBar(
        context,
        'Informe sua senha atual para alterar e-mail ou senha.',
        isError: true,
      );
      _currentPasswordField.focus.requestFocus();
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (nameChanged) {
        await _authService.updateDisplayName(newName);
      }

      if (emailChanged) {
        await _authService.updateEmail(
          newEmail: newEmail,
          currentPassword: currentPassword,
        );
      }

      if (passwordChanged) {
        await _authService.updatePassword(
          newPassword: newPassword,
          currentPassword: currentPassword,
        );
      }

      if (!mounted) return;

      _currentPasswordField.controller.clear();
      _newPasswordField.controller.clear();
      _loadUserData();

      showAuthSnackBar(context, 'Perfil atualizado com sucesso!');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      showAuthSnackBar(
        context,
        AuthErrorMessages.fromFirebaseAuthException(e),
        isError: true,
      );
    } catch (_) {
      if (!mounted) return;
      showAuthSnackBar(
        context,
        'Não foi possível atualizar o perfil.',
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signOut() async {
    await _authService.signOut();
    if (!mounted) return;
    context.goNamed(AppRouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _isLoading ? null : () => context.goNamed(AppRouteNames.home),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: AppSpacing.paddingLg,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.manage_accounts_outlined,
                  size: 64,
                  color: colorScheme.onSecondary,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Edite seus dados de acesso',
                  style: context.textStyles.bodyMedium?.withColor(
                    colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                InputTextField(
                  fieldKey: _nameField.key,
                  controller: _nameField.controller,
                  focusNode: _nameField.focus,
                  label: 'Nome',
                  hint: 'Digite seu nome',
                  prefixIcon: Icons.account_circle_outlined,
                  enabled: !_isLoading,
                  validator: (value) =>
                      validateField(value, [EmptyStrValidator()]),
                ),
                const SizedBox(height: AppSpacing.md),
                InputTextField(
                  fieldKey: _emailField.key,
                  controller: _emailField.controller,
                  focusNode: _emailField.focus,
                  label: 'E-mail',
                  hint: 'Digite seu e-mail',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  enabled: !_isLoading,
                  validator: (value) => validateField(value, [
                    EmptyStrValidator(),
                    EmailStrValidator(),
                  ]),
                ),
                const SizedBox(height: AppSpacing.md),
                InputTextField(
                  fieldKey: _currentPasswordField.key,
                  controller: _currentPasswordField.controller,
                  focusNode: _currentPasswordField.focus,
                  label: 'Senha atual',
                  hint: 'Necessária para alterar e-mail ou senha',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: AppSpacing.md),
                InputTextField(
                  fieldKey: _newPasswordField.key,
                  controller: _newPasswordField.controller,
                  focusNode: _newPasswordField.focus,
                  label: 'Nova senha',
                  hint: 'Deixe em branco para manter a atual',
                  prefixIcon: Icons.lock_reset_outlined,
                  obscureText: true,
                  enabled: !_isLoading,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null;
                    return validateField(value, [
                      PassworFullValidator(),
                    ]);
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          'SALVAR ALTERAÇÕES',
                          style: context.textStyles.titleMedium?.bold,
                        ),
                ),
                const SizedBox(height: AppSpacing.md),
                OutlinedButton(
                  onPressed: _isLoading ? null : _signOut,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                    foregroundColor: colorScheme.onSecondary,
                    side: BorderSide(color: colorScheme.onSecondary),
                  ),
                  child: Text(
                    'SAIR DA CONTA',
                    style: context.textStyles.titleMedium?.bold,
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
