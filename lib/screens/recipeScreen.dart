import 'package:flutter/material.dart';
import 'package:nomnom/systems/recipeClass.dart';
import 'package:nomnom/systems/saveSystem.dart';
import 'package:nomnom/themes/apptheme.dart';
import 'package:nomnom/utils/drawer.dart';

class RecipeScreen extends StatefulWidget {
  final Recipe recipe;
  const RecipeScreen({super.key, required this.recipe});
  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  void _checkIfFavorite() async {
    List<Recipe> favorites = PreferenceManager.getFavoriteRecipes();
    if (favorites.any((r) => r.name == widget.recipe.name)) {
      setState(() {
        isFavorite = true;
      });
    }
  }

  void _toggleFavorite() async {
    if (isFavorite) {
      List<Recipe> favorites = PreferenceManager.getFavoriteRecipes();
      favorites.removeWhere((r) => r.name == widget.recipe.name);
      await PreferenceManager.setFavoriteRecipe(favorites);
    } else {
      List<Recipe> favorites = PreferenceManager.getFavoriteRecipes();
      favorites.add(widget.recipe);
      await PreferenceManager.setFavoriteRecipe(favorites);
    }

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: AppTheme.whiteColor,
        title: const Text(
          'NomNom',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontFamily: 'Lobster',
            fontSize: 50,
            color: AppTheme.primaryColor,
          ),
        ),
        centerTitle: true,
      ),
      endDrawer: const MenuDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                  child: widget.recipe.imageUrl != null
                      ? Image.network(
                          widget.recipe.imageUrl!,
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/curry.png',
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                ),
                Positioned(
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0,
                  child: Text(
                    widget.recipe.name,
                    style: const TextStyle(
                      fontSize: 32.0,
                      fontFamily: "Lobster",
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Ingredients',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 24.0,
                  fontFamily: "Lobster",
                  color: AppTheme.secondaryColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.recipe.ingredients.map((ingredient) {
                  return Text(
                    '- $ingredient',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontFamily: "Poppins",
                    ),
                  );
                }).toList(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Instructions',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 24.0,
                  fontFamily: "Lobster",
                  color: AppTheme.secondaryColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.recipe.instructions.map((instruction) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '• $instruction',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontFamily: "Poppins",
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: ElevatedButton.icon(
                onPressed: _toggleFavorite,
                style: ElevatedButton.styleFrom(
                  primary: isFavorite ? Colors.red : AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                ),
                label: Text(
                  isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
                  style: const TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
