import 'package:flutter/material.dart';
import 'package:nomnom/systems/saveSystem.dart';
import 'package:nomnom/themes/appTheme.dart';

class KitchenEquipmentSection extends StatefulWidget {
  const KitchenEquipmentSection({super.key});

  @override
  State<KitchenEquipmentSection> createState() => _KitchenEquipmentSectionState();
}

class _KitchenEquipmentSectionState extends State<KitchenEquipmentSection> {
  late List<String> _selectedEquipments;
  final Map<String, bool> _allEquipment = {
    'Oven': false,
    'Blender': false,
    'Microwave': false,
    'Airfryer': false,
    'Rice Cooker': false,
    'Pressure Cooker': false,
  };

  @override
  void initState() {
    super.initState();
    loadCookingMethods();
  }

  Future<void> loadCookingMethods() async {
    Set<String> allKeys = PreferenceManager.getAllKeys();
    if (allKeys.contains('kitchenEquipments')) {
      List<String> savedEquipments = PreferenceManager.getList('kitchenEquipments');
      setState(() {
        _selectedEquipments = savedEquipments;
        for (String equipment in _selectedEquipments) {
          _allEquipment[equipment] = true;
        }
      });
    } else {
      setState(() {
        _selectedEquipments = [];
      });
    }
  }

  Future<void> saveSelectedEquipments() async {
    _selectedEquipments = _allEquipment.entries
      .where((entry) => entry.value)
      .map((entry) => entry.key)
      .toList();
    PreferenceManager.setList('kitchenEquipments', _selectedEquipments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Text(
                'Select Cooking Equipment',
                textAlign: TextAlign.center,
                style: AppTheme.poppinsTextTheme.labelLarge
              ),
            ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: 50,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: _allEquipment.keys.map((String key) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SwitchListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.black54, width: 2.0),
                      ),
                      title: Text(key, style: AppTheme.poppinsTextTheme.bodyLarge),
                      value: _allEquipment[key]!,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (bool value) {
                        setState(() {
                          _allEquipment[key] = value;
                          saveSelectedEquipments();
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
