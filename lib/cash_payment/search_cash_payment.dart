import 'dart:convert';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'cash_payment_approval.dart';
import 'cash_payment_comp_selection.dart';
import 'edit_cash_payment.dart';

class SearchCashPayment extends StatefulWidget {
  final String? compId;
  final String? compName;
  final String? empid;
  final String? type;

  const SearchCashPayment({
    Key? key,
    required this.compId,
    this.empid,
    this.type,
    this.compName,
  }) : super(key: key);

  @override
  _SearchCashPaymentState createState() => _SearchCashPaymentState();
}

class _SearchCashPaymentState extends State<SearchCashPayment>
    with NetworkResponse {
  List<PaymentApprovalModel> payApprList = [];
  List<PaymentApprovalModel> payApprMainList = [];
  final TextEditingController _searchController = TextEditingController();
  Search _search = Search.Party;
  String _limit = '30';
  int _offset = 0;
  bool _isLastPage = false;
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _searchCashPayments();
      _scrollController.addListener(() {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.position.pixels) {
          logIt('AddScrollListener - ReadyToFired $_isLoading - $_isLastPage');
          if (!_isLoading && !_isLastPage) {
            logIt('AddScrollListener - Fired');
            _offset++;
            _searchCashPayments();
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Cash Payment'),
        ),
        body: Column(
          children: [
            /// Search
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          onTap: () {
                            if (_search == Search.DocDate) {
                              _selectDocDate(BuildContext);
                            }
                            // FocusScope.of(context).unfocus();
                          },
                          controller: _searchController,
                          // onChanged: (v) {
                          //    {
                          //     if (v.trim().length > 1) {
                          //      _filterCashPayments(v.trim());
                          //     }
                          //     else if (v.trim().isEmpty)
                          //     {
                          //     _resetPagination();
                          //      _searchCashPayments();
                          //     }
                          //   }
                          //   },
                          textCapitalization: TextCapitalization.sentences,
                          readOnly: _search == Search.DocDate,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 4, top: 12),
                            suffixIcon: _searchController.text.isEmpty
                                ? Visibility(
                                    visible: _search == Search.DocDate,
                                    child: Icon(Icons.date_range_sharp))
                                : GestureDetector(
                                    onTap: () {
                                      _searchController.clear();
                                      _searchCashPayments();
                                      _resetPagination();
                                    },
                                    child: Icon(Icons.clear_rounded)),
                            isDense: true,
                            hintText: _search == Search.DocDate
                                ? 'Select Date'
                                : 'Search',
                          ),
                        ),
                      ),
                      Visibility(
                          visible: _search != Search.DocDate,
                          child: GestureDetector(
                              onTap: () {
                                _filterCashPayments(
                                    _searchController.text.trim());
                              },
                              child: Icon(
                                Icons.search,
                              )))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Total: ${payApprList.length}',
                      style: TextStyle(
                          fontSize: 14, color: CupertinoColors.inactiveGray),
                    ),
                  )
                ],
              ),
            ),

            /// Filter
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Row(
                children: [
                  Expanded(child: _getFilter(Search.DocDate)),
                  Expanded(child: _getFilter(Search.DocNo)),
                  Expanded(child: _getFilter(Search.Party)),
                  Expanded(child: _getFilter(Search.CreatedBy)),
                ],
              ),
            ),
            SizedBox(height: 8),
            payApprList.isEmpty
                ? Center(
                    child: Text(
                    'No Data Found',
                    style: TextStyle(fontSize: 18),
                  ))
                : Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: payApprList.length,
                      itemBuilder: (ctx, index) => GestureDetector(
                        onTap: () async {
                          if (ifHasPermission(
                              compCode: widget.compId,
                              permission: Permissions.CASH_PAYMENT,
                              permType: PermType.MODIFIED)!) {
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditCashPayment(
                                      compId: widget.compId,
                                      codePk: payApprList[index].id,
                                      partyCode: payApprList[index].acccode,
                                      compName: widget.compName,
                                    )));
                            _searchCashPayments();
                          } else {
                            Commons.showToast('You don\'t have permission');
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Card(
                                child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Table(
                                    children: [
                                      TableRow(children: [
                                        Text('Doc Date'),
                                        Text(payApprList[index].docdate)
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Text('Doc FinYear'),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Text(
                                              payApprList[index].docfinyear),
                                        )
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Text('Docno'),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Text(payApprList[index].docno),
                                        )
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Text('Party'),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Text(payApprList[index].party),
                                        )
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Text('Payment Type'),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child:
                                              Text(payApprList[index].paytype),
                                        )
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Text('Amount'),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child:
                                              Text(payApprList[index].amount),
                                        )
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Text('Inserted Date'),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child:
                                              Text(payApprList[index].insdate),
                                        )
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Text('Created By'),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child:
                                              Text(payApprList[index].insuser),
                                        )
                                      ]),
                                    ],
                                  ),

                                  /// Delete
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Visibility(
                                      visible: ifHasPermission(
                                          permType: PermType.MODIFIED,
                                          flag: PermFlag.DEL,
                                          compCode: widget.compId,
                                          permission:
                                              Permissions.CASH_PAYMENT)!,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            showAlert(
                                                context,
                                                'Do You Want to Delete this Cash Payment?',
                                                'Confirmation',
                                                ok: 'Ok',
                                                onOk: () {
                                                  _paymentDelete(index);
                                                },
                                                notOk: 'Cancel',
                                                onNo: () {
                                                  popIt(context);
                                                });
                                          },
                                          child: Text('Delete')),
                                    ),
                                  )
                                ],
                              ),
                            )),
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CashPaymentCompSelection()));
            _searchCashPayments();
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }

  double _filterHeight = 34;
  Widget _getFilter(Search type) {
    switch (type) {
      case Search.DocDate:
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            setState(() {
              _search = Search.DocDate;
            });
          },
          child: Container(
              height: _filterHeight,
              decoration: BoxDecoration(
                  color: _search == Search.DocDate ? Colors.red : Colors.white,
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4))),
              child: Center(
                child: Text(
                  'Doc Date',
                  style: TextStyle(
                    color:
                        _search == Search.DocDate ? Colors.white : Colors.red,
                    fontSize: 12,
                  ),
                ),
              )),
        );
      // break;
      case Search.DocNo:
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            setState(() {
              _search = Search.DocNo;
            });
          },
          child: Container(
            height: _filterHeight,
            decoration: BoxDecoration(
              color: _search == Search.DocNo ? Colors.red : Colors.white,
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.red),
                  // left: BorderSide(color: Colors.red),
                  bottom: BorderSide(color: Colors.red),
                  // right: BorderSide(width:0.1,color: Colors.red),
                ),
              ),
              child: Center(
                  child: Text(
                'Doc No',
                style: TextStyle(
                  color: _search == Search.DocNo ? Colors.white : Colors.red,
                  fontSize: 12,
                ),
              )),
            ),
          ),
        );
      //break;
      case Search.Party:
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            setState(() {
              _search = Search.Party;
            });
          },
          child: Container(
            height: _filterHeight,
            decoration: BoxDecoration(
              color: _search == Search.Party ? Colors.red : Colors.white,
              //border: Border.all(color: Colors.red),
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.red),
                  left: BorderSide(color: Colors.red),
                  bottom: BorderSide(color: Colors.red),
                  // right: BorderSide(width:0.1,color: Colors.red),
                ),
              ),
              child: Center(
                  child: Text(
                'Party',
                style: TextStyle(
                  color: _search == Search.Party ? Colors.white : Colors.red,
                  fontSize: 12,
                ),
              )),
            ),
          ),
        );
      // break;
      case Search.CreatedBy:
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            setState(() {
              _search = Search.CreatedBy;
            });
          },
          child: Container(
            height: _filterHeight,
            decoration: BoxDecoration(
                color: _search == Search.CreatedBy ? Colors.red : Colors.white,
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4))),
            child: Center(
                child: Text(
              'Created By',
              style: TextStyle(
                color: _search == Search.CreatedBy ? Colors.white : Colors.red,
                fontSize: 12,
              ),
            )),
          ),
        );
      // break;
      default:
        return Container();
    }
  }

  filterResult(String str) {
    payApprList.clear();
    if (str.isNotEmpty) {
      payApprList.addAll(payApprMainList.where((a) =>
          a.id.toLowerCase().contains(str.toLowerCase()) ||
          a.docdate.toLowerCase().contains(str.toLowerCase()) ||
          a.docfinyear.toLowerCase().contains(str.toLowerCase()) ||
          a.party.toLowerCase().contains(str.toLowerCase()) ||
          a.amount.toLowerCase().contains(str.toLowerCase()) ||
          a.insdate.toLowerCase().contains(str.toLowerCase()) ||
          a.insuser.toLowerCase().contains(str.toLowerCase()) ||
          a.paytype.toLowerCase().contains(str.toLowerCase())));
    } else {
      payApprList.addAll(payApprMainList);
    }
    setState(() {});
  }

  getPaymentApproval() {
    Map jsonBody = {
      'user_id': getUserId(),
      'comp_code': widget.compId,
    };
    if (widget.type == 'emp') {
      jsonBody.addAll({
        'search_user_id': widget.empid,
      });
    }
    WebService.fromApi(AppConfig.paymentreceiptapproval, this, jsonBody)
        .callPostService(context);
    _isLoading = true;
  }

  _searchCashPayments() {
    Map jsonBody = {
      'user_id': getUserId(),
      'comp_code': widget.compId,
      'limit': _limit,
      'offset': _offset.toString(),
    };
    if (widget.type == 'emp') {
      jsonBody.addAll({
        'search_user_id': widget.empid,
      });
    }
    WebService.fromApi(AppConfig.getCashPayment, this, jsonBody)
        .callPostService(context);
    _isLoading = true;
  }

  _filterCashPayments(String string) {
    _resetPagination();
    Map jsonBody = {
      'user_id': getUserId(),
      'comp_code': widget.compId,
      'limit': _limit,
      'offset': _offset.toString(),
    };
    switch (_search) {
      case Search.DocDate:
        jsonBody.addAll({
          'doc_date': string,
        });
        break;
      case Search.DocNo:
        jsonBody.addAll({'doc_no': string});
        break;
      case Search.Party:
        jsonBody.addAll({'acc_code': string.toUpperCase()});
        break;
      case Search.CreatedBy:
        jsonBody.addAll({'created_by': string.toUpperCase()});
        break;
    }
    if (widget.type == 'emp') {
      jsonBody.addAll({
        'search_user_id': widget.empid,
      });
    }
    WebService.fromApi(AppConfig.getCashPayment, this, jsonBody)
        .callPostService(context);
    _isLoading = true;
  }

  _resetPagination() {
    _limit = '30';
    _offset = 0;
    _isLoading = false;
    _isLastPage = false;
  }

  _paymentDelete(index) {
    Map jsonBody = {
      'user_id': getUserId(),
      'code_pk': payApprList[index].codePk,
      'item_type': 'cash'
    };
    logIt('_cashDelete $jsonBody');
    WebService.fromApi(AppConfig.cashDelete, this, jsonBody)
        .callPostService(context, onResult: () {
      payApprList.removeAt(index);
      setState(() {});
    });
  }

  _selectDocDate(buildContext) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null) {
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      _searchController.text = formatter.format(selected);
      _filterCashPayments(_searchController.text.trim());
    }
  }

  void onResponse({Key? key, String? requestCode, String? response}) {
    switch (requestCode) {
      case AppConfig.getCashPayment:
        {
          _isLoading = false;
          var data = jsonDecode(response!);
          if (data['error'] == 'false') {
            var receiptApprContent = data['content'] as List;
            if (_offset == 0) {
              payApprList.clear();
              payApprMainList.clear();
            }
            payApprList.addAll(receiptApprContent
                .map((e) => PaymentApprovalModel.parsejson(e))
                .toList());
            payApprMainList.addAll(payApprList);
            if (receiptApprContent.isEmpty ||
                int.parse(_limit) > payApprList.length) _isLastPage = true;
            setState(() {});
          }
        }
        break;
      case AppConfig.cashDelete:
        {
          var data = jsonDecode(response!);
          if (data['error'] == 'false') {
            showAlert(context, data['message'], 'Success', onOk: () {
              //  popIt(context);
            });
          } else {
            showAlert(context, data['message'], 'Error');
          }
        }
        break;
    }
  }
}

enum Search { DocDate, DocNo, Party, CreatedBy }
