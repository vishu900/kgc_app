import 'package:animated_button/animated_button.dart';
import 'package:dataproject2/material_issue/Url/url.dart';
import 'package:dataproject2/material_issue/model/selected_item_model.dart';
import 'package:dataproject2/material_issue/screens/process_order.dart';
import 'package:dataproject2/material_issue/screens/sale_order.dart';
import 'package:dataproject2/material_issue/screens/show_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/process_order_model.dart';

class MISelectedItems extends StatefulWidget {
  var comp_code;
  var acc_code;
  var CONT_PERSON_CODE;

  MISelectedItems({
    super.key,
    required this.comp_code,
    required this.acc_code,
    required this.CONT_PERSON_CODE,
  });

  @override
  State<MISelectedItems> createState() => _PendingOrdersState();
}

class _PendingOrdersState extends State<MISelectedItems> {
  List<Map<String, dynamic>> _catalogItem = [];
  List<Map<String, dynamic>> _selectItem = [];
  List<Map<String, dynamic>> _selectItemDetails = [];

  double stockTotal = 0.0;

  List<Map<String, dynamic>> _selectItemSearch = [];

  int _selextedIndex = 0;

  List<bool>? isChecked = [];
  List<SelectedItemModel> selectedItemsList = [];
  var currentIndex = 0;

  ProcessOrderModel? processOrder;

  @override
  void initState() {
    super.initState();

    getSelectItem();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> getCatalogItem(String PROD_ORDER_DTL_PK) async {
    final url = Uri.parse(
        "${Reusable.baseUrl}/webapi/api/Common/ItemHeader?PROD_ORDER_DTL_PK=" +
            PROD_ORDER_DTL_PK);
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);
    setState(
      () {
        _catalogItem = List.castFrom(jsonResponseList);
        processOrder = ProcessOrderModel(
            CATALOG_ITEM_NAME:
                _selectItemSearch[currentIndex]["CATALOG_ITEM"].toString(),
            prdOrderNo: _selectItemSearch[currentIndex]["ORDER_NO"].toString(),
            catalogCode: _catalogItem.isEmpty
                ? ""
                : _catalogItem[0]["CATALOG_ITEM"].toString(),
            orderDate: _selectItemSearch[currentIndex]["ORDER_DATE"].toString(),
            pro_odr_name: _catalogItem.isEmpty
                ? ""
                : _catalogItem[0]["CATALOG_ITEM_NAME"].toString());
      },
    );
  }

  Future<void> getSelectItem() async {
    final url = Uri.parse(
        "${Reusable.baseUrl}/webapi/api/Common/CatItem?comp_code=" +
            widget.comp_code.toString() +
            "&acc_code=" +
            widget.acc_code.toString() +
            "&CONT_PERSON_CODE=" +
            widget.CONT_PERSON_CODE.toString());
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);
    _selectItemSearch.clear();
    setState(
      () {
        _selectItem = List.castFrom(jsonResponseList);

        _selectItemSearch = _selectItem;
        getSelectItemDetails(_selectItemSearch[0]["CATALOG_ITEM"].toString());
        getCatalogItem(_selectItemSearch[0]["PROD_ORDER_DTL_PK"].toString());
      },
    );
  }

  Future<void> getSelectItemDetails(String cat_item) async {
    try {
      final url = Uri.parse(
          "${Reusable.baseUrl}/webapi/api/Common/SelectItemDetails?CATALOG_ITEM=" +
              cat_item);
      final response = await http.get(url);
      final jsonResponseList = json.decode(response.body);

      setState(
        () {
          _selectItemDetails = List.castFrom(jsonResponseList);

          stockTotal = 0.0;
          for (int i = 0; i < _selectItemDetails.length; i++) {
            //Do Something
            stockTotal = stockTotal +
                double.parse(_selectItemDetails[i]["STOCK_QTY"].toString());
          }

          isChecked = List<bool>.filled(_selectItemDetails.length, false);
        },
      );
    } catch (e) {
      print(e);
    }
  }

  bool _isSearching = false;

  int totalPages = 100;
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, selectedItemsList);

        return false;
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: _isSearching
                ? TextField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                    ],
                    onChanged: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          _selectItemSearch = List.from(_selectItem);
                        });
                      } else {
                        setState(() {
                          _selectItemSearch = _selectItem
                              .where((item) =>
                                  item["ORDER_NO"].toString().contains(value) ||
                                  item["CATALOG_ITEM"]
                                      .toString()
                                      .contains(value))
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
                  Navigator.pop(context, selectedItemsList);
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
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          "CATALOG CODE",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          _catalogItem.isEmpty
                              ? ""
                              : _catalogItem[0]["CATALOG_ITEM"].toString(),
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    // const SizedBox(width: 20),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0,top: 10.0,bottom: 10.0),
                child: Row(
                  children: [
                    Text(
                      "CAT ITEM NAME  ",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Flexible(
                      child: Text(
                        _catalogItem.isEmpty
                            ? ""
                            : _catalogItem[0]["CATALOG_ITEM_NAME"],
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(
                  child: PageView.builder(
                    onPageChanged: (value) {
                      getSelectItemDetails(
                          _selectItemSearch[value]["CATALOG_ITEM"].toString());
                      getCatalogItem(_selectItemSearch[value]
                              ["PROD_ORDER_DTL_PK"]
                          .toString());

                      setState(() {
                        _selextedIndex = value;
                        currentIndex = value;
                      });
                    },
                    itemCount: _selectItemSearch.length,
                    itemBuilder: (context, index) => SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 18.0, right: 18.0, bottom: 18.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectItemSearch[index]
                                          ["CATALOG_ITEM_NAME"],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 10.0),
                                    Row(
                                      children: const [
                                        Expanded(
                                          flex: 1,
                                          child: Text("Prd Order No."),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text("Catalog Item"),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text("Stock Qty"),
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
                                            _selectItemSearch[index]
                                                    ["CATALOG_ITEM"]
                                                .toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            _selectItemSearch[index]
                                                    ["STOCK_QTY"]
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
                                          child: Text("Prod Bom Qty"),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text("Issue Qty"),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text("Bal Issue"),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            _selectItemSearch[index]
                                                    ["PROD_BOM_QTY"]
                                                .toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            _selectItemSearch[index]
                                                    ["ISSUE_QTY"]
                                                .toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            _selectItemSearch[index]
                                                    ["BAL_ISSUE"]
                                                .toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 40.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) => ShowImage(
                                                    itemCode: _selectItem[
                                                            currentIndex]
                                                        ["CATALOG_ITEM"]),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            "Show image",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xffd53233),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          height: 20.0,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${index + 1}/${_selectItemSearch.length}',
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
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, bottom: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ProcessOrder(
                                      processorderData: processOrder!),
                                ),
                              );
                            },
                            child: const Text('PROCESS ORDER'),
                          ),
                          const SizedBox(width: 20.0),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => MISaleOrder(
                                    processOrderModel: processOrder!,
                                    SALE_ORDER_DTL_PK:
                                        _selectItemSearch[currentIndex]
                                                ["SALE_ORDER_DTL_PK"]
                                            .toString(),
                                  ),
                                ),
                              );
                            },
                            child: const Text('SALE ORDER'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "ITEM DETAILS",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Total QTY",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        stockTotal.toString(),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15.0),
              Expanded(
                child: SizedBox(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: _selectItemDetails.length,
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
                              Row(
                                children: const [
                                  Expanded(
                                    flex: 1,
                                    child: Text("Company"),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text("Godown"),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text("Lot No"),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      _selectItemDetails[index]["COMP_CODE"]
                                              .toString() +
                                          "-" +
                                          _selectItemDetails[index]["COMP_ABV"],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      _selectItemDetails[index]["GODOWN_NAME"],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      _selectItemDetails[index]["LOT_NO"]
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
                                    child: Text("Roll No/Bag No"),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text("Stock Qty"),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text("Uom"),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      _selectItemDetails[index]["ROLL_NO"]
                                          .toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      _selectItemDetails[index]["STOCK_QTY"]
                                          .toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      _selectItemDetails[index]["QTY_UOM"]
                                          .toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    height: 20.0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${index + 1}/${_selectItemDetails.length}',
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    // margin: const EdgeInsets.only(top: 40),
                                    alignment: Alignment.bottomRight,
                                    child: Checkbox(
                                      checkColor: Colors.white,
                                      value: isChecked![index],
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (widget.comp_code ==
                                              _selectItemDetails[index]
                                                      ["COMP_CODE"]
                                                  .toString()) {
                                            isChecked![index] = value!;
                                            if (value) {
                                              String rate = _selectItemSearch[
                                                      currentIndex]["RATE"]
                                                  .toString();

                                              String amount = _selectItemSearch[
                                                      currentIndex]["AMOUNT"]
                                                  .toString();

                                              selectedItemsList.add(
                                                SelectedItemModel(
                                                  RollNo:
                                                      _selectItemDetails[index]
                                                              ["ROLL_NO"]
                                                          .toString(),
                                                  Qty: _selectItemDetails[index]
                                                          ["STOCK_QTY"]
                                                      .toString(),
                                                  UOM: _selectItemDetails[index]
                                                          ["QTY_UOM"]
                                                      .toString(),
                                                  Rate: rate.contains("{") ||
                                                          rate == "null"
                                                      ? "0"
                                                      : rate,
                                                  Amount:
                                                      amount.contains("{") ||
                                                              amount == "null"
                                                          ? "0"
                                                          : amount,
                                                  index: index.toString(),
                                                  name: _selectItemSearch[
                                                          currentIndex]
                                                      ["CATALOG_ITEM_NAME"],
                                                  hsnCode:
                                                      _selectItemDetails[index]
                                                              ["MATERIAL_CODE"]
                                                          .toString(),
                                                  catalogCode: _catalogItem[0]
                                                          ["CATALOG_ITEM"]
                                                      .toString(),
                                                  prdOrderNo: _selectItemSearch[
                                                              currentIndex]
                                                          ["ORDER_NO"]
                                                      .toString(),
                                                  orderDate: _selectItemSearch[
                                                              currentIndex]
                                                          ["ORDER_DATE"]
                                                      .toString(),
                                                  PROD_ORDER_BOM_FK: _selectItem[
                                                              currentIndex]
                                                          ["PROD_ORDER_BOM_PK"]
                                                      .toString(),
                                                  godowncode:
                                                      _selectItemDetails[index]
                                                              ["GODOWN_CODE"]
                                                          .toString(),
                                                  lotNo:
                                                      _selectItemDetails[index]
                                                              ["LOT_NO"]
                                                          .toString(),
                                                  countCode:
                                                      _selectItemDetails[index]
                                                              ["COUNT_CODE"]
                                                          .toString(),
                                                  brandCode:
                                                      _selectItemDetails[index]
                                                              ["BRAND_CODE"]
                                                          .toString(),
                                                  materialCode:
                                                      _selectItemDetails[index]
                                                              ["MATERIAL_CODE"]
                                                          .toString(),
                                                  ITEM_CODE:
                                                      _selectItemDetails[index]
                                                              ["ITEM_CODE"]
                                                          .toString(),
                                                  shade_code:
                                                      _selectItemDetails[index]
                                                              ["SHADE_CODE"]
                                                          .toString(),
                                                  iop1_code:
                                                      _selectItemDetails[index]
                                                              ["IOP1_CODE"]
                                                          .toString(),
                                                  iop1_val:
                                                      _selectItemDetails[index]
                                                              ["IOP1_VAL"]
                                                          .toString(),
                                                  iop1_uom:
                                                      _selectItemDetails[index]
                                                              ["IOP1_UOM"]
                                                          .toString(),
                                                  iop2_code:
                                                      _selectItemDetails[index]
                                                              ["IOP2_CODE"]
                                                          .toString(),
                                                  iop2_val:
                                                      _selectItemDetails[index]
                                                              ["IOP2_VAL"]
                                                          .toString(),
                                                  iop2_uom:
                                                      _selectItemDetails[index]
                                                              ["IOP2_UOM"]
                                                          .toString(),
                                                  iop3_code:
                                                      _selectItemDetails[index]
                                                              ["IOP3_CODE"]
                                                          .toString(),
                                                  iop3_val:
                                                      _selectItemDetails[index]
                                                              ["IOP3_VAL"]
                                                          .toString(),
                                                  iop3_uom:
                                                      _selectItemDetails[index]
                                                              ["IOP3_UOM"]
                                                          .toString(),
                                                  QTY_UOM_NUM:
                                                      _selectItemDetails[index]
                                                              ["QTY_UOM_NUM"]
                                                          .toString(),
                                                  godownName:
                                                      _selectItemDetails[index]
                                                          ["GODOWN_NAME"],
                                                  pro_odr_name: _catalogItem[0]
                                                      ["CATALOG_ITEM_NAME"],
                                                  SALE_ORDER_DTL_PK:
                                                      _selectItemSearch[
                                                                  currentIndex][
                                                              "SALE_ORDER_DTL_PK"]
                                                          .toString(),
                                                ),
                                              );
                                            } else {
                                              selectedItemsList.removeWhere(
                                                  (selectedItemsList) =>
                                                      selectedItemsList.index ==
                                                      index.toString());
                                            }
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text("Error"),
                                                  content: const Text(
                                                      "Stock not available for the company.\nPlease tranfer the stock first !"),
                                                  actions: [
                                                    AnimatedButton(
                                                      width: 100,
                                                      height: 40,
                                                      color: Colors.red,
                                                      child: const Text(
                                                        "OK",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
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
      ),
    );
  }
}
