class PurchasePackagingBillModel{

  final String id;
  final String lotNo;
  final String rollNo;
  final String stockQty;
  final String stockUom;
  final String? stockUomCode;
  final String billQty;
  final String billUom;
  final String? billUomCode;
  final bool isHeader;
   bool isViewing;

  PurchasePackagingBillModel(
      {this.id='',
      this.lotNo='',
      this.rollNo='',
      this.stockQty='',
      this.stockUom='',
      this.stockUomCode='',
      this.billQty='',
      this.billUom='',
      this.billUomCode='',
      this.isHeader=false,
      this.isViewing=false,
      }
    );

}