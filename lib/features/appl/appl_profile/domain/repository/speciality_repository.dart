import 'package:mama_kris/core/utils/typedef.dart';

abstract class SpecialityRepository {
  ResultFuture<List<String>> searchSpeciality(String query);
}
