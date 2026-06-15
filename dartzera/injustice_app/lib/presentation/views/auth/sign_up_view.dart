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

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  late final IAuthService _authService;

  final _formKey = GlobalKey<FormState>();
  final _nameField = _createField();
  final _emailField = _createField();
  final _passwordField = _createField();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authService = injector.get<IAuthService>();
  }

  @override
  void dispose() {
    for (final field in [_nameField, _emailField, _passwordField]) {
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

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.createUserWithEmailAndPassword(
        email: _emailField.controller.text,
        password: _passwordField.controller.text,
        displayName: _nameField.controller.text,
      );
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
        'Não foi possível criar a conta. Tente novamente.',
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _isLoading
              ? null
              : () => context.goNamed(AppRouteNames.login),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: AppSpacing.paddingLg,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.person_add_outlined,
                    size: 72,
                    color: colorScheme.onSecondary,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Criar conta',
                    style: context.textStyles.headlineMedium?.bold.withColor(
                      colorScheme.onSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Preencha os dados abaixo para se cadastrar',
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
                    textInputAction: TextInputAction.next,
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
                    textInputAction: TextInputAction.next,
                    validator: (value) => validateField(value, [
                      EmptyStrValidator(),
                      EmailStrValidator(),
                    ]),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  InputTextField(
                    fieldKey: _passwordField.key,
                    controller: _passwordField.controller,
                    focusNode: _passwordField.focus,
                    label: 'Senha',
                    hint: 'Crie uma senha segura',
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _signUp(),
                    validator: (value) => validateField(value, [
                      EmptyStrValidator(),
                      PassworFullValidator(),
                    ]),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _signUp,
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
                            'CADASTRAR',
                            style: context.textStyles.titleMedium?.bold,
                          ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Já possui conta?',
                        style: context.textStyles.bodyMedium?.withColor(
                          colorScheme.onSurfaceVariant,
                        ),
                      ),
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () => context.goNamed(AppRouteNames.login),
                        child: Text(
                          'Entrar',
                          style: context.textStyles.bodyMedium?.semiBold
                              .withColor(colorScheme.onSecondary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
