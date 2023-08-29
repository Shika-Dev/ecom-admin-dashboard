import 'package:smart_admin_dashboard/responsive.dart';
import 'package:smart_admin_dashboard/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:smart_admin_dashboard/screens/product/product_screen.dart';

import 'components/side_menu.dart';

class HomeScreen extends StatelessWidget {
  final int activeIndex;
  HomeScreen({Key? key, required this.activeIndex});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: context.read<MenuController>().scaffoldKey,
      drawer: SideMenu(activeIndex: activeIndex),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(activeIndex: activeIndex),
              ),
            if(activeIndex==0)
              Expanded(
              // It takes 5/6 part of the screen
                flex: 5,
                child: DashboardScreen(),
              ),
            if(activeIndex==1)
              Expanded(
                // It takes 5/6 part of the screen
                flex: 5,
                child: ProductScreen(),
              ),
            if(activeIndex==2)
              Expanded(
                // It takes 5/6 part of the screen
                flex: 5,
                child: DashboardScreen(),
              ),
            if(activeIndex==3)
              Expanded(
                // It takes 5/6 part of the screen
                flex: 5,
                child: DashboardScreen(),
              ),
          ],
        ),
      ),
    );
  }
}
