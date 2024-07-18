import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:nomnom/screens/surveyScreens/cookingMethods.dart';
import 'package:nomnom/screens/surveyScreens/kitchenEquipments.dart';
import 'package:nomnom/screens/surveyScreens/nonprefferedIngredients.dart';
import 'package:nomnom/screens/surveyScreens/personalInfoSections.dart';
import 'package:nomnom/systems/saveSystem.dart';
import 'package:nomnom/themes/appTheme.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final iconList = <IconData>[
    Icons.person,
    Icons.block,
    Icons.kitchen_rounded,
    Icons.local_fire_department,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    PreferenceManager.setBool("preferencesSet", true);
    _tabController.addListener(() {
      setState(() {}); // Tab index değişimini yansıtmak için setState çağırıyoruz
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 125,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, '/home'),
          color: AppTheme.whiteColor,
        ),
        title: const Text(
          'Preferences',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: 'Lobster',
            fontSize: 50,
            color: AppTheme.whiteColor,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        centerTitle: true,
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          PersonalInfoSection(),
          IngredientsSection(),
          KitchenEquipmentSection(),
          CookingMethodsSection(),
        ],
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _tabController.index,
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.defaultEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) {
          setState(() {
            _tabController.index = index;
          });
        },
        activeColor: Colors.white,
        inactiveColor: Colors.white70,
        backgroundColor: AppTheme.primaryColor,
        splashColor: AppTheme.secondaryColor,
      ),
    );
  }
}
