import 'package:mama_kris/features/appl/appl_home/domain/entities/ad_entity.dart';

class AdModel extends AdEntity {
  const AdModel({
    required super.id,
    required super.imagePath,
    required super.link,
    required super.isActive,
    required super.sendCount,
    required super.imageData,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['id'],
      imagePath: json['imagePath'],
      link: json['link'],
      isActive: json['isActive'],
      sendCount: json['sendCount'],
      imageData: json['imageData'],
    );
  }
}
