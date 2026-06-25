import '../../core/typedefs/types_defs.dart';
import '../../domain/models/character_entity.dart';

abstract interface class ICharacterLocalStorage {
  void setSubAccountId(String id);
  Future<CharacterResult> saveCharacter(Character character);
  Future<ListCharacterResult> getAllCharacters();
  Future<CharacterResult> getCharacterById(String id);
  Future<CharacterResult> deleteCharacter(String id);
  Future<CharacterResult> updateCharacter(Character character);
}