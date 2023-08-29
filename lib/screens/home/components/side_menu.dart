import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_admin_dashboard/screens/home/home_screen.dart';

class SideMenu extends StatelessWidget {
  final int activeIndex;
  const SideMenu({
    Key? key, required this.activeIndex
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        // it enables scrolling
        child: Column(
          children: [
            DrawerHeader(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: defaultPadding * 3,
                ),
                Image.asset(
                  "assets/logo/logo_icon.png",
                  scale: 5,
                ),
                SizedBox(
                  height: defaultPadding,
                ),
                Text("Sevva - Admin")
              ],
            )),
            DrawerListTile(
              title: "Product",
              svgSrc: "assets/icons/menu_tran.svg",
              press: () {
                Navigator.push(context, MaterialPageRoute(builder: (_)=>HomeScreen(activeIndex: 1)));
              },
              index: 1, activeIndex: activeIndex,
            ),
            DrawerListTile(
              title: "Pages",
              svgSrc: "assets/icons/menu_task.svg",
              press: () {},
              index: 2, activeIndex: activeIndex,
            ),
            DrawerListTile(
              title: "Categories",
              svgSrc: "assets/icons/menu_doc.svg",
              press: () {},
              index: 3, activeIndex: activeIndex,
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
    required this.index,
    required this.activeIndex
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;
  final int index;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: activeIndex==index? Colors.white : Colors.white54,
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: activeIndex == index ? Colors.white : Colors.white54),
      ),
    );
  }
}
