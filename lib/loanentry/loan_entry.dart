import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
class LoanEntry extends StatefulWidget {
  final String? compId;
  const LoanEntry({Key? key, required this.compId,}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _LoanEntry();
}

class _LoanEntry extends State<LoanEntry> {
  final _formKey = GlobalKey<FormState>();
  final hspacer=SizedBox(width: 16);
  final vspacer=SizedBox(height: 16);
  String banktag = 'Cash';
  String paytoother = 'Yes';
  DateTime now=DateTime.now();
  TextEditingController _salmonthcontroller=TextEditingController();
  TextEditingController _docdatecontroller=TextEditingController();
  TextEditingController _empcodecontroller=TextEditingController();
  TextEditingController _otherpersoncontroller=TextEditingController();
  TextEditingController _amountpaidcontroller=TextEditingController();
  TextEditingController _previousloanbalcontroller=TextEditingController();
  TextEditingController _installmentcontroller=TextEditingController();
  TextEditingController _impaccnamecontroller=TextEditingController();
  TextEditingController _ledbalcontroller=TextEditingController();
  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    _docdatecontroller.text=DateFormat('dd-MM-yyyy').format(now);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    });
  }
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('Loan Entry'),),
    body: SingleChildScrollView(
      padding:EdgeInsets.all(8),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            /// Bank Tag
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bank Tag',
                        style:TextStyle(
                            fontSize: 18
                        )
                    ),
                    Row(
              children: [
                Radio(value: 'Cash', groupValue: banktag, onChanged: (dynamic value){
                      setState(() {
                        banktag='Cash';
                      });
                    },
                    ),
                Text('Cash',style: TextStyle(fontSize: 18)),
                Radio(value: 'Bank', groupValue: banktag, onChanged: (dynamic value){
                      setState(() {
                        banktag='Bank';
                      });
                    },
                    ),
                Text(
                    'Bank',style: TextStyle(fontSize: 18)),
              ],
            ),
                  ],
                ),
              ],
            ),
            vspacer,
            /// Sal Month,Doc Date
            Row(
              children: [
                Flexible(
                  child:
                  TextFormField(
                    validator: (value) => _salmonthcontroller.text.isEmpty
                        ? 'Please select Sal Month'
                        : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    controller: _salmonthcontroller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Sal Month',
                      hintText: 'Sal Month',
                      isDense: true
                    ),
                  ),
                ),
            hspacer,
            Flexible(child:
            TextFormField(
              validator: (value) => _docdatecontroller.text.isEmpty
                  ? 'Please select Doc Date'
                  : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              readOnly: true,
              controller: _docdatecontroller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Doc Date',
                  isDense: true
              ),
            ))
              ],
            ),
            vspacer,
            /// Emp Code
            Row(
              children: [
                Flexible(child: TypeAheadFormField<String>(
                  validator: (value) => _empcodecontroller.text.isEmpty
                      ? 'Please select Emp Code'
                      : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  itemBuilder: (BuildContext context, _empcodecontroller) {
                    return ListTile();
                  },
                  onSuggestionSelected: (sg) {
                    setState(() {},
                    );
                  },
                  suggestionsCallback: (String pattern) {
                    return[];
                  },
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: _empcodecontroller,
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                          labelText: 'Emp Code',
                          hintText: 'Emp Code',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          isDense: true)),
                )
                ) ],
            ),
            vspacer,
            /// Pay to Other
           Row(
        children: [
        Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pay to Other',
              style:TextStyle(
                  fontSize: 18
              )
          ),
          Row(
                  children: [
                    Radio(value: 'Yes', groupValue: paytoother, onChanged: (dynamic value){
                      setState(() {
                        paytoother='Yes';
                      });
                    },
                    ),
                    Text(
                        'Yes',style: TextStyle(fontSize: 18)),
                    Radio(value: 'No', groupValue: paytoother, onChanged: (dynamic value){
                      setState(() {
                        paytoother='No';
                      });
                    },
                    ),
                    Text(
                        'No',style: TextStyle(fontSize: 18)),
                  ],
                )
        ],
      ),
        ],
      ),
            vspacer,
            /// Other Person Name
            Row(
              children: [
                Flexible(child: TypeAheadFormField<String>(
                  validator: (value) => _otherpersoncontroller.text.isEmpty
                      ? 'Please select Other Person Name'
                      : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  itemBuilder: (BuildContext context, _otherpersoncontroller) {
                    return ListTile();
                  },
                  onSuggestionSelected: (sg) {
                    setState(() {},
                    );
                  },
                  suggestionsCallback: (String pattern) {
                    return[];
                  },
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: _otherpersoncontroller,
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                          labelText: 'Other Person Name',
                          hintText: 'Other Person Name',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          isDense: true)),
                )
                ) ],
            ),
            vspacer,
            /// Amount Paid,Previous Loan Balance
            Row(
              children: [
                Flexible(
                  child:
                  TextFormField(
                    validator: (value) => _amountpaidcontroller.text.isEmpty
                        ? 'Please select Amount Paid'
                        : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    controller: _amountpaidcontroller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Amount Paid',
                        hintText: 'Amount Paid',
                        isDense: true
                    ),
                  ),
                ),
                hspacer,
                Flexible(child:
                TextFormField(
                  validator: (value) => _previousloanbalcontroller.text.isEmpty
                      ? 'Please select Previous Loan Balance'
                      : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textInputAction: TextInputAction.next,
                  controller: _previousloanbalcontroller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Previous Loan Balance',
                      hintText: 'Previous Loan Balance',
                      isDense: true
                  ),
                ))
              ],
            ),
            vspacer,
            /// Installment
            TextFormField(
              validator: (value) => _installmentcontroller.text.isEmpty
                  ? 'Please select Installment'
                  : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
              controller: _installmentcontroller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Installment',
                  hintText: 'Installment',
                  isDense:true
              ),
            ),
            vspacer,
            /// Imprest Acc Name
            TextFormField(
              validator: (value) => _impaccnamecontroller.text.isEmpty
                  ? 'Please select Imprest Acc Name Name'
                  : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
              controller: _impaccnamecontroller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Imprest Acc Name',
                  hintText: 'Imprest Acc Name',
                  isDense:true
              ),
            ),
            vspacer,
            /// Ledger Balance
            TextFormField(
              validator: (value) => _ledbalcontroller.text.isEmpty
                  ? 'Please select Ledger Balance'
                  : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
              controller: _ledbalcontroller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Ledger Balance',
                  hintText: 'Ledger Balance',
                  isDense:true
              ),
            ),
            vspacer,
            /// Submit
            ElevatedButton(onPressed: (){
              if (_formKey.currentState!.validate()){}
            },
                child: Text('Submit',
                  style: TextStyle(fontSize: 18),
                ))

          ],
        ),
      ),
    ),
  );
}
}
