import 'package:mama_kris/features/emp/emp_resume/data/models/Speciality_list_model.dart';

abstract class SpecialityRemoteDataSource {
  Future<SpecialityListModel> searchSpecialities(String query, int page);
}