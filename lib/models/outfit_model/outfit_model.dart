class OutfitModel {
  final String image;
  final String city;
  final String season;
  final String activity;

  OutfitModel({
    required this.image,
    required this.city,
    required this.season,
    required this.activity,
  });

  factory OutfitModel.fromJson(Map<String, dynamic> json) {
    return OutfitModel(
      image: json['image'] ?? '',
      city: json['city'] ?? '',
      season: json['season'] ?? '',
      activity: json['activity'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'city': city,
      'season': season,
      'activity': activity,
    };
  }
}
