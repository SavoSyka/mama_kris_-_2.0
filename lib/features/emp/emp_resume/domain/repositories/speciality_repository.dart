import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/entities/speciality.dart';

abstract class SpecialityRepository {
  ResultFuture<List<Speciality>> searchSpecialities(String query);
}