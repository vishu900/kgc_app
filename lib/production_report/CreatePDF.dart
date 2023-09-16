import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class CreatePDF {
  static Future<File> generatePDF(String name, fromto, comp_name, List<Map<String, dynamic>> searchList, List<Map<String, dynamic>> sumList,
      var total_day, var total_night) async {
    final pdf = Document();
    final font = await rootBundle.load("fonts/Roboto-Medium.ttf");
    final ttf = Font.ttf(font);
    TextStyle headingStyle =
    TextStyle(color: PdfColors.black, fontWeight: FontWeight.bold, font: ttf);

    List<Widget> widgetList = [];

    widgetList.add(SizedBox(
      height: 5,
    ));

    int index = 0;

    TextStyle normalStyle =
    TextStyle(font: ttf);
    
    widgetList.add(
      Padding(padding: EdgeInsets.all(0),
      child: Column(
        children: [
          Text("Production Report Summery", style: TextStyle(font: ttf, fontSize: 24, fontWeight: FontWeight.bold, color: PdfColors.red)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(fromto, style: headingStyle),
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
    
    for(var searchItem in searchList){
      String daySum = "";
      String nightSum = "";
      for (var tempSum in sumList) {
        if (tempSum["ACC_CONT_PERSON_CODE"] ==
            searchItem["ACC_CONT_PERSON_CODE"]) {
          daySum =
              tempSum["TOTAL_DAY"].toStringAsFixed(3);
          nightSum =
              tempSum["TOTAL_NIGHT"].toStringAsFixed(3);
        }
      }
      
      widgetList.add(Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),

        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  "Machine Code/Contact Person: ",
                  style: headingStyle,
                ),
                Expanded(
                    child: Text(searchItem
                    ["CONTACT_PERSON"], style: normalStyle))
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  "Party: ",
                  style: headingStyle,
                ),
                Expanded(
                    child: Text(searchItem
                    ["PARTY_NAME"], style: normalStyle))
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "Prod Day",
                      style: headingStyle,
                    ),
                    Text(daySum, style: normalStyle),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "Prod Night",
                      style: headingStyle,
                    ),
                    Text(nightSum, style: normalStyle),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "Total Prod",
                      style: headingStyle,
                    ),
                    Text((double.parse(daySum) +
                        double.parse(nightSum))
                        .toStringAsFixed(3), style: normalStyle),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
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
      index = index +1;
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
