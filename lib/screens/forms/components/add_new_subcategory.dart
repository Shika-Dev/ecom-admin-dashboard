import 'dart:js_interop';
import 'dart:typed_data';

import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:smart_admin_dashboard/core/widgets/app_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:smart_admin_dashboard/models/category_model.dart';
import 'package:smart_admin_dashboard/models/post_response_model.dart';
import 'package:smart_admin_dashboard/models/subcategory_model.dart';
import 'package:smart_admin_dashboard/screens/product/datasources/product_datasources.dart';

class AddNewSubCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [],
        ),
        SizedBox(height: defaultPadding),
        SubCategoryForm()
      ],
    );
  }
}

class SubCategoryForm extends StatefulWidget {
  const SubCategoryForm({
    Key? key,
  }) : super(key: key);

  @override
  _SubCategoryFormState createState() => _SubCategoryFormState();
}

class _SubCategoryFormState extends State<SubCategoryForm> {
  bool _loading = false;
  late Future<CategoryModel> futureCategoryModel;
  String category = '';

  TextEditingController _subcategoryController = TextEditingController();

  @override
  void initState() {
    futureCategoryModel = getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 10.0),
              child: Material(
                elevation: 10.0,
                borderRadius: BorderRadius.circular(8.0),
                child: ListTile(
                    title: FutureBuilder<CategoryModel>(
                        future: futureCategoryModel,
                        builder: (context, snapshot) {
                          if(snapshot.hasData){
                            List<String> item = snapshot.data!.data.categories.map((e) => e.category).toList();
                            return DropdownButton(
                              hint: Text('Select Category'),
                              value: category==''?null:category,
                              items: item.map((e) => DropdownMenuItem(child: Text(e), value: e,)).toList(),
                              onChanged: (dynamic val)async{
                                setState(() {
                                  category = val;
                                });
                              },
                            );
                          } else if(snapshot.hasError) return Text(snapshot.error.toString());
                          else return SizedBox(width: 50, child: Center(child: CircularProgressIndicator()));
                        }
                    )
                ),
              ),
            ),
            SizedBox(height: defaultPadding),
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 10.0),
              child: Material(
                elevation: 10.0,
                borderRadius: BorderRadius.circular(8.0),
                child: ListTile(
                  title: TextField(
                    controller: _subcategoryController,
                    decoration: InputDecoration(
                      hintText: 'Enter SubCategory Name',
                      border: InputBorder.none,
                    ),
                  ),
                  trailing: new IconButton(
                    icon: new Icon(Icons.cancel),
                    onPressed: () {
                      _subcategoryController.clear();
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: defaultPadding),
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: true,
              child: Container(
                padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0),
                margin: EdgeInsets.only(top: 15),
                child: Center(
                  child: AppButton(
                    type: ButtonType.PRIMARY,
                    text: _loading?"Loading...":"Add Sub Category",
                    onPressed: _loading? () {}: () async {
                      setState(() {
                        _loading = true;
                      });
                      PostResponseModel model = await addSubCategory(
                        category: category,
                        subcategory: _subcategoryController.text
                      );
                      setState(() {
                        _loading=false;
                      });
                      if(!model.errors.errorCode.isNull)
                        _showDialog(context, model.errors.errorMessage.toString(), false);
                      else _showDialog(context, 'Sub Category Added Successfully', true);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showDialog(BuildContext context, String message, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Container(
            child: Row(
      children: [
        Icon(
          success?Icons.verified:Icons.cancel_outlined,
          color: bgColor,
        ),
        SizedBox(
          width: 25,
        ),
        Text('${message}'),
      ],
    ))));
  }
}
