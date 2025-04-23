import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ios_fl_n_mondialstyle_3445/cubit/clothes_cubit/clothes_cubit.dart';
import 'package:ios_fl_n_mondialstyle_3445/models/clothes_model/clothes_model.dart';

class AddClothesScreen extends StatefulWidget {
  const AddClothesScreen({super.key});

  @override
  State<AddClothesScreen> createState() => _AddClothesScreenState();
}

class _AddClothesScreenState extends State<AddClothesScreen> {
  final _nameController = TextEditingController();
  final _seasonController = TextEditingController();
  final _activityController = TextEditingController();
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  void _saveClothes() {
    if (_imageFile == null ||
        _nameController.text.isEmpty ||
        _seasonController.text.isEmpty ||
        _activityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields and add a picture.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newClothes = ClothesModel(
      id: DateTime.now().millisecondsSinceEpoch,
      name: _nameController.text,
      image: _imageFile!.path,
      season: _seasonController.text,
      activity: _activityController.text,
    );

    context.read<ClothesCubit>().addCustomClothes(newClothes);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFF0E12D)),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'ADD CLOTHES',
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                  image:
                      _imageFile != null
                          ? DecorationImage(
                            image: FileImage(_imageFile!),
                            fit: BoxFit.cover,
                          )
                          : null,
                ),
                child:
                    _imageFile == null
                        ? const Center(
                          child: Text(
                            'ADD PICTURE',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                        : null,
              ),
            ),
            const SizedBox(height: 24),
            _buildField(label: 'NAME', controller: _nameController),
            _buildField(label: 'SEASON', controller: _seasonController),
            _buildField(label: 'ACTIVITY', controller: _activityController),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saveClothes,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.yellow,
                  side: const BorderSide(color: Colors.yellow),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('SAVE', style: TextStyle(fontSize: 28)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Enter',
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
