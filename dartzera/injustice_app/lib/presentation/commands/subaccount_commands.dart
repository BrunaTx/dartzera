import '../../core/failure/failure.dart';
import '../../core/patterns/command.dart';
import '../../core/patterns/result.dart';
import '../../core/typedefs/types_defs.dart';
import '../../domain/facades/subaccount_facade_usecases_interface.dart';
import '../../domain/models/subaccount_entity.dart';

final class GetAllSubAccountsCommand
    extends ParameterizedCommand<List<SubAccount>, Failure, NoParams> {
  final ISubAccountFacadeUseCases _facade;

  GetAllSubAccountsCommand(this._facade);

  @override
  Future<ListSubAccountResult> execute() async {
    return await _facade.getAllSubAccounts(());
  }
}

final class SaveSubAccountCommand
    extends ParameterizedCommand<SubAccount, Failure, SubAccountParams> {
  final ISubAccountFacadeUseCases _facade;

  SaveSubAccountCommand(this._facade);

  @override
  Future<SubAccountResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parâmetro nulo para criar subconta.'));
    }
    return await _facade.saveSubAccount(parameter!);
  }
}

final class UpdateSubAccountCommand
    extends ParameterizedCommand<SubAccount, Failure, SubAccountParams> {
  final ISubAccountFacadeUseCases _facade;

  UpdateSubAccountCommand(this._facade);

  @override
  Future<SubAccountResult> execute() async {
    final current = parameter;
    if (current == null) {
      return Error(InputFailure('Parâmetro nulo para atualizar subconta.'));
    }
    return await _facade.updateSubAccount(current);
  }
}

final class DeleteSubAccountCommand
    extends ParameterizedCommand<SubAccount, Failure, SubAccountIdParams> {
  final ISubAccountFacadeUseCases _facade;

  DeleteSubAccountCommand(this._facade);

  @override
  Future<SubAccountResult> execute() async {
    if (parameter == null || parameter!.id.isEmpty) {
      return Error(InputFailure('ID inválido para deletar subconta.'));
    }
    return await _facade.deleteSubAccount(parameter!);
  }
}
