import 'dart:convert';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../cash_receipt_company_selection.dart';
import 'cash_receipt_approval.dart';
import 'edit_cash_receipt.dart';

class SearchCashReceipt extends StatefulWidget {
  final String? compId;
  final String? compName;

  final String? empid;
  final String? type;

  const SearchCashReceipt({
    Key? key,
    required this.compId,
    this.empid,
    this.type,
    this.compName,
  }) : super(key: key);

  @override
  _SearchCashReceipt createState() => _SearchCashReceipt();
}

class _SearchCashReceipt extends State<SearchCashReceipt> with NetworkResponse {
  List<ReceiptApprovalModel> _receiptApprList = [];
  List<ReceiptApprovalModel> _receiptApprMainList = [];
  final TextEditingController _partySearchController = TextEditingController();
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
      _searchCashRecPayments();
      _scrollController.addListener(() {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.position.pixels) {
          logIt('AddScrollListener - ReadyToFired $_isLoading - $_isLastPage');
          if (!_isLoading && !_isLastPage) {
            logIt('AddScrollListener - Fired');
            _offset++;
            _searchCashRecPayments();
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
          title: Text('Cash Receipt'),
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
                            //FocusScope.of(context).unfocus();
                          },
                          readOnly: _search == Search.DocDate,
                          controller: _partySearchController,
                          // onChanged:(v)=> _filterCashRecPayments(_partySearchController.text.trim()),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 4, top: 12),
                            suffixIcon: _partySearchController.text.isEmpty
                                ? Visibility(
                                    visible: _search == Search.DocDate,
                                    child: Icon(Icons.date_range_sharp))
                                : GestureDetector(
                                    onTap: () {
                                      _partySearchController.clear();
                                      _searchCashRecPayments();
                                      _resetPagination();
                                    },
                                    child: Icon(Icons.clear_rounded)),
                            isDense: true,
                            hintText: _search != Search.DocDate
                                ? 'Search'
                                : 'Select Date',
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _search != Search.DocDate,
                        child: GestureDetector(
                            onTap: () {
                              _filterCashRecPayments(
                                  _partySearchController.text.trim());
                            },
                            child: Icon(Icons.search)),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Total: ${_receiptApprList.length}',
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
            _receiptApprList.isEmpty
                ? Center(
                    child: Text(
                    'No Data Found',
                    style: TextStyle(fontSize: 18),
                  ))
                : Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _receiptApprList.length,
                      itemBuilder: (ctx, index) => GestureDetector(
                        onTap: () async {
                          logIt('${_receiptApprList[index].id}');
                          if (ifHasPermission(
                              compCode: widget.compId,
                              permission: Permissions.CASH_PAYMENT,
                              permType: PermType.MODIFIED)!) {
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditCashReceipt(
                                      compId: widget.compId,
                                      codePk: _receiptApprList[index].id,
                                      partyCode:
                                          _receiptApprList[index].acccode,
                                      compName: widget.compName,
                                    )));
                            _searchCashRecPayments();
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
                                        Text(_receiptApprList[index].docdate)
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
                                          child: Text(_receiptApprList[index]
                                              .docfinyear),
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
                                          child: Text(
                                              _receiptApprList[index].docno),
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
                                          child: Text(
                                              _receiptApprList[index].party),
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
                                          child: Text(
                                              _receiptApprList[index].paytype),
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
                                          child: Text(
                                              _receiptApprList[index].amount),
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
                                          child: Text(
                                              _receiptApprList[index].insdate),
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
                                          child: Text(
                                              _receiptApprList[index].insuser),
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
                                              Permissions.CASH_RECEIPT)!,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          showAlert(
                                              context,
                                              'Do you Want to Delete this Cash Receipt',
                                              'Confirmation',
                                              ok: 'Ok',
                                              onOk: () {
                                                _receiptDelete(index);
                                              },
                                              notOk: 'Cancel',
                                              onNo: () {
                                                popIt(context);
                                              });
                                        },
                                        child: Text('Delete'),
                                      ),
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
                    builder: (context) => CashReceiptCompSelection()));
            _searchCashRecPayments();
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
      // break;
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
    _receiptApprList.clear();
    if (str.isNotEmpty) {
      _receiptApprList.addAll(_receiptApprMainList.where((a) =>
          a.id.toLowerCase().contains(str.toLowerCase()) ||
          a.docdate.toLowerCase().contains(str.toLowerCase()) ||
          a.docfinyear.toLowerCase().contains(str.toLowerCase()) ||
          a.party.toLowerCase().contains(str.toLowerCase()) ||
          a.amount.toLowerCase().contains(str.toLowerCase()) ||
          a.insdate.toLowerCase().contains(str.toLowerCase()) ||
          a.insuser.toLowerCase().contains(str.toLowerCase()) ||
          a.docno.toLowerCase().contains(str.toLowerCase()) ||
          a.paytype.toLowerCase().contains(str.toLowerCase())));
    } else {
      _receiptApprList.addAll(_receiptApprMainList);
    }
    setState(() {});
  }

  getReceiptApproval() {
    Map jsonBody = {
      'user_id': getUserId(),
      'comp_code': widget.compId,
    };
    if (widget.type == 'emp') {
      jsonBody.addAll({
        'search_user_id': widget.empid,
      });
    }
    WebService.fromApi(AppConfig.cashreceiptapproval, this, jsonBody)
        .callPostService(context);
  }

  _searchCashRecPayments() {
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
    WebService.fromApi(AppConfig.getCashReceipt, this, jsonBody)
        .callPostService(context);
    _isLoading = true;
  }

  _filterCashRecPayments(String string) {
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
    WebService.fromApi(AppConfig.getCashReceipt, this, jsonBody)
        .callPostService(context);
    _isLoading = true;
  }

  _resetPagination() {
    _limit = '30';
    _offset = 0;
    _isLoading = false;
    _isLastPage = false;
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
      _partySearchController.text = formatter.format(selected);
      _filterCashRecPayments(_partySearchController.text.trim());
    }
  }

  _receiptDelete(index) {
    Map jsonBody = {
      'user_id': getUserId(),
      'code_pk': _receiptApprList[index].codePk,
      'item_type': 'cash'
    };
    logIt('_cashDelete $jsonBody');
    WebService.fromApi(AppConfig.cashDelete, this, jsonBody)
        .callPostService(context, onResult: () {
      _receiptApprList.removeAt(index);
      setState(() {});
    });
  }

  void onResponse({Key? key, String? requestCode, String? response}) {
    switch (requestCode) {
      case AppConfig.getCashReceipt:
        {
          _isLoading = false;
          var data = jsonDecode(response!);
          if (data['error'] == 'false') {
            var receiptapprcontent = data['content'] as List;
            if (_offset == 0) {
              _receiptApprList.clear();
              _receiptApprMainList.clear();
            }
            _receiptApprList.addAll(receiptapprcontent
                .map((e) => ReceiptApprovalModel.parsejson(e))
                .toList());
            _receiptApprMainList.addAll(_receiptApprList);
            if (receiptapprcontent.isEmpty ||
                int.parse(_limit) > _receiptApprList.length) _isLastPage = true;
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
