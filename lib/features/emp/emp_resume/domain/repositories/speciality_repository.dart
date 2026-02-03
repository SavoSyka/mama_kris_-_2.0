import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/entities/speciality_list.dart';

abstract class SpecialityRepository {
  ResultFuture<SpecialityList> searchSpecialities(String query, int page);
}
