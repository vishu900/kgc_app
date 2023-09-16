import 'package:dataproject2/utils/Utils.dart';

class PoOrderListingModel {
  final String id;
  final String indentNo;
  final String catalogItem;
  final String partyItemName;
  final String itemName;
  final String quantity;
  final String rate;
  final String discountPer;
  final String discountRate;
  final String netRate;
  final String amount;
  final String delvDate;
  final String status;
  final String approvedByUid;
  final String approvedBy;
  final String approvedDate;
  final String soParty;
  final bool isHeader;
  bool isViewing;
  final List<String?>? imageList;

  PoOrderListingModel(
      {this.id = '',
      this.indentNo = '',
      this.catalogItem = '',
      this.partyItemName = '',
      this.itemName = '',
      this.quantity = '',
      this.rate = '',
      this.discountPer = '',
      this.discountRate = '',
      this.netRate = '',
      this.amount = '',
      this.delvDate = '',
      this.status = '',
      this.approvedByUid = '',
      this.approvedBy = '',
      this.approvedDate = '',
      this.soParty = '',
      this.isViewing = false,
      this.isHeader = false,
      this.imageList});

  factory PoOrderListingModel.fromJson(Map<String, dynamic> data) {
    var imgList = data['item_images'] as List;

    List<String?> imageList = [];

    imgList.forEach((element) {
      imageList.add(element['code_pk']);
    });

    return PoOrderListingModel(
        id: getString(data, 'pod_pk'),
        indentNo:
            getString(data['indent_item_single']['item_hedaer'], 'indent_no'),
        catalogItem: getString(data, 'catalog_code'),
        partyItemName: getString(data, 'party_item_name'),
        itemName: getString(data, 'catalog_name'),
        quantity: getString(data, 'qty'),
        rate: getString(data, 'rate'),
        discountPer: getString(data, 'disc_per'),
        discountRate: getString(data, 'disc_rate'),
        netRate: getString(data, 'net_rate'),
        amount: getTotalAmount(data),
        delvDate: getString(data, 'delv_date'),
        status: getString(data, 'pod_pk_status') == 'Y' ? 'Yes' : 'No',
        imageList: imageList,
        approvedByUid: getString(data, 'approved_uid'),
        approvedDate: getString(data, 'approved_date'),
        approvedBy: getString(data['approved_user_name'], 'name'));
  }

  static getTotalAmount(Map<String, dynamic> data) {
    try {
      String qty = getString(data, 'qty');
      String rate = getString(data, 'net_rate');

      return (qty.toDouble() * rate.toDouble()).toString();
    } catch (err, stack) {
      logIt('getTotalAmount-> $err $stack');
    }
  }
}
