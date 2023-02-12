class Pokemon {
  final int pokedex;
  final int form;
  final String name;
  final String hiraName;
  final int type1;
  final int type2;
  final int weight10;
  final int baseStatsHp;
  final int baseStatsAtk;
  final int baseStatsDef;
  final int baseStatsSpAtk;
  final int baseStatsSpDef;
  final int baseStatsSpeed;

  static const String pokedexField = 'pokedex';
  static const String formField = 'form';
  static const String nameField = 'name';
  static const String hiraNameField = 'hiraname';
  static const String type1Field = 'type1';
  static const String type2Field = 'type2';
  static const String weight10Field = 'weight10';
  static const String baseStatsHpField = 'bshp';
  static const String baseStatsAtkField = 'bsatk';
  static const String baseStatsDefField = 'bsdef';
  static const String baseStatsSpAtkField = 'bssat';
  static const String baseStatsSpDefField = 'bssdf';
  static const String baseStatsSpeedField = 'bsspd';

  const Pokemon({
    required this.pokedex,
    required this.form,
    required this.name,
    required this.hiraName,
    required this.type1,
    required this.type2,
    required this.weight10,
    required this.baseStatsHp,
    required this.baseStatsAtk,
    required this.baseStatsDef,
    required this.baseStatsSpAtk,
    required this.baseStatsSpDef,
    required this.baseStatsSpeed,
  });

  Pokemon copy({
    int? newPokedex,
    int? newForm,
    String? newName,
    String? newHiraName,
    int? newType1,
    int? newType2,
    int? newWeight10,
    int? newBaseStatsHp,
    int? newBaseStatsAtk,
    int? newBaseStatsDef,
    int? newBaseStatsSpAtk,
    int? newBaseStatsSpDef,
    int? newBaseStatsSpeed,
  }) {
    return Pokemon(
      pokedex: newPokedex ?? pokedex,
      form: newForm ?? form,
      name: newName ?? name,
      hiraName: newHiraName ?? hiraName,
      type1: newType1 ?? type1,
      type2: newType2 ?? type2,
      weight10: newWeight10 ?? weight10,
      baseStatsHp: newBaseStatsHp ?? baseStatsHp,
      baseStatsAtk: newBaseStatsAtk ?? baseStatsAtk,
      baseStatsDef: newBaseStatsDef ?? baseStatsDef,
      baseStatsSpAtk: newBaseStatsSpAtk ?? baseStatsSpAtk,
      baseStatsSpDef: newBaseStatsSpDef ?? baseStatsSpDef,
      baseStatsSpeed: newBaseStatsSpeed ?? baseStatsSpeed,
    );
  }

  Pokemon.fromMap(Map<String, dynamic> data)
      : pokedex = data[pokedexField],
        form = data[formField],
        name = data[nameField],
        hiraName = data[hiraNameField],
        type1 = data[type1Field],
        type2 = data[type2Field],
        weight10 = data[weight10Field],
        baseStatsHp = data[baseStatsHpField],
        baseStatsAtk = data[baseStatsAtkField],
        baseStatsDef = data[baseStatsDefField],
        baseStatsSpAtk = data[baseStatsSpAtkField],
        baseStatsSpDef = data[baseStatsSpDefField],
        baseStatsSpeed = data[baseStatsSpeedField];

  Map<String, dynamic> toMap() {
    return {
      pokedexField: pokedex,
      formField: form,
      nameField: name,
      hiraNameField: hiraName,
      type1Field: type1,
      type2Field: type2,
      weight10Field: weight10,
      baseStatsHpField: baseStatsHp,
      baseStatsAtkField: baseStatsAtk,
      baseStatsDefField: baseStatsDef,
      baseStatsSpAtkField: baseStatsSpAtk,
      baseStatsSpDefField: baseStatsSpDef,
      baseStatsSpeedField: baseStatsSpeed,
    };
  }

  @override
  String toString() {
    return '$pokedex-$form $name';
  }
}
