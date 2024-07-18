import 'package:flutter/material.dart';
import 'package:nomnom/systems/saveSystem.dart';
import 'package:nomnom/themes/apptheme.dart';
import 'package:nomnom/utils/drawer.dart';
import 'package:nomnom/systems/recipeClass.dart';
import 'recipeScreen.dart';

class FavouriteRecipeScreen extends StatefulWidget {
  const FavouriteRecipeScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteRecipeScreen> createState() => _FavouriteRecipeScreenState();
}

class _FavouriteRecipeScreenState extends State<FavouriteRecipeScreen> {
  List<Recipe> favouriteRecipes = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteRecipes();
  }

  void _loadFavoriteRecipes() {
    List<Recipe> favorites = PreferenceManager.getFavoriteRecipes();
    setState(() {
      favouriteRecipes = favorites;
    });
  }

  void _removeRecipe(int index) async {
    favouriteRecipes.removeAt(index);
    await PreferenceManager.setFavoriteRecipe(favouriteRecipes);
    setState(() {});
  }

  void _onRecipeTap(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeScreen(recipe: recipe),
      ),
    );
  }

  void _editRecipeName(int index) async {
    final newName = await _showEditDialog(favouriteRecipes[index].name);
    if (newName != null && newName.isNotEmpty) {
      setState(() {
        favouriteRecipes[index].name = newName;
      });
      await PreferenceManager.setFavoriteRecipe(favouriteRecipes);
    }
  }

  Future<String?> _showEditDialog(String currentName) {
    final TextEditingController controller = TextEditingController(text: currentName);
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Recipe Name',
            style: TextStyle(color: AppTheme.secondaryColor)),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter new recipe name'), 
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Cancel',
                style: TextStyle(color: AppTheme.primaryColor)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.secondaryColor,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 125,
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
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, "/home"),
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
              'Favourite Recipes',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 36, fontFamily: "Lobster", color: AppTheme.secondaryColor),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ListView.builder(
                  itemCount: favouriteRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = favouriteRecipes[index];
                    return InkWell(
                      onTap: () => _onRecipeTap(recipe),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.whiteColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.blackColor, width: 1),
                          ),
                          child: ListTile(
                            title: Text(
                              recipe.name,
                              style: const TextStyle(
                                fontSize: 22,
                                color: AppTheme.secondaryColor,
                                fontFamily: "Poppins",
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: AppTheme.secondaryColor),
                                  onPressed: () => _editRecipeName(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: AppTheme.secondaryColor),
                                  onPressed: () => _removeRecipe(index),
                                ),
                              ],
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
