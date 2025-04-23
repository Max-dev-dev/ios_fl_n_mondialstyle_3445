class ClothesModel {
  final int? id;
  final String name;
  final String image;
  final String season;
  final String activity;

  ClothesModel({
    this.id,
    required this.name,
    required this.image,
    required this.season,
    required this.activity,
  });

  factory ClothesModel.fromJson(Map<String, dynamic> json) {
    return ClothesModel(
      id: json['id'] != null ? json['id'] as int : null,
      name: json['name'] as String,
      image: json['image'] as String,
      season: json['season'] as String,
      activity: json['activity'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'season': season,
      'activity': activity,
    };
  }
}
