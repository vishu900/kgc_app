import 'package:dataproject2/utils/Utils.dart';

class PurchaseBillApprovalModel {
  final String id;
  final String catalog;
  final String itemName;
  final String stockQty;
  final String stockUom;
  final String finQty;
  final String finQtyUom;
  final String rate;
  final String rateUom;
  final String itemAmount;
  final String otherAmount;
  final String amount;
  final String gst;
  final String gstAmount;
  final String cgst;
  final String cgstAmount;
  final String sgst;
  final String sgstAmount;
  final String igst;
  final String igstAmount;
  final String hsnCode;

  final String order;
  final String packingDocNo;
  final String packingDocDate;
  final String gateEntryDocNo;
  final String gateEntryDocDate;
  final String packingDocId;
  final String gateEntryDocId;
  final String poDocId;
  final String indentDocId;
  final String poNo;
  final String poDate;
  final String indentNo;
  final String indentDate;
  final String approvedBy;
  final String approvedDate;

  final String ocat1;
  final String ocat2;
  final String ocat3;
  bool isSelected;

  final List<String?>? imageList;

  bool isHeader;
  bool isViewing;
  bool isApproved;

  PurchaseBillApprovalModel(
      {this.id = '',
      this.catalog = '',
      this.itemName = '',
      this.stockQty = '',
      this.stockUom = '',
      this.finQty = '',
      this.finQtyUom = '',
      this.rate = '',
      this.rateUom = '',
      this.itemAmount = '',
      this.otherAmount = '',
      this.amount = '',
      this.gst = '',
      this.gstAmount = '',
      this.cgst = '',
      this.cgstAmount = '',
      this.sgst = '',
      this.sgstAmount = '',
      this.igst = '',
      this.igstAmount = '',
      this.hsnCode = '',
      this.order = '',
      this.packingDocNo = '',
      this.packingDocDate = '',
      this.gateEntryDocNo = '',
      this.gateEntryDocDate = '',
      this.packingDocId = '',
      this.gateEntryDocId = '',
      this.poDocId = '',
      this.indentDocId = '',
      this.poNo = '',
      this.ocat1 = '',
      this.ocat2 = '',
      this.ocat3 = '',
      this.poDate = '',
      this.indentNo = '',
      this.indentDate = '',
      this.approvedBy = '',
      this.approvedDate = '',
      this.isViewing = false,
      this.isHeader = false,
      this.isApproved = false,
      this.isSelected = false,
      this.imageList});

  factory PurchaseBillApprovalModel.fromJson(
      Map<String, dynamic> data, bool isType13) {
    var gateEntryObj1 = data['gate_entry_detail'];

    if (gateEntryObj1 == null) gateEntryObj1 = {};

    var entryHdr = data['gate_entry_detail'] != null
        ? data['gate_entry_detail']['entry_hdr'] as List?
        : [];
    var gateEntryObj = {};
    if (entryHdr != null) {
      if (entryHdr.isNotEmpty) {
        gateEntryObj = entryHdr[0];
      }
    }

    List<String?> imageList = [];
    var imgList = data['catalog_item']['catalog_images'] as List;

    imgList.forEach((element) {
      imageList.add(element['code_pk']);
    });

    return PurchaseBillApprovalModel(
        id: getString(data, 'code_pk'),
        catalog: getString(data['catalog_item'], 'catalog_code'),
        itemName: getString(data['catalog_item'], 'catalog_name'),
        stockQty: getString(data, 'stock_qty'),
        stockUom: getString(data['stock_unit_name'], 'abv'),
        finQty: getString(data, 'fin_qty'),
        finQtyUom: getString(data['finqty_unit_name'], 'abv'),
        rate: getString(data, 'rate'),
        rateUom: getString(data['rate_unit_name'], 'abv'),
        itemAmount: getString(data, 'item_amount'),
        otherAmount: getOtherAmountTotal(
            getString(data, 'other_amount_1'),
            getString(data, 'other_amount_2'),
            getString(data, 'other_amount_3')),
        amount: getTotal(
            getString(data, 'other_amount_1'), getString(data, 'item_amount')),
        hsnCode: getString(data, 'hsn_code'),
        ocat1: getString(data, 'other_amount_1'),
        ocat2: getString(data, 'other_amount_2'),
        ocat3: getString(data, 'other_amount_3'),
        sgst: getString(data, 'sgst_per'),
        sgstAmount: getString(data, 'sgst_amount'),
        cgst: getString(data, 'cgst_per'),
        cgstAmount: getString(data, 'cgst_amount'),
        igst: getString(data, 'igst_per'),
        igstAmount: getString(data, 'igst_amount'),
        packingDocNo: getString(gateEntryObj1['packaging_detail'], 'doc_no'),
        packingDocId: getString(gateEntryObj1['packaging_detail'], 'code_pk'),
        packingDocDate:
            getString(gateEntryObj1['packaging_detail'], 'doc_date'),
        gateEntryDocNo: getString(gateEntryObj, 'doc_no'),
        gateEntryDocId: getString(gateEntryObj, 'code_pk'),
        gateEntryDocDate: getString(gateEntryObj, 'doc_date'),
        approvedBy: getString(data, 'approved_uid'),
        approvedDate: getString(data, 'approved_date'),
        poDocId: getFromPO(data, 'PoId', isType13),
        poNo: getFromPO(data, 'PoNo', isType13),
        poDate: getFromPO(data, 'PoDate', isType13),
        indentNo: getFromPO(data, 'IndentNo', isType13),
        indentDocId: getFromPO(data, 'IndentDocId', isType13),
        indentDate: getFromPO(data, 'IndentDate', isType13),
        imageList: imageList);
  }

  static getTotal(String am1, String am2) {
    try {
      return (am1.toDouble() + am2.toDouble()).toString();
    } catch (err, stack) {
      logIt('getTotal-> $err $stack');
    }
  }

  static getOtherAmountTotal(String am1, String am2, String am3) {
    try {
      return (am1.toDouble() + am2.toDouble() + am3.toDouble()).toString();
    } catch (err, stack) {
      logIt('getTotal-> $err $stack');
    }
  }

  static getFromPO(Map<String, dynamic> data, String type, bool isType13) {
    var poObj = data['po_item_detail'];
    if (poObj == null) poObj = {};

    switch (type) {
      case 'PoNo':
        {
          if (isType13) {
            return ''; //getString(data['prod_item_detail']['prod_hdr'], 'order_no');
          } else {
            return getString(poObj['item_hedaer'], 'order_no');
          }
        }
      // break;

      case 'PoId':
        {
          if (isType13) {
            return ''; //getString(data['prod_item_detail']['prod_hdr'], 'prod_order_hdr_pk');
          } else {
            return getString(poObj['item_hedaer'], 'poh_pk');
          }
        }
      // break;

      case 'PoDate':
        {
          if (isType13) {
            return ''; //getString(data['prod_item_detail']['prod_hdr'], 'order_date');
          } else {
            return getString(poObj['item_hedaer'], 'order_date');
          }
        }
      //  break;

      case 'IndentNo':
        {
          if (isType13) {
            return '';
          } else {
            var indItemObj = poObj['indent_item_single'];
            if (indItemObj == null) indItemObj = {};
            return getString(indItemObj['item_hedaer'], 'indent_no');
          }
        }
      // break;

      case 'IndentDocId':
        {
          if (isType13) {
            return '';
          } else {
            var indItemObj = poObj['indent_item_single'];
            if (indItemObj == null) indItemObj = {};
            return getString(indItemObj['item_hedaer'], 'indent_hdr_pk');
          }
        }
      // break;

      case 'IndentDate':
        {
          if (isType13) {
            return '';
          } else {
            var indItemObj = poObj['indent_item_single'];
            if (indItemObj == null) indItemObj = {};
            return getString(indItemObj['item_hedaer'], 'indent_date');
          }
        }
      // break;
    }
  }
}
