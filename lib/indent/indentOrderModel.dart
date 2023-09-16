import 'package:dataproject2/utils/Utils.dart';

class IndentOrderModel {
  final String id;
  final String item;
  final String partyItemName;
  final String count;
  final String material;
  final String qty;
  final String qtyUom;
  final String status;

  final String catalogItemCode;
  final String catalogItemName;
  final String saleOrderNo;
  final String brandName;
  final String shade;
  final String purchaser;
  final String remarks;

  final String itemParam1;
  final String itemParam2;
  final String itemParam3;

  final String itemValue1;
  final String itemValue2;
  final String itemValue3;

  final String itemUom1;
  final String itemUom2;
  final String itemUom3;

  final String appUid;
  final String appName;
  final String appDate;

  final bool isHeader;
   bool isViewing;
  final List<String?>? imageList;

  IndentOrderModel(
      {this.id = '',
      this.item = '',
      this.partyItemName = '',
      this.count = '',
      this.material = '',
      this.qty = '',
      this.qtyUom = '',
      this.status = '',
      this.catalogItemCode='',
      this.catalogItemName='',
      this.saleOrderNo='',
      this.brandName='',
      this.shade='',
      this.purchaser='',
      this.remarks='',
      this.itemParam1='',
      this.itemParam2='',
      this.itemParam3='',
      this.itemValue1='',
      this.itemValue2='',
      this.itemValue3='',
      this.itemUom1='',
      this.itemUom2='',
      this.itemUom3='',
      this.imageList,
      this.appUid='',
      this.appName='',
      this.appDate='',
      this.isHeader = false,
      this.isViewing = false});

  factory IndentOrderModel.fromJson(Map<String,dynamic> data){

    var imgList=data['item_images'] as List;

    List<String?> imageList=[];

    imgList.forEach((element) {imageList.add(element['code_pk']);});

    var sobj=data['sale_item_detail'];

    if(sobj==null) sobj= {};

   return IndentOrderModel(
        item: getString(data, 'item_code'),
        partyItemName: getString(data, 'party_item_name'),
        catalogItemName: getString(data, 'catalog_name'),
        count: getString(data['item_count'], 'name'),
        material: getString(data['item_material'], 'name'),
        qty: getString(data, 'qty'),
        qtyUom: getString(data['qty_unit_name'], 'abv'),
        status: getString(data, 'code_pk_status')=='Y'?'Yes':'No',
        catalogItemCode: getString(data,'catalog_code'),
        saleOrderNo: getString(sobj['order_header'], 'order_no'),
        brandName: getString(data['item_brand'], 'name'),
        shade: getString(data['item_shade'], 'name'),
        purchaser: getString(data['purchaser_name'], 'name'),
        remarks: getString(data, 'remarks'),
        itemValue1: getString(data, 'iop1_val'),
        itemValue2: getString(data, 'iop2_val'),
        itemValue3: getString(data, 'iop3_val'),
        itemParam1: getString(data['item_code_1'], 'name'),
        itemParam2: getString(data['item_code_2'], 'name'),
        itemParam3: getString(data['item_code_3'], 'name'),
        itemUom1: getString(data['item_unit_1'], 'abv'),
        itemUom2: getString(data['item_unit_2'], 'abv'),
        itemUom3: getString(data['item_unit_3'], 'abv'),
        appUid: getString(data, 'approved_uid'),
        appName: getString(data['approved_user_name'], 'name'),
        appDate: getString(data, 'approved_date'),
        imageList: imageList
   );

  }

}
