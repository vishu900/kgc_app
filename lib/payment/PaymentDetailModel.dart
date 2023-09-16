class PaymentDetailModel{

  final String id;
  final String docNo;
  final String docDate;
  final String purAmount;
  final String bankAmount;
  final String cashAmount;
  final String rtnAmount;
  final String tdsAmount;
  final String purSaleAmount;
  final String otherAmount;
  bool isHeader;
  bool isViewing;

  PaymentDetailModel(
      {this.id='',
      this.docNo='',
      this.docDate='',
      this.purAmount='',
      this.bankAmount='',
      this.cashAmount='',
      this.rtnAmount='',
      this.tdsAmount='',
      this.purSaleAmount='',
      this.otherAmount='',
      this.isHeader=false,
      this.isViewing=false,});


}
