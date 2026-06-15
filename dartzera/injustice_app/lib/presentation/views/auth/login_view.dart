import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Imports corretos saindo de presentation/views/auth/ para a raiz de core/ e data/
import '../../../core/di/dependency_injection.dart';
import '../../../core/messages/auth_error_messages.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/typedefs/types_defs.dart';
import '../../../core/validators/email_str_validator.dart';
import '../../../core/validators/empty_str_validator.dart';
import '../../../data/services/auth_service_interface.dart';
import '../../functions/ui_functions.dart';
import '../../widgets/input_text_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final IAuthService _authService;

  final _formKey = GlobalKey<FormState>();
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
    _emailField.focus.dispose();
    _emailField.controller.dispose();
    _passwordField.focus.dispose();
    _passwordField.controller.dispose();
    super.dispose();
  }

  static FormFieldControl _createField() {
    return (
      key: GlobalKey<FormFieldState>(),
      focus: FocusNode(),
      controller: TextEditingController(),
    );
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.signInWithEmailAndPassword(
        email: _emailField.controller.text,
        password: _passwordField.controller.text,
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
        'Não foi possível entrar. Tente novamente.',
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
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
                  const SizedBox(height: AppSpacing.xxl),
                  Icon(
                    Icons.lock_outline,
                    size: 72,
                    color: colorScheme.onSecondary,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Bem-vindo de volta',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Entre com seu e-mail e senha para continuar',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
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
                    hint: 'Digite sua senha',
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _signIn(),
                    validator: (value) =>
                        validateField(value, [EmptyStrValidator()]),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _signIn,
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
                            'ENTRAR',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Não tem conta?',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () => context.go('/sign-up'),
                        child: Text(
                          'Cadastre-se',
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSecondary,
                          ),
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