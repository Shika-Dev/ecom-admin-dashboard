import 'package:smart_admin_dashboard/core/constants/color_constants.dart';

import 'package:smart_admin_dashboard/responsive.dart';
import 'package:smart_admin_dashboard/screens/forms/input_form.dart';
import 'package:flutter/material.dart';

class MiniInformation extends StatelessWidget {
  const MiniInformation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 10,
            ),
            ElevatedButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5,
                  vertical:
                  defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute<Null>(
                    builder: (BuildContext context) {
                      return new FormMaterial(type: FormType.category,);
                    },
                    fullscreenDialog: true));
              },
              icon: Icon(Icons.add),
              label: Text(
                "Add Category",
              ),
            ),
            SizedBox(
              width: 10,
            ),
            ElevatedButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5,
                  vertical:
                  defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute<Null>(
                    builder: (BuildContext context) {
                      return new FormMaterial(type: FormType.subcategory,);
                    },
                    fullscreenDialog: true));
              },
              icon: Icon(Icons.add),
              label: Text(
                "Add Sub Category",
              ),
            ),
            SizedBox(
              width: 10,
            ),
            ElevatedButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5,
                  vertical:
                      defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute<Null>(
                    builder: (BuildContext context) {
                      return new FormMaterial(type: FormType.product,);
                    },
                    fullscreenDialog: true));
              },
              icon: Icon(Icons.add),
              label: Text(
                "Add New Product",
              ),
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
      ],
    );
  }
}
