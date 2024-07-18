import 'package:flutter/material.dart';
import 'package:nomnom/systems/recipeClass.dart';
import 'package:nomnom/themes/apptheme.dart';
import 'package:nomnom/utils/drawer.dart';
import 'recipeScreen.dart';

class MatchingRecipeScreen extends StatefulWidget {
  final List<Recipe> recipe;

  const MatchingRecipeScreen({super.key, required this.recipe});
  @override
  State<MatchingRecipeScreen> createState() => _MatchingRecipeScreenState();
}

class _MatchingRecipeScreenState extends State<MatchingRecipeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: AppTheme.primaryColor,
        title: const Text(
          'NomNom',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: 'Lobster', 
            fontSize: 50,
            color: AppTheme.whiteColor,
          ),
        ), 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.whiteColor),
          onPressed: () {
            Navigator.pushNamed(context, "/home");
          },
        ),
        centerTitle: true,
      ),
      endDrawer: const MenuDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Matching Recipes',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 36, fontFamily: "Lobster", color: AppTheme.secondaryColor),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: widget.recipe.length, // Number of recipes
                itemBuilder: (context, index) {
                  final recipe = widget.recipe[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.blackColor, width: 1),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeScreen(recipe: recipe),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: AppTheme.whiteColor,
                          padding: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), // Rounded corners
                          ),
                        ),
                        child: Text(
                          recipe.name,
                          style: const TextStyle(
                            fontSize: 22,
                            color: AppTheme.secondaryColor,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/loading');
              },
              child: const Text(
                'Give Different Option',
                style: TextStyle(fontSize: 20, 
                  color: AppTheme.whiteColor, 
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
