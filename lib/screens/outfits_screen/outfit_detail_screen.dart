import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ios_fl_n_mondialstyle_3445/cubit/outfit_cubit/outfit_cubit.dart';
import 'package:ios_fl_n_mondialstyle_3445/models/outfit_model/outfit_model.dart';

class OutfitDetailScreen extends StatefulWidget {
  final OutfitModel outfit;
  const OutfitDetailScreen({super.key, required this.outfit});

  @override
  State<OutfitDetailScreen> createState() => _OutfitDetailScreenState();
}

class _OutfitDetailScreenState extends State<OutfitDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OutfitCubit>();
    final isInWantToRepeat = cubit.wantToRepeat.contains(widget.outfit);
    final isInInspired = cubit.inspired.contains(widget.outfit);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFF0E12D)),
          onPressed: () => Navigator.pop(context),
        ),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                widget.outfit.image,
                height: 420,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      cubit.toggleWantToRepeat(widget.outfit);
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
                      side: const BorderSide(color: Colors.yellow),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'WANT TO REPEAT',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      cubit.toggleInspired(widget.outfit);
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
                      side: const BorderSide(color: Colors.yellow),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
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
            const SizedBox(height: 24),
            Image.asset('assets/jax_1.png'),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
