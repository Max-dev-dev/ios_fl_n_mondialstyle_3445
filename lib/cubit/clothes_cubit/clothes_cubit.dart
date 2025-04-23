import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'package:ios_fl_n_mondialstyle_3445/models/clothes_model/clothes_model.dart';

class ClothesCubit extends Cubit<List<ClothesModel>> {
  ClothesCubit() : super([]);

  final Logger _logger = Logger();
  final List<String> selectedIds = [];

  Future<void> loadClothes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final customData = prefs.getStringList('custom_clothes') ?? [];
      final selected = prefs.getStringList('selected_clothes') ?? [];

      final String jsonString = await rootBundle.loadString('assets/data/clothes.json');
      final List<dynamic> baseJson = json.decode(jsonString);
      final baseClothes = baseJson.map((e) => ClothesModel.fromJson(e)).toList();
      final customClothes = customData.map((item) => ClothesModel.fromJson(json.decode(item))).toList();

      selectedIds.clear();
      selectedIds.addAll(selected);
      emit([...baseClothes, ...customClothes]);

      _logger.i('Loaded clothes: ${state.length}, selected: ${selectedIds.length}');
    } catch (e) {
      _logger.e('Failed to load clothes: $e');
      emit([]);
    }
  }

  Future<void> toggleSelected(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    if (selectedIds.contains(imagePath)) {
      selectedIds.remove(imagePath);
    } else {
      selectedIds.add(imagePath);
    }
    await prefs.setStringList('selected_clothes', selectedIds);
    emit(List.from(state)); // trigger rebuild
  }

  Future<void> addCustomClothes(ClothesModel clothes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> current = prefs.getStringList('custom_clothes') ?? [];
      final updated = [...current, json.encode(clothes.toJson())];
      await prefs.setStringList('custom_clothes', updated);

      final updatedList = [...state, clothes];
      emit(updatedList);

      _logger.i('Added custom clothes: ${clothes.name}');
    } catch (e) {
      _logger.e('Failed to add custom clothes: $e');
    }
  }

  List<String> get allSeasons =>
      state.map((e) => e.season).toSet().toList();

  List<String> get allActivities =>
      state.expand((e) => e.activity.split(',').map((e) => e.trim())).toSet().toList();
}
