import 'package:auto_injector/auto_injector.dart';

import '../../data/repositories/account_repository_impl.dart';
import '../../data/repositories/account_repository_interface.dart';
import '../../data/repositories/character_repository_impl.dart';
import '../../data/repositories/character_repository_interface.dart';
import '../../data/repositories/subaccount_repository_impl.dart';
import '../../data/repositories/subaccount_repository_interface.dart';
import '../../data/services/account_firestore_service.dart';
import '../../data/services/account_local_storage_interface.dart';
import '../../data/services/auth_service_interface.dart';
import '../../data/services/character_firestore_service.dart';
import '../../data/services/character_local_storage_interface.dart';
import '../../data/services/firebase_auth_service_impl.dart';
import '../../data/services/subaccount_firestore_service.dart';
import '../../data/services/subaccount_local_storage_interface.dart';
import '../../domain/facades/account_facade_usecases_impl.dart';
import '../../domain/facades/account_facade_usecases_interface.dart';
import '../../domain/facades/character_facade_usecases_impl.dart';
import '../../domain/facades/character_facade_usecases_interface.dart';
import '../../domain/facades/subaccount_facade_usecases_impl.dart';
import '../../domain/facades/subaccount_facade_usecases_interface.dart';
import '../../domain/usecases/account_usecases_impl.dart';
import '../../domain/usecases/account_usecases_interfaces.dart';
import '../../domain/usecases/character_usecases_impl.dart';
import '../../domain/usecases/character_usecases_interfaces.dart';
import '../../domain/usecases/subaccount_usecases_impl.dart';
import '../../domain/usecases/subaccount_usecases_interfaces.dart';
import '../../presentation/controllers/account_viewmodel.dart';
import '../../presentation/controllers/characters_view_model.dart';
import '../../presentation/controllers/subaccount_viewmodel.dart';
import '../theme/theme_controller.dart';


final injector = AutoInjector();

void setupDependencyInjection() {

  // Regristração de dependências do Core
  injector.addSingleton<ThemeController>(ThemeController.new);
  injector.addSingleton<IAuthService>(FirebaseAuthServiceImpl.new);

  // Regristração de dependências para Account
  injector.addSingleton<IAccountLocalStorage>(AccountFirestoreService.new);
  injector.addSingleton<IAccountRepository>(AccountRepositoryImpl.new);

  injector.addSingleton<IAccountFacadeUseCases>(AccountFacadeUsecasesImpl.new);
  injector.addSingleton<IGetAccountUseCase>(GetAccountUseCaseImpl.new);
  injector.addSingleton<ISaveAccountUseCase>(SaveAccountUseCaseImpl.new);
  injector.addSingleton<IDeleteAccountUseCase>(DeleteAccountUseCaseImpl.new);
  injector.addSingleton<IUpdateAccountUseCase>(UpdateAccountUseCaseImpl.new);

  // Regristração de dependências para Character
  injector.addSingleton<ICharacterLocalStorage>(CharacterFirestoreService.new);
  injector.addSingleton<ICharacterRepository>(CharacterRepositoryImpl.new);

  injector.addSingleton<ICharacterFacadeUseCases>(CharacterFacadeUseCasesImpl.new);
  injector.addSingleton<IGetAllCharactersUseCase>(GetAllCharactersUseCaseImpl.new);
  injector.addSingleton<IGetCharacterByIdUseCase>(GetCharacterByIdUseCaseImpl.new);
  injector.addSingleton<ISaveCharacterUseCase>(SaveCharacterUseCaseImpl.new);
  injector.addSingleton<IDeleteCharacterUseCase>(DeleteCharacterUseCaseImpl.new);
  injector.addSingleton<IUpdateCharacterUseCase>(UpdateCharacterUseCaseImpl.new);

  // Regristração de dependências para SubAccount
  injector.addSingleton<ISubAccountLocalStorage>(SubAccountFirestoreService.new);
  injector.addSingleton<ISubAccountRepository>(SubAccountRepositoryImpl.new);

  injector.addSingleton<ISubAccountFacadeUseCases>(SubAccountFacadeUseCasesImpl.new);
  injector.addSingleton<ISaveSubAccountUseCase>(SaveSubAccountUseCaseImpl.new);
  injector.addSingleton<IUpdateSubAccountUseCase>(UpdateSubAccountUseCaseImpl.new);
  injector.addSingleton<IGetAllSubAccountsUseCase>(GetAllSubAccountsUseCaseImpl.new);
  injector.addSingleton<IGetSubAccountByIdUseCase>(GetSubAccountByIdUseCaseImpl.new);
  injector.addSingleton<IDeleteSubAccountUseCase>(DeleteSubAccountUseCaseImpl.new);

  // ViewModels
  injector.addSingleton<AccountViewModel>(AccountViewModel.new);
  injector.addSingleton<CharactersViewModel>(CharactersViewModel.new);
  injector.addSingleton<SubAccountViewModel>(SubAccountViewModel.new);

  // O commit finaliza a configuração e instancia os Singletons
  injector.commit();
}

