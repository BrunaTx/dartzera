import '../../core/failure/failure.dart';
import '../../core/patterns/result.dart';
import '../../domain/models/subaccount_entity.dart';

typedef SubAccountResult = Result<SubAccount, Failure>;
typedef ListSubAccountResult = Result<List<SubAccount>, Failure>;

abstract interface class ISubAccountLocalStorage {
  Future<SubAccountResult> saveSubAccount(SubAccount subAccount);
  Future<SubAccountResult> updateSubAccount(SubAccount subAccount);
  Future<ListSubAccountResult> getAllSubAccounts();
  Future<SubAccountResult> getSubAccountById(String id);
  Future<SubAccountResult> deleteSubAccount(String id);
}