import '../services/subaccount_local_storage_interface.dart';
import '../../domain/models/subaccount_entity.dart';

abstract interface class ISubAccountRepository {
  Future<SubAccountResult> saveSubAccount(SubAccount subAccount);
  Future<SubAccountResult> updateSubAccount(SubAccount subAccount);
  Future<ListSubAccountResult> getAllSubAccounts();
  Future<SubAccountResult> getSubAccountById(String id);
  Future<SubAccountResult> deleteSubAccount(String id);
}