import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../core/di/dependency_injection.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../controllers/account_viewmodel.dart';
import '../widgets/app_drawer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final AccountViewModel _vmAccount;

  @override
  void initState() {
    _vmAccount = injector.get<AccountViewModel>();
    _vmAccount.commands.fetchAccount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inj2 Mobile - Player Acc'),
        actions: [
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final currentUser = snapshot.data;
              if (currentUser == null) return const SizedBox.shrink();

              return TextButton.icon(
                onPressed: () => context.goNamed(AppRouteNames.profile),
                icon: Icon(
                  Icons.person_outline,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                label: Text(
                  currentUser.displayName ?? currentUser.email ?? 'Usuário',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                ),
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Watch((context) {
        if (_vmAccount.commands.getAccountCommand.isExecuting.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!_vmAccount.accountState.hasAccount.value) {
          return _buildAboutContent(context);
        }

        return _accountHeaderCard(context);
      }),
    );
  }

  Widget _buildAboutContent(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Icon(
              Icons.videogame_asset,
              size: 100,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Bem-vindo ao Game App',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          const _InfoSection(
            titulo: 'Descrição',
            conteudo:
                'Um jogo épico de RPG onde você controla heróis poderosos, '
                'explora mundos fantásticos e enfrenta desafios emocionantes. '
                'Personalize seus personagens, desenvolva habilidades únicas e '
                'embarque em uma jornada inesquecível.',
          ),
          const SizedBox(height: AppSpacing.lg),
          const _InfoSection(
            titulo: 'Recursos',
            conteudo: '• Sistema de combate estratégico\n'
                '• Mais de 50 personagens únicos\n'
                '• Mundos vastos para explorar\n'
                '• Sistema de progressão profundo\n'
                '• Modo multiplayer cooperativo\n'
                '• Eventos semanais exclusivos',
          ),
          const SizedBox(height: AppSpacing.xl),
          Center(
            child: FilledButton.icon(
              onPressed: () => context.goNamed(AppRouteNames.accountCreate),
              icon: const Icon(Icons.person_add),
              label: const Text('Criar Conta para Começar'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _accountHeaderCard(BuildContext context) {
    final account = _vmAccount.accountState.state.value!;

    return RefreshIndicator(
      onRefresh: () async => await _vmAccount.commands.fetchAccount(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AccountHeaderCard(
              displayName: account.displayName,
              email: account.email,
              level: account.level,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Recursos',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _ResourceCard(
                    icon: Icons.diamond,
                    label: 'Gemas',
                    value: account.gems.toString(),
                    color: Colors.cyan,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _ResourceCard(
                    icon: Icons.bolt,
                    label: 'Energia',
                    value: account.energy.toString(),
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Center(
              child: FractionallySizedBox(
                widthFactor: 0.6,
                child: _ResourceCard(
                  icon: Icons.monetization_on,
                  label: 'Gold',
                  value: NumberFormat.currency(
                    locale: 'en_US',
                    symbol: '\$ ',
                    decimalDigits: 2,
                  ).format(account.gold),
                  color: Colors.amber,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Informações da Conta',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            _InfoCard(
              icon: Icons.calendar_today,
              label: 'Data de Criação',
              value: DateFormat('dd/MM/yyyy').format(account.createdAt),
            ),
            const SizedBox(height: AppSpacing.xl),
            Center(
              child: FilledButton.icon(
                onPressed: () => context.goNamed(
                  AppRouteNames.characters,
                  extra: account,
                ),
                icon: const Icon(Icons.people),
                label: const Text('Ver Meus Personagens'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.md,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountHeaderCard extends StatelessWidget {
  final String displayName;
  final String email;
  final int level;

  const _AccountHeaderCard({
    required this.displayName,
    required this.email,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingLg,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.8),
            Theme.of(context).colorScheme.tertiary,
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.9),
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.tertiary,
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).colorScheme.onSecondary,
                child: Text(
                  displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.military_tech,
                  color: Theme.of(context).colorScheme.onSecondary,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Level $level',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ResourceCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String titulo;
  final String conteudo;

  const _InfoSection({required this.titulo, required this.conteudo});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: double.infinity,
          padding: AppSpacing.paddingMd,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Text(
            conteudo,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
          ),
        ),
      ],
    );
  }
}
