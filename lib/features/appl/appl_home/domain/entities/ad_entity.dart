// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class AdEntity extends Equatable {
  final int id;
  final String imagePath;
  final String imageData;
  final String link;
  final bool isActive;
  final int sendCount;

  const AdEntity({
    required this.id,
    required this.imagePath,
    required this.link,
    required this.isActive,
    required this.sendCount,
    required this.imageData,
  });

  @override
  List<Object?> get props => [
    id,
    imagePath,
    link,
    isActive,
    sendCount,
    imageData,
  ];
}
