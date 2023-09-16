import 'package:dataproject2/utils/Utils.dart';

class PurPackItemModel{

  final String? id;
  final String? gateSrNo;
  final String? gateSrdate;
  final String? billNo;
  final String? docType;
  final String? billDate;
  final String? itemCode;
  final String? itemName;
  final String? catalogCode;
  final String? stockQty;
  final String? billQty;
  final String? uom;
  final String? uomCode;
  bool isSelected;
  List<String?>? imageList;

  PurPackItemModel(
      {this.id,
      this.gateSrNo,
      this.gateSrdate,
      this.itemName,
      this.billNo,
      this.docType,
      this.billDate,
      this.itemCode,
      this.catalogCode,
      this.stockQty,
      this.billQty,
      this.uom,
      this.uomCode,
      this.isSelected=false,
      this.imageList
      });

  factory PurPackItemModel.fromJson(Map<String,dynamic> data){

    var imageList=data['catalog_images'] as List?;

    List<String?> imgList=[];

    if(imageList!=null) {

      imageList.forEach((element) {
        imgList.add(element['code_pk']);
      });

    }

    var entryHdrList=data['entry_hdr'] as List;
    var entryHdr={};

    if(entryHdrList.isNotEmpty){
      entryHdr=entryHdrList[0];
    }

    return PurPackItemModel(
      id: getString(data, 'code_pk'),
      gateSrNo: getString(entryHdr, 'doc_no'),
      gateSrdate: getString(entryHdr, 'doc_date'),
      docType: getString(entryHdr, 'ge_doc_type_fk'),
      itemName: getString(data, 'catalog_name'),
      billNo: getString(data, 'bill_no').isEmpty? getString(data, 'chl_no'):getString(data, 'bill_no'),
      billDate: getString(data, 'bill_date').isEmpty? getString(data, 'chl_date'):getString(data, 'bill_date'),
      itemCode: getString(data['po_item_detail']['indent_item_single'], 'item_code'),
      catalogCode: getString(data, 'catalog_code'),
      stockQty: getString(data, 'stk_qty'),
      billQty: getString(data['po_item_detail'], 'qty'),
      uom: getString(data['stk_quantity_unit'], 'abv'),
      uomCode: getString(data['stk_quantity_unit'], 'code'),
      imageList: imgList
    );

  }

}