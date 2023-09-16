import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import 'detailsModel.dart';

class CreateFullPDF{

  static Future<File> generatePDF(String name, fromto, comp_name, var total_day, var total_night,
      String machine_name, List<DetailsModel> searchList) async {
    final pdf = Document();
    final font = await rootBundle.load("fonts/Roboto-Medium.ttf");
    final ttf = Font.ttf(font);
    TextStyle headingStyle =
    TextStyle(color: PdfColors.black, fontWeight: FontWeight.bold, font: ttf);

    List<Widget> widgetList = [];
    int index = 0;

    TextStyle normalStyle =
    TextStyle(font: ttf);

    /***
     * Add View Here
     */

    widgetList.add(
        Padding(padding: EdgeInsets.all(0),
            child: Column(
                children: [
                  Text("Production Report", style: TextStyle(font: ttf, fontSize: 24, fontWeight: FontWeight.bold, color: PdfColors.red)),
                  SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(fromto, style: headingStyle),
                        Text(machine_name, style: headingStyle),
                        Text(comp_name, style: headingStyle)
                      ]
                  )
                ]
            ))
    );

    widgetList.add(Padding(
      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                "Prod Day",
                style: TextStyle(
                    color: PdfColors.red, fontWeight: FontWeight.bold, font: ttf),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                total_day.toStringAsFixed(3),
                style: TextStyle(
                    color: PdfColors.red, fontWeight: FontWeight.bold, font: ttf),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                "Prod Night",
                style: TextStyle(
                    color: PdfColors.red, fontWeight: FontWeight.bold, font: ttf),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                total_night.toStringAsFixed(3),
                style: TextStyle(
                    color: PdfColors.red, fontWeight: FontWeight.bold, font: ttf),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                "Prod Total",
                style: TextStyle(
                    color: PdfColors.red, fontWeight: FontWeight.bold, font: ttf),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                (total_day + total_night).toStringAsFixed(3),
                style: TextStyle(
                    color: PdfColors.red, fontWeight: FontWeight.bold, font: ttf),
              ),
            ],
          ),
        ],
      ),
    ));
    
    for(var items in searchList){
      widgetList.add(Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
        padding: EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              items.catalog_code.toString() +
                  "-" +
                  items.catalog_name,
              style: headingStyle,
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Text(
                  "Insertion Time: ",
                  style: headingStyle,
                ),
                Text(items.ins_date, style: normalStyle)
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Date: ",
                      style: headingStyle,
                    ),
                    Text(DateFormat('dd.MM.yyyy').format(
                        DateTime.parse(items.date)), style: normalStyle)
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "PO Number: ",
                      style: headingStyle,
                    ),
                    Text(items.po_number.toString(), style: normalStyle)
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Username:",
                        style: headingStyle,
                      ),
                      Text(items.username.toString(), style: normalStyle),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Party",
                        style: headingStyle,
                      ),
                      Text(items
                          .party_name
                          .toString(), style: normalStyle),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Gate Entry",
                        style: headingStyle,
                      ),
                      Text(items
                          .gate_entry
                          .toString(), style: normalStyle),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Count Code",
                        style: headingStyle,
                      ),
                      Text(items
                          .count_code
                          .toString(), style: normalStyle),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Material",
                        style: headingStyle,
                      ),
                      Text(items
                          .material_name
                          .toString(), style: normalStyle),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Shade",
                        style: headingStyle,
                      ),
                      Text(items.shade.toString(), style: normalStyle),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Brand",
                        style: headingStyle,
                      ),
                      Text(items.brand.toString(), style: normalStyle),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Prod QTY",
                        style: headingStyle,
                      ),
                      Text(items.prod_qty.toString() +
                          " " +
                          items.uom.toString(), style: normalStyle),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Godown",
                        style: headingStyle,
                      ),
                      Text(items.godown.toString(), style: normalStyle),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Prod Day",
                        style: headingStyle,
                      ),
                      Text(
                          double.parse(items.prod_day)
                              .toStringAsFixed(3), style: normalStyle),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Prod Night",
                        style: headingStyle,
                      ),
                      Text(double.parse(items
                          .prod_night
                          .toString())
                          .toStringAsFixed(3), style: normalStyle),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Prod",
                        style: headingStyle,
                      ),
                      Text((double.parse(items
                          .prod_day
                          .toString()) +
                          double.parse(items
                              .prod_night
                              .toString()))
                          .toStringAsFixed(3), style: normalStyle),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               
                Text(
                  (index + 1).toString() +
                      "/" +
                      searchList.length.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: PdfColors.red, font: ttf),
                ),
              ],
            ),
            Divider(color: PdfColors.grey, thickness: 1)

          ],
        ),
      ));
      index = index + 1;
    }


    pdf.addPage(MultiPage(build: (context) =>  widgetList,
    ));
    return saveDocument(name: name, pdf: pdf);
  }

  static Future<File> saveDocument(
      {required String name, required Document pdf}) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${name}');
    await file.writeAsBytes(bytes);
    return file;
  }
}