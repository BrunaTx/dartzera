import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme/app_theme.dart';
import '../../core/validators/email_str_validator.dart';
import '../../core/validators/empty_str_validator.dart';
import '../../domain/models/subaccount_entity.dart';
import '../functions/ui_functions.dart';
import '../widgets/account_attribute_card.dart';
import '../widgets/date_wheel_picker.dart';
import '../widgets/input_text_field.dart';

class SubAccountCreateView extends StatefulWidget {
  final SubAccount? subAccount;

  const SubAccountCreateView({super.key, this.subAccount});

  @override
  State<SubAccountCreateView> createState() => _SubAccountCreateViewState();
}

class _SubAccountCreateViewState extends State<SubAccountCreateView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _displayNameController;

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _displayNameFocus = FocusNode();

  late int _level;
  late double _gold;
  late int _gems;
  late int _energy;
  late DateTime _createdAt;

  bool get _isEditing => widget.subAccount != null;

  @override
  void initState() {
    super.initState();
    final sub = widget.subAccount;
    _nameController = TextEditingController(text: sub?.name ?? '');
    _emailController = TextEditingController(text: sub?.email ?? '');
    _displayNameController = TextEditingController(text: sub?.displayName ?? '');
    _nameController.addListener(() => setState(() {}));
    _level = sub?.level ?? 1;
    _gold = sub?.gold ?? 0;
    _gems = sub?.gems ?? 0;
    _energy = sub?.energy ?? 1;
    _createdAt = sub?.createdAt ?? DateTime.now();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _displayNameController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _displayNameFocus.dispose();
    super.dispose();
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final now = DateTime.now();
    final subAccount = SubAccount(
      id: widget.subAccount?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      displayName: _displayNameController.text.trim(),
      level: _level,
      gold: _gold,
      gems: _gems,
      energy: _energy,
      createdAt: widget.subAccount?.createdAt ?? _createdAt,
      updatedAt: now,
    );

    Navigator.pop(context, subAccount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Perfil' : 'Novo Perfil'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: AppSpacing.paddingLg,
            physics: const BouncingScrollPhysics(),
            children: [
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    _nameController.text.isNotEmpty
                        ? _nameController.text[0].toUpperCase()
                        : '?',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              InputTextField(
                label: 'Nome do Perfil',
                controller: _nameController,
                focusNode: _nameFocus,
                prefixIcon: Icons.person,
                hint: 'Ex: Minha Conta Principal',
                validator: (value) => validateField(value, [EmptyStrValidator()]),
              ),
              const SizedBox(height: AppSpacing.md),

              InputTextField(
                label: 'Email',
                controller: _emailController,
                focusNode: _emailFocus,
                prefixIcon: Icons.email,
                hint: 'seuemail@exemplo.com',
                keyboardType: TextInputType.emailAddress,
                validator: (value) => validateField(value, [
                  EmptyStrValidator(),
                  EmailStrValidator(),
                ]),
              ),
              const SizedBox(height: AppSpacing.md),

              InputTextField(
                label: 'Apelido',
                controller: _displayNameController,
                focusNode: _displayNameFocus,
                prefixIcon: Icons.verified_user,
                hint: 'Como você quer ser chamado',
                validator: (value) => validateField(value, [EmptyStrValidator()]),
              ),
              const SizedBox(height: AppSpacing.md),

              DateWheelPicker(
                label: 'Data de Criação da Conta',
                selectedDate: _createdAt,
                onDateSelected: (date) => setState(() => _createdAt = date),
              ),
              const SizedBox(height: AppSpacing.xl),

              Text(
                'Atributos',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),

              AccountAttributeCard(
                icon: Icons.star,
                iconColor: Theme.of(context).colorScheme.primary,
                label: 'Nível',
                hint: '[1, 80]',
                minValue: 1,
                maxValue: 80,
                value: _level,
                onChanged: (v) => setState(() => _level = v),
              ),
              const SizedBox(height: 1),
              AccountAttributeCard(
                icon: Icons.monetization_on,
                iconColor: Colors.amber,
                label: 'Ouro',
                hint: 'Min: 0',
                minValue: 0,
                maxValue: 999999,
                value: _gold.toInt(),
                onChanged: (v) => setState(() => _gold = v.toDouble()),
              ),
              const SizedBox(height: 1),
              AccountAttributeCard(
                icon: Icons.diamond,
                iconColor: Colors.cyan,
                label: 'Gemas',
                hint: 'Min: 0',
                minValue: 0,
                maxValue: 999999,
                value: _gems,
                onChanged: (v) => setState(() => _gems = v),
              ),
              const SizedBox(height: 1),
              AccountAttributeCard(
                icon: Icons.bolt,
                iconColor: Colors.orange,
                label: 'Energia',
                hint: 'Min: 1',
                minValue: 1,
                maxValue: 999999,
                value: _energy,
                onChanged: (v) => setState(() => _energy = v),
              ),
              const SizedBox(height: AppSpacing.xl),

              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: Text(
                    _isEditing ? 'Salvar Alterações' : 'Criar Perfil',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
