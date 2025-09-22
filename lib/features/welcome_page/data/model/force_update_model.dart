import 'package:mama_kris/features/welcome_page/domain/entity/force_update.dart';

class ForceUpdateModel extends ForceUpdate {
  const ForceUpdateModel({required super.id, required super.version});

  factory ForceUpdateModel.fromJson(Map<String, dynamic> json) {
    return ForceUpdateModel(
      id: json['id'].toString(),
      version: json['version'] ?? '',
    );
  }
}
