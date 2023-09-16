import 'dart:convert';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/contactMaster/Contacts.dart';
import 'package:dataproject2/datamodel/EmailModel.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SendEmail extends StatefulWidget {
  final String? codePk;
  final String? partyCode;
  final String? companyName;
  final String? type;

  const SendEmail(
      {Key? key, this.codePk, this.companyName, this.partyCode, this.type})
      : super(key: key);

  @override
  _SendEmailState createState() => _SendEmailState();
}

class _SendEmailState extends State<SendEmail> with NetworkResponse {
  String? accCode = '';
  final _toController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  RegExp emailValidator = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  List<EmailModel> _emailList = [];

  @override
  void initState() {
    super.initState();
    logIt('SendEmail->SqhPk-> ${widget.codePk} ${widget.partyCode} ');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getPrefMessage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Send Email'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                /// To
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _toController,
                        onTap: () {
                          _emailListSheet();
                        },
                        validator: (value) => value!.isEmpty
                            ? 'Enter sender\'s email'
                            : (!emailValidator.hasMatch(value)
                                ? 'Enter valid email'
                                : null),
                        readOnly: true,
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: AppColor.appRed,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            hintText: 'To',
                            suffixIcon: Icon(Icons.arrow_drop_down)),
                      ),
                    ),
                    IconButton(
                        icon: SvgPicture.asset(
                          'images/add-user.svg',
                          width: 28,
                          height: 26,
                        ),
                        onPressed: () async {
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => Contacts(
                                  accCode: widget.partyCode,
                                  companyName: widget.companyName)));

                          /// ToDo : Run init service here
                        }),
                  ],
                ),
                SizedBox(height: 12),

                /// Subject
                TextFormField(
                  controller: _subjectController,
                  validator: (value) => value!.isEmpty ? 'Enter subject' : null,
                  keyboardType: TextInputType.text,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  cursorColor: AppColor.appRed,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(hintText: 'Subject'),
                ),
                SizedBox(height: 12),

                /// Message body
                TextFormField(
                  validator: (value) => value!.isEmpty ? 'Enter message' : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _messageController,
                  keyboardType: TextInputType.multiline,
                  cursorColor: AppColor.appRed,
                  maxLines: 6,
                  minLines: 1,
                  decoration: InputDecoration(hintText: 'Message'),
                ),

                SizedBox(height: 48),

                FloatingActionButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _sendEmail();
                    }
                  },
                  child: Icon(Icons.send),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getPrefMessage() {
    Map jsonBody = {'user_id': getUserId(), 'code_pk': widget.codePk};

    WebService.fromApi(
            widget.type == Qtn
                ? AppConfig.getMailMessage
                : AppConfig.getEnquiryPreText,
            this,
            jsonBody)
        .callPostService(context);
  }

  _sendEmail() {
    Map sendMail = {
      'user_id': getUserId(),
      'code_pk': widget.codePk,
      'to': _toController.text,
      'subject': _subjectController.text,
      'message': _messageController.text,
    };

    WebService.fromApi(
            widget.type == Qtn ? AppConfig.sendMail : AppConfig.sendSaleEnquiry,
            this,
            sendMail)
        .callPostService(context);
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) {
    try {
      switch (requestCode) {
        case AppConfig.getEnquiryPreText:
        case AppConfig.getMailMessage:
          {
            var data = jsonDecode(response!);

            logIt('getMailMessage-> $data');

            if (data['error'] == 'false') {
              /*  accCode = getValue(data['contact_person'], 'acc_code');
              _toController.text =
                  getValue(data['contact_person'], 'email_id'); */

              var contactList = data['contact_person'] as List;
              _emailList.clear();
              _emailList.addAll(
                  contactList.map((e) => EmailModel.fromJSON(e)).toList());

              _subjectController.text = getString(data, 'subject');
              _messageController.text = getString(data, 'message');
              //logIt('Email Lenght-> ${_emailList.length}');
              if (_emailList.length == 1) {
                _toController.text = _emailList[0].email!;
                accCode = _emailList[0].accCode;
              }
            }
          }
          break;
        case AppConfig.sendSaleEnquiry:
        case AppConfig.sendMail:
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
      }
    } catch (err) {
      logIt('onResponse-> $err');
    }
  }

  void _emailListSheet() {
    showModalBottomSheet(
        enableDrag: false,
        isDismissible: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        context: context,
        builder: (BuildContext bc) {
          return Container(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  _emailList.length,
                  (index) => ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${index + 1} ${_emailList[index].email}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    enabled: _emailList[index].isActive!,
                    onTap: () async {
                      setState(() {
                        _toController.text = _emailList[index].email!;
                        accCode = _emailList[index].accCode;
                      });
                      popIt(context);
                    },
                  ),
                ),
              ),
            ),
          ));
        });
  }
}
