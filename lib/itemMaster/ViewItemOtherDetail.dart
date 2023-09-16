import 'dart:convert';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/itemMaster/model/PuchasePlanRateModel.dart';
import 'package:dataproject2/itemMaster/model/SaleOrderDetailModel.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'model/CatalogStockModel.dart';
import 'model/JWProcessModel.dart';
import 'model/JobWorkModel.dart';
import 'model/ProdOrderListModel.dart';
import 'model/SaleRatePlanModel.dart';

class ViewItemOtherDetail extends StatefulWidget {
  final String? catalogCode;

  const ViewItemOtherDetail({Key? key, required this.catalogCode})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ViewItemOtherDetail();
}

class _ViewItemOtherDetail extends State<ViewItemOtherDetail>
    with NetworkResponse {
  ///
  List<CatalogStockModel> catalogStockList = [];
  List<PurchasePlanRateModel> purchasePlanList = [];
  List<SaleRatePlanModel> saleRatePlanList = [];
  List<JWProcessModel> jwProcessList = [];
  List<JWProcessModel> accList = [];
  List<ProdOrderListModel> prodOrderList = [];
  List<ProdOrderListModel> prodOrderDetailList = [];
  List<SaleOrderDetailModel> saleOrderList = [];
  List<JobWorkModel> jobWorkList = [];
  TextEditingController processController = TextEditingController();
  TextEditingController accController = TextEditingController();
  TextEditingController contController = TextEditingController();
  int? detailIndex;
  int? saleOrderIndex;
  int? saleDetailIndex;
  int? selectedJwCompIndex;
  int? selectedJwSaleIndex;
  final dataKey = GlobalKey();
  final dataSaleKey = GlobalKey();
  String dropdownValue = 'One';
  bool isAscending = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fireService(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFF0000),
          automaticallyImplyLeading: true,
          title: Text(
            'Other Detail',
            style: TextStyle(fontSize: 18),
          ),
          bottom: TabBar(
            isScrollable: true,
            unselectedLabelStyle: TextStyle(fontSize: 18, color: Colors.white),
            labelStyle: TextStyle(fontSize: 18, color: Colors.white),
            labelColor: Colors.white,
            indicatorColor: AppColor.appRed,
            labelPadding: EdgeInsets.all(8),
            physics: BouncingScrollPhysics(),
            tabs: [
              Text('Stock'),
              Text('Purchase Rate Plan'),
              Text('Sale Rate Plan'),
              Text('Jw Plan Rate'),
            ],
            onTap: (position) {
              _fireService(position);
            },
          ),
        ),
        body: Container(
            child: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            _getWidget(WidgetType.CatalogCode),
            _getWidget(WidgetType.PurchasePlanRate),
            _getWidget(WidgetType.SalePlanRate),
            _getWidget(WidgetType.JWPlanRate),
          ],
        )),
      ),
    );
  }

  Widget _getWidget(WidgetType type) {
    switch (type) {
      case WidgetType.CatalogCode:
        return catalogStockList.isNotEmpty
            ? SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: _buildCells(catalogStockList.length),
                        ),
                        Flexible(
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _buildRows(catalogStockList.length),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ))
            : Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                      child: Text(
                    'No Data Found',
                    style: TextStyle(fontSize: 18),
                  )),
                ],
              );
      // break;
      case WidgetType.PurchasePlanRate:
        return purchasePlanList.isNotEmpty
            ? SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: _buildCellsPurPlan(purchasePlanList.length),
                        ),
                        Flexible(
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  _buildRowsPurPlan(purchasePlanList.length),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 42,
                    ),
                    detailIndex != null ? _getDetailWidget() : Text(''),
                    SizedBox(
                      height: 36,
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                      child: Text(
                    'No Data Found',
                    style: TextStyle(fontSize: 18),
                  )),
                ],
              );
      // break;

      case WidgetType.SalePlanRate:
        return saleRatePlanList.isNotEmpty
            ? SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:
                              _buildCellsSaleRatePlan(saleRatePlanList.length),
                        ),
                        Flexible(
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _buildRowsSaleRatePlan(
                                  saleRatePlanList.length),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 42,
                    ),
                    saleDetailIndex != null
                        ? _getSaleDetailWidget()
                        : Container(),
                    SizedBox(
                      height: 36,
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                      child: Text(
                    'No Data Found',
                    style: TextStyle(fontSize: 18),
                  )),
                ],
              );
      // break;

      case WidgetType.JWPlanRate:
        return jwProcessList.isNotEmpty
            ? SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    /// Process Name
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                      child: TypeAheadFormField<JWProcessModel>(
                        validator: (value) =>
                            value!.isEmpty ? 'Please select process' : null,
                        itemBuilder: (BuildContext context, itemData) {
                          return ListTile(
                            title: Text(itemData.name!),
                          );
                        },
                        onSuggestionSelected: (sg) {
                          accList.clear();
                          accList.addAll(sg.accList!);

                          prodOrderList.clear();
                          prodOrderList.addAll(sg.prodOrderList!);

                          setState(() {
                            if (sg.name == processController.text) return;
                            processController.text = sg.name!;
                            accController.clear();
                            contController.clear();
                            prodOrderDetailList.clear();
                          });
                        },
                        suggestionsCallback: (String pattern) {
                          return _getFilteredProcessList(pattern);
                        },
                        textFieldConfiguration: TextFieldConfiguration(
                            textAlign: TextAlign.start,
                            controller: processController,
                            autofocus: false,
                            onChanged: (string) {
                              //processController.clear();
                              accController.clear();
                              contController.clear();
                              saleOrderList.clear();
                              prodOrderDetailList.clear();
                              prodOrderList.clear();
                              saleOrderList.clear();
                              jobWorkList.clear();
                              setState(() {});
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.keyboard_arrow_down),
                                hintText: 'Process Name',
                                isDense: true)),
                      ),
                    ),

                    /// Acc Name
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                      child: TypeAheadFormField<JWProcessModel>(
                        validator: (value) =>
                            value!.isEmpty ? 'Please select acc name' : null,
                        itemBuilder: (BuildContext context, itemData) {
                          return ListTile(
                            title: Text(itemData.name!),
                          );
                        },
                        onSuggestionSelected: (sg) async {
                          await _getProdOrders(sg.procCode);
                          if (prodOrderDetailList.length < 1) return;
                          saleOrderList.clear();
                          saleOrderList.add(SaleOrderDetailModel(
                              isHeader: true,
                              orderNo: 'Order No',
                              rate: 'Rate',
                              qty: 'Qty',
                              partyItemName: 'Party Item Name',
                              orderDate: 'Order Date',
                              partyName: 'Party Name',
                              partyOrderNo: 'Party Order No'));
                          saleOrderList
                              .addAll(prodOrderDetailList[1].saleOrderList!);
                          if (saleOrderList.length == 1) {
                            saleOrderList.clear();
                          } else {
                            selectedJwCompIndex = 1;
                            prodOrderDetailList[1].isViewing = true;
                          }
                          setState(() {
                            accController.text = sg.name!;
                            contController.text = sg.contName!;
                          });

                          if (saleOrderList.isEmpty) return;
                          jobWorkList.clear();
                          jobWorkList.add(JobWorkModel(
                              isHeader: true,
                              docDate: 'Doc Date',
                              docNo: 'Doc No',
                              rate: 'Rate',
                              rateUom: 'Uom',
                              billNo: 'Bill No',
                              billDate: 'Bill Date',
                              finQty: 'Fin Qty',
                              finQtyUom: 'Uom',
                              stockQtyUom: 'Stock Qty Uom',
                              catalogItem: 'Catalog Item',
                              stockQty: 'Stock Qty'));
                          jobWorkList.addAll(saleOrderList[1].jobWorkList!);
                          if (jobWorkList.length == 1) {
                            jobWorkList.clear();
                            Commons.showToast('Not data found!');
                          } else {
                            selectedJwSaleIndex = 1;
                            setState(() {});
                          }
                        },
                        suggestionsCallback: (String pattern) {
                          return _getFilteredAccList(pattern);
                        },
                        textFieldConfiguration: TextFieldConfiguration(
                            textAlign: TextAlign.start,
                            controller: accController,
                            autofocus: false,
                            onChanged: (string) {
                              prodOrderDetailList.clear();
                              jobWorkList.clear();
                              saleOrderList.clear();
                              setState(() {});
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.keyboard_arrow_down),
                                hintText: 'Acc Name',
                                isDense: true)),
                      ),
                    ),

                    /// Cont Name
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                      child: TextFormField(
                          controller: contController,
                          readOnly: true,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Cont Name',
                              isDense: true)),
                    ),

                    /// Prod Orders
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(4.0),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children:
                                      _buildCellsJw(prodOrderDetailList.length),
                                ),
                                Flexible(
                                  child: SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: _buildRowsJw(
                                          prodOrderDetailList.length),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// Sale Orders Detail
                    Visibility(
                      visible: saleOrderList.isNotEmpty,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(4.0),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Sale Order Detail',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700)),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children:
                                        _buildCellsJwSale(saleOrderList.length),
                                  ),
                                  Flexible(
                                    child: SingleChildScrollView(
                                      physics: BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: _buildRowsJwSale(
                                            saleOrderList.length),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 42,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    /// Job Work Bill Detail
                    Visibility(
                      visible: jobWorkList.isNotEmpty,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(4.0),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Job Work Bill Detail',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700)),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children:
                                        _buildCellsJwSaleJW(jobWorkList.length),
                                  ),
                                  Flexible(
                                    child: SingleChildScrollView(
                                      physics: BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: _buildRowsJwSaleJw(
                                            jobWorkList.length),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 42,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                      child: Text(
                    'No Data Found',
                    style: TextStyle(fontSize: 18),
                  )),
                ],
              );
      // break;
      default:
        return Text('');
      //  break;
    }
  }

  _fireService(int position) {
    Map jsonBody = {
      'user_id': AppConfig.prefs.getString('user_id'),
      'catalog_code': widget.catalogCode
    };

    switch (position) {
      /// Catalog Code
      case 0:
        {
          if (catalogStockList.isNotEmpty) return;
          WebService.fromApi(AppConfig.catalogStockDetails, this, jsonBody)
              .callPostService(context);
        }
        break;

      /// Purchase Plan rate
      case 1:
        {
          if (purchasePlanList.isNotEmpty) return;
          WebService.fromApi(AppConfig.purchasePlanRate, this, jsonBody)
              .callPostService(context);
        }
        break;

      /// Sale Plan rate
      case 2:
        {
          if (saleRatePlanList.isNotEmpty) return;
          WebService.fromApi(AppConfig.salePlanRate, this, jsonBody)
              .callPostService(context);
        } //
        break;

      /// JW Plan rate
      case 3:
        {
          if (jwProcessList.isNotEmpty) return;
          WebService.fromApi(AppConfig.catalogProcessPlans, this, jsonBody)
              .callPostService(context);
        }
        break;
    }
  }

  getCatalogQty() {
    Map jsonBody = {
      'user_id': AppConfig.prefs.getString('user_id'),
      'catalog_code': widget.catalogCode
    };

    WebService.fromApi(AppConfig.catalogStockDetails, this, jsonBody)
        .callPostService(context);
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) {
    try {
      switch (requestCode) {
        case AppConfig.catalogStockDetails:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              var contentList = data['content'] as List;

              catalogStockList.clear();
              catalogStockList.add(CatalogStockModel(
                isHeader: true,
                id: 'Comp Code',
                stockQty: 'Stock Qty',
                godown: 'Godown',
                lotNo: 'Lot No',
                rollNo: 'Roll No',
              ));
              catalogStockList.addAll(contentList
                  .map((e) => CatalogStockModel.fromJSON(e))
                  .toList());

              catalogStockList.add(CatalogStockModel(
                id: 'Total Qty',
                stockQty: '${_getTotalQty()}',
                godown: '',
                lotNo: '',
                rollNo: '',
              ));

              if (catalogStockList.length == 2) catalogStockList.clear();

              setState(() {});
            }
          }
          break;
        case AppConfig.purchasePlanRate:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              var contentList = data['content'] as List;

              purchasePlanList.clear();
              purchasePlanList.add(PurchasePlanRateModel(
                  isHeader: true,
                  id: 'Comp Code',
                  basicRate: 'Basic Rate',
                  discRate: 'Disc Rate',
                  descPercent: 'Disc %',
                  netRate: 'Net Rate',
                  orderDate: 'Order Date',
                  orderNo: 'Order No',
                  partyName: 'Party Name',
                  qty: 'Quantity'));
              purchasePlanList.addAll(contentList
                  .map((e) => PurchasePlanRateModel.fromJSON(e))
                  .toList());

              if (purchasePlanList.length == 1) {
                purchasePlanList.clear();
              } else {
                if (purchasePlanList[1].isHeader) return;
                setState(() {
                  detailIndex = 1;
                });
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  Scrollable.ensureVisible(dataKey.currentContext!);
                });
              }
              setState(() {});
            }
          }
          break;

        case AppConfig.salePlanRate:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              var contentList = data['content'] as List;

              saleRatePlanList.clear();
              saleRatePlanList.add(SaleRatePlanModel(
                  isHeader: true,
                  stock: 'Stock Type',
                  id: 'Comp Code',
                  netRate: 'Net Rate',
                  orderDate: 'Order Date',
                  orderNo: 'Order No',
                  partyOrderNo: 'Party Order No',
                  partyName: 'Party Name',
                  uom: 'Uom',
                  qty: 'Quantity'));
              saleRatePlanList.addAll(contentList
                  .map((e) => SaleRatePlanModel.fromJSON(e))
                  .toList());
              saleRatePlanList.add(
                  SaleRatePlanModel(id: 'Total', qty: getTotalSaleRateQty()));

              if (saleRatePlanList.length == 2) {
                saleRatePlanList.clear();
              } else {
                if (saleRatePlanList[1].isHeader) return;
                if (saleRatePlanList.length - 1 == 1) return;
                if (saleRatePlanList[1].saleDetailList!.isEmpty)
                  Commons.showToast('No data found!');

                setState(() {
                  saleDetailIndex = 1;
                  saleRatePlanList[1].isViewing = true;
                });

                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  Scrollable.ensureVisible(dataSaleKey.currentContext!);
                });
              }
              setState(() {});
            }
          }
          break;

        case AppConfig.catalogProcessPlans:

          /// JW Process Plan
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              var contentList = data['content'] as List;

              jwProcessList.clear();
              jwProcessList.addAll(
                  contentList.map((e) => JWProcessModel.fromJSON(e)).toList());

              setState(() {});
            }
          }
          break;
      }
    } catch (err) {
      logIt('Error while OnResponse -> $err');
    }
  }

  String getTotalSaleRateQty() {
    ///
    double qty = 0.0;

    try {
      saleRatePlanList.forEach((element) {
        if (element.isHeader) return;
        if (element.qty!.isEmpty) return;
        qty += double.parse(element.qty!);
      });

      return qty.toStringAsFixed(2);
    } catch (err) {
      logIt('getTotalQty-> $err');
      return qty.toStringAsFixed(2);
    }
  }

  _getFilteredProcessList(String str) {
    return jwProcessList
        .where((i) => i.name!.toLowerCase().startsWith(str.toLowerCase()))
        .toList();
  }

  _getFilteredAccList(String str) {
    return accList
        .where((i) => i.name!.toLowerCase().startsWith(str.toLowerCase()))
        .toList();
  }

  /// Table Widgets => Stock
  /// Catalog Code
  /// Vertically
  List<Widget> _buildCells(int count) {
    return List.generate(
      count,
      (mainIndex) => Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Container(
            width: 110,
            height: 48,
            color: catalogStockList[mainIndex].isHeader
                ? AppColor.appRed
                : Colors.red[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Text(
                    catalogStockList[mainIndex].id!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: catalogStockList[mainIndex].isHeader
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  /// Horizontally  => Stock
  List<Widget> _buildRows(int count) {
    return List.generate(count, (index) => _buildHorizontalCells(count, index));
  }

  /// => Stock
  Container _buildHorizontalCells(int count, int index) {
    double width = 120;
    return Container(
      alignment: Alignment.topCenter,
      child: Row(children: [
        /// Godown
        GestureDetector(
          onTap: () {
            if (catalogStockList[index].isHeader) _sortStock('Godown');
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width,
              color: catalogStockList[index].isHeader
                  ? AppColor.appRed
                  : Colors.red[100],
              child: Center(
                child: Text(
                  catalogStockList[index].godown!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: catalogStockList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),
        ),

        /// LotNo
        GestureDetector(
          onTap: () {
            if (catalogStockList[index].isHeader) _sortStock('LotNo');
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width,
              color: catalogStockList[index].isHeader
                  ? AppColor.appRed
                  : Colors.red[100],
              child: Center(
                child: Text(
                  catalogStockList[index].lotNo!,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: 18,
                      color: catalogStockList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),
        ),

        /// RollNo
        GestureDetector(
          onTap: () {
            if (catalogStockList[index].isHeader) _sortStock('RollNo');
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width,
              color: catalogStockList[index].isHeader
                  ? AppColor.appRed
                  : Colors.red[100],
              child: Center(
                child: Text(
                  catalogStockList[index].rollNo!,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: 18,
                      color: catalogStockList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),
        ),

        /// Stock Qty
        GestureDetector(
          onTap: () {
            if (catalogStockList[index].isHeader) _sortStock('StockQty');
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width,
              color: catalogStockList[index].isHeader
                  ? AppColor.appRed
                  : Colors.red[100],
              child: Center(
                child: Text(
                  catalogStockList[index].stockQty!,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: 18,
                      color: catalogStockList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  /// => Stock
  String _getTotalQty() {
    double qty = 0.0;

    try {
      catalogStockList.forEach((element) {
        if (element.isHeader) return;
        qty += double.parse(element.stockQty!);
      });

      return qty.toStringAsFixed(2);
    } catch (err) {
      logIt('getTotalQty-> $err');
      return qty.toStringAsFixed(2);
    }
  }

  /// Purchase Rate Plan
  /// Vertically
  List<Widget> _buildCellsPurPlan(int count) {
    return List.generate(
      count,
      (mainIndex) {
        return Padding(
          padding: const EdgeInsets.only(top: 2),
          child: InkWell(
            onTap: () {
              if (purchasePlanList[mainIndex].isHeader) return;
              if (purchasePlanList[mainIndex].detailList!.isEmpty) {
                Commons.showToast('No data found');
                return;
              }

              purchasePlanList.forEach((element) {
                if (element.isViewing) element.isViewing = false;
              });

              setState(() {
                detailIndex = mainIndex;
                purchasePlanList[mainIndex].isViewing = true;
              });

              Fluttertoast.cancel();
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                Scrollable.ensureVisible(dataKey.currentContext!);
              });
            },
            child: Container(
                width: 110,
                height: 48,
                color: purchasePlanList[mainIndex].isHeader
                    ? AppColor.appRed
                    : (purchasePlanList[mainIndex].isViewing
                        ? AppColor.appRed[500]
                        : Colors.red[100]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Text(
                        purchasePlanList[mainIndex].id!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            color: purchasePlanList[mainIndex].isHeader
                                ? Colors.white
                                : (purchasePlanList[mainIndex].isViewing
                                    ? Colors.white
                                    : Colors.black)),
                      ),
                    ),
                  ],
                )),
          ),
        );
      },
    );
  }

  /// Horizontally
  List<Widget> _buildRowsPurPlan(int count) {
    return List.generate(
        count, (index) => _buildHorizontalCellsPurPlan(count, index));
  }

  /// Total Cells in a row
  Container _buildHorizontalCellsPurPlan(int count, int index) {
    double width = 120;
    return Container(
      alignment: Alignment.topCenter,
      child: IntrinsicWidth(
        child: Row(children: [
          /// Order Date
          GestureDetector(
            onTap: () {
              if (purchasePlanList[index].isHeader) {
                _sortPurchaseRatePlan('OrderDate');
              } else {
                _purchaseRatePlanAttClick(index);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: purchasePlanList[index].isHeader
                    ? AppColor.appRed
                    : (purchasePlanList[index].isViewing
                        ? AppColor.appRed[500]
                        : Colors.red[100]),
                child: Center(
                    child: Text(
                  purchasePlanList[index].orderDate!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: purchasePlanList[index].isHeader
                          ? Colors.white
                          : (purchasePlanList[index].isViewing
                              ? Colors.white
                              : Colors.black)),
                )),
              ),
            ),
          ),

          /// Order No
          GestureDetector(
            onTap: () {
              if (purchasePlanList[index].isHeader) {
                _sortPurchaseRatePlan('OrderNo');
              } else {
                _purchaseRatePlanAttClick(index);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: purchasePlanList[index].isHeader
                    ? AppColor.appRed
                    : (purchasePlanList[index].isViewing
                        ? AppColor.appRed[500]
                        : Colors.red[100]),
                child: Center(
                  child: Text(
                    purchasePlanList[index].orderNo!,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 18,
                        color: purchasePlanList[index].isHeader
                            ? Colors.white
                            : (purchasePlanList[index].isViewing
                                ? Colors.white
                                : Colors.black)),
                  ),
                ),
              ),
            ),
          ),

          /// Party Name
          GestureDetector(
            onTap: () {
              if (purchasePlanList[index].isHeader) {
                _sortPurchaseRatePlan('PartyName');
              } else {
                _purchaseRatePlanAttClick(index);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width + width + width,
                color: purchasePlanList[index].isHeader
                    ? AppColor.appRed
                    : (purchasePlanList[index].isViewing
                        ? AppColor.appRed[500]
                        : Colors.red[100]),
                child: Center(
                  child: Text(
                    purchasePlanList[index].partyName!,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 18,
                        color: purchasePlanList[index].isHeader
                            ? Colors.white
                            : (purchasePlanList[index].isViewing
                                ? Colors.white
                                : Colors.black)),
                  ),
                ),
              ),
            ),
          ),

          /// Qty
          GestureDetector(
            onTap: () {
              if (purchasePlanList[index].isHeader) {
                _sortPurchaseRatePlan('Quantity');
              } else {
                _purchaseRatePlanAttClick(index);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: purchasePlanList[index].isHeader
                    ? AppColor.appRed
                    : (purchasePlanList[index].isViewing
                        ? AppColor.appRed[500]
                        : Colors.red[100]),
                child: Center(
                  child: Text(
                    purchasePlanList[index].qty!,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 18,
                        color: purchasePlanList[index].isHeader
                            ? Colors.white
                            : (purchasePlanList[index].isViewing
                                ? Colors.white
                                : Colors.black)),
                  ),
                ),
              ),
            ),
          ),

          /// Basic Rate
          GestureDetector(
            onTap: () {
              if (purchasePlanList[index].isHeader) {
                _sortPurchaseRatePlan('BasicRate');
              } else {
                _purchaseRatePlanAttClick(index);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: purchasePlanList[index].isHeader
                    ? AppColor.appRed
                    : (purchasePlanList[index].isViewing
                        ? AppColor.appRed[500]
                        : Colors.red[100]),
                child: Center(
                  child: Text(
                    purchasePlanList[index].basicRate!,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 18,
                        color: purchasePlanList[index].isHeader
                            ? Colors.white
                            : (purchasePlanList[index].isViewing
                                ? Colors.white
                                : Colors.black)),
                  ),
                ),
              ),
            ),
          ),

          /// Desc %
          GestureDetector(
            onTap: () {
              if (purchasePlanList[index].isHeader) {
                _sortPurchaseRatePlan('Discount');
              } else {
                _purchaseRatePlanAttClick(index);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: purchasePlanList[index].isHeader
                    ? AppColor.appRed
                    : (purchasePlanList[index].isViewing
                        ? AppColor.appRed[500]
                        : Colors.red[100]),
                child: Center(
                  child: Text(
                    purchasePlanList[index].descPercent!,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 18,
                        color: purchasePlanList[index].isHeader
                            ? Colors.white
                            : (purchasePlanList[index].isViewing
                                ? Colors.white
                                : Colors.black)),
                  ),
                ),
              ),
            ),
          ),

          /// Desc rate
          GestureDetector(
            onTap: () {
              if (purchasePlanList[index].isHeader) {
                _sortPurchaseRatePlan('DiscountRate');
              } else {
                _purchaseRatePlanAttClick(index);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: purchasePlanList[index].isHeader
                    ? AppColor.appRed
                    : (purchasePlanList[index].isViewing
                        ? AppColor.appRed[500]
                        : Colors.red[100]),
                child: Center(
                  child: Text(
                    purchasePlanList[index].discRate!,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 18,
                        color: purchasePlanList[index].isHeader
                            ? Colors.white
                            : (purchasePlanList[index].isViewing
                                ? Colors.white
                                : Colors.black)),
                  ),
                ),
              ),
            ),
          ),

          /// Net rate
          GestureDetector(
            onTap: () {
              if (purchasePlanList[index].isHeader) {
                _sortPurchaseRatePlan('NetRate');
              } else {
                _purchaseRatePlanAttClick(index);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: purchasePlanList[index].isHeader
                    ? AppColor.appRed
                    : (purchasePlanList[index].isViewing
                        ? AppColor.appRed[500]
                        : Colors.red[100]),
                child: Center(
                  child: Text(
                    purchasePlanList[index].netRate!,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 18,
                        color: purchasePlanList[index].isHeader
                            ? Colors.white
                            : (purchasePlanList[index].isViewing
                                ? Colors.white
                                : Colors.black)),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  /// Purchase Rate Plan Details
  Widget _getDetailWidget() {
    return Visibility(
      visible: detailIndex != null,
      child: Row(
        key: dataKey,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: _buildCellsPurPlanDetails(
                purchasePlanList[detailIndex!].detailList!.length),
          ),
          Flexible(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildRowsPurPlanDetails(
                    purchasePlanList[detailIndex!].detailList!.length),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Vertically
  List<Widget> _buildCellsPurPlanDetails(int count) {
    logIt('_buildCellsPurPlanDetails-> $count');

    return List.generate(
      count,
      (mainIndex) => Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Container(
            width: 110,
            height: 48,
            color: purchasePlanList[mainIndex].isHeader
                ? AppColor.appRed
                : Colors.red[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Text(
                    purchasePlanList[detailIndex!]
                        .detailList![mainIndex]
                        .orderNo!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: purchasePlanList[mainIndex].isHeader
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  /// Horizontally
  List<Widget> _buildRowsPurPlanDetails(int count) {
    logIt('_buildRowsPurPlanDetails-> $count');
    return List.generate(
        count, (index) => _buildHorizontalCellsPurPlanDetails(count, index));
  }

  /// Total Cells in a row
  Container _buildHorizontalCellsPurPlanDetails(int count, int index) {
    logIt('_buildHorizontalCellsPurPlanDetails $count $index');
    double width = 120;
    return Container(
      alignment: Alignment.topCenter,
      child: IntrinsicWidth(
        child: Row(children: [
          /// Doc No
          GestureDetector(
            onTap: () {
              if (purchasePlanList[detailIndex!].detailList![index].isHeader)
                _sortPurchaseRateDetailPlan('DocNo');
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color:
                    purchasePlanList[detailIndex!].detailList![index].isHeader
                        ? AppColor.appRed
                        : Colors.red[100],
                child: Center(
                  child: Text(
                    purchasePlanList[detailIndex!].detailList![index].docNo!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: purchasePlanList[detailIndex!]
                                .detailList![index]
                                .isHeader
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ),
          ),

          /// Doc Date
          GestureDetector(
            onTap: () {
              if (purchasePlanList[detailIndex!].detailList![index].isHeader)
                _sortPurchaseRateDetailPlan('DocDate');
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color:
                    purchasePlanList[detailIndex!].detailList![index].isHeader
                        ? AppColor.appRed
                        : Colors.red[100],
                child: Center(
                  child: Text(
                    purchasePlanList[detailIndex!].detailList![index].docDate!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: purchasePlanList[detailIndex!]
                                .detailList![index]
                                .isHeader
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ),
          ),

          /// Bill No
          GestureDetector(
            onTap: () {
              if (purchasePlanList[detailIndex!].detailList![index].isHeader)
                _sortPurchaseRateDetailPlan('BillNo');
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color:
                    purchasePlanList[detailIndex!].detailList![index].isHeader
                        ? AppColor.appRed
                        : Colors.red[100],
                child: Center(
                  child: Text(
                    purchasePlanList[detailIndex!].detailList![index].billNo!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: purchasePlanList[detailIndex!]
                                .detailList![index]
                                .isHeader
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ),
          ),

          /// Bill Date
          GestureDetector(
            onTap: () {
              if (purchasePlanList[detailIndex!].detailList![index].isHeader)
                _sortPurchaseRateDetailPlan('BillDate');
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color:
                    purchasePlanList[detailIndex!].detailList![index].isHeader
                        ? AppColor.appRed
                        : Colors.red[100],
                child: Center(
                  child: Text(
                    purchasePlanList[detailIndex!].detailList![index].billDate!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: purchasePlanList[detailIndex!]
                                .detailList![index]
                                .isHeader
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ),
          ),

          /// Rate
          GestureDetector(
            onTap: () {
              if (purchasePlanList[detailIndex!].detailList![index].isHeader)
                _sortPurchaseRateDetailPlan('Rate');
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color:
                    purchasePlanList[detailIndex!].detailList![index].isHeader
                        ? AppColor.appRed
                        : Colors.red[100],
                child: Center(
                  child: Text(
                    purchasePlanList[detailIndex!].detailList![index].rate!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: purchasePlanList[detailIndex!]
                                .detailList![index]
                                .isHeader
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ),
          ),

          /// Stock Qty
          GestureDetector(
            onTap: () {
              if (purchasePlanList[detailIndex!].detailList![index].isHeader)
                _sortPurchaseRateDetailPlan('StockQty');
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color:
                    purchasePlanList[detailIndex!].detailList![index].isHeader
                        ? AppColor.appRed
                        : Colors.red[100],
                child: Center(
                  child: Text(
                    purchasePlanList[detailIndex!].detailList![index].stockQty!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: purchasePlanList[detailIndex!]
                                .detailList![index]
                                .isHeader
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ),
          ),

          /// Fin Qty
          GestureDetector(
            onTap: () {
              if (purchasePlanList[detailIndex!].detailList![index].isHeader)
                _sortPurchaseRateDetailPlan('FinQty');
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color:
                    purchasePlanList[detailIndex!].detailList![index].isHeader
                        ? AppColor.appRed
                        : Colors.red[100],
                child: Center(
                  child: Text(
                    purchasePlanList[detailIndex!].detailList![index].finQty!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: purchasePlanList[detailIndex!]
                                .detailList![index]
                                .isHeader
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  /// Sale rate plan
  /// Vertically
  List<Widget> _buildCellsSaleRatePlan(int count) {
    return List.generate(
      count,
      (mainIndex) => Padding(
        padding: const EdgeInsets.only(top: 2),
        child: InkWell(
          onTap: () {
            if (saleRatePlanList[mainIndex].isHeader) return;
            if (saleRatePlanList.length - 1 == mainIndex) return;

            saleRatePlanList.forEach((element) {
              if (element.isViewing) element.isViewing = false;
            });

            setState(() {
              saleDetailIndex = mainIndex;
              saleRatePlanList[mainIndex].isViewing = true;
            });

            if (saleRatePlanList[mainIndex].saleDetailList!.isEmpty) {
              Commons.showToast('No data found!');
              return;
            }

            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Scrollable.ensureVisible(dataSaleKey.currentContext!);
            });
          },
          child: Container(
              width: 110,
              height: 48,
              color: saleRatePlanList[mainIndex].isHeader
                  ? AppColor.appRed
                  : (saleRatePlanList[mainIndex].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Text(
                      saleRatePlanList[mainIndex].id!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          color: saleRatePlanList[mainIndex].isHeader
                              ? Colors.white
                              : (saleRatePlanList[mainIndex].isViewing
                                  ? Colors.white
                                  : Colors.black)),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  /// Horizontally
  List<Widget> _buildRowsSaleRatePlan(int count) {
    return List.generate(
        count, (index) => _buildHorizontalCellsSaleRatePlan(count, index));
  }

  /// Total Cells in a row
  Container _buildHorizontalCellsSaleRatePlan(int count, int index) {
    double width = 120;
    return Container(
      alignment: Alignment.topCenter,
      child: IntrinsicWidth(
        child: Row(children: [
          /// Order Date
          GestureDetector(
            onTap: () {
              if (saleRatePlanList[index].isHeader) {
                _sortSaleRateTable('OrderDate');
              } else {
                salePlanRateAttClick(index);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width + 24,
                color: saleRatePlanList[index].isHeader
                    ? AppColor.appRed
                    : (saleRatePlanList[index].isViewing
                        ? AppColor.appRed[500]
                        : Colors.red[100]),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        saleRatePlanList[index].orderDate!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            color: saleRatePlanList[index].isHeader
                                ? Colors.white
                                : (saleRatePlanList[index].isViewing
                                    ? Colors.white
                                    : Colors.black)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// Order No
          GestureDetector(
            onTap: () {
              if (saleRatePlanList[index].isHeader) {
                _sortSaleRateTable('OrderNo');
              } else {
                salePlanRateAttClick(index);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: saleRatePlanList[index].isHeader
                    ? AppColor.appRed
                    : (saleRatePlanList[index].isViewing
                        ? AppColor.appRed[500]
                        : Colors.red[100]),
                child: Center(
                  child: Text(
                    saleRatePlanList[index].orderNo!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: saleRatePlanList[index].isHeader
                            ? Colors.white
                            : (saleRatePlanList[index].isViewing
                                ? Colors.white
                                : Colors.black)),
                  ),
                ),
              ),
            ),
          ),

          /// Party Order No
          GestureDetector(
            onTap: () {
              if (saleRatePlanList[index].isHeader) {
                _sortSaleRateTable('PartyOrderNo');
              } else {
                salePlanRateAttClick(index);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: saleRatePlanList[index].isHeader
                    ? AppColor.appRed
                    : (saleRatePlanList[index].isViewing
                        ? AppColor.appRed[500]
                        : Colors.red[100]),
                child: Center(
                  child: Text(
                    saleRatePlanList[index].partyOrderNo!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: saleRatePlanList[index].isHeader
                            ? Colors.white
                            : (saleRatePlanList[index].isViewing
                                ? Colors.white
                                : Colors.black)),
                  ),
                ),
              ),
            ),
          ),

          /// Party name
          GestureDetector(
            onTap: () {
              if (saleRatePlanList[index].isHeader) {
                _sortSaleRateTable('PartyName');
              } else {
                salePlanRateAttClick(index);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width * 3,
                color: saleRatePlanList[index].isHeader
                    ? AppColor.appRed
                    : (saleRatePlanList[index].isViewing
                        ? AppColor.appRed[500]
                        : Colors.red[100]),
                child: Center(
                  child: Text(
                    saleRatePlanList[index].partyName!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: saleRatePlanList[index].isHeader
                            ? Colors.white
                            : (saleRatePlanList[index].isViewing
                                ? Colors.white
                                : Colors.black)),
                  ),
                ),
              ),
            ),
          ),

          /// Stock Type
          GestureDetector(
            onTap: () {
              if (saleRatePlanList[index].isHeader) {
                _sortSaleRateTable('StockType');
              } else {
                salePlanRateAttClick(index);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: saleRatePlanList[index].isHeader
                    ? AppColor.appRed
                    : (saleRatePlanList[index].isViewing
                        ? AppColor.appRed[500]
                        : Colors.red[100]),
                child: Center(
                  child: Text(
                    saleRatePlanList[index].stock,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: saleRatePlanList[index].isHeader
                            ? Colors.white
                            : (saleRatePlanList[index].isViewing
                                ? Colors.white
                                : Colors.black)),
                  ),
                ),
              ),
            ),
          ),

          /// Quantity
          GestureDetector(
            onTap: () {
              if (saleRatePlanList[index].isHeader) {
                _sortSaleRateTable('Quantity');
              } else {
                salePlanRateAttClick(index);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: saleRatePlanList[index].isHeader
                    ? AppColor.appRed
                    : (saleRatePlanList[index].isViewing
                        ? AppColor.appRed[500]
                        : Colors.red[100]),
                child: Center(
                  child: Text(
                    saleRatePlanList[index].qty!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: saleRatePlanList[index].isHeader
                            ? Colors.white
                            : (saleRatePlanList[index].isViewing
                                ? Colors.white
                                : Colors.black)),
                  ),
                ),
              ),
            ),
          ),

          /// UOM
          GestureDetector(
            onTap: () {
              if (saleRatePlanList[index].isHeader) {
                _sortSaleRateTable('UOM');
              } else {
                salePlanRateAttClick(index);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: saleRatePlanList[index].isHeader
                    ? AppColor.appRed
                    : (saleRatePlanList[index].isViewing
                        ? AppColor.appRed[500]
                        : Colors.red[100]),
                child: Center(
                  child: Text(
                    saleRatePlanList[index].uom!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: saleRatePlanList[index].isHeader
                            ? Colors.white
                            : (saleRatePlanList[index].isViewing
                                ? Colors.white
                                : Colors.black)),
                  ),
                ),
              ),
            ),
          ),

          /// Net Rate
          GestureDetector(
            onTap: () {
              if (saleRatePlanList[index].isHeader) {
                _sortSaleRateTable('NetRate');
              } else {
                salePlanRateAttClick(index);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: saleRatePlanList[index].isHeader
                    ? AppColor.appRed
                    : (saleRatePlanList[index].isViewing
                        ? AppColor.appRed[500]
                        : Colors.red[100]),
                child: Center(
                  child: Text(
                    saleRatePlanList[index].netRate!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: saleRatePlanList[index].isHeader
                            ? Colors.white
                            : (saleRatePlanList[index].isViewing
                                ? Colors.white
                                : Colors.black)),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  /// Sale rate plan Detail
  Widget _getSaleDetailWidget() {
    return Visibility(
      visible: saleDetailIndex != null,
      child: Row(
        key: dataSaleKey,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: _buildCellsSaleRatePlanDetail(
                saleRatePlanList[saleDetailIndex!].saleDetailList!.length),
          ),
          Flexible(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildRowsSaleRatePlanDetail(
                    saleRatePlanList[saleDetailIndex!].saleDetailList!.length),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Vertically
  List<Widget> _buildCellsSaleRatePlanDetail(int count) {
    return List.generate(
      count,
      (index) => Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Container(
            width: 110,
            height: 48,
            color: saleRatePlanList[saleDetailIndex!]
                    .saleDetailList![index]
                    .isHeader
                ? AppColor.appRed
                : Colors.red[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Text(
                    saleRatePlanList[saleDetailIndex!]
                        .saleDetailList![index]
                        .orderNo!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: saleRatePlanList[saleDetailIndex!]
                                .saleDetailList![index]
                                .isHeader
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  /// Horizontally
  List<Widget> _buildRowsSaleRatePlanDetail(int count) {
    return List.generate(count,
        (index) => _buildHorizontalCellsSaleRatePlanDetail(count, index));
  }

  /// Total Cells in a row
  Container _buildHorizontalCellsSaleRatePlanDetail(int count, int index) {
    double width = 120;
    return Container(
      alignment: Alignment.topCenter,
      child: IntrinsicWidth(
        child: Row(children: [
          /// Bill No
          GestureDetector(
            onTap: () {
              if (saleRatePlanList[saleDetailIndex!]
                  .saleDetailList![index]
                  .isHeader) {
                _sortSaleRateDetailTable('BillNo');
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: saleRatePlanList[saleDetailIndex!]
                        .saleDetailList![index]
                        .isHeader
                    ? AppColor.appRed
                    : Colors.red[100],
                child: Center(
                  child: Text(
                    saleRatePlanList[saleDetailIndex!]
                        .saleDetailList![index]
                        .billNo!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: saleRatePlanList[saleDetailIndex!]
                                .saleDetailList![index]
                                .isHeader
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ),
          ),

          /// Date
          GestureDetector(
            onTap: () {
              if (saleRatePlanList[saleDetailIndex!]
                  .saleDetailList![index]
                  .isHeader) {
                _sortSaleRateDetailTable('Date');
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: saleRatePlanList[saleDetailIndex!]
                        .saleDetailList![index]
                        .isHeader
                    ? AppColor.appRed
                    : Colors.red[100],
                child: Center(
                  child: Text(
                    saleRatePlanList[saleDetailIndex!]
                        .saleDetailList![index]
                        .date!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: saleRatePlanList[saleDetailIndex!]
                                .saleDetailList![index]
                                .isHeader
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ),
          ),

          /// Party Item Name
          GestureDetector(
            onTap: () {
              if (saleRatePlanList[saleDetailIndex!]
                  .saleDetailList![index]
                  .isHeader) {
                _sortSaleRateDetailTable('PartyItemName');
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width * 3,
                color: saleRatePlanList[saleDetailIndex!]
                        .saleDetailList![index]
                        .isHeader
                    ? AppColor.appRed
                    : Colors.red[100],
                child: Center(
                  child: Text(
                    saleRatePlanList[saleDetailIndex!]
                        .saleDetailList![index]
                        .partyItemName!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: saleRatePlanList[saleDetailIndex!]
                                .saleDetailList![index]
                                .isHeader
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ),
          ),

          /// Party PO
          GestureDetector(
            onTap: () {
              if (saleRatePlanList[saleDetailIndex!]
                  .saleDetailList![index]
                  .isHeader) {
                _sortSaleRateDetailTable('PartyPO');
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: saleRatePlanList[saleDetailIndex!]
                        .saleDetailList![index]
                        .isHeader
                    ? AppColor.appRed
                    : Colors.red[100],
                child: Center(
                  child: Text(
                    saleRatePlanList[saleDetailIndex!]
                        .saleDetailList![index]
                        .partyPO!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: saleRatePlanList[saleDetailIndex!]
                                .saleDetailList![index]
                                .isHeader
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ),
          ),

          /// Bags
          GestureDetector(
            onTap: () {
              if (saleRatePlanList[saleDetailIndex!]
                  .saleDetailList![index]
                  .isHeader) {
                _sortSaleRateDetailTable('Bags');
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: saleRatePlanList[saleDetailIndex!]
                        .saleDetailList![index]
                        .isHeader
                    ? AppColor.appRed
                    : Colors.red[100],
                child: Center(
                  child: Text(
                    saleRatePlanList[saleDetailIndex!]
                        .saleDetailList![index]
                        .bags!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: saleRatePlanList[saleDetailIndex!]
                                .saleDetailList![index]
                                .isHeader
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ),
          ),

          ///  Qty
          GestureDetector(
            onTap: () {
              if (saleRatePlanList[saleDetailIndex!]
                  .saleDetailList![index]
                  .isHeader) {
                _sortSaleRateDetailTable('Qty');
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: saleRatePlanList[saleDetailIndex!]
                        .saleDetailList![index]
                        .isHeader
                    ? AppColor.appRed
                    : Colors.red[100],
                child: Center(
                  child: Text(
                    saleRatePlanList[saleDetailIndex!]
                        .saleDetailList![index]
                        .qty!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: saleRatePlanList[saleDetailIndex!]
                                .saleDetailList![index]
                                .isHeader
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ),
          ),

          ///  Qty Uom
          GestureDetector(
            onTap: () {
              if (saleRatePlanList[saleDetailIndex!]
                  .saleDetailList![index]
                  .isHeader) {
                _sortSaleRateDetailTable('Uom');
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: saleRatePlanList[saleDetailIndex!]
                        .saleDetailList![index]
                        .isHeader
                    ? AppColor.appRed
                    : Colors.red[100],
                child: Center(
                  child: Text(
                    saleRatePlanList[saleDetailIndex!]
                        .saleDetailList![index]
                        .qtyUom!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: saleRatePlanList[saleDetailIndex!]
                                .saleDetailList![index]
                                .isHeader
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ),
          ),

          /// Rate
          GestureDetector(
            onTap: () {
              if (saleRatePlanList[saleDetailIndex!]
                  .saleDetailList![index]
                  .isHeader) {
                _sortSaleRateDetailTable('Rate');
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: saleRatePlanList[saleDetailIndex!]
                        .saleDetailList![index]
                        .isHeader
                    ? AppColor.appRed
                    : Colors.red[100],
                child: Center(
                  child: Text(
                    saleRatePlanList[saleDetailIndex!]
                        .saleDetailList![index]
                        .rate!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: saleRatePlanList[saleDetailIndex!]
                                .saleDetailList![index]
                                .isHeader
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ),
          ),

          /// Rate Uom
          GestureDetector(
            onTap: () {
              if (saleRatePlanList[saleDetailIndex!]
                  .saleDetailList![index]
                  .isHeader) {
                _sortSaleRateDetailTable('RateUom');
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: saleRatePlanList[saleDetailIndex!]
                        .saleDetailList![index]
                        .isHeader
                    ? AppColor.appRed
                    : Colors.red[100],
                child: Center(
                  child: Text(
                    saleRatePlanList[saleDetailIndex!]
                        .saleDetailList![index]
                        .rateUom!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: saleRatePlanList[saleDetailIndex!]
                                .saleDetailList![index]
                                .isHeader
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ),
          ),

          /// Item Amount
          GestureDetector(
            onTap: () {
              if (saleRatePlanList[saleDetailIndex!]
                  .saleDetailList![index]
                  .isHeader) {
                _sortSaleRateDetailTable('ItemAmount');
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: saleRatePlanList[saleDetailIndex!]
                        .saleDetailList![index]
                        .isHeader
                    ? AppColor.appRed
                    : Colors.red[100],
                child: Center(
                  child: Text(
                    saleRatePlanList[saleDetailIndex!]
                        .saleDetailList![index]
                        .amount!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: saleRatePlanList[saleDetailIndex!]
                                .saleDetailList![index]
                                .isHeader
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  /// JW => Plan rate Tables
  /// Vertically
  List<Widget> _buildCellsJw(int count) {
    return List.generate(
      count,
      (index) => Padding(
        padding: const EdgeInsets.only(top: 2),
        child: InkWell(
          onTap: () {
            _jwSaleRateAttClick(index);
          },
          child: Container(
              width: 110,
              height: 48,
              color: prodOrderDetailList[index].isHeader
                  ? AppColor.appRed
                  : (prodOrderDetailList[index].isViewing
                      ? Colors.red[300]
                      : Colors.red[100]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Text(
                      prodOrderDetailList[index].id!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          color: prodOrderDetailList[index].isHeader
                              ? Colors.white
                              : (prodOrderDetailList[index].isViewing
                                  ? Colors.white
                                  : Colors.black)),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  /// Horizontally
  List<Widget> _buildRowsJw(int count) {
    return List.generate(
        count, (index) => _buildHorizontalCellsJw(count, index));
  }

  /// Total Cells in a row
  Container _buildHorizontalCellsJw(int count, int index) {
    double width = 120;
    return Container(
      alignment: Alignment.topCenter,
      child: IntrinsicWidth(
        child: Row(children: [
          /// Prod Order No
          GestureDetector(
            onTap: () {
              if (prodOrderDetailList[index].isHeader) {
                _sortJwSaleRateTable('ProdOrderNo');
              } else {
                _jwSaleRateAttClick(index);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: prodOrderDetailList[index].isHeader
                    ? AppColor.appRed
                    : (prodOrderDetailList[index].isViewing
                        ? Colors.red[300]
                        : Colors.red[100]),
                child: Center(
                  child: Text(
                    prodOrderDetailList[index].prodOrderNo!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: prodOrderDetailList[index].isHeader
                            ? Colors.white
                            : (prodOrderDetailList[index].isViewing
                                ? Colors.white
                                : Colors.black)),
                  ),
                ),
              ),
            ),
          ),

          /// Prod Order Date
          GestureDetector(
            onTap: () {
              if (prodOrderDetailList[index].isHeader) {
                _sortJwSaleRateTable('ProdOrderDate');
              } else {
                _jwSaleRateAttClick(index);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: prodOrderDetailList[index].isHeader
                    ? AppColor.appRed
                    : (prodOrderDetailList[index].isViewing
                        ? Colors.red[300]
                        : Colors.red[100]),
                child: Center(
                  child: Text(
                    prodOrderDetailList[index].prodOrderDate!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: prodOrderDetailList[index].isHeader
                            ? Colors.white
                            : (prodOrderDetailList[index].isViewing
                                ? Colors.white
                                : Colors.black)),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  /// JW => Sale Order Details
  /// Vertically
  List<Widget> _buildCellsJwSale(int count) {
    return List.generate(
      count,
      (index) => Padding(
        padding: const EdgeInsets.only(top: 2),
        child: InkWell(
          onTap: () {
            _jwSaleRateDetailAttClick(index);
            /*if (saleOrderList[index].isHeader) return;
            jobWorkList.clear();
            jobWorkList.add(JobWorkModel(
                isHeader: true,
                docDate: 'Doc Date',
                docNo: 'Doc No',
                rate: 'Rate',
                rateUom: 'Uom',
                billNo: 'Bill No',
                billDate: 'Bill Date',
                finQty: 'Fin Qty',
                finQtyUom: 'Uom',
                stockQtyUom: 'Stock Qty',
                catalogItem: 'Catalog Item',
                stockQty: 'Stock Qty'));
            jobWorkList.addAll(saleOrderList[index].jobWorkList);
            if(jobWorkList.length == 1) {
              jobWorkList.clear();
              Commons.showToast('Not data found!');
            }
            setState(() {});*/
          },
          child: Container(
              width: 110,
              height: 48,
              color: saleOrderList[index].isHeader
                  ? AppColor.appRed
                  : (selectedJwSaleIndex == index
                      ? Colors.red[300]
                      : Colors.red[100]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Text(
                      saleOrderList[index].orderNo!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          color: saleOrderList[index].isHeader
                              ? Colors.white
                              : (selectedJwSaleIndex == index
                                  ? Colors.white
                                  : Colors.black)),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  /// Horizontally
  List<Widget> _buildRowsJwSale(int count) {
    return List.generate(
        count, (index) => _buildHorizontalCellsJwSale(count, index));
  }

  /// Total Cells in a row
  Container _buildHorizontalCellsJwSale(int count, int index) {
    double width = 120;
    return Container(
      alignment: Alignment.topCenter,
      child: IntrinsicWidth(
        child: Row(children: [
          /// Order Date
          GestureDetector(
            onTap: () {
              if (saleOrderList[index].isHeader) {
                _sortJwSaleRateDetailTable('OrderDate');
              } else {
                _jwSaleRateDetailAttClick(index);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: saleOrderList[index].isHeader
                    ? AppColor.appRed
                    : (selectedJwSaleIndex == index
                        ? Colors.red[300]
                        : Colors.red[100]),
                child: Center(
                  child: Text(
                    saleOrderList[index].orderDate!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: saleOrderList[index].isHeader
                            ? Colors.white
                            : (selectedJwSaleIndex == index
                                ? Colors.white
                                : Colors.black)),
                  ),
                ),
              ),
            ),
          ),

          /// Party Name
          GestureDetector(
            onTap: () {
              if (saleOrderList[index].isHeader) {
                _sortJwSaleRateDetailTable('PartyName');
              } else {
                _jwSaleRateDetailAttClick(index);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width * 3,
                color: saleOrderList[index].isHeader
                    ? AppColor.appRed
                    : (selectedJwSaleIndex == index
                        ? Colors.red[300]
                        : Colors.red[100]),
                child: Center(
                  child: Text(
                    saleOrderList[index].partyName!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: saleOrderList[index].isHeader
                            ? Colors.white
                            : (selectedJwSaleIndex == index
                                ? Colors.white
                                : Colors.black)),
                  ),
                ),
              ),
            ),
          ),

          /// Party Item Name
          GestureDetector(
            onTap: () {
              if (saleOrderList[index].isHeader) {
                _sortJwSaleRateDetailTable('PartyItemName');
              } else {
                _jwSaleRateDetailAttClick(index);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width * 3,
                color: saleOrderList[index].isHeader
                    ? AppColor.appRed
                    : (selectedJwSaleIndex == index
                        ? Colors.red[300]
                        : Colors.red[100]),
                child: Center(
                  child: Text(
                    saleOrderList[index].partyItemName!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: saleOrderList[index].isHeader
                            ? Colors.white
                            : (selectedJwSaleIndex == index
                                ? Colors.white
                                : Colors.black)),
                  ),
                ),
              ),
            ),
          ),

          /// Party Order No
          GestureDetector(
            onTap: () {
              if (saleOrderList[index].isHeader) {
                _sortJwSaleRateDetailTable('PartyOrderNo');
              } else {
                _jwSaleRateDetailAttClick(index);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: saleOrderList[index].isHeader
                    ? AppColor.appRed
                    : (selectedJwSaleIndex == index
                        ? Colors.red[300]
                        : Colors.red[100]),
                child: Center(
                  child: Text(
                    saleOrderList[index].partyOrderNo!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: saleOrderList[index].isHeader
                            ? Colors.white
                            : (selectedJwSaleIndex == index
                                ? Colors.white
                                : Colors.black)),
                  ),
                ),
              ),
            ),
          ),

          /// Qty
          GestureDetector(
            onTap: () {
              if (saleOrderList[index].isHeader) {
                _sortJwSaleRateDetailTable('Qty');
              } else {
                _jwSaleRateDetailAttClick(index);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: saleOrderList[index].isHeader
                    ? AppColor.appRed
                    : (selectedJwSaleIndex == index
                        ? Colors.red[300]
                        : Colors.red[100]),
                child: Center(
                  child: Text(
                    saleOrderList[index].qty!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: saleOrderList[index].isHeader
                            ? Colors.white
                            : (selectedJwSaleIndex == index
                                ? Colors.white
                                : Colors.black)),
                  ),
                ),
              ),
            ),
          ),

          /// Rate
          GestureDetector(
            onTap: () {
              if (saleOrderList[index].isHeader) {
                _sortJwSaleRateDetailTable('Rate');
              } else {
                _jwSaleRateDetailAttClick(index);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: saleOrderList[index].isHeader
                    ? AppColor.appRed
                    : (selectedJwSaleIndex == index
                        ? Colors.red[300]
                        : Colors.red[100]),
                child: Center(
                  child: Text(
                    saleOrderList[index].rate!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: saleOrderList[index].isHeader
                            ? Colors.white
                            : (selectedJwSaleIndex == index
                                ? Colors.white
                                : Colors.black)),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  /// => Job Work Details
  /// Vertically
  List<Widget> _buildCellsJwSaleJW(int count) {
    return List.generate(
      count,
      (index) => Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Container(
            width: 110,
            height: 48,
            color:
                jobWorkList[index].isHeader ? AppColor.appRed : Colors.red[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Text(
                    jobWorkList[index].docNo!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: jobWorkList[index].isHeader
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  /// Horizontally
  List<Widget> _buildRowsJwSaleJw(int count) {
    return List.generate(
        count, (index) => _buildHorizontalCellsJwSaleJw(count, index));
  }

  /// Total Cells in a row
  Container _buildHorizontalCellsJwSaleJw(int count, int index) {
    double width = 120;
    return Container(
      alignment: Alignment.topCenter,
      child: IntrinsicWidth(
        child: Row(children: [
          /// Doc Date
          GestureDetector(
            onTap: () {
              if (jobWorkList[index].isHeader)
                _sortJwBillDetailTable('DocDate');
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: jobWorkList[index].isHeader
                    ? AppColor.appRed
                    : Colors.red[100],
                child: Center(
                  child: Text(
                    jobWorkList[index].docDate!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: jobWorkList[index].isHeader
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ),
          ),

          /// Bill No
          GestureDetector(
            onTap: () {
              if (jobWorkList[index].isHeader) _sortJwBillDetailTable('BillNo');
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: jobWorkList[index].isHeader
                    ? AppColor.appRed
                    : Colors.red[100],
                child: Center(
                  child: Text(
                    jobWorkList[index].billNo!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: jobWorkList[index].isHeader
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ),
          ),

          /// Bill Date
          GestureDetector(
            onTap: () {
              if (jobWorkList[index].isHeader)
                _sortJwBillDetailTable('BillDate');
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: jobWorkList[index].isHeader
                    ? AppColor.appRed
                    : Colors.red[100],
                child: Center(
                  child: Text(
                    jobWorkList[index].billDate!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: jobWorkList[index].isHeader
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ),
          ),

          /// Catalog Item
          GestureDetector(
            onTap: () {
              if (jobWorkList[index].isHeader)
                _sortJwBillDetailTable('CatalogItem');
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: jobWorkList[index].isHeader
                    ? AppColor.appRed
                    : Colors.red[100],
                child: Center(
                  child: Text(
                    jobWorkList[index].catalogItem!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: jobWorkList[index].isHeader
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ),
          ),

          /// Stock Qty
          GestureDetector(
            onTap: () {
              if (jobWorkList[index].isHeader)
                _sortJwBillDetailTable('StockQty');
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: jobWorkList[index].isHeader
                    ? AppColor.appRed
                    : Colors.red[100],
                child: Center(
                  child: Text(
                    jobWorkList[index].stockQty!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: jobWorkList[index].isHeader
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ),
          ),

          /// Stock Qty Uom
          GestureDetector(
            onTap: () {
              if (jobWorkList[index].isHeader)
                _sortJwBillDetailTable('StockQtyUom');
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: jobWorkList[index].isHeader
                    ? AppColor.appRed
                    : Colors.red[100],
                child: Center(
                  child: Text(
                    jobWorkList[index].stockQtyUom!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: jobWorkList[index].isHeader
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ),
          ),

          /// Fin Qty
          GestureDetector(
            onTap: () {
              if (jobWorkList[index].isHeader) _sortJwBillDetailTable('FinQty');
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: jobWorkList[index].isHeader
                    ? AppColor.appRed
                    : Colors.red[100],
                child: Center(
                  child: Text(
                    jobWorkList[index].finQty!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: jobWorkList[index].isHeader
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ),
          ),

          /// Fin Qty Uom
          GestureDetector(
            onTap: () {
              if (jobWorkList[index].isHeader)
                _sortJwBillDetailTable('FinQtyUom');
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: jobWorkList[index].isHeader
                    ? AppColor.appRed
                    : Colors.red[100],
                child: Center(
                  child: Text(
                    jobWorkList[index].finQtyUom!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: jobWorkList[index].isHeader
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ),
          ),

          /// Rate
          GestureDetector(
            onTap: () {
              if (jobWorkList[index].isHeader) _sortJwBillDetailTable('Rate');
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: jobWorkList[index].isHeader
                    ? AppColor.appRed
                    : Colors.red[100],
                child: Center(
                  child: Text(
                    jobWorkList[index].rate!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: jobWorkList[index].isHeader
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ),
          ),

          /// Rate Uom
          GestureDetector(
            onTap: () {
              if (jobWorkList[index].isHeader)
                _sortJwBillDetailTable('RateUom');
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 48,
                width: width,
                color: jobWorkList[index].isHeader
                    ? AppColor.appRed
                    : Colors.red[100],
                child: Center(
                  child: Text(
                    jobWorkList[index].rateUom!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: jobWorkList[index].isHeader
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> _getProdOrders(String? procCode) async {
    prodOrderDetailList.clear();
    prodOrderDetailList.add(ProdOrderListModel(
        isHeader: true,
        id: 'Comp Code',
        prodOrderNo: 'Prod Order No',
        prodOrderDate: 'Prod Order Date'));
    prodOrderList.forEach((element) {
      if (element.procCode == procCode) {
        prodOrderDetailList.add(element);
      }
    });

    if (prodOrderDetailList.length == 1) prodOrderDetailList.clear();
  }

  /// Column Clicks
  _purchaseRatePlanAttClick(int index) {
    if (purchasePlanList[index].isHeader) return;

    purchasePlanList.forEach((element) {
      if (element.isViewing) element.isViewing = false;
    });

    setState(() {
      detailIndex = index;
      purchasePlanList[index].isViewing = true;
    });

    if (purchasePlanList[detailIndex!].detailList!.isEmpty) {
      Commons.showToast('No data found!');
      return;
    }

    Fluttertoast.cancel();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Scrollable.ensureVisible(dataKey.currentContext!);
    });
  }

  salePlanRateAttClick(int index) {
    if (saleRatePlanList[index].isHeader) return;

    if (saleRatePlanList.length - 1 == index) return;

    saleRatePlanList.forEach((element) {
      if (element.isViewing) element.isViewing = false;
    });

    setState(() {
      saleDetailIndex = index;
      saleRatePlanList[index].isViewing = true;
    });

    if (saleRatePlanList[index].saleDetailList!.isEmpty) {
      Commons.showToast('No data found!');
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Scrollable.ensureVisible(dataSaleKey.currentContext!);
    });
  }

  _jwSaleRateAttClick(int index) {
    if (prodOrderDetailList[index].isHeader) return;
    saleOrderList.clear();
    saleOrderList.add(SaleOrderDetailModel(
        isHeader: true,
        orderNo: 'Order No',
        rate: 'Rate',
        qty: 'Qty',
        partyItemName: 'Party Item Name',
        orderDate: 'Order Date',
        partyName: 'Party Name',
        partyOrderNo: 'Party Order No'));

    saleOrderList.addAll(prodOrderDetailList[index].saleOrderList!);
    if (saleOrderList.length == 1) saleOrderList.clear();

    prodOrderDetailList.forEach((element) {
      if (element.isViewing) element.isViewing = false;
    });

    setState(() {
      selectedJwCompIndex = index;
      prodOrderDetailList[index].isViewing = true;
    });

    if (saleOrderList.isEmpty) return;
    jobWorkList.clear();
    jobWorkList.add(JobWorkModel(
        isHeader: true,
        docDate: 'Doc Date',
        docNo: 'Doc No',
        rate: 'Rate',
        rateUom: 'Uom',
        billNo: 'Bill No',
        billDate: 'Bill Date',
        finQty: 'Fin Qty',
        finQtyUom: 'Uom',
        stockQtyUom: 'Stock Qty Uom',
        catalogItem: 'Catalog Item',
        stockQty: 'Stock Qty'));
    jobWorkList.addAll(saleOrderList[1].jobWorkList!);
    if (jobWorkList.length == 1) {
      jobWorkList.clear();
      Commons.showToast('Not data found!');
    } else {
      selectedJwSaleIndex = 1;
    }
  }

  _jwSaleRateDetailAttClick(int index) {
    if (saleOrderList[index].isHeader) return;
    jobWorkList.clear();
    jobWorkList.add(JobWorkModel(
        isHeader: true,
        docDate: 'Doc Date',
        docNo: 'Doc No',
        rate: 'Rate',
        rateUom: 'Uom',
        billNo: 'Bill No',
        billDate: 'Bill Date',
        finQty: 'Fin Qty',
        finQtyUom: 'Uom',
        stockQtyUom: 'Stock Qty Uom',
        catalogItem: 'Catalog Item',
        stockQty: 'Stock Qty'));
    jobWorkList.addAll(saleOrderList[index].jobWorkList!);
    if (jobWorkList.length == 1) {
      jobWorkList.clear();
      Commons.showToast('Not data found!');
    }
  }

  /// Sorting of Columns

  /// => Stock
  Future<void> _sortStock(String type) async {
    var header = catalogStockList.first;
    catalogStockList.removeAt(0);

    var footer = catalogStockList.last;
    catalogStockList.removeLast();

    switch (type) {
      case 'Godown':
        {
          if (!header.isAscending) {
            catalogStockList.sort((a, b) => a.godown!.compareTo(b.godown!));
          } else {
            catalogStockList.sort((a, b) => b.godown!.compareTo(a.godown!));
          }
        }
        break;

      case 'LotNo':
        {
          if (!header.isAscending) {
            catalogStockList.sort((a, b) => a.lotNo!.compareTo(b.lotNo!));
          } else {
            catalogStockList.sort((a, b) => b.lotNo!.compareTo(a.lotNo!));
          }
        }
        break;

      case 'RollNo':
        {
          if (!header.isAscending) {
            catalogStockList.sort((a, b) => a.rollNo!.compareTo(b.rollNo!));
          } else {
            catalogStockList.sort((a, b) => b.rollNo!.compareTo(a.rollNo!));
          }
        }
        break;

      case 'StockQty':
        {
          if (!header.isAscending) {
            catalogStockList.sort((a, b) =>
                a.stockQty!.toDouble().compareTo(b.stockQty!.toDouble()));
          } else {
            catalogStockList.sort((a, b) =>
                b.stockQty!.toDouble().compareTo(a.stockQty!.toDouble()));
          }
        }
        break;
    }

    header.isAscending = !header.isAscending;
    catalogStockList.insert(0, header);
    catalogStockList.add(footer);

    setState(() {});
  }

  /// => Purchase Rate Plan
  Future<void> _sortPurchaseRatePlan(String type) async {
    var header = purchasePlanList.first;
    purchasePlanList.removeAt(0);

    switch (type) {
      case 'OrderDate':
        {
          if (!header.isAscending) {
            purchasePlanList.sort((a, b) =>
                a.orderDate!.toDateTime().compareTo(b.orderDate!.toDateTime()));
          } else {
            purchasePlanList.sort((a, b) =>
                b.orderDate!.toDateTime().compareTo(a.orderDate!.toDateTime()));
          }
        }
        break;

      case 'OrderNo':
        {
          if (!header.isAscending) {
            purchasePlanList.sort(
                (a, b) => a.orderNo!.toInt().compareTo(b.orderNo!.toInt()));
          } else {
            purchasePlanList.sort(
                (a, b) => b.orderNo!.toInt().compareTo(a.orderNo!.toInt()));
          }
        }
        break;

      case 'PartyName':
        {
          if (!header.isAscending) {
            purchasePlanList
                .sort((a, b) => a.partyName!.compareTo(b.partyName!));
          } else {
            purchasePlanList
                .sort((a, b) => b.partyName!.compareTo(a.partyName!));
          }
        }
        break;

      case 'Quantity':
        {
          if (!header.isAscending) {
            purchasePlanList
                .sort((a, b) => a.qty!.toDouble().compareTo(b.qty!.toDouble()));
          } else {
            purchasePlanList
                .sort((a, b) => b.qty!.toDouble().compareTo(a.qty!.toDouble()));
          }
        }
        break;

      case 'BasicRate':
        {
          if (!header.isAscending) {
            purchasePlanList.sort((a, b) =>
                a.basicRate!.toDouble().compareTo(b.basicRate!.toDouble()));
          } else {
            purchasePlanList.sort((a, b) =>
                b.basicRate!.toDouble().compareTo(a.basicRate!.toDouble()));
          }
        }
        break;

      case 'DiscountPercent':
        {
          if (!header.isAscending) {
            purchasePlanList.sort((a, b) =>
                a.descPercent!.toDouble().compareTo(b.descPercent!.toDouble()));
          } else {
            purchasePlanList.sort((a, b) =>
                b.descPercent!.toDouble().compareTo(a.descPercent!.toDouble()));
          }
        }
        break;

      case 'DiscountRate':
        {
          if (!header.isAscending) {
            purchasePlanList.sort((a, b) =>
                a.discRate!.toDouble().compareTo(b.discRate!.toDouble()));
          } else {
            purchasePlanList.sort((a, b) =>
                b.discRate!.toDouble().compareTo(a.discRate!.toDouble()));
          }
        }
        break;

      case 'NetRate':
        {
          if (!header.isAscending) {
            purchasePlanList.sort((a, b) =>
                a.netRate!.toDouble().compareTo(b.netRate!.toDouble()));
          } else {
            purchasePlanList.sort((a, b) =>
                b.netRate!.toDouble().compareTo(a.netRate!.toDouble()));
          }
        }
        break;
    }

    header.isAscending = !header.isAscending;
    purchasePlanList.insert(0, header);

    for (int i = 0; i < purchasePlanList.length; i++) {
      if (purchasePlanList[i].isViewing) detailIndex = i;
    }

    setState(() {});
  }

  /// => Purchase Rate Detail Plan
  Future<void> _sortPurchaseRateDetailPlan(String type) async {
    var header = purchasePlanList[detailIndex!].detailList!.first;
    purchasePlanList[detailIndex!].detailList!.removeAt(0);

    switch (type) {
      case 'DocNo':
        {
          if (!header.isAscending) {
            purchasePlanList[detailIndex!]
                .detailList!
                .sort((a, b) => a.docNo!.toInt().compareTo(b.docNo!.toInt()));
          } else {
            purchasePlanList[detailIndex!]
                .detailList!
                .sort((a, b) => b.docNo!.toInt().compareTo(a.docNo!.toInt()));
          }
        }
        break;

      case 'DocDate':
        {
          if (!header.isAscending) {
            purchasePlanList[detailIndex!].detailList!.sort((a, b) =>
                a.docDate!.toDateTime().compareTo(b.docDate!.toDateTime()));
          } else {
            purchasePlanList[detailIndex!].detailList!.sort((a, b) =>
                b.docDate!.toDateTime().compareTo(a.docDate!.toDateTime()));
          }
        }
        break;

      case 'BillNo':
        {
          if (!header.isAscending) {
            purchasePlanList[detailIndex!]
                .detailList!
                .sort((a, b) => a.billNo!.toInt().compareTo(b.billNo!.toInt()));
          } else {
            purchasePlanList[detailIndex!]
                .detailList!
                .sort((a, b) => b.billNo!.toInt().compareTo(a.billNo!.toInt()));
          }
        }
        break;

      case 'BillDate':
        {
          if (!header.isAscending) {
            purchasePlanList[detailIndex!].detailList!.sort((a, b) =>
                a.billDate!.toDateTime().compareTo(b.billDate!.toDateTime()));
          } else {
            purchasePlanList[detailIndex!].detailList!.sort((a, b) =>
                b.billDate!.toDateTime().compareTo(a.billDate!.toDateTime()));
          }
        }
        break;

      case 'Rate':
        {
          if (!header.isAscending) {
            purchasePlanList[detailIndex!].detailList!.sort(
                (a, b) => a.rate!.toDouble().compareTo(b.rate!.toDouble()));
          } else {
            purchasePlanList[detailIndex!].detailList!.sort(
                (a, b) => b.rate!.toDouble().compareTo(a.rate!.toDouble()));
          }
        }
        break;

      case 'StockQty':
        {
          if (!header.isAscending) {
            purchasePlanList[detailIndex!].detailList!.sort((a, b) =>
                a.stockQty!.toDouble().compareTo(b.stockQty!.toDouble()));
          } else {
            purchasePlanList[detailIndex!].detailList!.sort((a, b) =>
                b.stockQty!.toDouble().compareTo(a.stockQty!.toDouble()));
          }
        }
        break;

      case 'FinQty':
        {
          if (!header.isAscending) {
            purchasePlanList[detailIndex!].detailList!.sort(
                (a, b) => a.finQty!.toDouble().compareTo(b.finQty!.toDouble()));
          } else {
            purchasePlanList[detailIndex!].detailList!.sort(
                (a, b) => b.finQty!.toDouble().compareTo(a.finQty!.toDouble()));
          }
        }
        break;
    }

    header.isAscending = !header.isAscending;
    purchasePlanList[detailIndex!].detailList!.insert(0, header);

    setState(() {});
  }

  /// => Sale Rate Plan
  Future<void> _sortSaleRateTable(String type) async {
    var header = saleRatePlanList.first;
    saleRatePlanList.removeAt(0);
    var footer;

    footer = saleRatePlanList.last;
    saleRatePlanList.removeLast();

    switch (type) {
      case 'OrderDate':
        {
          if (!header.isAscending) {
            saleRatePlanList.sort((a, b) =>
                a.orderDate!.toDateTime().compareTo(b.orderDate!.toDateTime()));
          } else {
            saleRatePlanList.sort((a, b) =>
                b.orderDate!.toDateTime().compareTo(a.orderDate!.toDateTime()));
          }
        }
        break;

      case 'OrderNo':
        {
          if (!header.isAscending) {
            saleRatePlanList.sort(
                (a, b) => a.orderNo!.toInt().compareTo(b.orderNo!.toInt()));
          } else {
            saleRatePlanList.sort(
                (a, b) => b.orderNo!.toInt().compareTo(a.orderNo!.toInt()));
          }
        }
        break;

      case 'PartyOrderNo':
        {
          if (!header.isAscending) {
            saleRatePlanList.sort((a, b) => a.partyOrderNo!
                .toDouble()
                .compareTo(b.partyOrderNo!.toDouble()));
          } else {
            saleRatePlanList.sort((a, b) => b.partyOrderNo!
                .toDouble()
                .compareTo(a.partyOrderNo!.toDouble()));
          }
        }
        break;

      case 'PartyName':
        {
          if (!header.isAscending) {
            saleRatePlanList
                .sort((a, b) => a.partyName!.compareTo(b.partyName!));
          } else {
            saleRatePlanList
                .sort((a, b) => b.partyName!.compareTo(a.partyName!));
          }
        }
        break;

      case 'StockType':
        {
          if (!header.isAscending) {
            saleRatePlanList.sort((a, b) => a.stock.compareTo(b.stock));
          } else {
            saleRatePlanList.sort((a, b) => b.stock.compareTo(a.stock));
          }
        }
        break;

      case 'Quantity':
        {
          if (!header.isAscending) {
            saleRatePlanList
                .sort((a, b) => a.qty!.toDouble().compareTo(b.qty!.toDouble()));
          } else {
            saleRatePlanList
                .sort((a, b) => b.qty!.toDouble().compareTo(a.qty!.toDouble()));
          }
        }
        break;

      case 'UOM':
        {
          if (!header.isAscending) {
            saleRatePlanList.sort((a, b) => a.uom!.compareTo(b.uom!));
          } else {
            saleRatePlanList.sort((a, b) => b.uom!.compareTo(a.uom!));
          }
        }
        break;

      case 'NetRate':
        {
          if (!header.isAscending) {
            saleRatePlanList.sort((a, b) =>
                a.netRate!.toDouble().compareTo(b.netRate!.toDouble()));
          } else {
            saleRatePlanList.sort((a, b) =>
                b.netRate!.toDouble().compareTo(a.netRate!.toDouble()));
          }
        }
        break;
    }

    header.isAscending = !header.isAscending;
    saleRatePlanList.insert(0, header);
    saleRatePlanList.add(footer);

    for (int i = 0; i < saleRatePlanList.length; i++) {
      if (saleRatePlanList[i].isViewing) {
        saleDetailIndex = i;
        break;
      }
    }

    setState(() {});
  }

  /// => Sale Rate Plan Detail
  Future<void> _sortSaleRateDetailTable(String type) async {
    var header = saleRatePlanList[saleDetailIndex!].saleDetailList!.first;
    saleRatePlanList[saleDetailIndex!].saleDetailList!.removeAt(0);
    var footer = saleRatePlanList[saleDetailIndex!].saleDetailList!.last;
    saleRatePlanList[saleDetailIndex!].saleDetailList!.removeLast();

    switch (type) {
      case 'BillNo':
        {
          if (!header.isAscending) {
            saleRatePlanList[saleDetailIndex!]
                .saleDetailList!
                .sort((a, b) => a.billNo!.toInt().compareTo(b.billNo!.toInt()));
          } else {
            saleRatePlanList[saleDetailIndex!]
                .saleDetailList!
                .sort((a, b) => b.billNo!.toInt().compareTo(a.billNo!.toInt()));
          }
        }
        break;

      case 'Date':
        {
          if (!header.isAscending) {
            saleRatePlanList[saleDetailIndex!].saleDetailList!.sort(
                (a, b) => a.date!.toDateTime().compareTo(b.date!.toDateTime()));
          } else {
            saleRatePlanList[saleDetailIndex!].saleDetailList!.sort(
                (a, b) => b.date!.toDateTime().compareTo(a.date!.toDateTime()));
          }
        }
        break;

      case 'PartyItemName':
        {
          if (!header.isAscending) {
            saleRatePlanList[saleDetailIndex!]
                .saleDetailList!
                .sort((a, b) => a.partyItemName!.compareTo(b.partyItemName!));
          } else {
            saleRatePlanList[saleDetailIndex!]
                .saleDetailList!
                .sort((a, b) => b.partyItemName!.compareTo(a.partyItemName!));
          }
        }
        break;

      case 'PartyPO':
        {}
        break;

      case 'Bags':
        {
          if (!header.isAscending) {
            saleRatePlanList[saleDetailIndex!]
                .saleDetailList!
                .sort((a, b) => a.bags!.toInt().compareTo(b.bags!.toInt()));
          } else {
            saleRatePlanList[saleDetailIndex!]
                .saleDetailList!
                .sort((a, b) => b.bags!.toInt().compareTo(a.bags!.toInt()));
          }
        }
        break;

      case 'Qty':
        {
          if (!header.isAscending) {
            saleRatePlanList[saleDetailIndex!]
                .saleDetailList!
                .sort((a, b) => a.qty!.toInt().compareTo(b.qty!.toInt()));
          } else {
            saleRatePlanList[saleDetailIndex!]
                .saleDetailList!
                .sort((a, b) => b.qty!.toInt().compareTo(a.qty!.toInt()));
          }
        }
        break;

      case 'Uom':
        {
          if (!header.isAscending) {
            saleRatePlanList[saleDetailIndex!]
                .saleDetailList!
                .sort((a, b) => a.qtyUom!.compareTo(b.qtyUom!));
          } else {
            saleRatePlanList[saleDetailIndex!]
                .saleDetailList!
                .sort((a, b) => b.qtyUom!.compareTo(a.qtyUom!));
          }
        }
        break;

      case 'Rate':
        {
          if (!header.isAscending) {
            saleRatePlanList[saleDetailIndex!].saleDetailList!.sort(
                (a, b) => a.rate!.toDouble().compareTo(b.rate!.toDouble()));
          } else {
            saleRatePlanList[saleDetailIndex!].saleDetailList!.sort(
                (a, b) => b.rate!.toDouble().compareTo(a.rate!.toDouble()));
          }
        }
        break;

      case 'RateUom':
        {
          if (!header.isAscending) {
            saleRatePlanList[saleDetailIndex!]
                .saleDetailList!
                .sort((a, b) => a.rateUom!.compareTo(b.rateUom!));
          } else {
            saleRatePlanList[saleDetailIndex!]
                .saleDetailList!
                .sort((a, b) => b.rateUom!.compareTo(a.rateUom!));
          }
        }
        break;

      case 'NetAmount':
        {
          if (!header.isAscending) {
            saleRatePlanList[saleDetailIndex!].saleDetailList!.sort(
                (a, b) => a.amount!.toDouble().compareTo(b.amount!.toDouble()));
          } else {
            saleRatePlanList[saleDetailIndex!].saleDetailList!.sort(
                (a, b) => b.amount!.toDouble().compareTo(a.amount!.toDouble()));
          }
        }
        break;
    }

    header.isAscending = !header.isAscending;
    saleRatePlanList[saleDetailIndex!].saleDetailList!.insert(0, header);
    saleRatePlanList[saleDetailIndex!].saleDetailList!.add(footer);
    setState(() {});
  }

  /// => JW Rate Plan
  Future<void> _sortJwSaleRateTable(String type) async {
    logIt('_sortJwSaleRateTable-> $type');

    var header = prodOrderDetailList.first;
    prodOrderDetailList.removeAt(0);

    switch (type) {
      case 'ProdOrderNo':
        {
          if (!header.isAscending) {
            prodOrderDetailList.sort((a, b) =>
                a.prodOrderNo!.toInt().compareTo(b.prodOrderNo!.toInt()));
          } else {
            prodOrderDetailList.sort((a, b) =>
                b.prodOrderNo!.toInt().compareTo(a.prodOrderNo!.toInt()));
          }
        }
        break;

      case 'ProdOrderDate':
        {
          if (!header.isAscending) {
            prodOrderDetailList.sort((a, b) => a.prodOrderDate!
                .toDateTime()
                .compareTo(b.prodOrderDate!.toDateTime()));
          } else {
            prodOrderDetailList.sort((a, b) => b.prodOrderDate!
                .toDateTime()
                .compareTo(a.prodOrderDate!.toDateTime()));
          }
        }
        break;
    }

    header.isAscending = !header.isAscending;
    prodOrderDetailList.insert(0, header);

    for (int i = 0; i < prodOrderDetailList.length; i++) {
      if (prodOrderDetailList[i].isViewing) selectedJwCompIndex = i;
    }

    setState(() {});
  }

  /// => JW Rate Plan Detail
  Future<void> _sortJwSaleRateDetailTable(String type) async {
    logIt('_sortJwSaleRateTable-> $type');

    var header = saleOrderList.first;
    saleOrderList.removeAt(0);

    switch (type) {
      case 'OrderDate':
        {
          if (!header.isAscending) {
            saleOrderList.sort((a, b) =>
                a.orderDate!.toDateTime().compareTo(b.orderDate!.toDateTime()));
          } else {
            saleOrderList.sort((a, b) =>
                b.orderDate!.toDateTime().compareTo(a.orderDate!.toDateTime()));
          }
        }
        break;

      case 'PartyName':
        {
          if (!header.isAscending) {
            saleOrderList.sort((a, b) => a.partyName!.compareTo(b.partyName!));
          } else {
            saleOrderList.sort((a, b) => b.partyName!.compareTo(a.partyName!));
          }
        }
        break;

      case 'PartyItemName':
        {
          if (!header.isAscending) {
            saleOrderList
                .sort((a, b) => a.partyItemName!.compareTo(b.partyItemName!));
          } else {
            saleOrderList
                .sort((a, b) => b.partyItemName!.compareTo(a.partyItemName!));
          }
        }
        break;

      case 'PartyOrderNo':
        {
          if (!header.isAscending) {
            saleOrderList.sort((a, b) =>
                a.partyOrderNo!.toInt().compareTo(b.partyOrderNo!.toInt()));
          } else {
            saleOrderList.sort((a, b) =>
                b.partyOrderNo!.toInt().compareTo(a.partyOrderNo!.toInt()));
          }
        }
        break;

      case 'Qty':
        {
          if (!header.isAscending) {
            saleOrderList
                .sort((a, b) => a.qty!.toInt().compareTo(b.qty!.toInt()));
          } else {
            saleOrderList
                .sort((a, b) => b.qty!.toInt().compareTo(a.qty!.toInt()));
          }
        }
        break;

      case 'Rate':
        {
          if (!header.isAscending) {
            saleOrderList.sort(
                (a, b) => a.rate!.toDouble().compareTo(b.rate!.toDouble()));
          } else {
            saleOrderList.sort(
                (a, b) => b.rate!.toDouble().compareTo(a.rate!.toDouble()));
          }
        }
        break;
    }

    header.isAscending = !header.isAscending;
    saleOrderList.insert(0, header);

    /*for(int i=0; i<saleOrderList.length; i++){

      if(saleOrderList[i].isViewing) selectedJwCompIndex=i;

    }*/

    setState(() {});
  }

  /// => JW Bill Detail
  Future<void> _sortJwBillDetailTable(String type) async {
    logIt('_sortJwSaleRateTable-> $type');

    var header = jobWorkList.first;
    jobWorkList.removeAt(0);

    switch (type) {
      case 'DocDate':
        {
          if (!header.isAscending) {
            jobWorkList.sort((a, b) =>
                a.docDate!.toDateTime().compareTo(b.docDate!.toDateTime()));
          } else {
            jobWorkList.sort((a, b) =>
                b.docDate!.toDateTime().compareTo(a.docDate!.toDateTime()));
          }
        }
        break;

      case 'BillNo':
        {
          if (!header.isAscending) {
            jobWorkList
                .sort((a, b) => a.billNo!.toInt().compareTo(b.billNo!.toInt()));
          } else {
            jobWorkList
                .sort((a, b) => b.billNo!.toInt().compareTo(a.billNo!.toInt()));
          }
        }
        break;

      case 'BillDate':
        {
          if (!header.isAscending) {
            jobWorkList.sort((a, b) =>
                a.billDate!.toDateTime().compareTo(b.billDate!.toDateTime()));
          } else {
            jobWorkList.sort((a, b) =>
                b.billDate!.toDateTime().compareTo(a.billDate!.toDateTime()));
          }
        }
        break;

      case 'CatalogItem':
        {
          if (!header.isAscending) {
            jobWorkList.sort((a, b) =>
                a.catalogItem!.toInt().compareTo(b.catalogItem!.toInt()));
          } else {
            jobWorkList.sort((a, b) =>
                b.catalogItem!.toInt().compareTo(a.catalogItem!.toInt()));
          }
        }
        break;

      case 'StockQty':
        {
          if (!header.isAscending) {
            jobWorkList.sort((a, b) =>
                a.stockQty!.toDouble().compareTo(b.stockQty!.toDouble()));
          } else {
            jobWorkList.sort((a, b) =>
                b.stockQty!.toDouble().compareTo(a.stockQty!.toDouble()));
          }
        }
        break;

      case 'StockQtyUom':
        {
          if (!header.isAscending) {
            jobWorkList
                .sort((a, b) => a.stockQtyUom!.compareTo(b.stockQtyUom!));
          } else {
            jobWorkList
                .sort((a, b) => b.stockQtyUom!.compareTo(a.stockQtyUom!));
          }
        }
        break;

      case 'FinQty':
        {
          if (!header.isAscending) {
            jobWorkList.sort(
                (a, b) => a.finQty!.toDouble().compareTo(b.finQty!.toDouble()));
          } else {
            jobWorkList.sort(
                (a, b) => b.finQty!.toDouble().compareTo(a.finQty!.toDouble()));
          }
        }
        break;

      case 'FinQtyUom':
        {
          if (!header.isAscending) {
            jobWorkList.sort((a, b) => a.finQtyUom!.compareTo(b.finQtyUom!));
          } else {
            jobWorkList.sort((a, b) => b.finQtyUom!.compareTo(a.finQtyUom!));
          }
        }
        break;

      case 'Rate':
        {
          if (!header.isAscending) {
            jobWorkList.sort(
                (a, b) => a.rate!.toDouble().compareTo(b.rate!.toDouble()));
          } else {
            jobWorkList.sort(
                (a, b) => b.rate!.toDouble().compareTo(a.rate!.toDouble()));
          }
        }
        break;

      case 'RateUom':
        {
          if (!header.isAscending) {
            jobWorkList.sort((a, b) => a.rateUom!.compareTo(b.rateUom!));
          } else {
            jobWorkList.sort((a, b) => b.rateUom!.compareTo(a.rateUom!));
          }
        }
        break;
    }

    header.isAscending = !header.isAscending;
    jobWorkList.insert(0, header);

    /*for(int i=0; i<saleOrderList.length; i++){

      if(saleOrderList[i].isViewing) selectedJwCompIndex=i;

    }*/

    setState(() {});
  }
}

enum WidgetType {
  CatalogCode,
  PurchasePlanRate,
  SalePlanRate,
  JWPlanRate,
}
