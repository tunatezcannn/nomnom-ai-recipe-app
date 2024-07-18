import 'package:flutter/material.dart';
import 'package:nomnom/screens/loadingScreen.dart';
import 'package:nomnom/screens/surveyScreen.dart';
import 'package:nomnom/systems/saveSystem.dart';
import 'package:nomnom/themes/apptheme.dart';
import 'package:nomnom/utils/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _ingredientController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  late List<String> _ingredients;
  late String? _selectedCuisine;
  late List<String> _addedIngredients;

  static const List<String> commonIngredients = [
    'Cheese', 'Flour', 'Salt', 'Water', 'Tomatoes', 'Eggs', 'Sugar',
    'Milk', 'Butter', 'Chicken', 'Beef', 'Pork', 'Onion', 'Garlic', 'Pepper',
  ];

  static const List<String> cuisines = [
    'Arabic', 'Brazilian', 'British', 'Chinese', 'Dutch', 'Finnish', 'French',
    'Indian', 'Italian', 'Japanese', 'Korean', 'Mexican', 'Nigerian', 'Turkish'
  ];

  @override
  void initState() {
    super.initState();
    loadIngredients();
  }

  void controlForPreferences() {
    Set<String> allKeys = PreferenceManager.getAllKeys();
    if (!allKeys.contains('preferencesSet')) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SurveyScreen(),
          ),
        );
      });
    }
  }

  void loadIngredients() {
    Set<String> allKeys = PreferenceManager.getAllKeys();
    setState(() {
      _ingredients = allKeys.contains('currentIngredients') ? PreferenceManager.getList('currentIngredients') : [];
      _addedIngredients = List.from(_ingredients);
      _selectedCuisine = allKeys.contains('selectedCuisine') ? PreferenceManager.getString('selectedCuisine') : cuisines.first;
    });
  }

  void _addIngredient(String ingredient) {
    if (ingredient.isNotEmpty && !_ingredients.contains(ingredient)) {
      setState(() {
        _ingredients.add(ingredient);
      });
      PreferenceManager.setList('currentIngredients', _ingredients);
    }
  }

  void _removeIngredient(String ingredient) {
    setState(() {
      _ingredients.remove(ingredient);
    });
    PreferenceManager.setList('currentIngredients', _ingredients);
  }

  void onClearButtonTap() {
    setState(() {
      _ingredients.clear();
      _addedIngredients.clear();
    });
    PreferenceManager.setList('currentIngredients', _ingredients);
  }

  void showCuisineSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select your cuisine', style: TextStyle(fontFamily: "Poppins")),
          content: SizedBox(
            width: 500,
            height: 350,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: cuisines.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(cuisines[index]),
                  onTap: () {
                    setState(() {
                      _selectedCuisine = cuisines[index];
                    });
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    controlForPreferences();
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
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      endDrawer: const MenuDrawer(),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select your cuisine',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontFamily: "Lobster", color: AppTheme.secondaryColor),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                showCuisineSelectionDialog(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: AppTheme.whiteColor,
                backgroundColor: AppTheme.whiteColor,
                side: const BorderSide(color: AppTheme.secondaryColor, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
              child: Text(
                _selectedCuisine ?? 'Select cuisine',
                style: const TextStyle(fontSize: 18, color: AppTheme.secondaryColor),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Ingredients',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontFamily: "Lobster", color: AppTheme.secondaryColor),
            ),
            buildAddIngredientField(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.38, // Set height to a fraction of screen height
              child: buildIngredientList(),
            ),
            buildIngredientButton(),
            FindRecipeButton(selectedCuisine: _selectedCuisine, ingredients: _ingredients),
          ],
        ),
      ),
    );
  }


  Widget buildIngredientList() {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: AppTheme.secondaryColor),
    ),
    child: ListView.builder(
      itemCount: _ingredients.length,
      itemBuilder: (context, index) {
        return ListTile(
          style: ListTileStyle.list,
          title: Text(_ingredients[index]),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: AppTheme.primaryColor),
            onPressed: () {
              setState(() {
                _addedIngredients.remove(_ingredients[index]);
                _ingredients.removeAt(index);
                PreferenceManager.setList('currentIngredients', _ingredients);
              });
            },
          ),
        );
      },
    ),
  );
}


  Widget buildIngredientButton() {
    return ListTile(
      title: const Text("Show common ingredients", style: TextStyle(fontSize: 15, color: AppTheme.secondaryColor)),
      trailing: IconButton(
        icon: const Icon(Icons.arrow_upward),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return buildIngredientSearchSheet();
            },
          );
        },
      ),
    );
  }

  Widget buildAddIngredientField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _ingredientController,
              decoration: InputDecoration(
                labelText: 'Add Ingredient',
                hintText: 'Enter a new ingredient',
                hintStyle: const TextStyle(color: Color.fromARGB(46, 0, 0, 0)),
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    _addIngredient(_ingredientController.text);
                    _ingredientController.clear();
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 0),
          TextButton(onPressed: onClearButtonTap, child: const Text('Clear \n All', style: TextStyle(color: AppTheme.secondaryColor,
              fontSize: 15, fontFamily: "Poppins", fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget buildIngredientSearchSheet() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Search Ingredients',
              suffixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              // We no longer need to call setState here since it's handled within the StatefulBuilder
            },
          ),
        ),
        Expanded(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return ListView.builder(
                itemCount: commonIngredients.length,
                itemBuilder: (context, index) {
                  final ingredient = commonIngredients[index];
                  bool isAdded = _addedIngredients.contains(ingredient);
                  if (_searchController.text.isEmpty || ingredient.toLowerCase().contains(_searchController.text.toLowerCase())) {
                    return ListTile(
                      title: Text(ingredient),
                      trailing: IconButton(
                        icon: Icon(isAdded ? Icons.check : Icons.add),
                        onPressed: () {
                          setState(() {
                            if (!isAdded) {
                              if (!_addedIngredients.contains(ingredient)) {
                                _addedIngredients.add(ingredient);
                                _addIngredient(ingredient);
                              }
                            } else {
                              _addedIngredients.remove(ingredient);
                              _removeIngredient(ingredient);
                            }
                          });
                          PreferenceManager.setList('currentIngredients', _ingredients);
                        },
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class FindRecipeButton extends StatelessWidget {
  const FindRecipeButton({
    super.key,
    required String? selectedCuisine,
    required List<String> ingredients,
  }) : _selectedCuisine = selectedCuisine, _ingredients = ingredients;

  final String? _selectedCuisine;
  final List<String> _ingredients;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
      onPressed: () {
        if (_selectedCuisine != null && _ingredients.isNotEmpty) {
          PreferenceManager.setString('selectedCuisine', _selectedCuisine!);
          PreferenceManager.setList('currentIngredients', _ingredients);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select a cuisine and add ingredients'),
            ),
          );
          return;
        }
    
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoadingScreen(),
          ),
        );
      },
      child: const Text('Find your recipe', style: TextStyle(fontSize: 20, color: AppTheme.whiteColor, fontFamily: "Poppins", fontWeight: FontWeight.bold)),
    );
  }
}
