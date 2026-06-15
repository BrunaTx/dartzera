import 'package:flutter/material.dart';
import 'package:injustice_app/domain/models/character_entity.dart';
import '../../../../../core/theme/app_theme.dart';

class CharacterEditView extends StatefulWidget {
  final Character character;

  const CharacterEditView({super.key, required this.character});

  @override
  State<CharacterEditView> createState() => _CharacterEditViewState();
}

class _CharacterEditViewState extends State<CharacterEditView> {
  late TextEditingController _nameController;

  late CharacterClass selectedClass;
  late CharacterRarity selectedRarity;
  late CharacterAlignment selectedAlignment;

  late int level;
  late int attack;
  late int health;
  late int stars;
  late int threat;

  @override
  void initState() {
    super.initState();

    final c = widget.character;

    _nameController = TextEditingController(text: c.name);

    selectedClass = c.characterClass;
    selectedRarity = c.rarity;
    selectedAlignment = c.alignment;

    level = c.level;
    attack = c.attack;
    health = c.health;
    stars = c.stars;
    threat = c.threat;
  }

  void _save() {
    final updated = widget.character.copyWith(
      name: _nameController.text,
      characterClass: selectedClass,
      rarity: selectedRarity,
      alignment: selectedAlignment,
      level: level,
      attack: attack,
      health: health,
      stars: stars,
      threat: threat,
      updatedAt: DateTime.now(),
    );

    Navigator.pop(context, updated);
  }

  Widget _numberField(String label, int value, Function(int) onChanged) {
    return TextFormField(
      initialValue: value.toString(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
      onChanged: (v) {
        final parsed = int.tryParse(v);
        if (parsed != null) onChanged(parsed);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Personagem'), centerTitle: true),
      body: Padding(
        padding: AppSpacing.paddingMd,
        child: ListView(
          children: [
            // ================= IDENTIDADE =================
            Card(
              child: Padding(
                padding: AppSpacing.paddingLg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Identidade',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Nome'),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    DropdownButtonFormField(
                      value: selectedClass,
                      decoration: const InputDecoration(labelText: 'Classe'),
                      items: CharacterClass.values.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e.displayName),
                        );
                      }).toList(),
                      onChanged: (v) => setState(() => selectedClass = v!),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    DropdownButtonFormField(
                      value: selectedRarity,
                      decoration: const InputDecoration(labelText: 'Raridade'),
                      items: CharacterRarity.values.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e.displayName),
                        );
                      }).toList(),
                      onChanged: (v) => setState(() => selectedRarity = v!),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    DropdownButtonFormField(
                      value: selectedAlignment,
                      decoration: const InputDecoration(labelText: 'Alinhamento'),
                      items: CharacterAlignment.values.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e.displayName),
                        );
                      }).toList(),
                      onChanged: (v) => setState(() => selectedAlignment = v!),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // ================= ATRIBUTOS =================
            Card(
              child: Padding(
                padding: AppSpacing.paddingLg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Atributos',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    _numberField('Level', level, (v) => level = v),
                    const SizedBox(height: AppSpacing.md),

                    _numberField('Ataque', attack, (v) => attack = v),
                    const SizedBox(height: AppSpacing.md),

                    _numberField('Vida', health, (v) => health = v),
                    const SizedBox(height: AppSpacing.md),

                    _numberField('Ameaça', threat, (v) => threat = v),
                    const SizedBox(height: AppSpacing.md),

                    _numberField('Estrelas', stars, (v) => stars = v),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            SizedBox(
              height: 52,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text('Atualizar'),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}