// presentation/cubit/recent_searches_cubit.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/features/applicant_home/data/data_source/jobs_local_data_source.dart';
import 'package:mama_kris/features/applicant_home/data/model/search_job_model.dart';
import 'package:mama_kris/features/applicant_home/domain/entity/search_job_entity.dart';

// Define states for recent searches
abstract class RecentSearchesState {}

class RecentSearchesInitial extends RecentSearchesState {}

class RecentSearchesLoading extends RecentSearchesState {}

class RecentSearchesLoaded extends RecentSearchesState {
  final List<SearchJobEntity> searches;
  RecentSearchesLoaded(this.searches);
}

class RecentSearchesError extends RecentSearchesState {
  final String message;
  RecentSearchesError(this.message);
}

class RecentSearchesCubit extends Cubit<RecentSearchesState> {
  final JobsLocalDataSource localDataSource;

  RecentSearchesCubit(this.localDataSource) : super(RecentSearchesInitial());

  Future<void> loadRecentSearches() async {
    emit(RecentSearchesLoading());
    try {
      final searches = await localDataSource.getSearchQueries();

      debugPrint("Searches ${searches.length}");
      emit(RecentSearchesLoaded(searches));
      debugPrint("Searches emitterd ${searches.length}");
    } catch (e) {
      emit(RecentSearchesError(e.toString()));
    }
  }

  Future<void> saveSearchQuery(String query) async {
    try {
      await localDataSource.saveSearchQueries(query);
      await loadRecentSearches(); // Refresh the list
    } catch (e) {
      emit(RecentSearchesError(e.toString()));
    }
  }

  Future<void> clearRecentSearches() async {
    try {
      await localDataSource.clearAllSearchQueries();
      emit(RecentSearchesLoaded([])); // Update to empty list
    } catch (e) {
      emit(RecentSearchesError(e.toString()));
    }
  }

  Future<void> removeSearchQuery(String query) async {
    try {
      await localDataSource.removeSearchQuery(query);
      loadRecentSearches();
      // emit(RecentSearchesLoaded([]));
    } catch (e) {
      emit(RecentSearchesError(e.toString()));
    }
  }
}
