import 'package:signals_flutter/signals_flutter.dart';

import '../../core/failure/failure.dart';
import '../../core/patterns/command.dart';
import '../../domain/models/subaccount_entity.dart';
import '../commands/subaccount_commands.dart';
import 'subaccount_state_viewmodel.dart';

class SubAccountCommandsViewModel {
  final SubAccountStateViewModel state;

  final GetAllSubAccountsCommand _getAllCommand;
  final SaveSubAccountCommand _saveCommand;
  final UpdateSubAccountCommand _updateCommand;
  final DeleteSubAccountCommand _deleteCommand;

  SubAccountCommandsViewModel({
    required this.state,
    required GetAllSubAccountsCommand getAllCommand,
    required SaveSubAccountCommand saveCommand,
    required UpdateSubAccountCommand updateCommand,
    required DeleteSubAccountCommand deleteCommand,
  })  : _getAllCommand = getAllCommand,
        _saveCommand = saveCommand,
        _updateCommand = updateCommand,
        _deleteCommand = deleteCommand {
    _observeGetAll();
    _observeSave();
    _observeUpdate();
    _observeDelete();
  }

  GetAllSubAccountsCommand get getAllCommand => _getAllCommand;
  SaveSubAccountCommand get saveCommand => _saveCommand;
  UpdateSubAccountCommand get updateCommand => _updateCommand;
  DeleteSubAccountCommand get deleteCommand => _deleteCommand;

  void _observeCommand<T>(
    Command<T, Failure> command, {
    required void Function(T data) onSuccess,
    void Function(Failure err)? onFailure,
  }) {
    effect(() {
      if (command.isExecuting.value) return;
      final result = command.result.value;
      if (result == null) return;
      result.fold(
        onSuccess: (data) {
          state.clearMessage();
          onSuccess(data);
          command.clear();
        },
        onFailure: (err) {
          state.setMessage(err.msg);
          if (onFailure != null) onFailure(err);
          command.clear();
        },
      );
    });
  }

  void _observeGetAll() {
    _observeCommand<List<SubAccount>>(
      _getAllCommand,
      onSuccess: (list) => state.state.value = list,
    );
  }

  void _observeSave() {
    _observeCommand<SubAccount>(
      _saveCommand,
      onSuccess: (created) {
        state.state.value = [...state.state.value, created];
      },
    );
  }

  void _observeUpdate() {
    _observeCommand<SubAccount>(
      _updateCommand,
      onSuccess: (updated) {
        state.state.value = state.state.value.map((s) {
          return s.id == updated.id ? updated : s;
        }).toList();
      },
    );
  }

  void _observeDelete() {
    _observeCommand<SubAccount>(
      _deleteCommand,
      onSuccess: (deleted) {
        state.state.value =
            state.state.value.where((s) => s.id != deleted.id).toList();
      },
      onFailure: (_) => fetchSubAccounts(),
    );
  }

  Future<void> fetchSubAccounts() async {
    state.clearMessage();
    await _getAllCommand.executeWith(());
  }

  Future<void> addSubAccount(SubAccount subAccount) async {
    state.clearMessage();
    await _saveCommand.executeWith((subAccount: subAccount));
  }

  Future<void> updateSubAccount(SubAccount subAccount) async {
    state.clearMessage();
    await _updateCommand.executeWith((subAccount: subAccount));
  }

  Future<void> deleteSubAccount(String id) async {
    state.clearMessage();
    await _deleteCommand.executeWith((id: id));
  }
}
