// ignore_for_file: unnecessary_getters_setters

import 'package:nomnom/systems/saveSystem.dart';

class RecipeSystem {
  late List<String> _ingredientsToInclude;
  late List<String> _ingredientsToExclude;
  late List<String> _kitchenEquipments;
  late List<String> _cookingMethods;
  late String _measurementUnit;
  late String _cuisine;
  late bool _isVegan;
  late bool _isVegetarian;

  String createPrompt() {
    _ingredientsToInclude = PreferenceManager.getList("currentIngredients");
    _ingredientsToExclude = PreferenceManager.getList("nonPreferredIngredients");
    _kitchenEquipments = PreferenceManager.getList("kitchenEquipments");
    _cookingMethods = PreferenceManager.getList("cookingMethods");
    _cuisine = PreferenceManager.getString("selectedCuisine");
    _isVegan = PreferenceManager.getBool("isVegan");
    _isVegetarian = PreferenceManager.getBool("isVegetarian");
    _measurementUnit = PreferenceManager.getString("measurementUnit");

    // Initialize the prompt string
    String prompt = "Find recipes";

    // Append cuisine if specified
    if (_cuisine.isNotEmpty) {
      prompt += " from $_cuisine cuisine";
    }

    // Append dietary preferences
    if (_isVegan) {
      prompt += " that are vegan";
    } else if (_isVegetarian) {
      prompt += " that are vegetarian";
    }

    // Append ingredients to include if specified
    if (_ingredientsToInclude.isNotEmpty) {
      String ingredients = _ingredientsToInclude.join(", ");
      prompt += " with $ingredients";
    }

    // Append ingredients to exclude if specified
    if (_ingredientsToExclude.isNotEmpty) {
      String ingredients = _ingredientsToExclude.join(", ");
      prompt += " without $ingredients";
    }

    // Append kitchen equipment if specified
    if (_kitchenEquipments.isNotEmpty) {
      String equipments = _kitchenEquipments.join(", ");
      prompt += " using $equipments";
    }

    // Append cooking methods if specified
    if (_cookingMethods.isNotEmpty) {
      String methods = _cookingMethods.join(", ");
      prompt += " using methods prefered in this order $methods";
    }

    // Append measurement unit
    if (_measurementUnit.isNotEmpty) {
      prompt += " using $_measurementUnit as the measurement unit";
    }

    prompt += 
        ". If the user is vegan or vegetarian and if there is any material in the ingredients which is not a vegan material or vegetarian, please add a if user is vegan 'Vegan' if user is vegetarian 'Vegetarian' at the start of the ingredients which is not Vegan or Vegetarian.\n"
        ". Please pay attention to the cuisine selected even if the materials given you are not from that cuisine when faced with a situation like this please select the only materials for that cuisine and give a recipe from that cuisine.\n"
        "Provide the response with exactly 5 recipes. Each recipe should contain: recipe name, ingredients, and instructions. The output should be formatted exactly as follows:\n"
        "- Start each recipe with '@' followed by the recipe name.\n"
        "- Each ingredient should be on a new line, prefixed with '#'.\n"
        "- Each instruction should be on a new line, prefixed with '*'.\n"
        "- There should be a blank line between recipes.\n"
        "\n"
        "Example:\n"
        "@Recipe Name\n"
        "# Ingredient 1\n"
        "# Ingredient 2\n"
        "* Instruction 1\n"
        "* Instruction 2\n"
        "\n"
        "@Another Recipe Name\n"
        "# Ingredient 1\n"
        "# Ingredient 2\n"
        "* Instruction 1\n"
        "* Instruction 2";

    return prompt;
  }
}
