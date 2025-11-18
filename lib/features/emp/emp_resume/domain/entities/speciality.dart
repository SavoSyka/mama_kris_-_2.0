class Speciality {
  final String name;

  const Speciality({required this.name});

  factory Speciality.fromJson(String json) {
    return Speciality(name: json);
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Speciality &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
