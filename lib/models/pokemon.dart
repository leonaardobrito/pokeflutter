class Pokemon {
  final String name;
  final String imageUrl;
  final int id;

  Pokemon({required this.name, required this.imageUrl, required this.id});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      imageUrl: json['sprites']['front_default'],
      id: json['id'],
    );
  }
}
