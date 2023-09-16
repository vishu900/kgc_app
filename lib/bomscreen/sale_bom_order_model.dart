import 'package:dataproject2/utils/Utils.dart';

/// Main Model
class SaleOrderBomModel {
  final String? id;
  final String? date;
  final String? insertDateTime;
  final String? party;
  final String? saleOrderNo;
  final String? remarks;
  final List<SaleOrderBomItemModel>? itemList;

  SaleOrderBomModel(
      {this.id,
      this.date,
      this.insertDateTime,
      this.party,
      this.saleOrderNo,
      this.remarks,
      this.itemList});

  factory SaleOrderBomModel.fromJSON(Map<String, dynamic> data) {
    var content = data['order_items'] as List;
    List<SaleOrderBomItemModel> _itemList = [];
    _itemList
        .addAll(content.map((e) => SaleOrderBomItemModel.fromJSON(e)).toList());

    return SaleOrderBomModel(
        saleOrderNo: getString(data, 'order_no'),
        date: getString(data, 'order_date'),
        insertDateTime: getString(data, 'order_date_time'),
        remarks: getString(data, 'remarks'),
        party: getString(data, 'party_name'),
        itemList: _itemList);
  }
}

/// Item Model
class SaleOrderBomItemModel {
  final String? id;
  final String? itemId;
  final String? catalogName;
  final String? catalogItemName;
  final String? partyOrderNo;
  final String? qty;
  final String? qtyUom;
  final String? orderType;
  final String? mfgQty;
  final String? tradingQty;
  final String? deliveryDate;
  final String? saleOrderApprovedBy;
  final String? saleOrderApprovedDate;
  final String? remarks;

  final List<String>? imageList;
  final List<ProcessModel>? processList;

  SaleOrderBomItemModel(
      {this.id,
      this.itemId,
      this.catalogName,
      this.catalogItemName,
      this.partyOrderNo,
      this.qty,
      this.qtyUom,
      this.orderType,
      this.mfgQty,
      this.tradingQty,
      this.deliveryDate,
      this.saleOrderApprovedBy,
      this.saleOrderApprovedDate,
      this.remarks,
      this.imageList,
      this.processList});

  factory SaleOrderBomItemModel.fromJSON(Map<String, dynamic> data) {
    var content = data['catalog_item']['image_name'] as List;
    final List<String> _imageList = [];
    content.forEach((element) {
      _imageList.add(element);
    });

    var processItems = data['process_items'] as List;
    List<ProcessModel> _processList = [];
    _processList
        .addAll(processItems.map((e) => ProcessModel.fromJSON(e)).toList());

    return SaleOrderBomItemModel(
        id: getString(data['item_code'], 'code'),
        itemId: getString(data, 'sod_pk'),
        catalogName: getString(data['catalog_item'], 'code'),
        catalogItemName: getString(data, 'item_description'),
        partyOrderNo: getString(data, 'party_order_no'),
        qty: getString(data, 'order_qty'),
        qtyUom: getString(data, 'qty_uom'),
        orderType: getOrderType(getString(data, 'order_type')),
        mfgQty: getString(data, 'mfg_qty'),
        tradingQty: getString(data, 'trd_qty'),
        deliveryDate: getString(data, 'delv_date'),
        saleOrderApprovedBy: getString(data, 'so_approved_user_name'),
        saleOrderApprovedDate: getString(data, 'so_approved_date'),
        remarks: getString(data, 'remarks'),
        processList: _processList,
        imageList: _imageList);
  }

  static getOrderType(String type) {
    String orderType = '';

    if (type == "M") {
      orderType = "Manufacturing";
    } else if (type == "T") {
      orderType = "Trading";
    } else if (type == "B") {
      orderType = "Both";
    } else if (type == "N") {
      orderType = "N/A";
    } else if (type == "S") {
      orderType = "Stock";
    } else if (type == "O") {
      orderType = "Others Stock";
    } else {
      orderType = "";
    }

    return orderType;
  }
}

/// Process Model
class ProcessModel {
  final String? id;
  final String sodPk;
  final String sohFk;
  final String catalogItem;
  final String catalogName;
  final String processCode;
  final String process;
  final String processType;
  final String visibleWaste;
  final String invisibleWaste;
  final String autoTag;
  final String partyName;
  final String contactPerson;
  final List<BomItemModel>? bomItemList;

  ProcessModel(
      {this.id,
      this.sohFk = '',
      this.sodPk = '',
      this.catalogItem = '',
      this.catalogName = '',
      this.processCode = '',
      this.process = '',
      this.processType = '',
      this.visibleWaste = '',
      this.invisibleWaste = '',
      this.autoTag = '',
      this.partyName = '',
      this.contactPerson = '',
      this.bomItemList});

  factory ProcessModel.fromJSON(Map<String, dynamic> data) {
    var content = data['bom_items'] as List;
    List<BomItemModel> _processBomItem = [];

    _processBomItem
        .addAll(content.map((e) => BomItemModel.fromJSON(e)).toList());

    String sPk = getString(data, 'sod_pk');
    String sFk = getString(data, 'soh_fk');

    logIt('Spk-> $sPk FPK-> $sFk');

    return ProcessModel(
        id: getString(data, 'sod_pk'),
        sodPk: getString(data, 'sod_pk'),
        sohFk: getString(data, 'soh_fk'),
        catalogItem: getString(data, 'catalog_item'),
        catalogName: getString(data, 'item_description'),
        processCode: getString(data, 'proc_code'),
        process: getString(data, 'name'),
        processType: getString(data, 'proc_type'),
        visibleWaste: getString(data, 'v_wst'),
        invisibleWaste: getString(data, 'i_wst'),
        autoTag: getString(data, 'auto_tag'),
        partyName: getString(data, 'party_name'),
        contactPerson: getString(data, 'cont_person_name'),
        bomItemList: _processBomItem);
  }
}

class BomItemModel {
  final String? id;
  final String? sodPk;
  final String? sohFk;
  final String? itemDescription;
  final String? processCode;
  final String? qty;
  final String? uom;
  final String? stockTag;

  BomItemModel(
      {this.id,
      this.itemDescription,
      this.qty,
      this.uom,
      this.stockTag,
      this.sodPk,
      this.sohFk,
      this.processCode});

  factory BomItemModel.fromJSON(Map<String, dynamic> data) {
    //var sodPk= getString(data, 'sod_pk');
    //var sohFk= getString(data, 'soh_fk');

    return BomItemModel(
        id: getString(data, 'bom_catalog_item'),
        sodPk: getString(data, 'sod_pk').trim(),
        sohFk: getString(data, 'soh_fk').trim(),
        processCode: getString(data, 'proc_code'),
        itemDescription: getString(data, 'bom_item_description'),
        qty: getString(data, 'bom_qty_per'),
        uom: getString(data, 'bom_qty_uom'),
        stockTag: getString(data, 'stock_tag'));
  }
}
