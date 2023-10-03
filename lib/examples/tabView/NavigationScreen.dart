import 'package:firebaseflutterproject/examples/tabView/sample1.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  var mController = PersistentTabController(initialIndex: 2);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Persistant table"),
        // bottom: AppBar(
        //   title: Text("Bottom"),
        // ),
      ),
      // bottomSheet: Text("Bottom sheet"),
      body:  PersistentTabView(
        context,
        controller: mController,
        onItemSelected: (id) {
          if (id == 0) {
           // AppState().setScreenId(navigationIds[0].id!);
          }
          if (id == 1) {
           // AppState().setScreenId(navigationIds[1].id!);
          }
          if (id == 3) {
            // AppState().setScreenId(navigationIds[2].id!);
          }
          if (id == 4) {
           // AppState().setScreenId(navigationIds[3].id!);
          }
        },
        screens:  [
          Text("Shop"),
          Text("Store"),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // number of items in each row
              mainAxisSpacing: 8.0, // spacing between rows
              crossAxisSpacing: 8.0, // spacing between columns
            ),
            itemBuilder: (context, index) {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => Simple1()));
              return InkWell(onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Simple1()));

              },

                child: Container(
                  color: Colors.blue, // color of grid items
                  child: Center(
                    child:  Text("${index}",
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),

                  ),
                ),
              );
            },

          ),
          Text("Add Item"),
          Text("Shop"),
        ],
        items: [
          PersistentBottomNavBarItem(
            title: 'Shop',
            icon: const Icon(Icons.shop),
            inactiveColorPrimary: Colors.blueGrey,
            activeColorPrimary: Colors.redAccent,
          ),
          PersistentBottomNavBarItem(
            title: 'store',
            icon: const Icon(Icons.star),
            inactiveColorPrimary: Colors.blueGrey,
            activeColorPrimary: Colors.redAccent,
          ),
          PersistentBottomNavBarItem(
            title: 'Home',
            icon: const Icon(
              Icons.home,
              color: Colors.white,
            ),
            inactiveColorPrimary: Colors.blueGrey,
            activeColorPrimary: Colors.redAccent,
          ),
          PersistentBottomNavBarItem(
            title: 'add item',
            icon: const Icon(Icons.add_circle_outline),
            inactiveColorPrimary: Colors.blueGrey,
            activeColorPrimary: Colors.redAccent,
          ),
          PersistentBottomNavBarItem(
            title: 'Shop',
            icon: const Icon(Icons.shop),
            inactiveColorPrimary: Colors.blueGrey,
            activeColorPrimary: Colors.redAccent,
          ),
        ],
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties(
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style15,
      ),
    );
  }
}
