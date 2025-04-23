import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ios_fl_n_mondialstyle_3445/cubit/clothes_cubit/clothes_cubit.dart';
import 'package:ios_fl_n_mondialstyle_3445/models/clothes_model/clothes_model.dart';
import 'package:ios_fl_n_mondialstyle_3445/screens/my_wardrobe_screen/add_clothes_screen.dart';

class MyWardrobeScreen extends StatefulWidget {
  const MyWardrobeScreen({super.key});

  @override
  State<MyWardrobeScreen> createState() => _MyWardrobeScreenState();
}

class _MyWardrobeScreenState extends State<MyWardrobeScreen> {
  String? selectedSeason;
  String? selectedActivity;

  @override
  void initState() {
    super.initState();
    context.read<ClothesCubit>().loadClothes();
  }

  Widget _buildCustomDropdown({
    required String label,
    required List<String> items,
    required String? selectedValue,
    required void Function(String?) onChanged,
  }) {
    final isActive = selectedValue != null;
    return GestureDetector(
      onTap: () async {
        final result = await showModalBottomSheet<String>(
          context: context,
          backgroundColor: const Color(0xFF004A1F),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          builder:
              (_) => ListView(
                shrinkWrap: true,
                children:
                    items.map((item) {
                      return ListTile(
                        title: Center(
                          child: Text(
                            item.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.yellow,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () => Navigator.pop(context, item),
                      );
                    }).toList(),
              ),
        );
        if (result != null) setState(() => onChanged(result));
      },
      child: Container(
        width: 140,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFEBFC00) : const Color(0xFF444444),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            (selectedValue ?? label).toUpperCase(),
            style: TextStyle(
              color: isActive ? const Color(0xFF00590C) : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      selectedSeason = null;
      selectedActivity = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'MY WARDROBE',
          style: TextStyle(
            color: Color(0xFFF0E12D),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: BlocBuilder<ClothesCubit, List<ClothesModel>>(
        builder: (context, clothes) {
          final filtered =
              clothes.where((c) {
                final seasonMatch =
                    selectedSeason == null || c.season == selectedSeason;
                final activityMatch =
                    selectedActivity == null ||
                    c.activity
                        .split(',')
                        .map((e) => e.trim())
                        .contains(selectedActivity);
                return seasonMatch && activityMatch;
              }).toList();

          final cubit = context.read<ClothesCubit>();

          return Column(
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  SizedBox(
                    width: 140.0,
                    height: 50.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor:
                            (selectedSeason == null && selectedActivity == null)
                                ? const Color(0xFFEBFC00)
                                : const Color(0xFF444444),
                        foregroundColor: Colors.black,
                      ),
                      onPressed: _resetFilters,
                      child: Text(
                        'ALL',
                        style: TextStyle(
                          fontSize: 18.0,
                          color:
                              (selectedSeason == null &&
                                      selectedActivity == null)
                                  ? const Color(0xFF00590C)
                                  : Colors.white,
                        ),
                      ),
                    ),
                  ),

                  _buildCustomDropdown(
                    label: 'Season',
                    items: cubit.allSeasons,
                    selectedValue: selectedSeason,
                    onChanged: (value) => selectedSeason = value,
                  ),
                  _buildCustomDropdown(
                    label: 'Activity',
                    items: cubit.allActivities,
                    selectedValue: selectedActivity,
                    onChanged: (value) => selectedActivity = value,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    final isSelected = cubit.selectedIds.contains(item.image);

                    return Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF008C13),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child:
                                          item.image.startsWith('assets')
                                              ? Image.asset(
                                                item.image,
                                                fit: BoxFit.cover,
                                              )
                                              : Image.file(
                                                File(item.image),
                                                fit: BoxFit.cover,
                                              ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item.name.toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFFEBFC00),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                item.season.toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFF39C64C),
                                ),
                              ),
                              Text(
                                item.activity.toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFF39C64C),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: GestureDetector(
                            onTap: () {
                              cubit.toggleSelected(item.image);
                            },
                            child: Icon(
                              Icons.check_circle,
                              color:
                                  isSelected
                                      ? const Color(0xFF39C64C)
                                      : Colors.grey,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const AddClothesScreen()));
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF39C64C),
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Icon(Icons.add, size: 40, color: Color(0xFF1B2A1D)),
        ),
      ),
    );
  }
}
