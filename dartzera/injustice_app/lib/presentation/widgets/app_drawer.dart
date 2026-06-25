import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/dependency_injection.dart';
import '../../core/routes/app_routes.dart';
import '../controllers/characters_view_model.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});

  final _vmCharacters = injector.get<CharactersViewModel>();

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.toString();

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.videogame_asset,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                const SizedBox(height: 8),
                Text(
                  'Injustice 2 Mobile',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: currentRoute == AppPaths.home
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSecondary,
            ),
            title: Text(
              'Início',
              style: currentRoute == AppPaths.home
                  ? TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
            ),
            selected: currentRoute == AppPaths.home,
            onTap: () {
              context.pop();
              if (currentRoute != AppPaths.home) {
                context.goNamed(AppRouteNames.home);
              }
            },
          ),
          ListTile(
            leading: Icon(
              Icons.switch_account,
              color: currentRoute == AppPaths.subAccounts
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSecondary,
            ),
            title: Text(
              'Perfis',
              style: currentRoute == AppPaths.subAccounts
                  ? TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
            ),
            selected: currentRoute == AppPaths.subAccounts,
            onTap: () {
              context.pop();
              if (currentRoute != AppPaths.subAccounts) {
                context.goNamed(AppRouteNames.subAccounts);
              }
            },
          ),
          ListTile(
            leading: Icon(
              Icons.people,
              color: currentRoute == AppPaths.characters
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSecondary,
            ),
            title: const Text('Personagens'),
            subtitle: Text(
              'Selecione um perfil',
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            selected: currentRoute == AppPaths.characters,
            onTap: () {
              context.pop();
              if (currentRoute != AppPaths.subAccounts) {
                context.goNamed(AppRouteNames.subAccounts);
              }
            },
          ),
          ListTile(
            leading: Icon(
              Icons.info,
              color: currentRoute == AppPaths.about
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSecondary,
            ),
            title: Text(
              'Sobre',
              style: currentRoute == AppPaths.about
                  ? TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
            ),
            selected: currentRoute == AppPaths.about,
            onTap: () {
              context.pop();
              if (currentRoute != AppPaths.about) {
                context.goNamed(AppRouteNames.about);
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text(
              'Sair da Conta',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () async {
              context.pop();
              _vmCharacters.clearCharactersData();
              await FirebaseAuth.instance.signOut();
              if (context.mounted) context.go('/');
            },
          ),
        ],
      ),
    );
  }
}
