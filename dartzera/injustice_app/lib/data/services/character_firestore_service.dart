import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/failure/failure.dart';
import '../../core/patterns/result.dart';
import '../../core/typedefs/types_defs.dart';
import '../../domain/models/character_entity.dart';
import '../../domain/models/character_mapper.dart';
import 'character_local_storage_interface.dart';

final class CharacterFirestoreService
    implements ICharacterLocalStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _subAccountId;

  @override
  void setSubAccountId(String id) => _subAccountId = id;

  String get _uid {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      throw Exception('Usuário não autenticado.');
    }

    return uid;
  }

  CollectionReference<Map<String, dynamic>> get _characters {
    if (_subAccountId == null) {
      throw Exception('Nenhuma subconta selecionada.');
    }
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('subaccounts')
        .doc(_subAccountId)
        .collection('characters');
  }

  @override
  Future<CharacterResult> saveCharacter(
    Character character,
  ) async {
    try {
      await _characters.doc(character.id).set(
            CharacterMapper.toMap(character),
            SetOptions(merge: true),
          );

      return Success(character);
    } catch (e) {
      return Error(ApiLocalFailure(e.toString()));
    }
  }

  @override
  Future<ListCharacterResult> getAllCharacters() async {
    try {
      final snapshot = await _characters.get();

      final characters = snapshot.docs
          .map(
            (doc) => CharacterMapper.fromMap(doc.data()),
          )
          .toList();

      return Success(characters);
    } catch (e) {
      return Error(ApiLocalFailure(e.toString()));
    }
  }

  @override
  Future<CharacterResult> getCharacterById(
    String id,
  ) async {
    try {
      final doc = await _characters.doc(id).get();

      if (!doc.exists) {
        return Error(
          DefaultFailure('Personagem não encontrado'),
        );
      }

      return Success(
        CharacterMapper.fromMap(doc.data()!),
      );
    } catch (e) {
      return Error(ApiLocalFailure(e.toString()));
    }
  }

  @override
  Future<CharacterResult> updateCharacter(
    Character character,
  ) async {
    try {
      await _characters.doc(character.id).set(
            CharacterMapper.toMap(character),
            SetOptions(merge: true),
          );

      return Success(character);
    } catch (e) {
      return Error(ApiLocalFailure(e.toString()));
    }
  }

  @override
  Future<CharacterResult> deleteCharacter(
    String id,
  ) async {
    try {
      final doc = await _characters.doc(id).get();

      if (!doc.exists) {
        return Error(
          DefaultFailure('Personagem não encontrado'),
        );
      }

      final character =
          CharacterMapper.fromMap(doc.data()!);

      await _characters.doc(id).delete();

      return Success(character);
    } catch (e) {
      return Error(ApiLocalFailure(e.toString()));
    }
  }
}
