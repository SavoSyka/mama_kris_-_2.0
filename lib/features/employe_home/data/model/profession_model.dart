import 'package:mama_kris/features/employe_home/domain/entity/profession_entity.dart';

class ProfessionModel extends ProfessionEntity {
  const ProfessionModel({
    required String id,
    required String name,
  }) : super(
          id: id,
          name: name,
        );

  factory ProfessionModel.fromJson(Map<String, dynamic> json) {
    return ProfessionModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}