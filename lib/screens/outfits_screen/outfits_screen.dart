import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ios_fl_n_mondialstyle_3445/cubit/outfit_cubit/outfit_cubit.dart';
import 'package:ios_fl_n_mondialstyle_3445/models/outfit_model/outfit_model.dart';
import 'package:ios_fl_n_mondialstyle_3445/screens/outfits_screen/outfit_detail_screen.dart';

class OutfitsScreen extends StatefulWidget {
  const OutfitsScreen({super.key});

  @override
  State<OutfitsScreen> createState() => _OutfitsScreenState();
}

class _OutfitsScreenState extends State<OutfitsScreen> {
  String? selectedCity;
  String? selectedSeason;
  String? selectedActivity;

  @override
  void initState() {
    super.initState();
    context.read<OutfitCubit>().loadOutfits();
  }

  void _resetFilters() {
    setState(() {
      selectedCity = null;
      selectedSeason = null;
      selectedActivity = null;
    });
    context.read<OutfitCubit>().resetFilters();
  }

  void _applyFilter() {
    context.read<OutfitCubit>().filterBy(
      city: selectedCity,
      season: selectedSeason,
      activity: selectedActivity,
    );
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          builder: (_) {
            return ListView(
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
            );
          },
        );
        if (result != null) {
          setState(() => onChanged(result));
          _applyFilter();
        }
      },
      child: Container(
        width: 140.0,
        height: 50.0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Color(0xFFEBFC00) : Color(0xFF444444),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            (selectedValue ?? label).toUpperCase(),
            style: TextStyle(
              color: isActive ? Color(0xFF00590C) : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'GLOBAL FASHION FEED',
          style: TextStyle(
            color: Color(0xFFF0E12D),
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: BlocBuilder<OutfitCubit, List<OutfitModel>>(
              builder: (context, _) {
                final cubit = context.read<OutfitCubit>();
                return Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  alignment: WrapAlignment.start,
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
                              (selectedCity == null &&
                                      selectedSeason == null &&
                                      selectedActivity == null)
                                  ? Color(0xFFEBFC00)
                                  : Color(0xFF444444),
                          foregroundColor: Colors.black,
                        ),
                        onPressed: _resetFilters,
                        child: Text(
                          'ALL',
                          style: TextStyle(
                            fontSize: 18.0,
                            color:
                                (selectedCity == null &&
                                        selectedSeason == null &&
                                        selectedActivity == null)
                                    ? Color(0xFF00590C)
                                    : Colors.white,
                          ),
                        ),
                      ),
                    ),
                    if (cubit.cities.isNotEmpty)
                      _buildCustomDropdown(
                        label: 'Country',
                        items: cubit.cities,
                        selectedValue: selectedCity,
                        onChanged: (value) => selectedCity = value,
                      ),
                    if (cubit.seasons.isNotEmpty)
                      _buildCustomDropdown(
                        label: 'Season',
                        items: cubit.seasons,
                        selectedValue: selectedSeason,
                        onChanged: (value) => selectedSeason = value,
                      ),
                    if (cubit.activities.isNotEmpty)
                      _buildCustomDropdown(
                        label: 'Activity',
                        items: cubit.activities,
                        selectedValue: selectedActivity,
                        onChanged: (value) => selectedActivity = value,
                      ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<OutfitCubit, List<OutfitModel>>(
              builder: (context, outfits) {
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.398,
                  ),
                  itemCount: outfits.length,
                  itemBuilder: (context, index) {
                    final outfit = outfits[index];

                    final cubit = context.read<OutfitCubit>();
                    final isInWantToRepeat = cubit.wantToRepeat.contains(
                      outfit,
                    );
                    final isInInspired = cubit.inspired.contains(outfit);

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => OutfitDetailScreen(outfit: outfit),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                              child: Image.asset(
                                outfit.image,
                                fit: BoxFit.cover,
                                height: 220,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    outfit.city.toUpperCase(),
                                    style: const TextStyle(
                                      color: Color(0xFFEBFC00),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    outfit.season.toUpperCase(),
                                    style: const TextStyle(
                                      color: Color(0xFF39C64C),
                                    ),
                                  ),
                                  Text(
                                    outfit.activity.toUpperCase(),
                                    style: const TextStyle(
                                      color: Color(0xFF39C64C),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        cubit.toggleWantToRepeat(outfit);
                                        setState(() {});
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            isInWantToRepeat
                                                ? const Color(0xFFEBFC00)
                                                : Colors.transparent,
                                        foregroundColor:
                                            isInWantToRepeat
                                                ? const Color(0xFF00590C)
                                                : Colors.yellow,
                                        side: const BorderSide(
                                          color: Colors.yellow,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'WANT TO REPEAT',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        cubit.toggleInspired(outfit);
                                        setState(() {});
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            isInInspired
                                                ? const Color(0xFFEBFC00)
                                                : Colors.transparent,
                                        foregroundColor:
                                            isInInspired
                                                ? const Color(0xFF00590C)
                                                : Colors.yellow,
                                        side: const BorderSide(
                                          color: Colors.yellow,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'INSPIRED',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
