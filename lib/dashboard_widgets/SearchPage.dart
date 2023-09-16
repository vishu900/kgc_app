import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../Commons/Commons.dart';
import '../LocationMaster/LocationMaster.dart';
import '../Stock_opening/ItemMaster.dart';
import '../Stock_opening/company_list_page.dart';
import '../account_master_approval/account_approvalparty.dart';
import '../attendance/Attendance.dart';
import '../bankPayment/BankPaymentCompanySelection.dart';
import '../bomscreen/companyselection2.dart';
import '../cash_payment/cash_payments_approval_comp_selection.dart';
import '../cash_payment/cash_receipt_approval_comp_selection.dart';
import '../cash_payment/search_payment_company_selection.dart';
import '../cash_payment/search_receipt_company_selection.dart';
import '../company_selection.dart';
import '../full_and_final/full _and _final _comp _selection.dart';
import '../gateEntry/gate_entry_comp_selection.dart';
import '../gatePass/CreateGatePass.dart';
import '../gatePass/GatePassCompanySelection.dart';
import '../indent/IndentCompanySelection.dart';
import '../material_issue/screens/companies_list_page.dart';
import '../production_planning/company_list_pp.dart';
import '../production_report/company_list_page.dart';
import '../productionview/CompaniesScreen.dart';
import '../purchaseBillApproval/pur_bill_comp_selection.dart';
import '../purchaseOrder/PurchaseCompanySelection.dart';
import '../purchasePacking/pur_packing_comp_selection.dart';
import '../quotation/SearchSaleQuotation.dart';
import '../salary/employee_advance_comp_selection.dart';
import '../salary/employee_salary_comp_selection.dart';
import '../saleEnquiry/SaleEnquiry.dart';
import '../tracker/Tracker.dart';

class SearchPage extends StatefulWidget {

  List<String?> permList;
  var userid, empPassCount, visitorPassCount, bankCount, name, indentCount,
  poCount,
  counter,
  bomcounter,
  trackCount,
  pendingApprovalCount,
  purchasePackingCount,
  gateEntryCount,
  accMasterApprovalCount,
  cashPaymentApprovalCount,
  cashReceiptApprovalCount;

  SearchPage({Key? key, required this.permList, required this.userid, required this.empPassCount, required this.visitorPassCount,
  required this.bankCount, required this.name,
     required this.indentCount,
     required this.poCount,
     required this.counter,
     required this.bomcounter,
     required this.trackCount,
     required this.pendingApprovalCount,
     required this.purchasePackingCount,
     required this.gateEntryCount,
     required this.accMasterApprovalCount,
     required this.cashPaymentApprovalCount,
     required this.cashReceiptApprovalCount}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  String searchQuery = "";
  List<String?> filteredList = [];

  @override
  void initState() {
    super.initState();
    filterList();
  }

  void filterList() {
    if (searchQuery.isEmpty) {
      setState(() {
        filteredList = List.from(widget.permList);
      });
    } else {
      setState(() {
        filteredList = widget.permList
            .where((item) => item!.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    print("ACCMasterCount: "+widget.accMasterApprovalCount.toString());

    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.only(left: 8),
          height: 35,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
            ),
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  filterList();
                });
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                hintText: "Search",
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderSide: BorderSide.none),

              ),
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: SingleChildScrollView(
          child: GridView.count(
              shrinkWrap: true,
              childAspectRatio: 1,
              crossAxisSpacing: 1,
              mainAxisSpacing: 15,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              children: List.generate(
                  filteredList.length, (index) => _getWidgets(index, filteredList))),
        ),
      ),
    );
  }



  Widget _getWidgets(int index, permList) {

    final sizeb = SizedBox(
      height: 12,
    );

    switch (permList[index]) {


      case 'PROD_PLAN_MA':

      /// Material Issue ag Prod Orders
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CompanyListPP()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 36,
                        child: Image.asset(
                          'images/production_planning.png',
                          height: 36,
                          width: 36,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                sizeb,
                Text('Production Planning',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }




      case 'ATTENDANCE':

      /// ATTENDANCE
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Attendance()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 36.0,
                        child: SvgPicture.asset(
                          'images/attendance.svg',
                          height: 36.0,
                          width: 36.0,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                sizeb,
                Text('Attendance',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }

      case 'SALE_ENQ':

      /// Sale Enquiry
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => SaleEnquiry()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 36.0,
                        child: Image.asset(
                          'images/enquiry.png',
                          height: 36.0,
                          width: 36.0,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                sizeb,
                Text('Sale Enquiry',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
// Opening Stock start
      case 'STOCK_OPENING':

      // Opening Stock Add /Edit /Del /Search
        {
          return GestureDetector(
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) =>
              //         CompaniesListPage(userID: widget.userid)));
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CompanyListPageSI(userId: widget.userid,)));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 36.0,
                        child: Image.asset(
                          'images/Stock.png',
                          height: 36.0,
                          width: 36.0,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                sizeb,
                Text('Stock Opening',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
// End Opening Stock

      case 'MATERIAL_RECD_4_PROD_ORD':

      /// Sale Enquiry
      ///                   MaterialPageRoute(builder: (context) => CompaniesListPage(userID: widget.userid)));
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                ///                  MaterialPageRoute(builder: (context) => CompaniesScreen()));
                  MaterialPageRoute(builder: (context) => CompaniesScreen(userID: widget.userid)));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 36.0,
                        child: Image.asset(
                          'images/production.png',
                          height: 36.0,
                          width: 36.0,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                sizeb,
                Text('Production',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }

// ProdIssue Test start
      case 'MATERIAL_ISSUE_4_PROD_ORD':

      /// Material Issue ag Prod Orders
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CompaniesListPage(userID: widget.userid)));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 36.0,
                        child: Image.asset(
                          'images/production.png',
                          height: 36.0,
                          width: 36.0,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                sizeb,
                Text('Material Issue',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }


      case 'PROD_REP_MA':

      /// Material Issue ag Prod Orders
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CompanyListPagePR(userID: widget.userid,)));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 36.0,
                        child: Image.asset(
                          'images/production_report.png',
                          height: 36.0,
                          width: 36.0,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                sizeb,
                Text('Production Report',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }


// End Prod Issue Test
      case 'EMP_GATEPASS':

      /// Gate Pass
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => GatePassCompanySelection(
                    type: PassType.Employee,
                  )));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 36.0,
                        child: Image.asset(
                          'images/gate_pass.png',
                          height: 36.0,
                          width: 36.0,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    widget.empPassCount != 0
                        ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          widget.empPassCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Emp Gate Pass',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //  break;

      case 'VISITOR_GATE_ENTRY':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      GatePassCompanySelection(type: PassType.Visitor)));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 36.0,
                        child: Image.asset(
                          'images/gate_pass.png',
                          height: 36.0,
                          width: 36.0,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    widget.visitorPassCount != 0
                        ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          widget.visitorPassCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Visitor Gate Pass',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }

    //break;

      case 'BANK_PAYMENT':
        {
          return GestureDetector(
            onTap: () {
              widget.bankCount != 0
                  ? Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BankPaymentCompanySelection(
                    userId: widget.userid,
                    name: widget.name,
                  )))
                  : Commons.showToast('No Bank Payment is there!!!');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 36.0,
                        child: Image.asset(
                          'images/bankpayment.png',
                          height: 36.0,
                          width: 36.0,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    widget.bankCount != 0
                        ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          widget.bankCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Bank\nApproval',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //  break;

      case 'INDENT_APPROVAL':
        {
          return GestureDetector(
            onTap: () {
              widget.indentCount != 0
                  ? Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => IndentCompanySelection(
                    userId: widget.userid,
                    name: widget.name,
                  )))
                  : Commons.showToast('No Indent Report is there!!!');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 36.0,
                        child: SvgPicture.asset(
                          'images/indent_report.svg',
                          height: 36.0,
                          width: 36.0,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    widget.indentCount != 0
                        ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          widget.indentCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Indent\nApproval',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //  break;
      case 'PO_APPROVAL':
        {
          return GestureDetector(
            onTap: () {
              widget.poCount != 0
                  ? Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PurchaseCompanySelection(
                    userId: widget.userid,
                    name: widget.name,
                  )))
                  : Commons.showToast('No Purchase Order is there!!!');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 36.0,
                        child: Image.asset(
                          'images/purchaseorder.png',
                          height: 36.0,
                          width: 36.0,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    widget.poCount != 0
                        ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          widget.poCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Purchase\nOrder Approval',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    // break;

      case 'SALE_ORDER_APPROVAL':
        {
          return GestureDetector(
            onTap: () {
              widget.counter != 0
                  ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CompanySelection(
                        userid: widget.userid,
                        name: widget.name,
                      )))
                  : Commons.showToast('No Sale Order is there!!!');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 36.0,
                        child: Image.asset(
                          'images/saleorder.png',
                          height: 36.0,
                          width: 36.0,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    widget.counter != 0
                        ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          widget.counter.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Sale\nOrder Approval',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    // break;

      case 'SALE_QTN':
        {
          return GestureDetector(
            onTap: () {
              print('bom Clciked');

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchSaleQuotation()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 36.0,
                        child: SvgPicture.asset(
                          'images/quotation_form.svg',
                          height: 36.0,
                          width: 36.0,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                sizeb,
                Text('Sale\nQuotation',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //  break;

      case 'SO_BOM_APPROVAL':
        {
          return GestureDetector(
            onTap: () {
              print('bom Clciked');

              widget.bomcounter != 0
                  ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CompanySelection2(
                        userid: widget.userid,
                        name: widget.name,
                      )))
                  : Commons.showToast('No BOM Order is there!!!');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 36.0,
                        child: Image.asset(
                          'images/bom.png',
                          height: 36.0,
                          width: 36.0,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    widget.bomcounter != 0
                        ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          widget.bomcounter.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Sale Order\nBom Approval',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    // break;


      case 'TRACKER':
        {
          return GestureDetector(
            onTap: () {
              widget. trackCount != 0
                  ? Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Tracker()))
                  : Commons.showToast('No Tracker Report is there!!!');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 36.0,
                        child: SvgPicture.asset(
                          'images/tracker.svg',
                          height: 36.0,
                          width: 36.0,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    widget.trackCount != 0
                        ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          widget.trackCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Tracker',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    // break;

      case 'LOCATION_MASTER':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LocationMaster()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 36.0,
                        child: SvgPicture.asset(
                          'images/location.svg',
                          height: 36.0,
                          width: 36.0,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                sizeb,
                Text('Location Master',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //  break;

      case 'ITEM_MASTER':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ItemMaster()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 36.0,
                        child: SvgPicture.asset(
                          'images/item_master.svg',
                          height: 36.0,
                          width: 36.0,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                sizeb,
                Text('Item Master',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    // break;

      case 'PUR_BILL_APPROVAL':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PurBillCompSelection()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 36.0,
                        child: SvgPicture.asset(
                          'images/tracker.svg',
                          height: 36.0,
                          width: 36.0,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    widget.pendingApprovalCount != 0
                        ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          widget.pendingApprovalCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Purchase Bill Approval',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //  break;

      case 'PUR_PACKING_BILL':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PurPackingCompSelection()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 36.0,
                        child: SvgPicture.asset(
                          'images/shopping-bag.svg',
                          height: 36.0,
                          width: 36.0,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    widget.purchasePackingCount != 0
                        ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          widget.purchasePackingCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Purchase Packing',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //   break;

      case 'GATE_ENTRY_BILL':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => GateEntryCompSelection()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 36.0,
                        child: SvgPicture.asset(
                          'images/indent_report.svg',
                          height: 36.0,
                          width: 36.0,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    widget.gateEntryCount != 0
                        ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          widget.gateEntryCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Gate Entry',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //  break;

      case 'SALARY_PAY_CHECK':
        {
          return GestureDetector(
            onTap: () {
              /*if (!isImprest) {
                Commons.showToast('You profile does not have imprest code.');
                return;
              }*/
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EmpSalaryCompSelection()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 36.0,
                        child: Image.asset(
                          'images/salary.png',
                          height: 36.0,
                          width: 36.0,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),

                  ],
                ),
                sizeb,
                Text('Employee\nSalary Paid',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //  break;

      case 'SALARY_ADVANCE_PAID':
        {
          return GestureDetector(
            onTap: () {
              /*if (!isImprest) {
                Commons.showToast('You profile does not have imprest code.');
                return;
              }*/
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EmpAdvanceCompSelection()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 36.0,
                        child: Image.asset(
                          'images/cashback.png',
                          height: 36.0,
                          width: 36.0,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                sizeb,
                Text('Advance Entry',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //  break;

      case 'ACC_MST_APPROVAL':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AccountApprovalParty()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 36.0,
                        child: Image.asset(
                          'images/account_approval.png',
                          height: 36.0,
                          width: 36.0,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    widget.accMasterApprovalCount != 0
                        ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          widget.accMasterApprovalCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Account Master\nApproval',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //  break;

      case 'FANDF':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FullAndFinalCompSelection()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 36.0,
                        child: Image.asset(
                          'images/salary.png',
                          height: 36.0,
                          width: 36.0,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                sizeb,
                Text('Full And Final',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //  break;
      case 'CASH_PAYMENT':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CashCompSelection()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 36.0,
                        child: Image.asset(
                          'images/payment-method.png',
                          height: 36.0,
                          width: 36.0,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                sizeb,
                Text('Cash Payment',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //  break;
      case 'CASH_PAYMENT_APPROVAL':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CashPaymentApprovalCompSelection()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 36.0,
                        child: Image.asset(
                          'images/payment.png',
                          height: 36.0,
                          width: 36.0,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    widget.cashPaymentApprovalCount != 0
                        ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          widget.cashPaymentApprovalCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Cash Payment\nApproval',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //  break;
      case 'CASH_RECEIPT':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CashRecCompSelection()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 36.0,
                        child: Image.asset(
                          'images/receipt.png',
                          height: 36.0,
                          width: 36.0,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                sizeb,
                Text('Cash Receipt',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //  break;
      case 'CASH_RECEIPT_APPROVAL':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CashReceiptApprovalCompSelection()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 36.0,
                        child: Image.asset(
                          'images/receipt approval.png',
                          height: 36.0,
                          width: 36.0,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    widget.cashReceiptApprovalCount != 0
                        ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          widget.cashReceiptApprovalCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Cash Receipt\nApproval',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //  break;

      case 'CASH_RECEIPT_APPROVAL':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CashReceiptApprovalCompSelection()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 36.0,
                        child: Image.asset(
                          'images/receipt approval.png',
                          height: 36.0,
                          width: 36.0,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    widget.cashReceiptApprovalCount != 0
                        ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          widget.cashReceiptApprovalCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Cash Receipt\nApproval',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //  break;
      default:
        return Text('INVALID PERM');
    }
  }
  
  
  
}
