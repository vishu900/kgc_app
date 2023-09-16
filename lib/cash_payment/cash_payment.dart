import 'dart:convert';
import 'package:dataproject2/Commons/Commons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:dataproject2/cash_payment/pending_bill_for_payments.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CashPayment extends StatefulWidget {
  final String? compId;
  final String? partyCode;
  final String? compName;

  const CashPayment({
    Key? key,
    required this.compId,
    this.partyCode,
    this.compName,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CashPayment();
}

class _CashPayment extends State<CashPayment> with NetworkResponse {
  final hspacer = SizedBox(
    width: 16,
  );
  final vspacer = SizedBox(
    height: 16,
  );
  List<PartyModel> partyList = [];
  final _formKey = GlobalKey<FormState>();
  List<PayTypeModel> paytypeModelList = [];
  List<PendingBillModel> pendingBillList = [];
  List<ApprovalUserModel> approvalModelList = [];

  String? partyCode = '';
  String? selectedPartyId = '';
  String? selectedApprovalUser = '';
  // bool isSelected = false;
  String? selectedDate;
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

  TextEditingController _remarksController = TextEditingController();
  TextEditingController _diffAmountController = TextEditingController();
  //TextEditingController _tableamtcontroller = TextEditingController();
  TextEditingController _companynameController = TextEditingController();
  String purHdrPk = '';
  String saleHdrPk = '';

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    _docdateController.text = DateFormat('dd MMM yyyy').format(now);
    _docfinYearController.text = '${now.month}/${now.day}/${now.year}';
    if (now.month <= 4) {
      _docfinYearController.text = '${now.year - 1}${now.year}';
    } else {
      _docfinYearController.text = '${now.year}${now.year + 1}';
    }
    _companynameController.text = widget.compName!;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getParty();
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
        body: SingleChildScrollView(
            padding: EdgeInsets.all(12),
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
                            validator: (value) =>
                                _docdateController.text.isEmpty
                                    ? 'Please Enter Doc Date'
                                    : null,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                      controller: _docnoController,
                      readOnly: true,
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
                    Row(children: [
                      Flexible(
                          child: TypeAheadFormField<PartyModel>(
                        validator: (value) => _partyController.text.isEmpty
                            ? 'Please select Party'
                            : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        itemBuilder: (BuildContext context, _partyController) {
                          return ListTile(
                            title: Text(_partyController.name!),
                          );
                        },
                        suggestionsCallback: (String pattern) {
                          return _getPartyFilteredList(pattern);
                        },
                        onSuggestionSelected: (sg) {
                          setState(() {
                            _partyController.text = sg.name!;
                            partyCode = sg.accCode;
                            pendingBillList.clear();
                          });
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
                                    pendingBillList.clear();
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
                    ]),
                    vspacer,

                    /// Payment Type
                    Row(
                      children: [
                        Flexible(
                            child: TypeAheadFormField<PayTypeModel>(
                          validator: (value) => selectedPartyId!.isEmpty
                              ? 'Please select Payment Type'
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
                                pendingBillList.clear();
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
                            return _getPayTypeFilteredList(pattern);
                          },
                          textFieldConfiguration: TextFieldConfiguration(
                              controller: _paytypeController,
                              textInputAction: TextInputAction.next,
                              textAlign: TextAlign.start,
                              onChanged: (v) {
                                setState(() {
                                  selectedPartyId = '';
                                });
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
                          validator: (value) =>
                              _amountController.text.trim().isEmpty
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
                            // if(_paytypeController.text.trim()== 'AGAINST BILL'&&_againstbillamountController.text.isNotEmpty)
                            // {
                            //   logIt('_diffAmountController.text ->${int.parse(_againstbillamountController.text.trim())-double.parse(_getTotal('Amount'))}');
                            //   _diffAmountController.text=
                            //       ( int.parse(_againstbillamountController.text.trim())-
                            //           double.parse(_getTotal('Amount'))).toString();
                            // }
                            // return;
                          },
                          validator: (value) =>
                              _paytypeController.text == 'AGAINST BILL'
                                  ? _onaccamountController.text.isEmpty
                                      ? 'Please Enter on Amount Type'
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
                              ? _againstbillamountController.text.isEmpty
                                  ? 'Please Enter Against Bill Amount'
                                  : int.parse(_againstbillamountController.text
                                              .trim()) <
                                          1
                                      ? 'Enter Valid Against Bill Amount'
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
                            child: TypeAheadFormField<ApprovalUserModel>(
                          validator: (value) =>
                              _approvaluserController.text.isEmpty
                                  ? 'Please select User ID'
                                  : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          itemBuilder:
                              (BuildContext context, _approvaluserController) {
                            return ListTile(
                                title: Text(_approvaluserController.name!));
                          },
                          onSuggestionSelected: (sg) {
                            setState(() {
                              selectedApprovalUser = sg.id;
                              _approvaluserController.text = sg.name!;
                            });
                          },
                          suggestionsCallback: (String pattern) {
                            return _getApprovalFilteredList(pattern);
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
                    Visibility(
                      visible: _paytypeController.text == 'AGAINST BILL',
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              var back = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PendingBillForPayment(
                                            compId: widget.compId,
                                            partyCode: partyCode,
                                            selectedItemList: pendingBillList,
                                          )));
                              if (back != null) {
                                //pendingBillList.clear();
                                await Future.delayed(
                                    Duration(milliseconds: 350));
                                if (pendingBillList.isEmpty) {
                                  pendingBillList.addAll(back);
                                } else {
                                  pendingBillList.insertAll(
                                      pendingBillList.length - 1, back);
                                }
                                if (pendingBillList.isNotEmpty) {
                                  if (!pendingBillList.first.isHeader) {
                                    ///Header
                                    pendingBillList.insert(
                                        0,
                                        PendingBillModel(
                                            docno: 'Doc Number',
                                            docdate: 'Doc Date',
                                            billnumber: 'Bill Number',
                                            billdate: 'Bill Date',
                                            billamount: 'Bill Amount',
                                            amount: 'Amount',
                                            isHeader: true));

                                    ///Footer
                                    pendingBillList.add(PendingBillModel(
                                      docno: 'Total',
                                      billamount: _getTotal('Bill Amount'),
                                      amount: _getTotal('Amount'),
                                    ));
                                  }
                                }
                                setState(() {
                                  if (pendingBillList.isNotEmpty) {
                                    pendingBillList.last.amount =
                                        _getTotal('Amount');
                                  }
                                });
                              }
                            }
                          },
                          child: Text('Select Bill')),
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

                    /// Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        /// Mail
                        IconButton(
                          icon: SvgPicture.asset(
                            'images/mail_icon.svg',
                            width: 28,
                            height: 28,
                          ),
                          onPressed: () {
                            Fluttertoast.showToast(
                                msg: "Under Development",
                                backgroundColor: AppColor.appRed,
                                textColor: Colors.white,
                                gravity: ToastGravity.CENTER);
                            /*Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SendMAil(codePk:'')));*/
                          },
                        ),
                        hspacer,

                        /// Pdf
                        IconButton(
                          icon: SvgPicture.asset(
                            'images/pdf.svg',
                            width: 35,
                            height: 28,
                          ),
                          onPressed: () {
                            Fluttertoast.showToast(
                                msg: "Under Development",
                                backgroundColor: AppColor.appRed,
                                textColor: Colors.white,
                                gravity: ToastGravity.CENTER);
                          },
                        ),
                      ],
                    ),

                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            logIt('FormValidation Passed');
                            if (_paytypeController.text == 'AGAINST BILL') {
                              if (pendingBillList.isEmpty) {
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
                            _getSubmit();
                          } else {
                            logIt('FormValidation Failed');
                          }
                        },
                        child: Text('Submit'))
                  ],
                ),
              ),
            )),
      ),
    );
  }

  _cleardata() {
    pendingBillList.clear();
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

  _selectDate(BuildContext) async {
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

  String _getTotal(String type) {
    if (pendingBillList.isEmpty)
      return '0';
    else {
      var res = pendingBillList
          .where((element) => !element.isHeader && element.docno != 'Total');
      switch (type) {
        case 'Bill Amount':
          {
            double count = 0.0;
            res.forEach((element) {
              count += element.billamount.toDouble();
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
        // break;
        default:
          return '0';
      }
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

  _getPartyFilteredList(String str) {
    return partyList
        .where((i) => i.name!.toLowerCase().startsWith(str.toLowerCase()))
        .toList();
  }

  _getPayTypeFilteredList(String str) {
    return paytypeModelList
        .where((i) => i.name!.toLowerCase().startsWith(str.toLowerCase()))
        .toList();
  }

  _getApprovalFilteredList(String str) {
    return approvalModelList
        .where((i) => i.name!.toLowerCase().startsWith(str.toLowerCase()))
        .toList();
  }

  _getParty() {
    Map jsonBody = {
      'user_id': getUserId(),
      'comp_code': widget.compId,
    };

    WebService.fromApi(AppConfig.cashPartyDetail, this, jsonBody)
        .callPostService(context);
  }

  _getSubmit() {
    try {
      String salePurHdrPk = '';
      String saleBillHdrPk = '';
      String itemPayAmount = '';
      pendingBillList.forEach((element) {
        if (pendingBillList.first != element &&
            pendingBillList.last != element) {
          if (salePurHdrPk.isEmpty) {
            salePurHdrPk = element.send_pur_hdr_pk;
          } else {
            salePurHdrPk = '$salePurHdrPk,${element.send_pur_hdr_pk}';
          }
          if (saleBillHdrPk.isEmpty) {
            saleBillHdrPk = element.send_bill_hdr_pk;
          } else {
            saleBillHdrPk = '$saleBillHdrPk,${element.send_bill_hdr_pk}';
          }
          if (itemPayAmount.isEmpty) {
            itemPayAmount = element.amount;
          } else {
            itemPayAmount = '$itemPayAmount,${element.amount}';
          }
        }
      });
      Map jsonBody = {
        'user_id': getUserId(),
        'comp_code': widget.compId,
        'doc_finyear': _docfinYearController.text,
        'doc_no': _docnoController.text,
        'doc_date': _docdateController.text,
        'acc_code': partyCode,
        'payment_type_code': selectedPartyId,
        'pay_amount': _amountController.text,
        'on_acc_amount':
            // _paytypeController.text != 'AGAINST BILL' ? '0' :
            _onaccamountController.text,
        'ag_bill_amount': _paytypeController.text != 'AGAINST BILL'
            ? '0'
            : _againstbillamountController.text,
        'approval_uid': selectedApprovalUser,
        'remarks': _remarksController.text,
        'pur_bill_hdr_pk':
            _paytypeController.text == 'AGAINST BILL' ? salePurHdrPk : '0',
        'item_pay_amount': _paytypeController.text == 'AGAINST BILL'
            ? itemPayAmount
            : _amountController.text,
        'sale_bill_hdr_pk':
            _paytypeController.text == 'AGAINST BILL' ? saleBillHdrPk : '0',
      };

      logIt('_getSave -> $jsonBody ');
      WebService.fromApi(AppConfig.cashSubmit, this, jsonBody)
          .callPostService(context);
    } catch (err, stack) {
      logIt('on Post-> $err, $stack');
    }
  }

  void onResponse({Key? key, String? requestCode, String? response}) {
    switch (requestCode) {
      case AppConfig.cashPartyDetail:
        {
          var data = jsonDecode(response!);
          if (data['error'] == 'false') {
            partyList.clear();
            paytypeModelList.clear();
            approvalModelList.clear();
            _docnoController.text = getString(data, 'sr_no');
            _docnoController.text = getString(data, 'sr_no');
            var partycontent = data['parties_lists'] as List;
            partyList.addAll(
                partycontent.map((e) => PartyModel.parsejson(e)).toList());
            var paytypecontent = data['payment_types'] as List;
            paytypeModelList.addAll(
                paytypecontent.map((e) => PayTypeModel.parsejson(e)).toList());
            var approvalcontent = data['approved_users'] as List;
            approvalModelList.addAll(approvalcontent
                .map((e) => ApprovalUserModel.parsejson(e))
                .toList());
            var pendingbillcontent = data['bill_lists'] as List?;
            if (pendingbillcontent != null) {
              pendingBillList.addAll(pendingbillcontent
                  .map((e) => PendingBillModel.parsejson(e))
                  .toList());
              setState(() {});
            }
          }
        }
        break;
      case AppConfig.cashSubmit:
        {
          var data = jsonDecode(response!);
          if (data['error'] == 'false') {
            showAlert(context, data['message'], 'Success', onOk: () {
              _cleardata();
              _getParty();
            });
          } else {
            showAlert(context, data['message'], 'Failed');
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
      case AppConfig.getTableDetails:
        {}
    }
  }

  /// Vertically
  List<Widget> _buildCells() {
    return List.generate(
        pendingBillList.length,
        (index) => Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Container(
                width: 130,
                height: 50,
                color: pendingBillList[index].isHeader
                    ? AppColor.appRed
                    : pendingBillList[index].isViewing
                        ? AppColor.appRed[500]
                        : Colors.red[100],
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(children: [
                            Text(
                              pendingBillList[index].docno,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: pendingBillList[index].isHeader
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ]))
                    ]),
              ),
            ));
  }

  /// Horizontally
  List<Widget> _buildRows1() {
    return List.generate(pendingBillList.length,
        (index) => _eachRow(pendingBillList.length, index));
  }

  Container _eachRow(int count, int index) {
    return Container(
        alignment: Alignment.topCenter,
        child: IntrinsicWidth(
          child: Row(children: [
            /// Doc Date
            Padding(
              padding: EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 50,
                width: 130,
                color: pendingBillList[index].isHeader
                    ? AppColor.appRed
                    : pendingBillList[index].isViewing
                        ? AppColor.appRed[500]
                        : Colors.red[100],
                child: Center(
                    child: Text(
                  pendingBillList[index].docdate,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: pendingBillList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                )),
              ),
            ),

            /// Bill Number
            Padding(
              padding: EdgeInsets.only(left: 4, top: 2),
              child: Container(
                height: 50,
                width: 130,
                color: pendingBillList[index].isHeader
                    ? AppColor.appRed
                    : pendingBillList[index].isViewing
                        ? AppColor.appRed[500]
                        : Colors.red[100],
                child: Center(
                    child: Text(
                  pendingBillList[index].billnumber,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: pendingBillList[index].isHeader
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
                color: pendingBillList[index].isHeader
                    ? AppColor.appRed
                    : pendingBillList[index].isViewing
                        ? AppColor.appRed[500]
                        : Colors.red[100],
                child: Center(
                    child: Text(
                  pendingBillList[index].billdate,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: pendingBillList[index].isHeader
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
                color: pendingBillList[index].isHeader
                    ? AppColor.appRed
                    : pendingBillList[index].isViewing
                        ? AppColor.appRed[500]
                        : Colors.red[100],
                child: Center(
                    child: Text(
                  pendingBillList[index].billamount,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: pendingBillList[index].isHeader
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
                color: pendingBillList[index].isHeader
                    ? AppColor.appRed
                    : pendingBillList[index].isViewing
                        ? AppColor.appRed[500]
                        : Colors.red[100],
                child: Center(
                  child: pendingBillList[index].isHeader ||
                          pendingBillList[index] == pendingBillList.last
                      ? Text(
                          pendingBillList[index].amount,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              color: pendingBillList[index].isHeader
                                  ? Colors.white
                                  : Colors.black),
                        )
                      : TextFormField(
                          validator: (value) => pendingBillList[index]
                                      .amount
                                      .isEmpty ||
                                  int.parse(pendingBillList[index].amount) < 1
                              ? ' Enter Valid Amount'
                              : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (v) {
                            pendingBillList[index].amount = v.trim();
                            pendingBillList.last.amount = _getTotal('Amount');
                            setState(() {});
                          },
                          initialValue: pendingBillList[index].amount,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                              border: InputBorder.none,
                              isDense: true)),
                ),
              ),
            ),
          ]),
        ));
  }
}

class PartyModel {
  String? id, name, accCode;

  PartyModel({this.id, this.name, this.accCode});

  factory PartyModel.parsejson(Map<String, dynamic> data) {
    return PartyModel(
        id: getString(data, 'code'),
        name: getString(data, 'name'),
        accCode: getString(data, 'code'));
  }
}

class PayTypeModel {
  String? code, name;

  PayTypeModel({
    this.code,
    this.name,
  });

  factory PayTypeModel.parsejson(Map<String, dynamic> data) {
    return PayTypeModel(
        code: getString(data, 'code'), name: getString(data, 'name'));
  }
}

class ApprovalUserModel {
  String? id, name;

  ApprovalUserModel({
    this.id,
    this.name,
  });

  factory ApprovalUserModel.parsejson(Map<String, dynamic> data) {
    return ApprovalUserModel(
        id: getString(data, 'user_id'), name: getString(data, 'name'));
  }
}
