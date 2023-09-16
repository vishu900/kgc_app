import 'dart:convert';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/cash_payment/pending_bill_for_receipt.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:intl/intl.dart';

class EditCashReceipt extends StatefulWidget {
  final String? compId;
  final String? compName;
  final String? partyCode;
  final String? codePk;
  const EditCashReceipt(
      {Key? key,
      required this.compId,
      this.partyCode,
      this.codePk,
      this.compName})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditCashReceipt();
}

class _EditCashReceipt extends State<EditCashReceipt> with NetworkResponse {
  late int index;
  final _formKey = GlobalKey<FormState>();
  final _tableKey = GlobalKey<FormState>();
  final hspacer = SizedBox(width: 16);
  final vspacer = SizedBox(height: 16);

  List<_PartyModel> receiptList = [];
  List<_PayTypeModel> paytypereceiptList = [];
  List<_ApprovalUserModel> approvalreceiptList = [];
  List<ReceiptBillModel> receiptBillList = [];
  String? partyCode = '';
  String? selectedDate;
  String? selectedPartyId;
  String? selectedApprovalUser = '';
  DateTime now = new DateTime.now();
  TextEditingController _docdateController = TextEditingController();
  TextEditingController _docfinYearController = TextEditingController();
  TextEditingController _docnoController = TextEditingController();
  TextEditingController _partyController = TextEditingController();
  TextEditingController _paytypeController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _onaccamountController = TextEditingController();
  TextEditingController _againstbillamountController = TextEditingController();
  TextEditingController _approvaluserController = TextEditingController();
  TextEditingController _companynameController = TextEditingController();

  // TextEditingController _approvedbyController = TextEditingController();
  // TextEditingController _approveddateController = TextEditingController();
  TextEditingController _remarksController = TextEditingController();
  TextEditingController _diffAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    _docdateController.text = DateFormat('dd-MM-yyyy').format(now);
    _docfinYearController.text = '${now.month}/${now.day}/${now.year}';
    if (now.month <= 4) {
      _docfinYearController.text = '${now.year - 1}${now.year}';
    } else {
      _docfinYearController.text = '${now.year}${now.year + 1}';
    }
    _companynameController.text = widget.compName!;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getReceipt();
      _getReceiptDetail();
      //  _getnewReceiptEntry();
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
        appBar: AppBar(title: Text('Edit Cash Receipt')),
        body: GestureDetector(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(8),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    /// DocDate And DocFinYear
                    Row(
                      children: [
                        /// Doc Date
                        Flexible(
                          child: TextFormField(
                            readOnly: true,
                            onTap: () {
                              _selectDate(BuildContext);
                            },
                            controller: _docdateController,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.date_range),
                              border: OutlineInputBorder(),
                              labelText: 'Doc Date',
                              hintText: 'Doc Date',
                              isDense: true,
                            ),
                          ),
                        ),
                        hspacer,

                        /// Doc FinYear
                        Flexible(
                            child: TextFormField(
                          controller: _docfinYearController,
                          readOnly: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Doc FinYear",
                            hintText: 'Doc FinYear',
                            isDense: true,
                          ),
                        ))
                      ],
                    ),
                    vspacer,

                    /// Doc No.
                    TextFormField(
                      readOnly: true,
                      controller: _docnoController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Doc No',
                        hintText: 'Doc No',
                        isDense: true,
                      ),
                    ),
                    vspacer,

                    TextFormField(
                      controller: _companynameController,
                      readOnly: true,
                      decoration: InputDecoration(
                          labelText: 'Company Name',
                          border: OutlineInputBorder(),
                          isDense: true),
                    ),
                    vspacer,

                    /// Party
                    Row(
                      children: [
                        Flexible(
                            child: TypeAheadFormField<_PartyModel>(
                          validator: (value) => _partyController.text.isEmpty
                              ? 'Please Enter Payment Type'
                              : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          itemBuilder:
                              (BuildContext context, _partyController) {
                            return ListTile(
                                title: Text(_partyController.name!),
                                trailing: Text(_partyController.accCode!));
                          },
                          onSuggestionSelected: (sg) {
                            setState(() {
                              _partyController.text = sg.name!;
                              partyCode = sg.accCode;
                              receiptBillList.clear();
                            });
                          },
                          suggestionsCallback: (String pattern) {
                            return _getPartyReceiptList(pattern);
                          },
                          textFieldConfiguration: TextFieldConfiguration(
                              controller: _partyController,
                              textInputAction: TextInputAction.next,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                  labelText: 'Party',
                                  hintText: ' Party',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.keyboard_arrow_down),
                                  isDense: true)),
                        )),
                        Visibility(
                            visible: _partyController.text.isNotEmpty,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _partyController.clear();
                                      receiptBillList.clear();
                                    });
                                  },
                                  child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          color: AppColor.appRed,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Icon(Icons.clear,
                                          size: 14, color: Colors.white))),
                            )),
                      ],
                    ),
                    vspacer,

                    /// Payment Type
                    Row(
                      children: [
                        Flexible(
                            child: TypeAheadFormField<_PayTypeModel>(
                          validator: (value) => selectedPartyId!.isEmpty
                              ? 'Please Enter Payment Type'
                              : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          itemBuilder:
                              (BuildContext context, _paytypeController) {
                            return ListTile(
                                title: Text(_paytypeController.name!));
                          },
                          onSuggestionSelected: (sg) {
                            setState(
                              () {
                                _paytypeController.text = sg.name!;
                                selectedPartyId = sg.code;
                                if (sg.name != 'AGAINST BILL')
                                  receiptBillList.clear();
                                _amountController.clear();
                                _onaccamountController.clear();
                                if (_paytypeController.text.trim() !=
                                    'AGAINST BILL') {
                                  _againstbillamountController.text = '0';
                                } else {
                                  _againstbillamountController.clear();
                                  _onaccamountController.text = '0';
                                }
                              },
                            );
                          },
                          suggestionsCallback: (String pattern) {
                            return _getPayTypeReceiptList(pattern);
                          },
                          textFieldConfiguration: TextFieldConfiguration(
                              controller: _paytypeController,
                              textInputAction: TextInputAction.next,
                              textAlign: TextAlign.start,
                              onChanged: (v) {
                                selectedPartyId = '';
                              },
                              decoration: InputDecoration(
                                  labelText: 'Payment Type',
                                  hintText: ' Payment Type',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.keyboard_arrow_down),
                                  isDense: true)),
                        )),
                        Visibility(
                            visible: _paytypeController.text.isNotEmpty,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _paytypeController.clear();
                                      selectedPartyId = '';
                                    });
                                  },
                                  child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          color: AppColor.appRed,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Icon(Icons.clear,
                                          size: 14, color: Colors.white))),
                            )),
                      ],
                    ),
                    vspacer,

                    /// Amount and ONAcc Amount
                    Row(
                      children: [
                        /// Amount
                        Flexible(
                            child: TextFormField(
                          onChanged: (v) {
                            if (_paytypeController.text.trim() !=
                                'AGAINST BILL') {
                              _againstbillamountController.text = '0';
                              _onaccamountController.text =
                                  _amountController.text.trim();
                            }
                            if (_amountController.text.isNotEmpty &&
                                _onaccamountController.text.isNotEmpty) {
                              _againstbillamountController
                                  .text = (int.parse(_amountController.text) -
                                      int.parse(_onaccamountController.text))
                                  .toString();
                            } else {
                              _againstbillamountController.clear();
                            }
                            _getDiffAmount();
                          },
                          validator: (value) => _amountController.text.isEmpty
                              ? 'Please Enter Amount'
                              : int.parse(_amountController.text.trim()) < 1
                                  ? 'Amount cannot be zero'
                                  : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Amount',
                            hintText: 'Amount',
                            isDense: true,
                          ),
                        )),
                        hspacer,

                        /// On Acc Type
                        Flexible(
                            child: TextFormField(
                          readOnly: _paytypeController.text != 'AGAINST BILL',
                          onChanged: (v) {
                            if (_amountController.text.isNotEmpty &&
                                _onaccamountController.text.isNotEmpty) {
                              _againstbillamountController
                                  .text = (int.parse(_amountController.text) -
                                      int.parse(_onaccamountController.text))
                                  .toString();
                            } else {
                              _againstbillamountController.clear();
                            }
                            _getDiffAmount();
                          },
                          validator: (value) =>
                              _paytypeController.text == 'AGAINST BILL'
                                  ? _onaccamountController.text.isEmpty
                                      ? 'Please Enter On Acc Amount'
                                      : null
                                  : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _onaccamountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'On Acc Amount',
                            hintText: 'On Acc Amount',
                            isDense: true,
                          ),
                        )),
                      ],
                    ),
                    vspacer,

                    /// Against Bill Amount
                    TextFormField(
                      onChanged: (v) {
                        _getDiffAmount();
                        if (_againstbillamountController.text.isNotEmpty &&
                            _onaccamountController.text.isNotEmpty &&
                            _amountController.text.isNotEmpty) {
                          if (_againstbillamountController.text !=
                              (int.parse(_amountController.text) -
                                      int.parse(_onaccamountController.text))
                                  .toString()) {
                            _onaccamountController.text =
                                (int.parse(_amountController.text) -
                                        int.parse(
                                            _againstbillamountController.text))
                                    .toString();
                          }
                          return;
                        }
                      },
                      readOnly: _paytypeController.text != 'AGAINST BILL',
                      validator: (value) =>
                          _paytypeController.text == 'AGAINST BILL'
                              ? value!.trim().isEmpty
                                  ? 'Please Enter Against Bill Amount'
                                  : int.parse(value.trim()) < 1
                                      ? 'Enter valid Against Bill Amount'
                                      : null
                              : null,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _againstbillamountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Against Bill Amount',
                        hintText: 'Against Bill Amount',
                        isDense: true,
                      ),
                    ),
                    vspacer,

                    /// Approval User
                    Row(
                      children: [
                        Flexible(
                            child: TypeAheadFormField<_ApprovalUserModel>(
                          validator: (value) =>
                              _approvaluserController.text.isEmpty
                                  ? 'Please Enter Approval User'
                                  : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          itemBuilder: (BuildContext context, itemData) {
                            return ListTile(title: Text(itemData.name!));
                          },
                          onSuggestionSelected: (sg) {
                            setState(() {
                              _approvaluserController.text = sg.name!;
                              selectedApprovalUser = sg.id;
                            });
                          },
                          suggestionsCallback: (String pattern) {
                            return _getApprovalReceiptList(pattern);
                          },
                          textFieldConfiguration: TextFieldConfiguration(
                              controller: _approvaluserController,
                              textInputAction: TextInputAction.next,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                  labelText: 'Approval User',
                                  hintText: ' Approval User',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.keyboard_arrow_down),
                                  isDense: true)),
                        )),
                        Visibility(
                            visible: _approvaluserController.text.isNotEmpty,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _approvaluserController.clear();
                                      selectedApprovalUser = '';
                                    });
                                  },
                                  child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          color: AppColor.appRed,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Icon(Icons.clear,
                                          size: 14, color: Colors.white))),
                            )),
                      ],
                    ),
                    vspacer,

                    /// Remarks
                    TextFormField(
                      controller: _remarksController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Remarks',
                        hintText: 'Remarks',
                        isDense: true,
                      ),
                    ),
                    vspacer,

                    /// Select Bill
                    Form(
                      key: _tableKey,
                      child: Visibility(
                        visible: _paytypeController.text == 'AGAINST BILL',
                        child: ElevatedButton(
                            onPressed: () async {
                              if (_tableKey.currentState!.validate()) {
                                var back = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PendingBillForReceipt(
                                              compId: widget.compId,
                                              partyCode: partyCode,
                                              selectedItemList: receiptBillList,
                                            )));

                                if (back != null) {
                                  // receiptBillList.clear();
                                  await Future.delayed(
                                      Duration(milliseconds: 350));
                                  if (receiptBillList.isEmpty) {
                                    receiptBillList.addAll(back);
                                  } else {
                                    receiptBillList.insertAll(
                                        receiptBillList.length - 1, back);
                                  }
                                  if (receiptBillList.isNotEmpty) {
                                    if (!receiptBillList.first.isHeader) {
                                      ///Header
                                      receiptBillList.insert(
                                          0,
                                          ReceiptBillModel(
                                              docno: 'Doc Number',
                                              billnumber: 'Bill Number',
                                              billdate: 'Bill Date',
                                              billamount: 'Bill Amount',
                                              amount: 'Amount',
                                              isHeader: true));

                                      ///Footer
                                      receiptBillList.add(ReceiptBillModel(
                                        docno: 'Total',
                                        amount: _getTotal('Amount'),
                                      ));
                                    }
                                  }
                                  setState(() {
                                    if (receiptBillList.isNotEmpty) {
                                      receiptBillList.last.amount =
                                          _getTotal('Amount');
                                    }
                                  });
                                }
                              }
                            },
                            child: Text('Select Bill')),
                      ),
                    ),
                    vspacer,

                    /// Table
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: _buildCells(),
                        ),
                        Flexible(
                          child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                children: _buildRows1(),
                              )),
                        )
                      ],
                    ),
                    vspacer,

                    /// Difference Amount
                    TextFormField(
                      readOnly: true,
                      controller: _diffAmountController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Diff Amount',
                        hintText: 'Diff Amount',
                        isDense: true,
                      ),
                    ),
                    vspacer,

                    /// Print Cash Receipt
                    ElevatedButton(
                        onPressed: () {}, child: Text('Print Cash Receipt')),

                    /// Submit
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            logIt('FormValidation Passed');
                            if (_paytypeController.text == 'AGAINST BILL') {
                              if (receiptBillList.isEmpty) {
                                showAlert(context,
                                    'Please Select Atleast One Bill', 'Error');
                                return;
                              }
                              if (int.parse(_amountController.text) <
                                  double.parse(_getTotal('Amount')).toInt()) {
                                showAlert(
                                    context,
                                    'Entered Amount should not be Greater than  the Item Total  Amount',
                                    'Error');
                                return;
                              } else if (int.parse(
                                      _againstbillamountController.text) !=
                                  double.parse(_getTotal('Amount')).toInt()) {
                                showAlert(
                                    context,
                                    'Against Bill Amount should  be Equal to the Item Total  Amount',
                                    'Error');
                                return;
                              }
                            }
                            _getReceiptSave();
                          } else {
                            logIt('FormValidation Failed');
                          }
                        },
                        child: Text('Save'))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  cleardata() {
    receiptBillList.clear();
    _docnoController.clear();
    _partyController.clear();
    _paytypeController.clear();
    _amountController.clear();
    _onaccamountController.clear();
    _againstbillamountController.clear();
    _approvaluserController.clear();
    _remarksController.clear();
    _diffAmountController.clear();
    setState(() {});
  }

  _getDiffAmount() {
    if (_paytypeController.text.trim() == 'AGAINST BILL' &&
        _againstbillamountController.text.isNotEmpty &&
        _amountController.text.isNotEmpty &&
        _onaccamountController.text.isNotEmpty) {
      logIt(
          '_diffAmountController.text -->${int.parse(_againstbillamountController.text.trim()) - double.parse(_getTotal('Amount'))}');
      _diffAmountController.text =
          (int.parse(_againstbillamountController.text.trim()) -
                  double.parse(_getTotal('Amount')))
              .toString();
    } else {
      _diffAmountController.text = '0';
    }
  }

  _selectDate(buildContext) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null) {
      DateFormat formatter = DateFormat('dd MMM yyyy');
      _docdateController.text = formatter.format(selected);
      _getDocDate(selected.format('yyyy MMM dd'));
    }
  }

  _getDocDate(String docDate) {
    Map jsonBody = {
      'user_id': getUserId(),
      'doc_date': docDate,
      'comp_code': widget.compId,
      'doc_finyear': _docfinYearController.text
    };
    WebService.fromApi(AppConfig.cashDocDate, this, jsonBody)
        .callPostService(context);
  }

  _getTotal(String type) {
    if (receiptBillList.isEmpty)
      return '0';
    else {
      var res = receiptBillList
          .where((element) => !element.isHeader && element.docno != 'Total');
      switch (type) {
        case 'Bill Amount':
          {
            double count = 0.0;
            res.forEach((element) {
              count += element.saleamount.toDouble();
            });
            return count.toStringAsFixed(2);
          }
        // break;
        case 'Amount':
          {
            double count = 0.0;
            res.forEach((element) {
              count += element.amount.toDouble();
            });
            _diffAmountController.text =
                (int.parse(_againstbillamountController.text) - count)
                    .toStringAsFixed(2);
            return count.toStringAsFixed(2);
          }
        //  break;
      }
    }
  }

  _getPartyReceiptList(String str) {
    return receiptList
        .where((i) =>
            i.name!.toLowerCase().startsWith(str.toLowerCase()) ||
            i.accCode!.toLowerCase().contains(str.toLowerCase()))
        .toList();
  }

  _getPayTypeReceiptList(String str) {
    return paytypereceiptList
        .where((i) => i.name!.toLowerCase().startsWith(str.toLowerCase()))
        .toList();
  }

  _getApprovalReceiptList(String str) {
    return approvalreceiptList
        .where((i) => i.name!.toLowerCase().startsWith(str.toLowerCase()))
        .toList();
  }

  _getDelete(String codePk) {
    Map jsonBody = {
      'user_id': getUserId(),
      'code_pk': codePk,
      'item_type': 'receipt'
    };
    WebService.fromApi(AppConfig.getDelete, this, jsonBody)
        .callPostService(context);
  }

  _getReceipt() {
    Map jsonBody = {
      'user_id': getUserId(),
      'comp_code': widget.compId,
    };

    WebService.fromApi(AppConfig.receiptantPartyDetail, this, jsonBody)
        .callPostService(context);
  }

  _getReceiptDetail() {
    Map jsonBody = {
      'user_id': getUserId(),
      'code_pk': widget.codePk,
    };
    WebService.fromApi(AppConfig.cashReceiptDetail, this, jsonBody)
        .callPostService(context);
  }

  _getReceiptSave() {
    try {
      String saleBillHdrPk = '';
      String itemPayamount = '';
      String itemCodePk = '';

      receiptBillList.forEach((element) {
        if (receiptBillList.first != element &&
            receiptBillList.last != element) {
          if (saleBillHdrPk.isEmpty) {
            saleBillHdrPk = element.sendbillhdrpk;
          } else {
            saleBillHdrPk = '$saleBillHdrPk,${element.sendbillhdrpk}';
          }
          if (itemPayamount.isEmpty) {
            itemPayamount = element.amount;
          } else {
            itemPayamount = '$itemPayamount,${element.amount}';
          }
          if (itemCodePk.isEmpty) {
            if (element.isLocal) {
              itemCodePk = '0';
            } else {
              itemCodePk = element.item_code_pk;
            }
          } else {
            if (element.isLocal) {
              itemCodePk = '$itemCodePk,${'0'}';
            } else {
              itemCodePk = '$itemCodePk,${element.item_code_pk}';
            }
          }
        }
      });

      Map jsonBody = {
        'user_id': getUserId(),
        'code_pk': widget.codePk,
        'comp_code': widget.compId,
        'doc_date': _docdateController.text.toDateTime().format('yyyy-MM-dd'),
        'doc_finyear': _docfinYearController.text.trim(),
        'doc_no': _docnoController.text.trim(),
        'acc_code': partyCode,
        'payment_type_code': selectedPartyId,
        'pay_amount': _amountController.text.trim(),
        'on_acc_amount':
            //  _paytypeController.text!='AGAINST BILL'? '0':
            _onaccamountController.text,
        'ag_bill_amount': _paytypeController.text != 'AGAINST BILL'
            ? '0'
            : _againstbillamountController.text,
        'approval_uid': selectedApprovalUser,
        'remarks': _remarksController.text.trim(),
        'item_pay_amount':
            _paytypeController.text == 'AGAINST BILL' ? itemPayamount : '',
        'sale_bill_hdr_pk':
            _paytypeController.text == 'AGAINST BILL' ? saleBillHdrPk : '',
        'item_code_pk':
            _paytypeController.text == 'AGAINST BILL' ? itemCodePk : '',
      };
      logIt('_getReceiptSave -> $jsonBody ');
      WebService.fromApi(AppConfig.cashReceiptSave, this, jsonBody)
          .callPostService(context);
    } catch (err, stack) {
      logIt('on Post-> $err, $stack');
    }
  }

  void onResponse({Key? key, String? requestCode, String? response}) {
    switch (requestCode) {
      case AppConfig.receiptantPartyDetail:
        {
          var data = jsonDecode(response!);
          if (data['error'] == 'false') {
            _docnoController.text = getString(data, 'sr_no');
            var partyreceiptcontent = data['parties_lists'] as List;
            receiptList.addAll(partyreceiptcontent
                .map((e) => _PartyModel.parsejson(e))
                .toList());
            var paytypereceiptcontent = data['payment_types'] as List;
            paytypereceiptList.addAll(paytypereceiptcontent
                .map((e) => _PayTypeModel.parsejson(e))
                .toList());
            var approvalreceiptcontent = data['approved_users'] as List;
            approvalreceiptList.addAll(approvalreceiptcontent
                .map((e) => _ApprovalUserModel.parsejson(e))
                .toList());
            var receiptbillcontent = data[''] as List?;
            if (receiptbillcontent != null) {
              receiptBillList.addAll(receiptbillcontent
                  .map((e) => ReceiptBillModel.parsejson(e))
                  .toList());
              setState(() {});
            }
          }
        }
        break;
      case AppConfig.cashReceiptSave:
        {
          var data = jsonDecode(response!);
          if (data['error'] == 'false') {
            showAlert(context, data['message'], 'Success', onOk: () {
              popIt(context);
            });
          } else {
            showAlert(context, data['message'], 'Failed');
          }
        }
        break;
      case AppConfig.cashReceiptDetail:
        {
          var resp = jsonDecode(response!);
          if (resp['error'] == 'false') {
            var data = resp['payment_detail'];
            _docdateController.text = getString(data, 'doc_date');
            _docfinYearController.text = getString(data, 'doc_finyear');
            _docnoController.text = getString(data, 'doc_no');
            _partyController.text = getString(data['party_detail'], 'name');
            partyCode = getString(data['party_detail'], 'code');
            _paytypeController.text =
                getString(data['payment_type_detail'], 'name');
            selectedPartyId = getString(data['payment_type_detail'], 'code');
            _amountController.text = getString(data, 'pay_amount');
            _onaccamountController.text = getString(data, 'on_acc_amount');
            _againstbillamountController.text =
                getString(data, 'ag_bill_amount');
            _approvaluserController.text =
                getString(data['approval_user'], 'name');
            selectedApprovalUser = getString(data['approval_user'], 'user_id');
            _remarksController.text = getString(data, 'remarks');
            var receiptbillcontent = data['payment_items'] as List?;
            if (receiptbillcontent != null) {
              receiptBillList.addAll(receiptbillcontent
                  .map((e) => ReceiptBillModel.parseItems(e))
                  .toList());
            }
            if (receiptBillList.isNotEmpty) {
              ///Header
              receiptBillList.insert(
                  0,
                  ReceiptBillModel(
                      docno: 'Doc Number',
                      billnumber: 'Bill Number',
                      billdate: 'Bill Date',
                      billamount: 'Bill Amount',
                      amount: 'Amount',
                      isHeader: true));

              ///Footer
              receiptBillList.add(ReceiptBillModel(
                docno: 'Total',
                billamount: _getTotal('Bill Amount'),
                amount: _getTotal('Amount'),
              ));
            }
            setState(() {});
          }
        }
        break;
      case AppConfig.cashDocDate:
        {
          var data = jsonDecode(response!);
          if (data['error'] == 'false') {
            if (getString(data, 'doc_date_valid') == '0') {
              showAlert(
                context,
                'Invalid Date Range',
                'Failed',
                onOk: () {
                  _docdateController.clear();
                },
              );
            }
          } else {
            showAlert(
              context,
              data['message'],
              'Failed',
            );
          }
        }
        break;
      case AppConfig.getDelete:
        {
          var data = jsonDecode(response!);
          if (data['error'] == 'false') {
            showAlert(context, data['message'], 'Success', onOk: () {
              receiptBillList.removeAt(index);
              if (receiptBillList.length <= 2) {
                receiptBillList.clear();
                _diffAmountController.clear();
              }
              setState(() {});
            });
          } else {
            showAlert(
              context,
              data['message'],
              'Failed',
            );
          }
        }
        break;
    }
  }

  /// Vertically
  List<Widget> _buildCells() {
    return List.generate(
        receiptBillList.length,
        (index) => Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Container(
                width: 130,
                height: 50,
                color: receiptBillList[index].isHeader
                    ? AppColor.appRed
                    : receiptBillList[index].isViewing
                        ? AppColor.appRed[500]
                        : Colors.red[100],
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  receiptBillList[index].docno,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: receiptBillList[index].isHeader
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                Visibility(
                                  visible: !receiptBillList[index].isHeader &&
                                      receiptBillList.length - 1 != index,
                                  child: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        if (receiptBillList[index].isLocal) {
                                          receiptBillList.removeAt(index);
                                          if (receiptBillList.length <= 2) {
                                            receiptBillList.clear();
                                            _diffAmountController.clear();
                                          }
                                        } else {
                                          _getDelete(
                                              receiptBillList[index].codePk);
                                          this.index = index;
                                        }
                                        setState(() {});
                                      }),
                                ),
                              ]))
                    ]),
              ),
            ));
  }

  /// Horizontally
  List<Widget> _buildRows1() {
    return List.generate(receiptBillList.length,
        (index) => _eachRow(receiptBillList.length, index));
  }

  Container _eachRow(int count, int index) {
    return Container(
      alignment: Alignment.topCenter,
      child: IntrinsicWidth(
        child: Row(
          children: [
            /// Bill Number
            Padding(
              padding: EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 50,
                width: 130,
                color: receiptBillList[index].isHeader
                    ? AppColor.appRed
                    : receiptBillList[index].isViewing
                        ? AppColor.appRed[500]
                        : Colors.red[100],
                child: Center(
                    child: Text(
                  receiptBillList[index].billnumber,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: receiptBillList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                )),
              ),
            ),

            /// Bill Date
            Padding(
              padding: EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 50,
                width: 130,
                color: receiptBillList[index].isHeader
                    ? AppColor.appRed
                    : receiptBillList[index].isViewing
                        ? AppColor.appRed[500]
                        : Colors.red[100],
                child: Center(
                    child: Text(
                  receiptBillList[index].billdate,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: receiptBillList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                )),
              ),
            ),

            /// Bill Amount
            Padding(
              padding: EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 50,
                width: 130,
                color: receiptBillList[index].isHeader
                    ? AppColor.appRed
                    : receiptBillList[index].isViewing
                        ? AppColor.appRed[500]
                        : Colors.red[100],
                child: Center(
                    child: Text(
                  receiptBillList[index].billamount,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: receiptBillList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                )),
              ),
            ),

            /// Amount
            Padding(
              padding: EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 50,
                width: 130,
                color: receiptBillList[index].isHeader
                    ? AppColor.appRed
                    : receiptBillList[index].isViewing
                        ? AppColor.appRed[500]
                        : Colors.red[100],
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Center(
                    child: receiptBillList[index].isHeader ||
                            receiptBillList[index] == receiptBillList.last
                        ? Text(
                            receiptBillList[index].amount,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                color: receiptBillList[index].isHeader
                                    ? Colors.white
                                    : Colors.black),
                          )
                        : TextFormField(
                            validator: (value) => receiptBillList[index]
                                        .amount
                                        .isEmpty ||
                                    int.parse(receiptBillList[index].amount) < 1
                                ? ' Enter Valid Amount'
                                : null,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (v) {
                              receiptBillList[index].amount = v.trim();
                              receiptBillList.last.amount = _getTotal('Amount');
                              setState(() {});
                            },
                            initialValue: receiptBillList[index].amount,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 0, 0, 0),
                                border: InputBorder.none,
                                isDense: true)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PartyModel {
  String? id, name, accCode;

  _PartyModel({this.id, this.name, this.accCode});

  factory _PartyModel.parsejson(Map<String, dynamic> data) {
    return _PartyModel(
        id: getString(data, 'code'),
        name: getString(data, 'name'),
        accCode: getString(data, 'code'));
  }
}

class _PayTypeModel {
  String? code, name;

  _PayTypeModel({
    this.code,
    this.name,
  });

  factory _PayTypeModel.parsejson(Map<String, dynamic> data) {
    return _PayTypeModel(
        code: getString(data, 'code'), name: getString(data, 'name'));
  }
}

class _ApprovalUserModel {
  String? id, name;

  _ApprovalUserModel({
    this.id,
    this.name,
  });

  factory _ApprovalUserModel.parsejson(Map<String, dynamic> data) {
    return _ApprovalUserModel(
        id: getString(data, 'user_id'), name: getString(data, 'name'));
  }
}