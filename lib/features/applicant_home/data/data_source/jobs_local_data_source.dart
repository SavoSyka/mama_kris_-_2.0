import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mama_kris/core/constants/hive_constants.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mama_kris/features/applicant_home/data/model/search_job_model.dart';

abstract class JobsLocalDataSource {
  /// Save the last searched job list locally
  Future<void> saveSearchQueries(String query);

  /// Get cached search results
  Future<List<SearchJobModel>> getSearchQueries();

  /// Clear cached searches
  ///
  Future<void> clearAllSearchQueries();

  Future<void> removeSearchQuery(String query);

  Future<void> saveSpheres(List<SearchJobModel> spheres);

  Future<List<SearchJobModel>> getAllSpheres();

  /// Clear cached clearAllSpheres

  Future<void> clearAllSpheres();
}

class JobsLocalDataSourceImpl implements JobsLocalDataSource {
  Future<Box<SearchJobModel>> _getSearchBox() async {
    return await Hive.openBox<SearchJobModel>(HiveConstants.searchJobBox);
  }

  @override
  Future<List<SearchJobModel>> getSearchQueries() async {
    final box = await _getSearchBox();
    return box.values.toList();
  }

  @override
  Future<List<SearchJobModel>> getAllSpheres() async {
    final box = await _getSphereBox();
    return box.values.toList();
  }

  Future<Box<SearchJobModel>> _getSphereBox() async {
    return await Hive.openBox<SearchJobModel>(HiveConstants.sphereJobBox);
  }

  @override
  Future<void> saveSearchQueries(String query) async {
    if (query.isEmpty) return;

    final box = await _getSearchBox();
    final searchJob = SearchJobModel(title: query);

    // Find and remove duplicate based on title directly from the box
    for (int i = 0; i < box.length; i++) {
      if (box.getAt(i)?.title == query) {
        await box.deleteAt(i);
        debugPrint("Removed duplicate search query: $query at index $i");
        break; // Remove only the first matching duplicate
      }
    }

    debugPrint("Box Length ${box.length}");

    // Add new search to the beginning (index 0)
    if (box.isEmpty) {
      await box.add(searchJob);
    } else {
      await box.putAt(0, searchJob);
    }
    debugPrint("Added new search query at index 0: $query");

    // Limit to 10 searches
    if (box.length > 10) {
      final oldestIndex = box.length - 1;
      await box.deleteAt(oldestIndex);
      debugPrint("Removed oldest search query at index $oldestIndex");
    }

    // Verify the box contents (for debugging)
    debugPrint(
      "Current box contents: ${box.values.map((e) => e.title).toList()}",
    );
  }

  @override
  Future<void> removeSearchQuery(String query) async {
    final box = await _getSearchBox();

    final existingSearches = box.values.toList();

    final index = existingSearches.indexWhere(
      (search) => search.title == query,
    );

    if (index != -1) {
      await box.deleteAt(index);
    }
  }

  @override
  Future<void> clearAllSearchQueries() async {
    final box = await _getSearchBox();
    await box.clear();
  }

  @override
  Future<void> saveSpheres(List<SearchJobModel> spheres) async {
    if (spheres.isEmpty) return;

    final box = await _getSphereBox();

    final existingTitles = box.values.map((e) => e.title).toSet();

    for (var sphere in spheres) {
      if (!existingTitles.contains(sphere.title)) {
        await box.add(sphere);
        existingTitles.add(sphere.title);
        debugPrint("Added new sphere: ${sphere.title}");
      } else {
        debugPrint("Skipped duplicate sphere: ${sphere.title}");
      }
    }
  }

  @override
  Future<void> clearAllSpheres() async {
    final box = await _getSphereBox();
    await box.clear();
    debugPrint("Cleared all spheres");
  }
}
