import 'package:flutter/material.dart';
import 'package:nomnom/systems/saveSystem.dart';
import 'package:nomnom/themes/appTheme.dart';

class IngredientsSection extends StatefulWidget {
  const IngredientsSection({super.key});

  @override
  _IngredientsSectionState createState() => _IngredientsSectionState();
}

class _IngredientsSectionState extends State<IngredientsSection> {
  final TextEditingController _ingredientController = TextEditingController();
  late List<String> _ingredients;

  @override
  void initState() {
    super.initState();
    loadIngredients();
  }

  Future<void> loadIngredients() async {
    Set<String> allKeys = PreferenceManager.getAllKeys();
    if (allKeys.contains('nonPreferredIngredients')) {
      setState(() {
        _ingredients = PreferenceManager.getList('nonPreferredIngredients');
      });
    } else {
      setState(() {
        _ingredients = [];
      });
    }
  }

  void _addIngredient() {
    if (_ingredientController.text.isNotEmpty) {
      setState(() {
        _ingredients.add(_ingredientController.text);
        _ingredientController.clear();
      });
      PreferenceManager.setList('nonPreferredIngredients', _ingredients);
    }
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
    });
    PreferenceManager.setList('nonPreferredIngredients', _ingredients);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Text(
                  'Allergic/Non Preferred Ingredients',
                  style: AppTheme.poppinsTextTheme.labelLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _ingredientController,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey[600], fontSize: 18),
                    hintText: 'Find ingredients',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _addIngredient,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onFieldSubmitted: (_) => _addIngredient(),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Current Ingredients',
                  style: AppTheme.poppinsTextTheme.bodyLarge,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black54, width: 1.0),
                ),
                height: 300, // Arbitrary height to contain the ListView
                child: ListView.builder(
                  itemCount: _ingredients.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        _ingredients[index],
                        style: AppTheme.poppinsTextTheme.bodyLarge,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _removeIngredient(index);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
