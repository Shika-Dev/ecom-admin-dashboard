import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:smart_admin_dashboard/models/product_model.dart';
import 'package:smart_admin_dashboard/screens/forms/components/add_new_category.dart';
import 'package:smart_admin_dashboard/screens/forms/components/add_new_product.dart';
import 'package:smart_admin_dashboard/screens/forms/components/add_new_subcategory.dart';
import 'package:smart_admin_dashboard/screens/forms/components/add_new_widget.dart';
import 'package:flutter/material.dart';
import 'package:smart_admin_dashboard/screens/forms/components/update_product.dart';

enum FormType {product, order, category, subcategory, updateProduct}

class FormMaterial extends StatefulWidget {
  final FormType type;
  final Product? product;
  FormMaterial({Key? key, required this.type, this.product});
  @override
  _FormMaterialState createState() => _FormMaterialState();
}

class _FormMaterialState extends State<FormMaterial> {

  Widget getForm(FormType type){
    if(type==FormType.product){
      return AddNewProduct();
    } else if(type == FormType.category){
      return AddNewCategory();
    } else if(type == FormType.subcategory){
      return AddNewSubCategory();
    } else if(type == FormType.updateProduct){
      return UpdateProduct(product: widget.product!);
    } else return SelectionSection();
  }

  String getTitle(FormType type){
    if(type==FormType.product){
      return 'Add New Product';
    } else if(type == FormType.category){
      return 'Add New Category';
    } else if(type == FormType.subcategory){
      return 'Add New Sub Category';
    } else return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(),
      body: SingleChildScrollView(
        child: Card(
          color: bgColor,
          elevation: 5,
          margin: EdgeInsets.fromLTRB(32, 32, 64, 32),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: Column(
                  children: [
                    Center(
                      child: Text(getTitle(widget.type)),
                    ),
                    getForm(widget.type),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
