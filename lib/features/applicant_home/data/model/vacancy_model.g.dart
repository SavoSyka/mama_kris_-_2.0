// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vacancy_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VacancyModelAdapter extends TypeAdapter<VacancyModel> {
  @override
  final int typeId = 2;

  @override
  VacancyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VacancyModel(
      jobID: fields[0] as int?,
      job: fields[1] as JobModel?,
    );
  }

  @override
  void write(BinaryWriter writer, VacancyModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.jobID)
      ..writeByte(1)
      ..write(obj.job);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VacancyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class JobModelAdapter extends TypeAdapter<JobModel> {
  @override
  final int typeId = 3;

  @override
  JobModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JobModel(
      jobID: fields[0] as int?,
      userID: fields[1] as int?,
      description: fields[2] as String?,
      dateTime: fields[3] as String?,
      salary: fields[4] as String?,
      status: fields[5] as String?,
      title: fields[6] as String?,
      contactsID: fields[7] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, JobModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.jobID)
      ..writeByte(1)
      ..write(obj.userID)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.dateTime)
      ..writeByte(4)
      ..write(obj.salary)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.title)
      ..writeByte(7)
      ..write(obj.contactsID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
