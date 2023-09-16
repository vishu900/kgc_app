class GetSearchDetailsSO {
  
  var Approval;
  var Godown;
  var finYear;
  var docNo;
  var docDate;
  var catalogCode;
  var hsn;
  var lotno;
  var rate;
  var qty;
  var roll;
  var codePk;
  String catalogItemName;
  String Uom;


  GetSearchDetailsSO({
    required this.codePk,
    required this.docDate,
    required this.roll,
    required this.Approval,
    required this.Godown,
    required this.finYear,
    required this.docNo,
    required this.catalogCode,
    required this.hsn,
    required this.lotno,
    required this.rate,
    required this.qty,
    required this.catalogItemName,
    required this.Uom,

  });
}
