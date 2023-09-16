import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/cupertino.dart';

class GateEntryItemModel {

  String id;
  String billNo;
  String bag;
  String billQty;
  String stockQuantity;
  String adj;
  String perPc;
  String orderNo;
  String process;
  bool isViewing;
  bool isSelected;
  final String partyName;
   String billDate;
  final String catalogCode;
  final String partyItemName;
  final String stockUom;
  final String stockUomCode;
  final String billQtyUom;
  final String billQtyUomCode;
  final String indentNo;
  final String poNo;
  final String jwOrderNo;
  final String saleOrderNo;
  final String saleOrderDate;
  final String purchaseOrderNo;
  final String purchaseOrderDate;
  final String rate;
  final String poQty;
  final String recdQty;
  final String balQty;
  final String orderQty;
  final String gateEntryQty;
  final String partyOrderNo;
  final List<String?>? imageList;
  final bool isHeader;
  final TextEditingController? controller;
  final TextEditingController? stockQtyController;
  final TextEditingController? billQtyController;

  GateEntryItemModel(
      {this.id = '',
      this.billNo = '0',
      this.orderNo = '0',
      this.billDate = '',
      this.catalogCode = '',
      this.partyName = '',
      this.partyItemName = '',
      this.process = '',
      this.bag = '0',
      this.stockQuantity = '0',
      this.stockUom = '',
      this.stockUomCode = '',
      this.adj = '0',
      this.perPc = '0',
      this.billQty = '0',
      this.billQtyUom = '',
      this.billQtyUomCode = '',
      this.indentNo = '',
      this.poNo = '',
      this.jwOrderNo = '',
      this.saleOrderNo = '',
      this.saleOrderDate = '',
      this.purchaseOrderNo = '',
      this.purchaseOrderDate = '',
      this.rate = '',
      this.poQty = '',
      this.recdQty = '',
      this.balQty = '',
      this.controller,
      this.billQtyController,
      this.stockQtyController,
      this.orderQty='',
      this.partyOrderNo='',
      this.gateEntryQty='',
      this.imageList,
      this.isSelected = false,
      this.isHeader = false,
      this.isViewing = false});

  factory GateEntryItemModel.fromJSON(Map<String, dynamic> data) {

    var itemImages=data['catalog_image'] as List?;
    List<String?> imageList=[];

    itemImages?.forEach((element) {
      imageList.add(element['code_pk']);
    });

    var poOrderObj=getJsonObj(data, 'po_order_detail');
    var indItemObj=getJsonObj(poOrderObj, 'indent_item_single');
    var saleObj=getJsonObj(indItemObj, 'sale_item_detail');
    var saleHeaderObj=getJsonObj(saleObj, 'order_header');

    return GateEntryItemModel(
        id: getString(data, 'pod_pk'),
        catalogCode: getString(data, 'catalog_item'),
        indentNo: getString(data, 'indent_no'),
        purchaseOrderNo: getString(data, 'order_no'),
        purchaseOrderDate: getString(data, 'order_date'),
        partyItemName: getString(data, 'party_item_name'),
        rate: getString(data, 'net_rate'),
        poQty: getString(data, 'po_qty'),
        recdQty: getString(data, 'recd_qty'),
        balQty: getString(data, 'bal_qty'),
        stockUom: getString(data, 'qty_uom_abv'),
        stockUomCode: getString(data, 'qty_uom'),
        billQtyUom: getString(data, 'rate_uom_abv'),
        billQtyUomCode: getString(data, 'rate_uom'),
        partyOrderNo: getString(saleObj, 'party_order_no'),
        saleOrderNo: getString(saleHeaderObj, 'order_no'),
        saleOrderDate: getString(saleHeaderObj, 'order_date'),
        partyName: getString(poOrderObj['item_hedaer']['party_name'], 'name'),
        billDate: DateTime.now().format('dd MMM yyyy'),
        controller: TextEditingController(text: '0'),
        billQtyController: TextEditingController(text: getString(data, 'bal_qty')),
        billQty: getString(data, 'bal_qty'),
        stockQtyController:TextEditingController(text: getString(data, 'bal_qty')),
        stockQuantity:getString(data, 'bal_qty'),
        imageList: imageList
    );

  }

  factory GateEntryItemModel.fromJSON2(Map<String, dynamic> data) {

    var itemImages=data['catalog_image'] as List?;
    List<String?> imageList=[];

    itemImages?.forEach((element) {
      imageList.add(element['code_pk']);
    });

    var saleObj=data['sale_order_detail'];
    Map<dynamic, dynamic>? saleHeaderObj={};
    if(saleObj==null) saleObj={};
    else{
      saleHeaderObj=saleObj['order_header'];
    }

    return GateEntryItemModel(
        id: getString(data, 'prod_order_dtl_pk'),
        catalogCode: getString(data, 'catalog_item'),
        partyItemName: getString(data, 'catalog_item_name'),
        orderQty: getString(data, 'order_qty'),
        gateEntryQty: getString(data, 'ge_qty'),
        process: getString(data, 'process_name'),
        stockUom: getString(data, 'qty_uom_abv'),
        balQty: getString(data, 'bal_qty'),
        stockUomCode: getString(data, 'qty_uom'),
        billQtyUomCode: getString(data, 'rate_uom'),
        billQtyUom: getString(data, 'rate_uom_abv'),
        billDate: DateTime.now().format('dd MMM yyyy'),
        controller: TextEditingController(text: '0'),
        billQtyController: TextEditingController(text: getString(data, 'bal_qty')),
        billQty: getString(data, 'bal_qty'),
        stockQtyController:TextEditingController(text: getString(data, 'bal_qty')),
        stockQuantity:getString(data, 'bal_qty'),
       // indentNo: getString(data, ''),
        jwOrderNo: getString(data, 'order_no'),
        orderNo: getString(data, 'order_no'),
        partyOrderNo: getString(saleObj, 'party_order_no'),
        saleOrderNo: getString(saleHeaderObj, 'order_no'),
        saleOrderDate: getString(saleHeaderObj, 'order_date'),
        partyName: getString(saleHeaderObj!['party_name'], 'name'),
        imageList: imageList,
    );

  }

  factory GateEntryItemModel.parseDetail(Map<String, dynamic> data,bool isProd) {

    logIt('isProd-> $isProd');
    var poObj;

    if(data['po_item_detail']!=null){
      poObj= data['po_item_detail']['indent_item_single']['sale_item_detail'];
    }else{
      poObj={};
    }

    if(poObj==null) poObj={};

    var itemImages=data['item_images'] as List?;
    List<String?> imageList=[];

    itemImages?.forEach((element) {
      imageList.add(element['code_pk']);
    });

    return GateEntryItemModel(
        id: getString(data, 'prod_order_dtl_pk'),
        catalogCode: getString(data, 'catalog_code'),
        partyItemName: getString(data['po_item_detail'], 'party_item_name'),
        orderQty: getString(data['po_item_detail'], 'qty'),
        stockUom: getString(data['stk_quantity_unit'], 'abv'),
        stockUomCode: getString(data['stk_quantity_unit'], 'code'),
        billQtyUomCode: getString(data['fin_quantity_unit'], 'code'),
        billQtyUom: getString(data['fin_quantity_unit'], 'abv'),
        billDate: isProd? getString(data, 'bill_date'):getString(data, 'chl_date'),
        billNo: isProd? getString(data, 'bill_no'):getString(data, 'chl_no'),
        adj: getString(data, 'fin_qty_adj'),
        perPc: getString(data, 'weight_pp'),
        controller: TextEditingController(text: getString(data, 'bags')),//Bag
        billQtyController: TextEditingController(text: getString(data, 'fin_qty')),
        stockQtyController: TextEditingController(text: getString(data, 'stk_qty')),
        indentNo:data['po_item_detail']!=null? getString(data['po_item_detail']['indent_item_single']['item_hedaer'], 'indent_no'):'',
        poNo:data['po_item_detail']!=null? getString(data['po_item_detail']['item_hedaer'], 'order_no'):'',
        saleOrderNo: getString(poObj['order_header'], 'order_no'),
        saleOrderDate: getString(poObj['order_header'], 'order_date'),
        purchaseOrderNo: getString(poObj, 'party_order_no'),
        jwOrderNo: getString(data, ''),
        imageList: imageList
    );
  }

}
