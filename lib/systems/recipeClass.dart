
class Recipe {
  String name;
  String? imageUrl;
  final List<String> ingredients;
  final List<String> instructions;

  Recipe({
    required this.name,
    this.imageUrl,
    required this.ingredients,
    required this.instructions,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
      'instructions': instructions,
    };
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      name: json['name'],
      imageUrl: json['imageUrl'],
      ingredients: List<String>.from(json['ingredients']),
      instructions: List<String>.from(json['instructions']),
    );
  }

  
  
}
