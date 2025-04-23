import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ios_fl_n_mondialstyle_3445/cubit/outfit_cubit/outfit_cubit.dart';
import 'package:ios_fl_n_mondialstyle_3445/screens/outfits_screen/outfit_detail_screen.dart';

class FavouritesOutfitsScreen extends StatefulWidget {
  const FavouritesOutfitsScreen({super.key});

  @override
  State<FavouritesOutfitsScreen> createState() =>
      _FavouritesOutfitsScreenState();
}

class _FavouritesOutfitsScreenState extends State<FavouritesOutfitsScreen> {
  bool showRepeat = true;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OutfitCubit>();
    final outfits = showRepeat ? cubit.wantToRepeat : cubit.inspired;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'FAVORITS',
          style: TextStyle(
            color: Color(0xFFF0E12D),
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                width: 170,
                child: ElevatedButton(
                  onPressed: () => setState(() => showRepeat = true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        showRepeat
                            ? const Color(0xFFEBFC00)
                            : const Color(0xFF444444),
                    foregroundColor:
                        showRepeat ? const Color(0xFF00590C) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'WANT TO REPEAT',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 50,
                width: 170,
                child: ElevatedButton(
                  onPressed: () => setState(() => showRepeat = false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        !showRepeat
                            ? const Color(0xFFEBFC00)
                            : const Color(0xFF444444),
                    foregroundColor:
                        !showRepeat ? const Color(0xFF00590C) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'INSPIRED',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child:
                outfits.isEmpty
                    ? const Center(
                      child: Text(
                        'No favorites yet',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )
                    : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.5,
                          ),
                      itemCount: outfits.length,
                      itemBuilder: (context, index) {
                        final outfit = outfits[index];
                        final isInRepeat = cubit.wantToRepeat.contains(outfit);
                        final isInInspired = cubit.inspired.contains(outfit);

                        return GestureDetector(
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => OutfitDetailScreen(outfit: outfit),
                                ),
                              ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    outfit.image,
                                    fit: BoxFit.cover,
                                    height: 200,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  outfit.city.toUpperCase(),
                                  style: const TextStyle(
                                    color: Color(0xFFEBFC00),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
                                const SizedBox(height: 6),
                                if (!showRepeat)
                                  ElevatedButton(
                                    onPressed: () {
                                      cubit.toggleWantToRepeat(outfit);
                                      setState(() {});
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          isInRepeat
                                              ? const Color(0xFFEBFC00)
                                              : Colors.transparent,
                                      foregroundColor:
                                          isInRepeat
                                              ? const Color(0xFF00590C)
                                              : Colors.yellow,
                                      side: const BorderSide(
                                        color: Colors.yellow,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: const Text(
                                      'WANT TO REPEAT',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                if (showRepeat)
                                  ElevatedButton(
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
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: const Text(
                                      'INSPIRED',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
