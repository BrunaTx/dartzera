import '../../core/typedefs/types_defs.dart'
    show NoParams, SubAccountParams, SubAccountIdParams, SubAccountResult, ListSubAccountResult;
import '../usecases/subaccount_usecases_interfaces.dart';
import 'subaccount_facade_usecases_interface.dart';

final class SubAccountFacadeUseCasesImpl implements ISubAccountFacadeUseCases {
  final ISaveSubAccountUseCase _saveSubAccountUseCase;
  final IUpdateSubAccountUseCase _updateSubAccountUseCase;
  final IGetAllSubAccountsUseCase _getAllSubAccountsUseCase;
  final IGetSubAccountByIdUseCase _getSubAccountByIdUseCase;
  final IDeleteSubAccountUseCase _deleteSubAccountUseCase;

  SubAccountFacadeUseCasesImpl({
    required ISaveSubAccountUseCase saveSubAccountUseCase,
    required IUpdateSubAccountUseCase updateSubAccountUseCase,
    required IGetAllSubAccountsUseCase getAllSubAccountsUseCase,
    required IGetSubAccountByIdUseCase getSubAccountByIdUseCase,
    required IDeleteSubAccountUseCase deleteSubAccountUseCase,
  })  : _saveSubAccountUseCase = saveSubAccountUseCase,
        _updateSubAccountUseCase = updateSubAccountUseCase,
        _getAllSubAccountsUseCase = getAllSubAccountsUseCase,
        _getSubAccountByIdUseCase = getSubAccountByIdUseCase,
        _deleteSubAccountUseCase = deleteSubAccountUseCase;

  @override
  Future<ListSubAccountResult> getAllSubAccounts(NoParams params) =>
      _getAllSubAccountsUseCase(params);

  @override
  Future<SubAccountResult> getSubAccountById(SubAccountIdParams params) =>
      _getSubAccountByIdUseCase(params);

  @override
  Future<SubAccountResult> saveSubAccount(SubAccountParams params) =>
      _saveSubAccountUseCase(params);

  @override
  Future<SubAccountResult> updateSubAccount(SubAccountParams params) =>
      _updateSubAccountUseCase(params);

  @override
  Future<SubAccountResult> deleteSubAccount(SubAccountIdParams params) =>
      _deleteSubAccountUseCase(params);
}
