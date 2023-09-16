class SaleOrderModel{

  final String id;
  final String itemCode;
  final String partyItemName;
  final String qty;
  final String qtyUom;
  final String netRate;
  final String netRateUom;
  final String amount;
  final String orderNo;
  final String delvDate;
  final String clbQty;
  final String clbQtyUom;
  final String clbRate;
  final String clbRateUom;
  final String status;
  final bool isHeader;
  final bool isViewing;

  SaleOrderModel(
      {this.id='',
      this.itemCode='',
      this.partyItemName='',
      this.qty='',
      this.qtyUom='',
      this.netRate='',
      this.netRateUom='',
      this.amount='',
      this.orderNo='',
      this.delvDate='',
      this.clbQty='',
      this.clbQtyUom='',
      this.clbRate='',
      this.clbRateUom='',
      this.status='',
      this.isHeader=false,
      this.isViewing=false
      });

}