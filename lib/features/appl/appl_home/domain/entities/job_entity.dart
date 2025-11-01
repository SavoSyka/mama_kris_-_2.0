class JobEntity {
  final int id;
  final String title;
  final String description;
  final int price;
  final String status;

  JobEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.status,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is JobEntity &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.price == price &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        price.hashCode ^
        status.hashCode;
  }

  JobEntity copyWith({
    int? id,
    String? title,
    String? description,
    int? price,
    String? status,
  }) {
    return JobEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      status: status ?? this.status,
    );
  }
}