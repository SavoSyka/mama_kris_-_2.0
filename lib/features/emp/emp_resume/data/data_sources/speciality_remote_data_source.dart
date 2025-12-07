import 'package:mama_kris/features/emp/emp_resume/data/models/Speciality_list_model.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/entities/speciality.dart';

abstract class SpecialityRemoteDataSource {
  Future<SpecialityListModel> searchSpecialities(String query, int page);
}