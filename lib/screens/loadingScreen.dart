import 'package:flutter/material.dart';
import 'package:nomnom/screens/matchingrecipeScreen.dart';
import 'package:nomnom/systems/chatGPTSystem.dart';
import 'package:nomnom/systems/pexelsService.dart';
import 'package:nomnom/systems/recipeClass.dart';
import 'package:nomnom/systems/recipeSystem.dart';
import 'package:nomnom/themes/apptheme.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen(
      {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final ChatGptService _chatGptSystem = ChatGptService();
  final PexelsService _pexelsService = PexelsService();
  String? recipe;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    RecipeSystem recipeSystem = RecipeSystem();
    String myPrompt = recipeSystem.createPrompt();
    final response = await _chatGptSystem.sendGPTMessage(myPrompt);
    final content = response?['choices'][0]['message']['content'];

    List<Recipe> recipes = _parseRecipes(content);
  
    for (var recipe in recipes) {
      final imageUrl = await _pexelsService.getImageUrl(recipe.name);
      recipe.imageUrl = imageUrl; 
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MatchingRecipeScreen(recipe: recipes),
      ),
    );
  }

  List<Recipe> _parseRecipes(String content) {
    final recipeRegex = RegExp(
      r'@(.+?)\n((?:# .*\n)+)((?:\* .*\n)+)',
      multiLine: true,
    );

    final matches = recipeRegex.allMatches(content);
    List<Recipe> recipes = [];

    for (final match in matches) {
      final name = match.group(1)!.trim();
      final ingredientsRaw = match.group(2)!.trim();
      final instructionsRaw = match.group(3)!.trim();

      final ingredients = ingredientsRaw.isNotEmpty
          ? ingredientsRaw.split('\n').map((e) => e.length > 2 ? e.substring(2) : '').toList().cast<String>()
          : <String>[];
      final instructions = instructionsRaw.isNotEmpty
          ? instructionsRaw.split('\n').map((e) => e.length > 2 ? e.substring(2) : '').toList().cast<String>()
          : <String>[];

      recipes.add(Recipe(name: name, ingredients: ingredients, instructions: instructions));
    }

    return recipes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: AppTheme
            .primaryColor, // Using the AppTheme color you defined earlier
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              Icon(
                Icons.search, size: 150,
                color: AppTheme.whiteColor, // Adjust color as needed
              ),
              Text(
                'Finding Your Recipe...',
                style: TextStyle(
                    fontSize: 40, color: Colors.white, fontFamily: "Lobster"),
              ),
              SizedBox(height: 30),
              CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
              Spacer(),
              Text(
                textAlign: TextAlign.end,
                'Provided by G14',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
