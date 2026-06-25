import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../core/di/dependency_injection.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../data/services/character_local_storage_interface.dart';
import '../../domain/models/subaccount_entity.dart';
import '../controllers/characters_view_model.dart';
import '../controllers/subaccount_viewmodel.dart';
import '../functions/ui_functions.dart';
import '../widgets/app_drawer.dart';
import 'subaccount_create_view.dart';

class SubAccountsView extends StatefulWidget {
  const SubAccountsView({super.key});

  @override
  State<SubAccountsView> createState() => _SubAccountsViewState();
}

class _SubAccountsViewState extends State<SubAccountsView> {
  late final SubAccountViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = injector.get<SubAccountViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _vm.commands.fetchSubAccounts();
    });
  }

  Future<void> _openCreate() async {
    final result = await Navigator.push<SubAccount>(
      context,
      MaterialPageRoute(
        builder: (_) => const SubAccountCreateView(),
      ),
    );
    if (result != null) {
      await _vm.commands.addSubAccount(result);
    }
  }

  Future<void> _openEdit(SubAccount sub) async {
    final result = await Navigator.push<SubAccount>(
      context,
      MaterialPageRoute(
        builder: (_) => SubAccountCreateView(subAccount: sub),
      ),
    );
    if (result != null) {
      await _vm.commands.updateSubAccount(result);
    }
  }

  Future<void> _confirmDelete(SubAccount sub) async {
    final confirm = await confirmDialog(
      context,
      title: 'Excluir Perfil',
      message: 'Deseja excluir o perfil "${sub.name}"?\nEsta ação não pode ser desfeita.',
      confirmText: 'EXCLUIR',
    );
    if (!confirm) return;
    await _vm.commands.deleteSubAccount(sub.id);
  }

  void _selectSubAccount(SubAccount sub) {
    injector.get<ICharacterLocalStorage>().setSubAccountId(sub.id);
    injector.get<CharactersViewModel>().clearCharactersData();
    context.goNamed(AppRouteNames.characters, extra: sub);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfis'),
      ),
      drawer: AppDrawer(),
      floatingActionButton: Watch((_) {
        final isSaving = _vm.commands.saveCommand.isExecuting.value;
        return FloatingActionButton(
          onPressed: isSaving ? null : _openCreate,
          tooltip: 'Novo Perfil',
          child: isSaving
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.add),
        );
      }),
      body: Watch((context) {
        final isLoading = _vm.commands.getAllCommand.isExecuting.value;
        final subAccounts = _vm.subAccountState.state.value;
        final errorMsg = _vm.subAccountState.message.value;

        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (errorMsg != null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
                const SizedBox(height: AppSpacing.md),
                Text(errorMsg, textAlign: TextAlign.center),
                const SizedBox(height: AppSpacing.md),
                ElevatedButton(
                  onPressed: _vm.commands.fetchSubAccounts,
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          );
        }

        if (subAccounts.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.person_add_alt_1,
                  size: 72,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Nenhum perfil criado ainda',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Toque no + para criar seu primeiro perfil',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _vm.commands.fetchSubAccounts,
          child: GridView.builder(
            padding: AppSpacing.paddingLg,
            itemCount: subAccounts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (_, index) {
              final sub = subAccounts[index];
              return _SubAccountCard(
                subAccount: sub,
                onTap: () => _selectSubAccount(sub),
                onEdit: () => _openEdit(sub),
                onDelete: () => _confirmDelete(sub),
              );
            },
          ),
        );
      }),
    );
  }
}

class _SubAccountCard extends StatelessWidget {
  final SubAccount subAccount;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SubAccountCard({
    required this.subAccount,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final initial = subAccount.name.isNotEmpty
        ? subAccount.name[0].toUpperCase()
        : '?';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: AppSpacing.paddingMd,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  initial,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                subAccount.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Nv. ${subAccount.level}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    tooltip: 'Editar',
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      size: 20,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    tooltip: 'Excluir',
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
