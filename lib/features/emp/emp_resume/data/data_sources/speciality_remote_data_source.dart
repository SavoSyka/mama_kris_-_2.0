import 'package:mama_kris/features/emp/emp_resume/domain/entities/speciality.dart';

abstract class SpecialityRemoteDataSource {
  Future<List<Speciality>> searchSpecialities(String query);
}