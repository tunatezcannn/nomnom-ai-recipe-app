import 'package:flutter/material.dart';
import 'package:nomnom/themes/appTheme.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = false;
  double accuracyLevel = 0.7;
  bool proceedWithoutAds = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        backgroundColor: AppTheme.primaryColor,
        title: const Text(
              'Settings',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Lobster', // Title font
                fontSize: 50,
                color: AppTheme.whiteColor, // Color for the title
              ),
            ), 
        centerTitle: true,// Set the AppBar color
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: CheckboxListTile(
              title: Text(
                'Proceed without ads',
                style: AppTheme.poppinsTextTheme.headline3, // Başlık rengini kırmızı yapar
              ),
              value: proceedWithoutAds,
              onChanged: (bool? value) {
                setState(() {
                  proceedWithoutAds = value ?? false;
                });
              },
              checkColor: AppTheme.whiteColor, // Onay işaretinin rengi
              activeColor: AppTheme.primaryColor, // Kutucuğun dolu kısmının rengi
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            title: Text('Contribute!!!', style: AppTheme.poppinsTextTheme.headline3),
            trailing: IconButton(
              icon: const Icon(Icons.star, color: AppTheme.primaryColor),
              splashRadius: 10,
              iconSize: 40,
              onPressed: () {},
            ),
          ),
          const SizedBox(height: 85),
          const Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircleAvatar(
                  radius: 80.0,
                  backgroundColor: AppTheme.primaryColor,
                  child: Text(
                    "NomNom",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontFamily: "lobster"
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}