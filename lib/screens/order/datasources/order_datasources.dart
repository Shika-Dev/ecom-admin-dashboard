import 'dart:async';
import 'dart:convert';
import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:smart_admin_dashboard/core/constants/currency_format.dart';
import 'package:smart_admin_dashboard/injector/injector.dart';
import 'package:smart_admin_dashboard/models/order_model.dart';
import 'package:smart_admin_dashboard/screens/order/datasources/image_base64.dart';
import 'package:smart_admin_dashboard/storage/shared_preferences_manager.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

Future<OrderModel> getOrder() async {
  SharedPreferencesManager pref = locator<SharedPreferencesManager>();
  String accessToken =
      pref.getString(SharedPreferencesManager.keyAccessToken) ?? '';
  final response = await http.get(
      Uri.parse(
          'https://api.sevva.co.id/api/order/getallorder?limit=500&offset=0'),
      headers: {
        "Authorization": "Bearer $accessToken",
      });
  print(response.body);
  print(response.statusCode);
  if (response.statusCode == 200) {
    return OrderModel.fromJson(json.decode(response.body));
  } else
    throw Exception(response.body);
}

String getOrderStatus(String status) {
  return 'Waiting for Approve';
}

class OrderDataTable extends DataTableSource {
  OrderDataTable({required this.data, required this.context});
  final OrderData data;
  final BuildContext context;

  Future<void> _createPDF(List<Product> list, String name, String alamat,
      String mobile, int totalPrice, int start, int end) async {
    PdfDocument document = PdfDocument();

    //Adds page settings
    document.pageSettings.orientation = PdfPageOrientation.portrait;
    document.pageSettings.margins.all = 50;

    //Adds a page to the document
    PdfPage page = document.pages.add();
    PdfGraphics graphics = page.graphics;
    //add Logo
    PdfImage image = PdfBitmap.fromBase64String(logo_base64);
    page.graphics.drawImage(
        image, Rect.fromLTWH(graphics.clientSize.width - 102, 0, 102, 30));

    //Add company info
    PdfFont timesRoman = PdfStandardFont(PdfFontFamily.timesRoman, 12);
    Rect company_bounds = Rect.fromLTWH(0, 0, graphics.clientSize.width, 30);

    PdfTextElement element = PdfTextElement(
        text: 'Metronome SoundSystem',
        font: PdfStandardFont(PdfFontFamily.timesRoman, 24,
            style: PdfFontStyle.bold));

    PdfLayoutResult company_result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, company_bounds.top + 8, 0, 0))!;
    element.brush = PdfBrushes.black;

    element = PdfTextElement(
        text: 'Jalan Pakubuwono VI No. 26D RT.8/RW.5, Gunung, Kec. Kby. Baru,',
        font: timesRoman);
    element.brush = PdfBrushes.black;
    company_result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(10, company_result.bounds.bottom + 5, 0, 0))!;

    element =
        PdfTextElement(text: 'Kota Jakarta Selatan 12120.', font: timesRoman);
    element.brush = PdfBrushes.black;
    company_result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(10, company_result.bounds.bottom + 5, 0, 0))!;

    element = PdfTextElement(text: 'Phone: 0819 1888 7333', font: timesRoman);
    element.brush = PdfBrushes.black;
    company_result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(10, company_result.bounds.bottom + 5, 0, 0))!;

    element =
        PdfTextElement(text: 'Email: sevva.co.id@gmail.com', font: timesRoman);
    element.brush = PdfBrushes.black;
    company_result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(10, company_result.bounds.bottom + 5, 0, 0))!;

    PdfBrush solidBrush = PdfSolidBrush(PdfColor(126, 151, 173));

    Rect bounds = Rect.fromLTWH(0, 160, graphics.clientSize.width, 30);

//Draws a rectangle to place the heading in that region
    graphics.drawRectangle(brush: solidBrush, bounds: bounds);

//Creates a font for adding the heading in the page
    PdfFont subHeadingFont = PdfStandardFont(PdfFontFamily.timesRoman, 14);

//Creates a text element to add the invoice number
    element = PdfTextElement(text: 'INVOICE', font: subHeadingFont);
    element.brush = PdfBrushes.white;

//Draws the heading on the page
    PdfLayoutResult result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, bounds.top + 8, 0, 0))!;
//Use 'intl' package for date format.
    String currentDate = 'DATE ' + DateFormat.yMMMd().format(DateTime.now());

//Measures the width of the text to place it in the correct location
    Size textSize = subHeadingFont.measureString(currentDate);
    Offset textPosition = Offset(
        graphics.clientSize.width - textSize.width - 10, result.bounds.top);

//Draws the date by using drawString method
    graphics.drawString(currentDate, subHeadingFont,
        brush: element.brush,
        bounds: Offset(graphics.clientSize.width - textSize.width - 10,
                result.bounds.top) &
            Size(textSize.width + 2, 20));

//Creates text elements to add the address and draw it to the page
    element = PdfTextElement(
        text: 'CUSTOMER',
        font: PdfStandardFont(PdfFontFamily.timesRoman, 10,
            style: PdfFontStyle.bold));
    element.brush = PdfSolidBrush(PdfColor(126, 155, 203));
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 15, 0, 0))!;

    element = PdfTextElement(text: name, font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, result.bounds.bottom + 5, 0, 0))!;

    element = PdfTextElement(text: mobile, font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, result.bounds.bottom + 5, 0, 0))!;

    element = PdfTextElement(text: alamat, font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, result.bounds.bottom + 5, 0, 0))!;

    print('Start: $start, End: $end');
    String sDate = DateFormat('dd MMMM yyyy')
        .format(DateTime.fromMillisecondsSinceEpoch(start))
        .toString();
    String eDate = DateFormat('dd MMMM yyyy')
        .format(DateTime.fromMillisecondsSinceEpoch(end))
        .toString();
    element = PdfTextElement(
        text: 'Tanggal Event: $sDate - $eDate', font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, result.bounds.bottom + 5, 0, 0))!;

//Draws a line at the bottom of the address
    graphics.drawLine(
        PdfPen(PdfColor(126, 151, 173), width: 0.7),
        Offset(0, result.bounds.bottom + 5),
        Offset(graphics.clientSize.width, result.bounds.bottom + 5));

    PdfGrid grid = PdfGrid();

//Add the columns to the grid
    grid.columns.add(count: 4);

//Add header to the grid
    grid.headers.add(1);

//Set values to the header cells
    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'Product Name';
    header.cells[1].value = 'Price';
    header.cells[2].value = 'Quantity';
    header.cells[3].value = 'Total';

//Creates the header style
    PdfGridCellStyle headerStyle = PdfGridCellStyle();
    headerStyle.borders.all = PdfPen(PdfColor(126, 151, 173));
    headerStyle.backgroundBrush = PdfSolidBrush(PdfColor(126, 151, 173));
    headerStyle.textBrush = PdfBrushes.white;
    headerStyle.font = PdfStandardFont(PdfFontFamily.timesRoman, 14,
        style: PdfFontStyle.regular);

//Adds cell customizations
    for (int i = 0; i < header.cells.count; i++) {
      if (i == 0 || i == 1) {
        header.cells[i].stringFormat = PdfStringFormat(
            alignment: PdfTextAlignment.left,
            lineAlignment: PdfVerticalAlignment.middle);
      } else {
        header.cells[i].stringFormat = PdfStringFormat(
            alignment: PdfTextAlignment.right,
            lineAlignment: PdfVerticalAlignment.middle);
      }
      header.cells[i].style = headerStyle;
    }

    for (int i = 0; i < list.length; i++) {
      int price =
          list[i].priceSale == 0 ? list[i].priceOriginal : list[i].priceSale;
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = list[i].name;
      row.cells[1].value = CurrencyFormat.convertToIdr(price, 0);
      row.cells[2].value = list[i].qty.toString();
      row.cells[3].value = CurrencyFormat.convertToIdr(price * list[i].qty, 0);
    }

    PdfGridRow subtotal_row = grid.rows.add();
    subtotal_row.cells[2].value = 'Subtotal';
    subtotal_row.cells[3].value = CurrencyFormat.convertToIdr(totalPrice, 0);

    PdfGridRow total_row = grid.rows.add();
    total_row.cells[2].value = 'Total';
    total_row.cells[3].value = CurrencyFormat.convertToIdr(totalPrice, 0);

    //Set padding for grid cells
    grid.style.cellPadding = PdfPaddings(left: 2, right: 2, top: 2, bottom: 2);

    //Creates the grid cell styles
    PdfGridCellStyle cellStyle = PdfGridCellStyle();
    cellStyle.borders.all = PdfPens.white;
    cellStyle.borders.bottom = PdfPen(PdfColor(217, 217, 217), width: 0.70);
    cellStyle.font = PdfStandardFont(PdfFontFamily.timesRoman, 12);
    cellStyle.textBrush = PdfSolidBrush(PdfColor(131, 130, 136));
    //Adds cell customizations
    for (int i = 0; i < grid.rows.count; i++) {
      PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        row.cells[j].style = cellStyle;
        if (j == 0 || j == 1) {
          row.cells[j].stringFormat = PdfStringFormat(
              alignment: PdfTextAlignment.left,
              lineAlignment: PdfVerticalAlignment.middle);
        } else {
          row.cells[j].stringFormat = PdfStringFormat(
              alignment: PdfTextAlignment.right,
              lineAlignment: PdfVerticalAlignment.middle);
        }
      }
    }

    //Creates layout format settings to allow the table pagination
    PdfLayoutFormat layoutFormat =
        PdfLayoutFormat(layoutType: PdfLayoutType.paginate);

//Draws the grid to the PDF page
    PdfLayoutResult gridResult = grid.draw(
        page: page,
        bounds: Rect.fromLTWH(0, result.bounds.bottom + 20,
            graphics.clientSize.width, graphics.clientSize.height - 100),
        format: layoutFormat)!;

    Rect bank_bounds = Rect.fromLTWH(
        0, gridResult.bounds.bottom + 20, graphics.clientSize.width, 30);

    PdfFont bankFontStyle = PdfStandardFont(PdfFontFamily.timesRoman, 12);

    element = PdfTextElement(text: 'BCA', font: bankFontStyle);
    element.brush = PdfBrushes.black;
    PdfLayoutResult bank_result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, bank_bounds.top + 8, 0, 0))!;

    element =
        PdfTextElement(text: 'a.n. Yusa Nanda Hardito', font: bankFontStyle);
    element.brush = PdfBrushes.black;
    bank_result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(10, bank_result.bounds.bottom + 5, 0, 0))!;

    element = PdfTextElement(text: '5005141751', font: bankFontStyle);
    element.brush = PdfBrushes.black;
    bank_result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(10, bank_result.bounds.bottom + 5, 0, 0))!;

    //Save the document
    List<int> bytes = await document.save();

    js.context['pdfData'] = base64.encode(bytes);
    js.context['filename'] = 'Invoice.pdf';
    Timer.run(() {
      js.context.callMethod('download');
    });

    //Dispose the document
    document.dispose();
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => data.totalRows;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    int startMilis = int.parse(data.orders[index].eventStartDate);
    int endMilis = int.parse(data.orders[index].eventEndDate);
    return DataRow(
      cells: [
        DataCell(
          Text(
            data.orders[index].userId.toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(Text(data.orders[index].clientName)),
        DataCell(Text(data.orders[index].phoneNo)),
        DataCell(Text(
            '${DateFormat('dd-MM-yyyy').format(DateTime.fromMillisecondsSinceEpoch(startMilis))} - ${DateFormat('dd-MM-yyyy').format(DateTime.fromMillisecondsSinceEpoch(endMilis))}')),
        DataCell(Text(getOrderStatus(data.orders[index].orderStatus))),
        DataCell(Text(CurrencyFormat.convertToIdr(
            data.orders[index].totalOrderPrice, 0))),
        DataCell(
          Row(
            children: [
              TextButton(
                child: Text('Approve', style: TextStyle(color: greenColor)),
                onPressed: () {},
              ),
              SizedBox(
                width: 6,
              ),
              TextButton(
                child: Text('Download',
                    style: TextStyle(color: Colors.blueAccent)),
                onPressed: () {
                  _createPDF(
                      data.orders[index].productList,
                      data.orders[index].clientName,
                      data.orders[index].address,
                      data.orders[index].phoneNo,
                      data.orders[index].totalOrderPrice,
                      startMilis,
                      endMilis);
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
                                      "Are you sure want to delete '${data.orders[index].clientName}'?"),
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
                                          onPressed: () async {},
                                          label: Text("Delete"))
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
}
