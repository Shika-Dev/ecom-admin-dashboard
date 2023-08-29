import 'package:smart_admin_dashboard/core/constants/color_constants.dart';

import 'package:flutter/material.dart';
import 'package:smart_admin_dashboard/screens/product/components/add_new_product_button.dart';
import 'package:smart_admin_dashboard/screens/product/components/product_table.dart';

import 'components/header.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        //padding: EdgeInsets.all(defaultPadding),
        child: Container(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(),
              SizedBox(height: defaultPadding),
              MiniInformation(),
              SizedBox(height: defaultPadding),
              ProductTable(),
            ],
          ),
        ),
      ),
    );
  }
}
