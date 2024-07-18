import 'package:flutter/material.dart';
import 'package:nomnom/systems/saveSystem.dart';
import 'package:nomnom/themes/appTheme.dart';

class CookingMethodsSection extends StatefulWidget {
  const CookingMethodsSection({super.key});

  @override
  State<CookingMethodsSection> createState() => _CookingMethodsSectionState();
}

class _CookingMethodsSectionState extends State<CookingMethodsSection> {
  late List<String> cookingMethods;

  @override
  void initState() {
    super.initState();
    loadCookingMethods();
  }

  Future<void> loadCookingMethods() async {
    Set<String> allKeys = PreferenceManager.getAllKeys();
    if (allKeys.contains('cookingMethods')) {
      setState(() {
        cookingMethods = PreferenceManager.getList('cookingMethods');
      });
    } else {
      setState(() {
        cookingMethods = [
          'Deep Fry', 'Stir Fry', 'Grilling', 'Boiling', 'Steaming', 'Baking',
          'Roasting', 'Poaching', 'Smoking', 'Pressure cooking',
          'Simmering', 'Microwaving', 'Slow cooking'
        ];
      });
    }
  }

  void updateOrder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = cookingMethods.removeAt(oldIndex);
      cookingMethods.insert(newIndex, item);
      PreferenceManager.setList('cookingMethods', cookingMethods);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Text(
                'List Cooking Methods',
                textAlign: TextAlign.center,
                style: AppTheme.poppinsTextTheme.labelLarge
              ),
            ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: 50,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16.0),
            Expanded(
              child: ReorderableListView(
                onReorder: updateOrder,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                children: [
                  for (final method in cookingMethods)
                    Padding(
                      key: ValueKey(method),
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey), // Border rengi ve genişliğini ayarlayabilirsiniz
                            borderRadius: BorderRadius.circular(10.0), // Köşelerin yuvarlanmasını sağlar
                          ),
                          child: ListTile(
                            title: Text(
                              method,
                              style: AppTheme.poppinsTextTheme.bodyText1,
                            ),
                            tileColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            trailing: const Icon(Icons.drag_handle),
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
