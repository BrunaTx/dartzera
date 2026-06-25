import '../../domain/facades/subaccount_facade_usecases_interface.dart';
import '../commands/subaccount_commands.dart';
import 'subaccount_commands_viewmodel.dart';
import 'subaccount_state_viewmodel.dart';

class SubAccountViewModel {
  late final SubAccountStateViewModel _state;
  SubAccountStateViewModel get subAccountState => _state;

  late final SubAccountCommandsViewModel commands;

  SubAccountViewModel(ISubAccountFacadeUseCases facade) {
    _state = SubAccountStateViewModel();
    commands = SubAccountCommandsViewModel(
      state: _state,
      getAllCommand: GetAllSubAccountsCommand(facade),
      saveCommand: SaveSubAccountCommand(facade),
      updateCommand: UpdateSubAccountCommand(facade),
      deleteCommand: DeleteSubAccountCommand(facade),
    );
  }

  void clearData() => _state.clear();
}
