import '../../core/typedefs/types_defs.dart'
    show NoParams, SubAccountParams, SubAccountIdParams,
        SubAccountResult, ListSubAccountResult;
import '../../data/repositories/subaccount_repository_interface.dart';
import 'subaccount_usecases_interfaces.dart';

final class SaveSubAccountUseCaseImpl implements ISaveSubAccountUseCase {
  final ISubAccountRepository _repository;
  SaveSubAccountUseCaseImpl({required ISubAccountRepository repository})
      : _repository = repository;

  @override
  Future<SubAccountResult> call(SubAccountParams params) =>
      _repository.saveSubAccount(params.subAccount);
}

final class UpdateSubAccountUseCaseImpl implements IUpdateSubAccountUseCase {
  final ISubAccountRepository _repository;
  UpdateSubAccountUseCaseImpl({required ISubAccountRepository repository})
      : _repository = repository;

  @override
  Future<SubAccountResult> call(SubAccountParams params) =>
      _repository.updateSubAccount(params.subAccount);
}

final class GetAllSubAccountsUseCaseImpl implements IGetAllSubAccountsUseCase {
  final ISubAccountRepository _repository;
  GetAllSubAccountsUseCaseImpl({required ISubAccountRepository repository})
      : _repository = repository;

  @override
  Future<ListSubAccountResult> call(NoParams params) =>
      _repository.getAllSubAccounts();
}

final class GetSubAccountByIdUseCaseImpl implements IGetSubAccountByIdUseCase {
  final ISubAccountRepository _repository;
  GetSubAccountByIdUseCaseImpl({required ISubAccountRepository repository})
      : _repository = repository;

  @override
  Future<SubAccountResult> call(SubAccountIdParams params) =>
      _repository.getSubAccountById(params.id);
}

final class DeleteSubAccountUseCaseImpl implements IDeleteSubAccountUseCase {
  final ISubAccountRepository _repository;
  DeleteSubAccountUseCaseImpl({required ISubAccountRepository repository})
      : _repository = repository;

  @override
  Future<SubAccountResult> call(SubAccountIdParams params) =>
      _repository.deleteSubAccount(params.id);
}