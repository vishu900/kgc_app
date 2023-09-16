import 'package:dataproject2/material_issue/model/process_order_model.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'SaleOrderModel.dart';

class SaleOrder extends StatefulWidget {
  final String? id;

  const SaleOrder(
      {Key? key, this.id, required ProcessOrderModel processOrderModel})
      : super(key: key);

  @override
  _SaleOrderState createState() => _SaleOrderState();
}

class _SaleOrderState extends State<SaleOrder> {
  Widget _height = SizedBox(height: 12);
  List<SaleOrderModel> _saleOrderList = [];

  final _orderDateController = TextEditingController();
  final _finYearController = TextEditingController();
  final _partyController = TextEditingController();
  final _noController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _approvalByController = TextEditingController();
  final _merchandiserController = TextEditingController();
  final _remarksController = TextEditingController();

  final _itemNameController = TextEditingController();
  final _catalogItemController = TextEditingController();
  final _saleQtnNoController = TextEditingController();
  final _saleChlQtyController = TextEditingController();
  final _saleBillNoController = TextEditingController();
  final _rateController = TextEditingController();
  final _itemRemarksController = TextEditingController();
  final _discountPercentController = TextEditingController();
  final _discountAmountController = TextEditingController();

  /*  String _mfgTypeController='';
  String _tradingQtyController='';
  String _machineTypeController='';
  String _bomAuthController='';

  String _soUidController='';
  String _soNameController='';
  String _soDateController='';

  String _boUidController='';
  String _boNameController='';
  String _boDateController='';
 */
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _init();
    });
  }

  _init() {
    _saleOrderList.add(SaleOrderModel(
        id: '',
        isHeader: true,
        partyItemName: 'PartyItemName',
        itemCode: 'ItemCode',
        qty: 'Qty',
        qtyUom: 'Qty Uom',
        amount: 'Amount',
        clbQty: 'Clb Qty',
        clbQtyUom: 'Uom',
        clbRate: 'Clb Rate',
        clbRateUom: 'Uom',
        delvDate: 'Delv Date',
        netRate: 'Net Rate',
        netRateUom: 'Uom',
        orderNo: 'Order No',
        status: 'Status'));

    for (int i = 0; i < 5; i++) {
      _saleOrderList.add(SaleOrderModel(
          id: '',
          isHeader: false,
          partyItemName: 'Sample Name',
          itemCode: '120',
          qty: '21',
          qtyUom: 'PC',
          amount: '120',
          clbQty: '12',
          clbQtyUom: 'Pc',
          clbRate: '12',
          clbRateUom: 'Pc',
          delvDate: '12 May 2021',
          netRate: '120',
          netRateUom: '122',
          orderNo: '12211',
          status: 'Yes'));
    }

    _saleOrderList.add(SaleOrderModel(
      itemCode: 'Total',
      qty: _getTotal('Qty'),
      amount: _getTotal('Amount'),
    ));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        clearFocus(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sale Order'),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              /// Order Date and Fin Year
              Row(
                children: [
                  /// Order Date
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: _orderDateController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Order Date',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),

                  /// Fin Year
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: _finYearController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Fin Year',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              _height,

              /// No and Party Name
              Row(
                children: [
                  /// Party
                  Container(
                    width: (MediaQuery.of(context).size.width / 100) * 65,
                    child: TextFormField(
                      readOnly: true,
                      controller: _partyController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Party',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),

                  /// No
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: _noController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'No',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              _height,

              /// Contact Person and Approval By
              Row(
                children: [
                  /// Contact Person
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: _contactPersonController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Contact Person',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),

                  /// Approval By
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: _approvalByController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Approval By',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              _height,

              /// Merchandiser and Remarks
              Row(
                children: [
                  /// Merchandiser
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: _merchandiserController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Merchandiser',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),

                  /// Remarks
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: _remarksController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Remarks',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),

              _height,

              /// Flexible Items
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: _buildCells(_saleOrderList.length),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildRows(_saleOrderList.length),
                      ),
                    ),
                  )
                ],
              ),

              _height,

              /// Item Image
              Container(
                width: 25.0.h,
                height: 25.0.h,
                child: Placeholder(),
              ),

              _height,

              TextFormField(
                readOnly: true,
                controller: _itemNameController,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                ),
              ),

              _height,

              /// Catalog Item and Sale Qtn No
              Row(
                children: [
                  /// Catalog Item
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: _catalogItemController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Catalog Item',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  SizedBox(width: 8),

                  /// Sale Qtn No
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: _saleQtnNoController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Sale Qtn No',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),

              _height,

              /// Sale Chl Qty and Sale Bill Qty
              Row(
                children: [
                  /// Sale Chl Qty
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: _saleChlQtyController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Sale Chl Qty',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  SizedBox(width: 8),

                  /// Sale Bill No
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: _saleBillNoController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Sale Bill No',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),

              _height,

              /// Rate and Remarks
              Row(
                children: [
                  /// Rate
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: _rateController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Rate',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  SizedBox(width: 8),

                  /// Remarks
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: _itemRemarksController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Remarks',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),

              _height,

              /// Discount Percent and Discount Amount
              Row(
                children: [
                  /// Discount Percent
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: _discountPercentController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Discount Percent',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  SizedBox(width: 8),

                  /// Discount Amount
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: _discountAmountController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Discount Amount',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),

              _height,

              /// Divider (Sale Order Type)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),
                  Flexible(
                      child: Text(
                    'Sale Order Type',
                    style: TextStyle(fontSize: 16),
                  )),
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              _height,

              Table(
                children: [
                  /// Order Type
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Order Type', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Trading', style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Mfg Qty
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Mfg Qty', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('20', style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Trading Qty
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text('Trading Qty', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('2', style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Machine Type
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text('Machine Type', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Normal', style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Bom Auth.
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Bom Auth.', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Harjinder Singh',
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),
                ],
              ),

              _height,

              /// Divider (Sale Order Approve Details)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),
                  Flexible(
                      child: Text(
                    'Sale Order Approve Details',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  )),
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              _height,

              Table(
                children: [
                  /// UID
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('UID', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Rajesh', style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Name
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Name', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text('Rajesh Kumar', style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Date
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Date', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('28 May 2021, 11:44 AM',
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),
                ],
              ),

              _height,

              /// Divider (Sale Order BOM Approve Details)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),
                  Flexible(
                      child: Text('Sale Order BOM Approve Details',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16))),
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              _height,

              Table(
                children: [
                  /// UID
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('UID', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Rajesh', style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Name
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Name', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text('Rajesh Kumar', style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Date
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Date', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('28 May 2021, 11:44 AM',
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Vertically
  List<Widget> _buildCells(int count) {
    return List.generate(
      count,
      (mainIndex) => Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Container(
            width: 120,
            height: 48,
            color: _saleOrderList[mainIndex].isHeader
                ? AppColor.appRed
                : _saleOrderList[mainIndex].isViewing
                    ? AppColor.appRed[500]
                    : Colors.red[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _saleOrderList[mainIndex].itemCode,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            color: _saleOrderList[mainIndex].isHeader
                                ? Colors.white
                                : Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  /// Horizontally
  List<Widget> _buildRows(int count) {
    return List.generate(count, (index) => _eachRow(count, index));
  }

  /// Total Cells in a row --->>>
  Container _eachRow(int count, int index) {
    double width = 120;
    return Container(
      alignment: Alignment.topCenter,
      child: IntrinsicWidth(
        child: Row(children: [
          /// PartyItemName
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 110,
              color: _saleOrderList[index].isHeader
                  ? AppColor.appRed
                  : _saleOrderList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _saleOrderList[index].partyItemName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _saleOrderList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Qty
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _saleOrderList[index].isHeader
                  ? AppColor.appRed
                  : _saleOrderList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _saleOrderList[index].qty,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _saleOrderList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// QtyUom
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _saleOrderList[index].isHeader
                  ? AppColor.appRed
                  : _saleOrderList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _saleOrderList[index].qtyUom,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _saleOrderList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// NetRate
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _saleOrderList[index].isHeader
                  ? AppColor.appRed
                  : _saleOrderList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _saleOrderList[index].netRate,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _saleOrderList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// NetRate Uom
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _saleOrderList[index].isHeader
                  ? AppColor.appRed
                  : _saleOrderList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _saleOrderList[index].netRateUom,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _saleOrderList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Amount
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _saleOrderList[index].isHeader
                  ? AppColor.appRed
                  : _saleOrderList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _saleOrderList[index].amount,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _saleOrderList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Order No
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _saleOrderList[index].isHeader
                  ? AppColor.appRed
                  : _saleOrderList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _saleOrderList[index].orderNo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _saleOrderList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Delv Date
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _saleOrderList[index].isHeader
                  ? AppColor.appRed
                  : _saleOrderList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _saleOrderList[index].delvDate,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _saleOrderList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Clb Qty
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _saleOrderList[index].isHeader
                  ? AppColor.appRed
                  : _saleOrderList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _saleOrderList[index].clbQty,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _saleOrderList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Clb Qty Uom
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _saleOrderList[index].isHeader
                  ? AppColor.appRed
                  : _saleOrderList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _saleOrderList[index].clbQtyUom,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _saleOrderList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Clb Rate
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _saleOrderList[index].isHeader
                  ? AppColor.appRed
                  : _saleOrderList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _saleOrderList[index].clbRate,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _saleOrderList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Clb Rate Uom
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _saleOrderList[index].isHeader
                  ? AppColor.appRed
                  : _saleOrderList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _saleOrderList[index].clbRateUom,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _saleOrderList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  /// type-> Qty, Amount
  _getTotal(String type) {
    if (_saleOrderList.isEmpty)
      return '0';
    else {
      var res = _saleOrderList.where((element) => !element.isHeader);
      int count = 0;
      if (type == 'Qty') {
        res.forEach((element) {
          count += element.qty.toInt();
        });
        return count.toString();
      } else if (type == 'Amount') {
        res.forEach((element) {
          count += element.amount.toInt();
        });
        return count.toString();
      }
    }
  }

  @override
  void dispose() {
    _orderDateController.dispose();
    _finYearController.dispose();
    _partyController.dispose();
    _noController.dispose();
    _contactPersonController.dispose();
    _approvalByController.dispose();
    _merchandiserController.dispose();
    _remarksController.dispose();
    _itemNameController.dispose();
    _catalogItemController.dispose();
    _saleQtnNoController.dispose();
    _saleChlQtyController.dispose();
    _saleBillNoController.dispose();
    _rateController.dispose();
    _itemRemarksController.dispose();
    _discountPercentController.dispose();
    _discountAmountController.dispose();
    super.dispose();
  }
}
