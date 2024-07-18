import 'package:flutter/material.dart';
import 'package:nomnom/themes/apptheme.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      child: Column(
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Menu",
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 48,
                  fontFamily: "lobster",
                ),
              ),
            ),
          ),
          ListTile(
            title: menudrawertext("Profile"),
            onTap: () {
              Navigator.popAndPushNamed(context, '/profile');
            },
          ),
          ListTile(
            title: menudrawertext("Favourite Recipes"),
            onTap: () {
              Navigator.popAndPushNamed(context, '/favourite');
            },
          ),
          ListTile(
            title: menudrawertext("Preferences"),
            onTap: () {
              Navigator.popAndPushNamed(context, '/survey');
            },
          ),
          ListTile(
            title: menudrawertext("Share Us!"),
            onTap: () {
            },
          ),
          ListTile(
            title: menudrawertext("Shop Now!"),
            onTap: () {
            },
          ),
          ListTile(
            title: menudrawertext("Contribute Now!"),
            onTap: () {
              print("TR95 0006 2000 0000 0006 2990 00");
            },
          ),
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

  Text menudrawertext(String s) {
    return Text(s, 
           style: const TextStyle(
            fontSize: 20,
            color: AppTheme.secondaryColor,
            fontFamily: "poppins"));
  }
}
