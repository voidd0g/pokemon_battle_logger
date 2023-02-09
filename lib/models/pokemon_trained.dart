class PokemonTrained {
  final int pokedex;
  final int form;
  final String nickname;
  final int abilityId;
  final int itemId;
  final int move1Id;
  final int move2Id;
  final int move3Id;
  final int move4Id;
  final int sex;
  final int idValHp;
  final int idValAtk;
  final int idValDef;
  final int idValSpAtk;
  final int idValSpDef;
  final int idValSpeed;
  final int efValHp;
  final int efValAtk;
  final int efValDef;
  final int efValSpAtk;
  final int efValSpDef;
  final int efValSpeed;

  static const String pokedexField = 'pokedex';
  static const String formField = 'form';
  static const String nicknameField = 'nickname';
  static const String abilityIdField = 'ability_id';
  static const String itemIdField = 'item_id';
  static const String move1IdField = 'move1_Id';
  static const String move2IdField = 'move2_Id';
  static const String move3IdField = 'move3_Id';
  static const String move4IdField = 'move4_Id';
  static const String sexField = 'sex';
  static const String idValHpField = 'id_val_hp';
  static const String idValAtkField = 'id_val_atk';
  static const String idValDefField = 'id_val_def';
  static const String idValSpAtkField = 'id_val_sp_atk';
  static const String idValSpDefField = 'id_val_sp_def';
  static const String idValSpeedField = 'id_val_speed';
  static const String efValHpField = 'ef_val_hp';
  static const String efValAtkField = 'ef_val_atk';
  static const String efValDefField = 'ef_val_def';
  static const String efValSpAtkField = 'ef_val_sp_atk';
  static const String efValSpDefField = 'ef_val_sp_def';
  static const String efValSpeedField = 'ef_val_speed';

  const PokemonTrained({
    required this.pokedex,
    required this.form,
    required this.nickname,
    required this.abilityId,
    required this.itemId,
    required this.move1Id,
    required this.move2Id,
    required this.move3Id,
    required this.move4Id,
    required this.sex,
    required this.idValHp,
    required this.idValAtk,
    required this.idValDef,
    required this.idValSpAtk,
    required this.idValSpDef,
    required this.idValSpeed,
    required this.efValHp,
    required this.efValAtk,
    required this.efValDef,
    required this.efValSpAtk,
    required this.efValSpDef,
    required this.efValSpeed,
  });

  PokemonTrained copy({
    int? newPokedex,
    int? newForm,
    String? newNickname,
    int? newAbilityId,
    int? newItemId,
    int? newMove1Id,
    int? newMove2Id,
    int? newMove3Id,
    int? newMove4Id,
    int? newSex,
    int? newIdValHp,
    int? newIdValAtk,
    int? newIdValDef,
    int? newIdValSpAtk,
    int? newIdValSpDef,
    int? newIdValSpeed,
    int? newEfValHp,
    int? newEfValAtk,
    int? newEfValDef,
    int? newEfValSpAtk,
    int? newEfValSpDef,
    int? newEfValSpeed,
  }) {
    return PokemonTrained(
      pokedex: newPokedex ?? pokedex,
      form: newForm ?? form,
      nickname: newNickname ?? nickname,
      abilityId: newAbilityId ?? abilityId,
      itemId: newItemId ?? itemId,
      move1Id: newMove1Id ?? move1Id,
      move2Id: newMove2Id ?? move2Id,
      move3Id: newMove3Id ?? move3Id,
      move4Id: newMove4Id ?? move4Id,
      sex: newSex ?? sex,
      idValHp: newIdValHp ?? idValHp,
      idValAtk: newIdValAtk ?? idValAtk,
      idValDef: newIdValDef ?? idValDef,
      idValSpAtk: newIdValSpAtk ?? idValSpAtk,
      idValSpDef: newIdValSpDef ?? idValSpDef,
      idValSpeed: newIdValSpeed ?? idValSpeed,
      efValHp: newEfValHp ?? efValHp,
      efValAtk: newEfValAtk ?? efValAtk,
      efValDef: newEfValDef ?? efValDef,
      efValSpAtk: newEfValSpAtk ?? efValSpAtk,
      efValSpDef: newEfValSpDef ?? efValSpDef,
      efValSpeed: newEfValSpeed ?? efValSpeed,
    );
  }

  PokemonTrained.fromMap(Map<String, dynamic> data)
      : pokedex = data[pokedexField],
        form = data[formField],
        nickname = data[nicknameField],
        abilityId = data[abilityIdField],
        itemId = data[itemIdField],
        move1Id = data[move1IdField],
        move2Id = data[move2IdField],
        move3Id = data[move3IdField],
        move4Id = data[move4IdField],
        sex = data[sexField],
        idValHp = data[idValHpField],
        idValAtk = data[idValAtkField],
        idValDef = data[idValDefField],
        idValSpAtk = data[idValSpAtkField],
        idValSpDef = data[idValSpDefField],
        idValSpeed = data[idValSpeedField],
        efValHp = data[efValHpField],
        efValAtk = data[efValAtkField],
        efValDef = data[efValDefField],
        efValSpAtk = data[efValSpAtkField],
        efValSpDef = data[efValSpDefField],
        efValSpeed = data[efValSpeedField];

  Map<String, dynamic> toMap() {
    return {
      pokedexField: pokedex,
      formField: form,
      nicknameField: nickname,
      abilityIdField: abilityId,
      itemIdField: itemId,
      move1IdField: move1Id,
      move2IdField: move2Id,
      move3IdField: move3Id,
      move4IdField: move4Id,
      sexField: sex,
      idValHpField: idValHp,
      idValAtkField: idValAtk,
      idValDefField: idValDef,
      idValSpAtkField: idValSpAtk,
      idValSpDefField: idValSpDef,
      idValSpeedField: idValSpeed,
      efValHpField: efValHp,
      efValAtkField: efValAtk,
      efValDefField: efValDef,
      efValSpAtkField: efValSpAtk,
      efValSpDefField: efValSpDef,
      efValSpeedField: efValSpeed,
    };
  }
}
