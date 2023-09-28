import 'package:flutter/material.dart';
import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:smart_admin_dashboard/core/widgets/app_button_widget.dart';
import 'package:smart_admin_dashboard/models/post_response_model.dart';
import 'package:smart_admin_dashboard/screens/product/datasources/product_datasources.dart';

class AddNewCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [],
        ),
        SizedBox(height: defaultPadding),
        CategoryForm()
      ],
    );
  }
}

class CategoryForm extends StatefulWidget {
  const CategoryForm({
    Key? key,
  }) : super(key: key);

  @override
  _CategoryFormState createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  bool _loading = false;

  TextEditingController _categoryController = TextEditingController();

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
                  title: TextField(
                    controller: _categoryController,
                    decoration: InputDecoration(
                      hintText: 'Enter Category Name',
                      border: InputBorder.none,
                    ),
                  ),
                  trailing: new IconButton(
                    icon: new Icon(Icons.cancel),
                    onPressed: () {
                      _categoryController.clear();
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
                    text: _loading ? "Loading..." : "Add Category",
                    onPressed: _loading
                        ? () {}
                        : () async {
                            setState(() {
                              _loading = true;
                            });
                            PostResponseModel model = await addCategory(
                                category: _categoryController.text);
                            setState(() {
                              _loading = false;
                            });
                            if (model.errors.errorCode != null)
                              _showDialog(context,
                                  model.errors.errorMessage.toString(), false);
                            else
                              _showDialog(
                                  context, 'Category Added Successfully', true);
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
          success ? Icons.verified : Icons.cancel_outlined,
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
