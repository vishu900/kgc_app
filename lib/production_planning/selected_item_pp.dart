import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:dataproject2/production_planning/process_order.dart';
import 'package:dataproject2/production_planning/sale_order.dart';

class SelectedItemPP extends StatefulWidget {
  var COMP_CODE;
  var PARTY_CODE;

  SelectedItemPP({
    super.key,
    required this.COMP_CODE,
    required this.PARTY_CODE,
  });

  @override
  State<SelectedItemPP> createState() => _SelectedItemPPState();
}

class _SelectedItemPPState extends State<SelectedItemPP> {
  List<bool>? isChecked = [];
  @override
  void initState() {
    super.initState();
    getSelectedItem();
  }

  bool _isLoading = true;

  bool _isSearching = false;

  List<Map<String, dynamic>> _selectItemSearch = [];

  List<Map<String, dynamic>> selectedItemDetails = [];

  List<Map<String, dynamic>> selectedItem = [];
  Future<void> getSelectedItem() async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/ProdPlanSelectItem?COMP_CODE=" +
            widget.COMP_CODE.toString() +
            "&PARTY_CODE=" +
            widget.PARTY_CODE.toString());
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);
    _selectItemSearch.clear();
    setState(
      () {
        selectedItem = List.castFrom(jsonResponseList);
        _isLoading = false;

        isChecked = List<bool>.filled(selectedItem.length, false);
        _selectItemSearch = selectedItem;
        // _selectItemSearch = List.from(selectedItem);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, selectedItemDetails);

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: _isSearching
              ? TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                  ],
                  onChanged: (value) {
                    if (value.isEmpty) {
                      setState(() {
                        _selectItemSearch = List.from(selectedItem);
                      });
                    } else {
                      setState(() {
                        _selectItemSearch = selectedItem
                            .where((item) =>
                                item["ORDER_NO"].toString().contains(value) ||
                                item["CATALOG_ITEM"].toString().contains(value))
                            .toList();
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                  ),
                )
              : const Text('Selected Item'),
          leading: InkWell(
              onTap: () {
                Navigator.pop(context, selectedItemDetails);
              },
              child: const Icon(Icons.arrow_back_ios_new)),
          actions: [
            IconButton(
              icon: Icon(_isSearching ? Icons.cancel : Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                });
              },
            ),
          ],
        ),

        // appBar: AppBar(
        //   title: const Text("Selected Item"),
        //   leading: InkWell(
        //       onTap: () {
        //         Navigator.pop(context, selectedItemDetails);
        //       },
        //       child: const Icon(Icons.arrow_back_ios)),
        // ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                child: Visibility(
                  visible: _isLoading,
                  replacement: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: _selectItemSearch.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(
                          left: 18, right: 18, bottom: 25),
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
                              Container(
                                alignment: Alignment.topRight,
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  value: isChecked![index],
                                  onChanged: (bool? value) {
                                    selectedItemDetails
                                        .add(_selectItemSearch[index]);
                                    if (value == true) {
                                      selectedItemDetails
                                          .add(_selectItemSearch[index]);
                                    } else {
                                      selectedItemDetails
                                          .remove(_selectItemSearch[index]);
                                    }
                                    setState(() {
                                      isChecked![index] = value!;
                                    });
                                  },
                                ),
                              ),
                              Row(
                                children: const [
                                  Expanded(
                                    flex: 1,
                                    child: Text("Order No"),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text("Order Date"),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      _selectItemSearch[index]["ORDER_NO"]
                                          .toString(),
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
                                          selectedItem[index]["ORDER_DATE"]
                                              .toString(),
                                        ),
                                      ),
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
                                    child: Text("Catalog Item - Catalog Name"),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "${_selectItemSearch[index]["CATALOG_ITEM"]} - ${_selectItemSearch[index]["CATALOG_NAME"]}",
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
                                    child: Text("Count Code - Count Name"),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "${selectedItem[index]["COUNT_CODE"]} - ${selectedItem[index]["COUNT_NAME"]}",
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
                                    child: Text("Item Code - Item Name"),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "${selectedItem[index]["ITEM_CODE"]} - ${selectedItem[index]["ITEM_NAME"]}",
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
                                    child:
                                        Text("Material Code - Material Name"),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "${selectedItem[index]["MATERIAL_CODE"]} - ${selectedItem[index]["MATERIAL_NAME"]}",
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
                                    child: Text("Shade Code - Shade Name"),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "${selectedItem[index]["SHADE_CODE"]} - ${selectedItem[index]["SHADE_NAME"]}",
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
                                    child: Text("Brand Code - Brand Name"),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "${selectedItem[index]["BRAND_CODE"]} - ${selectedItem[index]["BRAND_NAME"]}",
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
                                    child: Text("Proc Code - Proc Name"),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "${selectedItem[index]["PROC_CODE"]} - ${selectedItem[index]["PROC_NAME"]}",
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
                                    child: Text("QTY - ABV"),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text("Bal Qty"),
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
                                      "${selectedItem[index]["QTY"]} - ${selectedItem[index]["UOM_ABV"]}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      selectedItem[index]["BAL_QTY"].toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      selectedItem[index]["RATE"].toString(),
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
                                    child: Text("Prod Day"),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text("Prod Night"),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text("Total Prod"),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      selectedItem[index]["PROD_DAY"]
                                          .toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      selectedItem[index]["PROD_NIGHT"]
                                          .toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      selectedItem[index]["TOT_PROD"]
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.red),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => SaleOrderPP(
                                              SALE_ORDER_DTL_PK:
                                                  selectedItem[index]
                                                      ["SALE_ORDER_DTL_PK"]),
                                        ),
                                      );
                                    },
                                    child: const Text("Sale Order"),
                                  ),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.red),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => ProcessOrederPP(
                                            PROD_ORDER_HDR_PK:
                                                selectedItem[index]
                                                    ["PROD_ORDER_HDR_PK"],
                                            SALE_ORDER_DTL_PK:
                                                selectedItem[index]
                                                    ["SALE_ORDER_DTL_PK"],
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text("Process Order"),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              Container(
                                alignment: Alignment.center,
                                height: 20.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${index + 1}/${selectedItem.length}',
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
                        ),
                      ),
                    ),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
