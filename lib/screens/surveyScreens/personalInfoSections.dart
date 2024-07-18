import 'package:flutter/material.dart';
import 'package:nomnom/systems/saveSystem.dart';
import 'package:nomnom/themes/appTheme.dart';

class PersonalInfoSection extends StatefulWidget {
  PersonalInfoSection({super.key});

  @override
  State<PersonalInfoSection> createState() => _PersonalInfoSectionState();
}

class _PersonalInfoSectionState extends State<PersonalInfoSection> {
  late bool isVeganSwitched;
  late bool isVegetarianSwitched;
  late DateTime birthdayDate;
  late String measurementUnit;
  late String gender;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    Set<String> allKeys = PreferenceManager.getAllKeys();
    setState(() {
      isVeganSwitched = allKeys.contains('isVegan')
          ? PreferenceManager.getBool('isVegan')
          : false;
      isVegetarianSwitched = allKeys.contains('isVegetarian')
          ? PreferenceManager.getBool('isVegetarian')
          : false;
      birthdayDate = allKeys.contains('birthdayDate')
          ? PreferenceManager.getDateTime('birthdayDate')
          : DateTime.now();
      gender = allKeys.contains('gender')
          ? PreferenceManager.getString('gender')
          : "Other";
      measurementUnit = allKeys.contains('measurementUnit')
          ? PreferenceManager.getString('measurementUnit')
          : "Metric(SI) Units";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        children: [
          Text(
                'Personal Info',
                style: AppTheme.poppinsTextTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: DropdownButtonFormField<String>(
              value: gender,
              items: <String>['Other', 'Male', 'Female']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: AppTheme.poppinsTextTheme.bodyLarge),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  gender = newValue!;
                  PreferenceManager.setString("gender", newValue);
                });
              },
              decoration: InputDecoration(
                labelText: 'Gender',
                labelStyle: AppTheme.poppinsTextTheme.bodyLarge,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: DropdownButtonFormField<String>(
              value: measurementUnit,
              items: <String>['Metric(SI) Units', 'Imperial(US) Units']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: AppTheme.poppinsTextTheme.bodyLarge),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  measurementUnit = newValue!;
                  PreferenceManager.setString("measurementUnit", newValue);
                });
              },
              decoration: InputDecoration(
                labelText: 'Units Of Measurement',
                labelStyle: AppTheme.poppinsTextTheme.bodyLarge,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.black54, width: 1.0),
            ),
            title: Text('Date of birth', style: AppTheme.poppinsTextTheme.bodyLarge),
            trailing: Text(
              "${birthdayDate.day}/${birthdayDate.month}/${birthdayDate.year}",
              style: AppTheme.poppinsTextTheme.bodyLarge,
            ),
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: birthdayDate,
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );

              if (picked != null && picked != birthdayDate) {
                setState(() {
                  birthdayDate = picked;
                  PreferenceManager.setDateTime('birthdayDate', picked);
                });
              }
            },
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.black54, width: 1.0),
            ),
            title: Text('Are you vegetarian', style: AppTheme.poppinsTextTheme.bodyLarge),
            value: isVegetarianSwitched,
            activeColor: Theme.of(context).primaryColor,
            onChanged: (bool value) {
              setState(() {
                isVegetarianSwitched = value;
                PreferenceManager.setBool('isVegetarian', value);
                if (isVeganSwitched) {
                  PreferenceManager.setBool('isVegan', false);
                  isVeganSwitched = false;
                }
              });
            },
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.black54, width: 1.0),
            ),
            title: Text('Are you vegan', style: AppTheme.poppinsTextTheme.bodyLarge),
            value: isVeganSwitched,
            activeColor: Theme.of(context).primaryColor,
            onChanged: (bool value) {
              setState(() {
                isVeganSwitched = value;
                PreferenceManager.setBool('isVegan', value);
                if (isVegetarianSwitched) {
                  PreferenceManager.setBool('isVegetarian', false);
                  isVegetarianSwitched = false;
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
