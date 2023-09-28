import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:smart_admin_dashboard/core/widgets/app_button_widget.dart';
import 'package:smart_admin_dashboard/models/category_model.dart';
import 'package:smart_admin_dashboard/models/post_response_model.dart';
import 'package:smart_admin_dashboard/models/subcategory_model.dart';
import 'package:smart_admin_dashboard/screens/product/datasources/product_datasources.dart';

class AddNewProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [],
        ),
        SizedBox(height: defaultPadding),
        ProductForm()
      ],
    );
  }
}

class ProductForm extends StatefulWidget {
  const ProductForm({
    Key? key,
  }) : super(key: key);

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  bool _loading = false;
  bool _sale = false;
  bool _feature = false;
  PlatformFile? _image;

  List<DropdownMenuItem> subcategoryItem =
      List<DropdownMenuItem>.empty(growable: true);

  String subcategory = '';
  String category = '';

  TextEditingController _nameController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _saleController = TextEditingController();
  TextEditingController _unitController = TextEditingController();
  TextEditingController _productDetailController = TextEditingController();

  late Future<CategoryModel> futureCategoryModel;

  Future<void> _pickImage() async {
    try {
      FilePickerResult? image =
          await FilePickerWeb.platform.pickFiles(type: FileType.image);
      if (image == null) return;
      setState(() {
        _image = image.files.first;
      });
    } catch (error) {
      print(error);
    }
  }

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
                  title: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter Product Name',
                      border: InputBorder.none,
                    ),
                  ),
                  trailing: new IconButton(
                    icon: new Icon(Icons.cancel),
                    onPressed: () {
                      _nameController.clear();
                    },
                  ),
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
                    controller: _descController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Enter Product Description',
                      border: InputBorder.none,
                    ),
                  ),
                  trailing: new IconButton(
                    icon: new Icon(Icons.cancel),
                    onPressed: () {
                      _descController.clear();
                    },
                  ),
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
                    controller: _productDetailController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Enter Product Detail',
                      border: InputBorder.none,
                    ),
                  ),
                  trailing: new IconButton(
                    icon: new Icon(Icons.cancel),
                    onPressed: () {
                      _productDetailController.clear();
                    },
                  ),
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
                    title: FutureBuilder<CategoryModel>(
                        future: futureCategoryModel,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<String> item = snapshot.data!.data.categories
                                .map((e) => e.category)
                                .toList();
                            return DropdownButton(
                              hint: Text('Select Category'),
                              value: category == '' ? null : category,
                              items: item
                                  .map((e) => DropdownMenuItem(
                                        child: Text(e),
                                        value: e,
                                      ))
                                  .toList(),
                              onChanged: (dynamic val) async {
                                SubCategoryModel model =
                                    await getSubCategory(val);
                                setState(() {
                                  subcategoryItem = model.data.subcategories
                                      .map((e) => DropdownMenuItem(
                                            child: Text(e.subcategory),
                                            value: e.subcategory,
                                          ))
                                      .toList();
                                  category = val;
                                });
                              },
                            );
                          } else if (snapshot.hasError)
                            return Text(snapshot.error.toString());
                          else
                            return SizedBox(
                                width: 50,
                                child:
                                    Center(child: CircularProgressIndicator()));
                        })),
              ),
            ),
            SizedBox(height: defaultPadding),
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 10.0),
              child: Material(
                elevation: 10.0,
                borderRadius: BorderRadius.circular(8.0),
                child: ListTile(
                    title: DropdownButton(
                  hint: Text('Select SubCategory'),
                  items: subcategoryItem,
                  value: subcategory == '' ? null : subcategory,
                  onChanged: (dynamic val) {
                    setState(() {
                      subcategory = val;
                    });
                  },
                )),
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
                    controller: _unitController,
                    decoration: InputDecoration(
                      hintText: 'Enter Product Unit',
                      border: InputBorder.none,
                    ),
                  ),
                  trailing: new IconButton(
                    icon: new Icon(Icons.cancel),
                    onPressed: () {
                      _unitController.clear();
                    },
                  ),
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
                    controller: _priceController,
                    decoration: InputDecoration(
                      hintText: 'Enter Product Price',
                      border: InputBorder.none,
                    ),
                  ),
                  trailing: new IconButton(
                    icon: new Icon(Icons.cancel),
                    onPressed: () {
                      _priceController.clear();
                    },
                  ),
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
                  leading: Checkbox(
                    fillColor:
                        MaterialStatePropertyAll(Theme.of(context).hintColor),
                    value: _sale,
                    onChanged: (value) => setState(() {
                      _sale = value!;
                    }),
                  ),
                  title: _sale
                      ? TextField(
                          controller: _saleController,
                          decoration: InputDecoration(
                            hintText: 'Enter Sale Price',
                            border: InputBorder.none,
                          ),
                        )
                      : Text(
                          'Sale',
                          style: TextStyle(color: Theme.of(context).hintColor),
                        ),
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
                  leading: Checkbox(
                    fillColor:
                        MaterialStatePropertyAll(Theme.of(context).hintColor),
                    value: _feature,
                    onChanged: (value) => setState(() {
                      _feature = value!;
                    }),
                  ),
                  title: Text(
                    'Featured',
                    style: TextStyle(color: Theme.of(context).hintColor),
                  ),
                ),
              ),
            ),
            SizedBox(height: defaultPadding),
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 10.0),
              child: Material(
                  elevation: 10.0,
                  borderRadius: BorderRadius.circular(8.0),
                  child: _image == null
                      ? ElevatedButton(
                          onPressed: () {
                            _pickImage();
                          },
                          child: Text('Select Image'),
                        )
                      : SizedBox(
                          width: 300,
                          height: 300,
                          child: Stack(
                            children: [
                              Align(
                                  alignment: Alignment.center,
                                  child: Image.memory(
                                    Uint8List.fromList(_image!.bytes!),
                                    fit: BoxFit.fitWidth,
                                  )),
                              Positioned(
                                  top: 15,
                                  right: 15,
                                  child: GestureDetector(
                                      onTap: () => setState(() {
                                            _image = null;
                                          }),
                                      child: Icon(Icons.cancel_outlined)))
                            ],
                          ))),
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
                    text: _loading ? "Loading..." : "Add Product",
                    onPressed: _loading
                        ? () {}
                        : () async {
                            setState(() {
                              _loading = true;
                            });
                            PostResponseModel model = await addProduct(
                                name: _nameController.text,
                                price: _priceController.text,
                                category: category,
                                subCategory: subcategory,
                                image: _image!.bytes as List<int>,
                                imageName: _image!.name,
                                unit: _unitController.text,
                                desc: _descController.text,
                                priceSale: _saleController.text,
                                isFeatured: _feature,
                                productDetail: _productDetailController.text);
                            setState(() {
                              _loading = false;
                            });
                            if (model.errors.errorCode != null)
                              _showDialog(context,
                                  model.errors.errorMessage.toString(), false);
                            else
                              _showDialog(
                                  context, 'Product Added Successfully', true);
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
