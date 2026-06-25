# Relatório Técnico — Implementação de Múltiplos Perfis (Subcontas)

**Aplicativo:** Injustice 2 Mobile Tracker  
**Tecnologia:** Flutter (Dart) · Firebase Firestore · Clean Architecture  
**Data:** Junho de 2026

---

## 1. Objetivo

O aplicativo originalmente permitia apenas **uma subconta** por usuário. O objetivo foi implementar um sistema de **múltiplos perfis independentes** — similar ao Netflix — onde cada perfil possui seus próprios personagens, e trocar de perfil não afeta os dados dos outros.

Estrutura desejada:

```
Usuário (Firebase Auth)
└── Perfis (SubContas)
    ├── Perfil "Lyza"  → personagens A, B, C
    └── Perfil "João"  → personagens X, Y, Z
```

---

## 2. Arquitetura Utilizada

O projeto segue **Clean Architecture** com três camadas:

```
lib/
├── core/              → padrões, rotas, DI, temas
├── data/              → serviços Firestore, repositórios
├── domain/            → entidades, casos de uso, facades
└── presentation/      → ViewModels, Commands, Views (UI)
```

O padrão de estado reativo utilizado é **Signals** (`signals_flutter`), e o padrão de **Command** encapsula cada operação assíncrona, separando a lógica de execução da lógica de estado.

---

## 3. Arquivos Criados (novos)

### 3.1 Entidade — `lib/domain/models/subaccount_entity.dart`

Define os dados de um perfil. Adicionados os campos `email` e `displayName` (apelido) para espelhar o que a conta principal tinha.

```dart
class SubAccount extends Equatable {
  final String id;
  final String name;
  final String email;        // NOVO
  final String displayName;  // NOVO (apelido)
  final int level;
  final double gold;
  final int gems;
  final int energy;
  final DateTime createdAt;
  final DateTime updatedAt;
  // ...
}
```

---

### 3.2 Mapper — `lib/domain/models/subaccount_mapper.dart`

Converte entre o objeto `SubAccount` e o `Map<String, dynamic>` do Firestore. Os campos `email` e `displayName` têm fallback (`?? ''`) para compatibilidade com registros antigos.

```dart
static SubAccount fromMap(Map<String, dynamic> map) {
  return SubAccount(
    id:          map['id'] as String,
    name:        map['name'] as String,
    email:       (map['email'] as String?) ?? '',        // fallback
    displayName: (map['displayName'] as String?) ?? '',  // fallback
    level:       map['level'] as int,
    gold:        (map['gold'] as num).toDouble(),
    gems:        map['gems'] as int,
    energy:      map['energy'] as int,
    createdAt:   DateTime.parse(map['createdAt'] as String),
    updatedAt:   DateTime.parse(map['updatedAt'] as String),
  );
}
```

---

### 3.3 Interface do Serviço — `lib/data/services/subaccount_local_storage_interface.dart`

Define o contrato que o serviço do Firestore deve implementar para operações CRUD de subcontas.

```dart
abstract interface class ISubAccountLocalStorage {
  Future<SubAccountResult> saveSubAccount(SubAccount subAccount);
  Future<SubAccountResult> updateSubAccount(SubAccount subAccount);
  Future<ListSubAccountResult> getAllSubAccounts();
  Future<SubAccountResult> getSubAccountById(String id);
  Future<SubAccountResult> deleteSubAccount(String id);
}
```

---

### 3.4 Serviço Firestore — `lib/data/services/subaccount_firestore_service.dart`

Implementa o CRUD no Firestore sob `users/{uid}/subaccounts/{subId}`. Todos os métodos têm `try/catch` que retorna um `Result` em vez de lançar exceção.

```dart
final class SubAccountFirestoreService implements ISubAccountLocalStorage {
  String get _uid => FirebaseAuth.instance.currentUser?.uid
      ?? (throw Exception('Usuário não autenticado.'));

  CollectionReference get _subAccounts =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(_uid)
          .collection('subaccounts');

  @override
  Future<SubAccountResult> saveSubAccount(SubAccount subAccount) async {
    try {
      await _subAccounts
          .doc(subAccount.id)
          .set(SubAccountMapper.toMap(subAccount), SetOptions(merge: true));
      return Success(subAccount);
    } catch (e) {
      return Error(ApiLocalFailure(e.toString()));
    }
  }
  // updateSubAccount, getAllSubAccounts, getSubAccountById, deleteSubAccount ...
}
```

---

### 3.5 Interfaces de Casos de Uso — `lib/domain/usecases/subaccount_usecases_interfaces.dart`

> **Ponto crítico:** a interface `IGetAllSubAccountsUseCase` usa `NoParams` (vindo de `types_defs.dart`) em vez de `()` diretamente, pois `()` em posição genérica é interpretado como tipo função pelo Dart, causando erro de compilação.

```dart
import '../../core/typedefs/types_defs.dart'
    show NoParams, SubAccountResult, ListSubAccountResult,
         SubAccountParams, SubAccountIdParams;

abstract interface class IGetAllSubAccountsUseCase
    implements IUseCase<ListSubAccountResult, NoParams> {}   // NoParams = ()

abstract interface class ISaveSubAccountUseCase
    implements IUseCase<SubAccountResult, SubAccountParams> {}

abstract interface class IDeleteSubAccountUseCase
    implements IUseCase<SubAccountResult, SubAccountIdParams> {}
// ...
```

---

### 3.6 Facade — `lib/domain/facades/subaccount_facade_usecases_impl.dart`

Agrega todos os casos de uso em uma única interface para simplificar o acesso da camada de apresentação.

```dart
final class SubAccountFacadeUseCasesImpl implements ISubAccountFacadeUseCases {
  final ISaveSubAccountUseCase    _saveSubAccountUseCase;
  final IGetAllSubAccountsUseCase _getAllSubAccountsUseCase;
  final IDeleteSubAccountUseCase  _deleteSubAccountUseCase;
  // ...

  @override
  Future<ListSubAccountResult> getAllSubAccounts(NoParams params) =>
      _getAllSubAccountsUseCase(params);

  @override
  Future<SubAccountResult> saveSubAccount(SubAccountParams params) =>
      _saveSubAccountUseCase(params);
}
```

---

### 3.7 Commands — `lib/presentation/commands/subaccount_commands.dart`

Cada operação CRUD é encapsulada em um `ParameterizedCommand`. O command chama o facade e retorna um `Result<Success, Failure>`.

```dart
final class GetAllSubAccountsCommand
    extends ParameterizedCommand<List<SubAccount>, Failure, NoParams> {

  final ISubAccountFacadeUseCases _facade;
  GetAllSubAccountsCommand(this._facade);

  @override
  Future<ListSubAccountResult> execute() =>
      _facade.getAllSubAccounts(());
}

final class SaveSubAccountCommand
    extends ParameterizedCommand<SubAccount, Failure, SubAccountParams> {

  final ISubAccountFacadeUseCases _facade;
  SaveSubAccountCommand(this._facade);

  @override
  Future<SubAccountResult> execute() async {
    if (parameter == null) return Error(InputFailure('Parâmetro nulo.'));
    return _facade.saveSubAccount(parameter!);
  }
}
// UpdateSubAccountCommand, DeleteSubAccountCommand ...
```

---

### 3.8 ViewModels — `lib/presentation/controllers/`

Três classes formam o ViewModel de subcontas (mesmo padrão do ViewModel de personagens):

| Arquivo | Responsabilidade |
|---|---|
| `subaccount_state_viewmodel.dart` | Sinal reativo da lista + mensagem de erro |
| `subaccount_commands_viewmodel.dart` | Observa commands via `effect()` e atualiza estado |
| `subaccount_viewmodel.dart` | Agrupa estado + commands, expõe para a View |

```dart
// subaccount_state_viewmodel.dart
class SubAccountStateViewModel {
  final state   = signal<List<SubAccount>>([]);
  final message = signal<String?>(null);
  void clear()              { state.value = []; message.value = null; }
  void setMessage(String m) => message.value = m;
  void clearMessage()       => message.value = null;
}
```

```dart
// subaccount_commands_viewmodel.dart — padrão effect()
void _observeCommand<T>(Command<T, Failure> command, {
  required void Function(T) onSuccess,
  void Function(Failure)? onFailure,
}) {
  effect(() {
    if (command.isExecuting.value) return;
    final result = command.result.value;
    if (result == null) return;
    result.fold(
      onSuccess: (data) { state.clearMessage(); onSuccess(data); command.clear(); },
      onFailure: (err)  { state.setMessage(err.msg); command.clear(); },
    );
  });
}
```

---

### 3.9 Views — `lib/presentation/views/`

**`subaccount_view.dart`** — Lista de perfis em grid (estilo Netflix). Ao tocar em um perfil, define o ID ativo no serviço de personagens e navega para a tela de personagens daquele perfil.

```dart
void _selectSubAccount(SubAccount sub) {
  // 1. Define qual subconta está ativa no serviço de personagens
  injector.get<ICharacterLocalStorage>().setSubAccountId(sub.id);

  // 2. Limpa dados antigos para não piscar na tela
  injector.get<CharactersViewModel>().clearCharactersData();

  // 3. Navega passando o SubAccount como contexto
  context.goNamed(AppRouteNames.characters, extra: sub);
}
```

**`subaccount_create_view.dart`** — Formulário de criação/edição com os mesmos campos que a conta principal tinha: nome, email, apelido, data de criação e atributos numéricos.

---

## 4. Arquivos Modificados

### 4.1 Bug crítico — `lib/core/patterns/command.dart`

**Problema:** o sinal `_running.value = false` disparava o `effect()` de forma **síncrona** antes do `return`, zerando `_result.value` via `command.clear()`. O `return _result.value!` então quebrava com `Unexpected null value`.

**Solução:** capturar o resultado em variável local antes de alterar os sinais.

```dart
// ANTES (com bug):
_result.value = await execute();
_running.value = false;
return _result.value!;    // ← null após o effect limpar!

// DEPOIS (corrigido):
final executionResult = await execute();   // captura local
_result.value = executionResult;           // atualiza sinal
_running.value = false;                    // effects podem limpar _result aqui
return executionResult;                    // imune ao clear()
```

---

### 4.2 Mudança de path no Firestore — `lib/data/services/character_firestore_service.dart`

Personagens passaram a pertencer a uma subconta específica. O getter `_characters` foi alterado para incluir o ID da subconta ativa no caminho.

```dart
// ANTES:
CollectionReference get _characters =>
    _firestore.collection('users').doc(_uid).collection('characters');

// DEPOIS:
String? _subAccountId;

void setSubAccountId(String id) => _subAccountId = id;

CollectionReference get _characters {
  if (_subAccountId == null) throw Exception('Nenhuma subconta selecionada.');
  return _firestore
      .collection('users')
      .doc(_uid)
      .collection('subaccounts')
      .doc(_subAccountId)   // ← ID da subconta ativa
      .collection('characters');
}
```

A interface foi atualizada para expor o método:

```dart
// character_local_storage_interface.dart
abstract interface class ICharacterLocalStorage {
  void setSubAccountId(String id);   // NOVO
  Future<CharacterResult> saveCharacter(Character character);
  // ...
}
```

---

### 4.3 Rota de personagens — `lib/core/routes/app_routes.dart`

A rota de personagens passou a receber `SubAccount` como `extra` em vez de `Account`.

```dart
// ANTES:
final account = state.extra;
if (account is! Account) return const NoTransitionPage(child: HomeView());
return NoTransitionPage(child: CharactersView(account: account));

// DEPOIS:
final subAccount = state.extra;
if (subAccount is! SubAccount) return const NoTransitionPage(child: HomeView());
return NoTransitionPage(child: CharactersView(subAccount: subAccount));
```

---

### 4.4 Tela de personagens — `CharactersView` e `CharactersBody`

`Account` substituído por `SubAccount` em toda a cadeia de widgets de personagens:

```dart
// characters_view.dart
class CharactersView extends StatefulWidget {
  final SubAccount subAccount;  // era: Account account
  // ...
}

// characters_body.dart
class CharactersBody extends StatelessWidget {
  final SubAccount subAccount;  // era: Account account
  // ...
  child: AccountSummaryCard(subAccount: subAccount),  // era: account: account
}
```

---

### 4.5 Card de resumo — `lib/presentation/widgets/account_summary_card.dart`

O widget que exibe nome, level e atributos no topo da tela de personagens foi adaptado para exibir dados do `SubAccount`:

```dart
class AccountSummaryCard extends StatelessWidget {
  final SubAccount subAccount;  // era: Account account

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        Text(subAccount.displayName.isNotEmpty
            ? subAccount.displayName
            : subAccount.name),      // apelido ou nome
        Text('Lv. ${subAccount.level}'),
        // energia, gemas, gold...
      ]),
    );
  }
}
```

---

### 4.6 Drawer — `lib/presentation/widgets/app_drawer.dart`

Removidos: item "Criar Conta / Editar Conta" e a dependência de `AccountViewModel`. O item "Personagens" agora redireciona para "Perfis" (pois personagens só são acessíveis através de um perfil selecionado).

```dart
// ANTES: "Personagens" ia direto para CharactersView com Account
context.goNamed(AppRouteNames.characters, extra: account);

// DEPOIS: "Personagens" vai para SubAccountsView
context.goNamed(AppRouteNames.subAccounts);  // usuário seleciona o perfil lá
```

---

### 4.7 Injeção de Dependências — `lib/core/di/dependency_injection.dart`

Registradas todas as dependências da cadeia de subcontas como singletons:

```dart
// Subcontas
injector.addSingleton<ISubAccountLocalStorage>(SubAccountFirestoreService.new);
injector.addSingleton<ISubAccountRepository>(SubAccountRepositoryImpl.new);
injector.addSingleton<ISubAccountFacadeUseCases>(SubAccountFacadeUseCasesImpl.new);
injector.addSingleton<ISaveSubAccountUseCase>(SaveSubAccountUseCaseImpl.new);
injector.addSingleton<IUpdateSubAccountUseCase>(UpdateSubAccountUseCaseImpl.new);
injector.addSingleton<IGetAllSubAccountsUseCase>(GetAllSubAccountsUseCaseImpl.new);
injector.addSingleton<IGetSubAccountByIdUseCase>(GetSubAccountByIdUseCaseImpl.new);
injector.addSingleton<IDeleteSubAccountUseCase>(DeleteSubAccountUseCaseImpl.new);
injector.addSingleton<SubAccountViewModel>(SubAccountViewModel.new);
```

---

## 5. Erros Corrigidos

### 5.1 `Unexpected null value` em `command.dart:36`

**Causa raiz:** a biblioteca `signals_flutter` dispara `effect()` de forma síncrona quando o valor de um sinal muda. Quando `_running.value = false` era executado, o `_observeCommand` effect era chamado imediatamente, invocava `command.clear()` → `_result.value = null`, e a linha seguinte `return _result.value!` crashava.

**Fix:** capturar o resultado em variável local imune ao `clear()`.

---

### 5.2 Erro de `invalid_override` em `GetAllSubAccountsUseCaseImpl`

**Causa raiz:** em Dart, `()` em posição de parâmetro genérico (`IUseCase<T, ()>`) é interpretado como `Function()` (tipo função), não como o record vazio. Isso causava um conflito de tipos com a implementação.

**Fix:** definir `typedef NoParams = ()` em `types_defs.dart` e usar `NoParams` na interface genérica.

---

### 5.3 Firestore `permission-denied`

**Causa raiz:** a regra de segurança usava a variável `uid`, mas o bloco `match /users/{userId}` define a variável como `userId`.

**Fix:** substituir `uid` por `userId` na regra das subcontas.

---

## 6. Estrutura do Firestore

```
Firestore
└── users/
    └── {uid}/
        └── subaccounts/
            └── {subId}/           ← perfil criado pelo usuário
                │   name, email, displayName, level, gold, gems, energy...
                └── characters/
                    └── {charId}   ← personagem desse perfil
```

**Regras de segurança no Firebase Console:**

```js
match /users/{userId} {
  allow read, write: if request.auth.uid == userId;

  match /subaccounts/{subId} {
    allow read, write: if request.auth.uid == userId;

    match /characters/{charId} {
      allow read, write: if request.auth.uid == userId;
    }
  }
}
```

---

## 7. Fluxo Final do Usuário

```
Login (Firebase Auth)
    ↓
Tela de Perfis (SubAccountsView)
    ├── Criar Perfil   → SubAccountCreateView (nome, email, apelido, atributos)
    ├── Editar Perfil  → SubAccountCreateView (mesmos campos, pré-preenchidos)
    ├── Excluir Perfil → confirmDialog → deleteSubAccount
    └── Selecionar Perfil
              ↓ setSubAccountId(perfil.id)
          Tela de Personagens (CharactersView)
              ├── Criar Personagem → salvo em subaccounts/{subId}/characters/
              ├── Editar Personagem
              └── Excluir Personagem
```

Os personagens do **Perfil A** nunca aparecem no **Perfil B** pois cada perfil lê/grava em seu próprio caminho no Firestore.

---

## 8. Resumo dos Arquivos

| Arquivo | Status | Descrição |
|---|---|---|
| `lib/domain/models/subaccount_entity.dart` | NOVO | Entidade do perfil com email e displayName |
| `lib/domain/models/subaccount_mapper.dart` | NOVO | Serialização Firestore ↔ Dart |
| `lib/data/services/subaccount_local_storage_interface.dart` | NOVO | Interface do serviço de subcontas |
| `lib/data/services/subaccount_firestore_service.dart` | NOVO | CRUD no Firestore |
| `lib/data/repositories/subaccount_repository_interface.dart` | NOVO | Interface do repositório |
| `lib/data/repositories/subaccount_repository_impl.dart` | NOVO | Implementação do repositório |
| `lib/domain/usecases/subaccount_usecases_interfaces.dart` | NOVO | Interfaces dos casos de uso |
| `lib/domain/usecases/subaccount_usecases_impl.dart` | NOVO | Implementações dos casos de uso |
| `lib/domain/facades/subaccount_facade_usecases_interface.dart` | NOVO | Interface da facade |
| `lib/domain/facades/subaccount_facade_usecases_impl.dart` | NOVO | Implementação da facade |
| `lib/presentation/commands/subaccount_commands.dart` | NOVO | Commands CRUD de subcontas |
| `lib/presentation/controllers/subaccount_state_viewmodel.dart` | NOVO | Estado reativo |
| `lib/presentation/controllers/subaccount_commands_viewmodel.dart` | NOVO | Observadores de commands |
| `lib/presentation/controllers/subaccount_viewmodel.dart` | NOVO | ViewModel principal |
| `lib/presentation/views/subaccount_view.dart` | NOVO | Tela de lista de perfis |
| `lib/presentation/views/subaccount_create_view.dart` | NOVO | Formulário criar/editar perfil |
| `lib/core/patterns/command.dart` | MODIFICADO | Fix: local var para evitar null crash |
| `lib/core/typedefs/types_defs.dart` | MODIFICADO | Adicionado typedefs de SubAccount |
| `lib/core/di/dependency_injection.dart` | MODIFICADO | Registro das novas dependências |
| `lib/core/routes/app_routes.dart` | MODIFICADO | Nova rota subAccounts; characters usa SubAccount |
| `lib/data/services/character_local_storage_interface.dart` | MODIFICADO | Adicionado setSubAccountId() |
| `lib/data/services/character_firestore_service.dart` | MODIFICADO | Path com subAccountId |
| `lib/presentation/views/characters/list_of/characters_view.dart` | MODIFICADO | Account → SubAccount |
| `lib/presentation/views/characters/list_of/widgets/characters_body.dart` | MODIFICADO | Account → SubAccount |
| `lib/presentation/widgets/account_summary_card.dart` | MODIFICADO | Account → SubAccount |
| `lib/presentation/widgets/app_drawer.dart` | MODIFICADO | Removido "Criar Conta"; simplificado |
