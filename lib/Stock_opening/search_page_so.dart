import 'package:dataproject2/Stock_opening/model/search_details_so_model.dart';
import 'package:dataproject2/Stock_opening/search_Page_Details_so.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class SearchPageSO extends StatefulWidget {
  var code;
  SearchPageSO({super.key, required this.code});

  @override
  State<SearchPageSO> createState() => _SearchPageSOState();
}

class _SearchPageSOState extends State<SearchPageSO>
    with WidgetsBindingObserver {
  TextEditingController docDateController = TextEditingController();
  TextEditingController finYearController = TextEditingController();
  TextEditingController docNoController = TextEditingController();
  TextEditingController catController = TextEditingController();

  List<Map<String, dynamic>> _searchStock = [];

  String dateformat(DateTime date) {
    String formattedDate = DateFormat('dd.MM.yyyy – HH:mm').format(date);
    return formattedDate;
  }

  Future<void> getSearchItem() async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/SearchOpeningStock?doc_date=" +
            docDateController.text +
            "&doc_finyear=" +
            finYearController.text +
            "&doc_no=" +
            docNoController.text +
            "&catalog_item=" +
            catController.text +
            "&comp_code=" +
            widget.code);
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);
    setState(
      () {
        _searchStock = List.castFrom(jsonResponseList);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Items"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // const Text(
            //   "Stock Opening",
            //   style: TextStyle(
            //     fontSize: 19,
            //     fontWeight: FontWeight.w600,
            //     color: Color(0xffd53233),
            //   ),
            // ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Doc Date",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(
                  height: 40,
                  width: 200,
                  child: TextFormField(
                    controller: docDateController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                    ],
                    decoration: InputDecoration(
                      hintText: 'Enter document date',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                              onTap: () {
                                docDateController.clear();
                              },
                              child: Icon(Icons.clear)),
                          SizedBox(width: 5.0),
                          InkWell(
                            onTap: () async {
                              final DateTime? selectedDate =
                                  await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );
                              if (selectedDate != null) {
                                docDateController.text =
                                    DateFormat('dd.MM.yyyy')
                                        .format(selectedDate);
                              }
                            },
                            child: Icon(Icons.calendar_today),
                          ),
                        ],
                      ),
                      // suffixIcon: IconButton(
                      //   onPressed: () async {
                      //     final DateTime? selectedDate = await showDatePicker(
                      //       context: context,
                      //       initialDate: DateTime.now(),
                      //       firstDate: DateTime(1900),
                      //       lastDate: DateTime(2100),
                      //     );
                      //     if (selectedDate != null) {
                      //       docdateController.text =
                      //           DateFormat('dd.MM.yyyy').format(selectedDate);
                      //     }
                      //   },
                      //   icon: Icon(Icons.calendar_today),
                      // ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Fin Year",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(
                  height: 40,
                  width: 200,
                  child: TextFormField(
                    controller: finYearController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter Fin Year',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      suffixIcon: IconButton(
                        onPressed: () {
                          finYearController.clear();
                        },
                        icon: Icon(Icons.clear),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Doc No",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(
                  height: 40,
                  width: 200,
                  child: TextFormField(
                    controller: docNoController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter Doc No',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      suffixIcon: IconButton(
                        onPressed: () {
                          docNoController.clear();
                        },
                        icon: Icon(Icons.clear),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Catalog Code",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(
                  height: 40,
                  width: 200,
                  child: TextFormField(
                    controller: catController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter Catalog Code',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      suffixIcon: IconButton(
                        onPressed: () {
                          catController.clear();
                        },
                        icon: Icon(Icons.clear),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    setState(() {
                      getSearchItem();
                    });
                  },
                  child: const Text('Search Item'),
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _searchStock.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, bottom: 25, top: 10),
                  child: InkWell(
                    onTap: () {
                      var search_Stock = GetSearchDetailsSO(
                        docDate: _searchStock[index]["DOC_DATE"].toString(),
                        roll: _searchStock[index]["ROLL_NO"].toString(),
                        Approval:
                            _searchStock[index]["APPROVAL_UID"].toString(),
                        Godown: _searchStock[index]["GODOWN_CODE"].toString(),
                        finYear: _searchStock[index]["DOC_FINYEAR"].toString(),
                        docNo: _searchStock[index]["DOC_NO"].toString(),
                        catalogCode:
                            _searchStock[index]["CATALOG_ITEM"].toString(),
                        hsn: _searchStock[index]["HSN_CODE"].toString(),
                        lotno: _searchStock[index]["LOT_NO"].toString(),
                        rate: _searchStock[index]["RATE"].toString(),
                        qty: _searchStock[index]["STOCK_QTY"].toString(),
                        catalogItemName:
                            _searchStock[index]["CATALOG_ITEM_NAME"].toString(),
                        Uom: _searchStock[index]["UOM_ABV"].toString(),
                        codePk: _searchStock[index]["CODE_PK"].toString(),
                      );

                      setState(() {
                        _searchStock.clear();
                      });
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => SearchDetaisSO(
                                code: widget.code,
                                getSearchDetailsSO: search_Stock,
                              )));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: Column(
                          children: [
                            const SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 20.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${index + 1}/${_searchStock.length}',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: const [
                                Expanded(
                                  flex: 1,
                                  child: Text("Company "),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    _searchStock[index]["COMP_NAME"].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: const [
                                Expanded(
                                  flex: 1,
                                  child: Text("Catalog Code "),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    _searchStock[index]["CATALOG_ITEM"]
                                        .toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              children: const [
                                Expanded(
                                  flex: 1,
                                  child: Text("Catalog Item Name"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    _searchStock[index]["CATALOG_ITEM_NAME"]
                                        .toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              children: const [
                                Expanded(
                                  flex: 1,
                                  child: Text("Doc No"),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text("Doc Date"),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text("Doc Fin Year"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    _searchStock[index]["DOC_NO"].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    DateFormat('dd.MM.yy').format(
                                      DateTime.parse(
                                        _searchStock[index]["DOC_DATE"]
                                            .toString(),
                                      ),
                                    ),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    _searchStock[index]["DOC_FINYEAR"]
                                        .toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: const [
                                Expanded(
                                  flex: 1,
                                  child: Text("Lot No"),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text("Roll No/Brand "),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text("Rate"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    _searchStock[index]["LOT_NO"].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    _searchStock[index]["ROLL_NO"].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    _searchStock[index]["RATE"].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              children: const [
                                Expanded(
                                  flex: 1,
                                  child: Text("Qty"),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text("Uom"),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text("Godown Name"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    _searchStock[index]["STOCK_QTY"].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    _searchStock[index]["UOM_ABV"].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    _searchStock[index]["GODOWN_NAME"]
                                        .toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              children: const [
                                Expanded(
                                  flex: 1,
                                  child: Text("Insert By"),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text("Insert Date"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    _searchStock[index]["INS_UID"].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    dateformat(DateTime.parse(
                                        _searchStock[index]["INS_DATE"]
                                            .toString())),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              children: const [
                                Expanded(
                                  flex: 1,
                                  child: Text("Approved By"),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text("Approved Date"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    _searchStock[index]["APPROVED_USER"]
                                                .toString() ==
                                            "null"
                                        ? ""
                                        : _searchStock[index]["APPROVED_USER"]
                                            .toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    _searchStock[index]["APPROVED_DATE"]
                                                .toString() ==
                                            "null"
                                        ? ""
                                        : dateformat(DateTime.parse(
                                            _searchStock[index]["APPROVED_DATE"]
                                                .toString())),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
