import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/failure/failure.dart';
import '../../core/patterns/result.dart';
import '../../core/typedefs/types_defs.dart';
import '../../domain/models/account_entity.dart';
import '../../domain/models/account_mapper.dart';
import 'account_local_storage_interface.dart';

final class AccountFirestoreService implements IAccountLocalStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get _uid {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      throw Exception('Usuário não autenticado.');
    }

    return uid;
  }

  @override
  Future<VoidResult> saveAccount(Account account) async {
    try {
      await _firestore
          .collection('users')
          .doc(_uid)
          .set(AccountMapper.toMap(account));

      return Success(null);
    } catch (e) {
      return Error(ApiLocalFailure(e.toString()));
    }
  }

  @override
  Future<AccountResult> getAccount() async {
    try {
      final doc =
          await _firestore.collection('users').doc(_uid).get();

      if (!doc.exists) {
        return Error(EmptyResultFailure());
      }

      return Success(
        AccountMapper.fromMap(doc.data()!),
      );
    } catch (e) {
      return Error(ApiLocalFailure(e.toString()));
    }
  }

  @override
  Future<VoidResult> updateAccount(Account account) async {
    return saveAccount(account);
  }

  @override
  Future<VoidResult> deleteAccount() async {
    try {
      await _firestore.collection('users').doc(_uid).delete();

      return Success(null);
    } catch (e) {
      return Error(ApiLocalFailure(e.toString()));
    }
  }
}
