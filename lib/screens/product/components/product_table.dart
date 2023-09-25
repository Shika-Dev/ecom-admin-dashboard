import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:smart_admin_dashboard/core/constants/currency_format.dart';
import 'package:smart_admin_dashboard/models/post_response_model.dart';
import 'package:smart_admin_dashboard/models/product_model.dart';
import 'package:smart_admin_dashboard/screens/forms/input_form.dart';
import 'package:smart_admin_dashboard/screens/product/datasources/product_datasources.dart';

class ProductTable extends StatefulWidget {
  const ProductTable({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductTable> createState() => _ProductTableState();
}

class _ProductTableState extends State<ProductTable> {
  late Future<ProductModel> futureProductModel;
  bool _loading = false;

  @override
  void initState() {
    futureProductModel = getProduct();
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Product Table",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SingleChildScrollView(
            //scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: double.infinity,
              child: FutureBuilder<ProductModel>(
                  future: futureProductModel,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var listProduct = snapshot.data!.data;
                      return DataTable(
                        horizontalMargin: 0,
                        columnSpacing: defaultPadding,
                        columns: [
                          DataColumn(
                            label: Text("Product Id"),
                          ),
                          DataColumn(
                            label: Text("Product Name"),
                          ),
                          DataColumn(
                            label: Text("Price"),
                          ),
                          DataColumn(
                            label: Text("Unit"),
                          ),
                          DataColumn(
                            label: Text("Featured Product"),
                          ),
                          DataColumn(
                            label: Text("Operation"),
                          ),
                        ],
                        rows: List.generate(
                          listProduct.length,
                          (index) =>
                              productDataRow(listProduct[index], context),
                        ),
                      );
                    } else
                      return Center(child: CircularProgressIndicator());
                  }),
            ),
          ),
        ],
      ),
    );
  }

  DataRow productDataRow(Product product, BuildContext context) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            product.id.toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(Text(product.name)),
        DataCell(Text(CurrencyFormat.convertToIdr(product.priceOriginal, 0))),
        DataCell(Text(product.unit)),
        DataCell(Text(product.isFeatured ? 'Yes' : 'No')),
        DataCell(
          Row(
            children: [
              TextButton(
                child: Text('Edit', style: TextStyle(color: greenColor)),
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return new FormMaterial(
                          type: FormType.updateProduct,
                          product: product,
                        );
                      },
                      fullscreenDialog: true));
                },
              ),
              SizedBox(
                width: 6,
              ),
              TextButton(
                child:
                    Text("Delete", style: TextStyle(color: Colors.redAccent)),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                            title: Center(
                              child: Column(
                                children: [
                                  Icon(Icons.warning_outlined,
                                      size: 36, color: Colors.red),
                                  SizedBox(height: 20),
                                  Text("Confirm Deletion"),
                                ],
                              ),
                            ),
                            content: Container(
                              color: secondaryColor,
                              height: 70,
                              child: Column(
                                children: [
                                  Text(
                                      "Are you sure want to delete '${product.name}'?"),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton.icon(
                                          icon: Icon(
                                            Icons.close,
                                            size: 14,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.grey),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          label: Text("Cancel")),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      ElevatedButton.icon(
                                          icon: Icon(
                                            Icons.delete,
                                            size: 14,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.red),
                                          onPressed: _loading
                                              ? () {}
                                              : () async {
                                                  setState(() {
                                                    _loading = true;
                                                  });
                                                  PostResponseModel model =
                                                      await deleteProduct(
                                                          product: product);
                                                  setState(() {
                                                    _loading = false;
                                                  });
                                                  if (!model
                                                      .errors.errorCode.isNull)
                                                    _showDialog(
                                                        context,
                                                        model
                                                            .errors.errorMessage
                                                            .toString(),
                                                        false);
                                                  else
                                                    _showDialog(
                                                        context,
                                                        'Product Updated Successfully',
                                                        true);
                                                },
                                          label: Text(_loading
                                              ? "Loading..."
                                              : "Delete"))
                                    ],
                                  )
                                ],
                              ),
                            ));
                      });
                },
                // Delete
              ),
            ],
          ),
        ),
      ],
    );
  }

  _showDialog(BuildContext context, String message, bool success) {
    Navigator.pop(context);
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
