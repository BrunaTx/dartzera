import '../../core/typedefs/types_defs.dart';

abstract interface class ISubAccountFacadeUseCases {
  Future<ListSubAccountResult> getAllSubAccounts(NoParams params);
  Future<SubAccountResult> getSubAccountById(SubAccountIdParams params);
  Future<SubAccountResult> saveSubAccount(SubAccountParams params);
  Future<SubAccountResult> updateSubAccount(SubAccountParams params);
  Future<SubAccountResult> deleteSubAccount(SubAccountIdParams params);
}
