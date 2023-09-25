import 'package:flutter/material.dart';
import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:smart_admin_dashboard/models/order_model.dart';
import 'package:smart_admin_dashboard/screens/order/datasources/order_datasources.dart';

class OrderTable extends StatefulWidget {
  const OrderTable({
    Key? key,
  }) : super(key: key);

  @override
  State<OrderTable> createState() => _OrderTableState();
}

class _OrderTableState extends State<OrderTable> {
  late Future<OrderModel> futureOrderModel;
  bool _loading = false;

  @override
  void initState() {
    futureOrderModel = getOrder();
    super.initState();
  }

  String getOrderStatus(String status) {
    return 'Waiting for Approve';
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
            "Order Table",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SingleChildScrollView(
            //scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: double.infinity,
              child: FutureBuilder<OrderModel>(
                  future: futureOrderModel,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var orderData = snapshot.data!.data;
                      return PaginatedDataTable(
                        arrowHeadColor: Colors.white,
                        showCheckboxColumn: false,
                        horizontalMargin: 0,
                        columnSpacing: defaultPadding,
                        columns: [
                          DataColumn(
                            label: Text("Order Id"),
                          ),
                          DataColumn(
                            label: Text("Client Name"),
                          ),
                          DataColumn(
                            label: Text("Phone Number"),
                          ),
                          DataColumn(
                            label: Text("Event Date"),
                          ),
                          DataColumn(
                            label: Text("Status"),
                          ),
                          DataColumn(
                            label: Text("Total Price"),
                          ),
                          DataColumn(
                            label: Text("Operation"),
                          ),
                        ],
                        source:
                            OrderDataTable(data: orderData, context: context),
                      );
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else
                      return Center(child: CircularProgressIndicator());
                  }),
            ),
          ),
        ],
      ),
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
