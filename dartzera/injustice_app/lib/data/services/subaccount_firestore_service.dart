import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/failure/failure.dart';
import '../../core/patterns/result.dart';
import '../../domain/models/subaccount_entity.dart';
import '../../domain/models/subaccount_mapper.dart';
import 'subaccount_local_storage_interface.dart';

final class SubAccountFirestoreService implements ISubAccountLocalStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get _uid {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception('Usuário não autenticado.');
    return uid;
  }

  CollectionReference<Map<String, dynamic>> get _subAccounts =>
      _firestore.collection('users').doc(_uid).collection('subaccounts');

  @override
  Future<SubAccountResult> saveSubAccount(SubAccount subAccount) async {
    try {
      await _subAccounts
          .doc(subAccount.id)
          .set(SubAccountMapper.toMap(subAccount), SetOptions(merge: true));
      return Success(subAccount);
    } catch (e) {
      return Error(ApiLocalFailure(e.toString()));
    }
  }

  @override
  Future<SubAccountResult> updateSubAccount(SubAccount subAccount) async {
    try {
      await _subAccounts
          .doc(subAccount.id)
          .set(SubAccountMapper.toMap(subAccount), SetOptions(merge: true));
      return Success(subAccount);
    } catch (e) {
      return Error(ApiLocalFailure(e.toString()));
    }
  }

  @override
  Future<ListSubAccountResult> getAllSubAccounts() async {
    try {
      final snapshot = await _subAccounts.get();
      final list = snapshot.docs
          .map((doc) => SubAccountMapper.fromMap(doc.data()))
          .toList();
      return Success(list);
    } catch (e) {
      return Error(ApiLocalFailure(e.toString()));
    }
  }

  @override
  Future<SubAccountResult> getSubAccountById(String id) async {
    try {
      final doc = await _subAccounts.doc(id).get();
      if (!doc.exists) {
        return Error(DefaultFailure('Subconta não encontrada'));
      }
      return Success(SubAccountMapper.fromMap(doc.data()!));
    } catch (e) {
      return Error(ApiLocalFailure(e.toString()));
    }
  }

  @override
  Future<SubAccountResult> deleteSubAccount(String id) async {
    try {
      final doc = await _subAccounts.doc(id).get();
      if (!doc.exists) {
        return Error(DefaultFailure('Subconta não encontrada'));
      }
      final subAccount = SubAccountMapper.fromMap(doc.data()!);
      await _subAccounts.doc(id).delete();
      return Success(subAccount);
    } catch (e) {
      return Error(ApiLocalFailure(e.toString()));
    }
  }
}