import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:ios_fl_n_mondialstyle_3445/models/outfit_model/outfit_model.dart';
import 'package:logger/logger.dart';

class OutfitCubit extends Cubit<List<OutfitModel>> {
  OutfitCubit() : super([]);

  final Logger _logger = Logger();

  final Set<OutfitModel> _wantToRepeat = {};
  final Set<OutfitModel> _inspired = {};

  Future<void> loadOutfits() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/outfits.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString);
      final outfits = jsonData.map((e) => OutfitModel.fromJson(e)).toList();
      emit(outfits);
      _logger.i('Loaded ${outfits.length} outfits');
    } catch (e) {
      emit([]);
      _logger.e('Failed to load outfits: $e');
    }
  }

  void filterBy({String? season, String? city, String? activity}) {
    final filtered =
        state.where((o) {
          final matchSeason = season == null || o.season == season;
          final matchCity = city == null || o.city == city;
          final matchActivity = activity == null || o.activity == activity;
          return matchSeason && matchCity && matchActivity;
        }).toList();

    emit(filtered);
    _logger.i('Filtered outfits. Results: ${filtered.length}');
  }

  void resetFilters() {
    loadOutfits();
    _logger.i('Filters reset');
  }

  void toggleWantToRepeat(OutfitModel outfit) {
    if (_wantToRepeat.contains(outfit)) {
      _wantToRepeat.remove(outfit);
      _logger.i('Removed from WantToRepeat: ${outfit.city}');
    } else {
      _wantToRepeat.add(outfit);
      _logger.i('Added to WantToRepeat: ${outfit.city}');
    }
    emit(List.from(state));
  }

  void toggleInspired(OutfitModel outfit) {
    if (_inspired.contains(outfit)) {
      _inspired.remove(outfit);
      _logger.i('Removed from Inspired: ${outfit.city}');
    } else {
      _inspired.add(outfit);
      _logger.i('Added to Inspired: ${outfit.city}');
    }
    emit(List.from(state));
  }

  List<OutfitModel> get wantToRepeat => _wantToRepeat.toList();
  List<OutfitModel> get inspired => _inspired.toList();

  List<String> get cities => state.map((e) => e.city).toSet().toList();
  List<String> get seasons => state.map((e) => e.season).toSet().toList();
  List<String> get activities => state.map((e) => e.activity).toSet().toList();
}
