import '../services/subaccount_local_storage_interface.dart';
import 'subaccount_repository_interface.dart';
import '../../domain/models/subaccount_entity.dart';

final class SubAccountRepositoryImpl implements ISubAccountRepository {
  final ISubAccountLocalStorage _localStorage;

  SubAccountRepositoryImpl({required ISubAccountLocalStorage localStorage})
      : _localStorage = localStorage;

  @override
  Future<SubAccountResult> saveSubAccount(SubAccount subAccount) =>
      _localStorage.saveSubAccount(subAccount);

  @override
  Future<SubAccountResult> updateSubAccount(SubAccount subAccount) =>
      _localStorage.updateSubAccount(subAccount);

  @override
  Future<ListSubAccountResult> getAllSubAccounts() =>
      _localStorage.getAllSubAccounts();

  @override
  Future<SubAccountResult> getSubAccountById(String id) =>
      _localStorage.getSubAccountById(id);

  @override
  Future<SubAccountResult> deleteSubAccount(String id) =>
      _localStorage.deleteSubAccount(id);
}
