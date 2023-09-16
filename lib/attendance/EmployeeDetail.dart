import 'dart:convert';
import 'dart:io';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/digital_signature/digital_signature.dart';
import 'package:dataproject2/fingerprint/fingerprint.dart';
import 'package:dataproject2/imageEditor/ImageEditor.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/quotation/ViewPdf.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
//import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as path;

class EmployeeDetail extends StatefulWidget {
  final String? employeeCode;

  const EmployeeDetail({Key? key, this.employeeCode}) : super(key: key);

  @override
  _EmployeeDetailState createState() => _EmployeeDetailState();
}

class _EmployeeDetailState extends State<EmployeeDetail> with NetworkResponse {
  double? height;
  late double width;

  String employeeCode = '';
  String lsCode = '';
  String employeeName = '';
  String section = '';
  String designation = '';
  String designationName = '';
  String department = '';
  String employeeIncharge = '';
  String dateOfBirth = '';
  String dateOfJoining = '';
  String dateOfLeaving = '';

  String fatherName = '';
  String motherName = '';
  String gender = '';
  String maritalStatus = '';
  String payBasis = '';
  String approvedBy = '';

  String epfNo = '';
  String uanNo = '';
  String esiNo = '';

  String bankAcNo = '';
  String bankIfscCode = '';
  String bankName = '';
  String bankBranchCode = '';
  String spouseName = '';
  String contactNo = '';

  String currentAddress = '';
  String currentCity = '';
  String currentState = '';
  String currentPostOffice = '';
  String currentPinCode = '';

  String permanentAddress = '';
  String permanentCity = '';
  String permanentState = '';
  String permanentPostOffice = '';
  String permanentPinCode = '';

  String nationality = '';
  String religion = '';
  String caste = '';
  String heightCms = '';
  String weightKg = '';
  String bloodGrp = '';
  String identityMark = '';
  String phydisableFlag = '';
  String healthRemarks = '';
  String compCode = '';

  List<ImageModel> image = [];
  List<EmployeeDocModel> _empDocList = [];
  List<EmploymentHistoryModel> emphistorylist = [];
  String fileBaseUrl = '';
  String imageBaseUrl = '';
  int _current = 0;
  File? mFile;
  final picker = ImagePicker();
  bool _isBlocked = false;
  bool? hasPerm = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getEmployeeDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height / 100;
    width = MediaQuery.of(context).size.width / 100;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Employee View'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Visibility(
                visible: image.isNotEmpty,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                      child: IconButton(
                          splashRadius: 20,
                          onPressed: () {
                            _downloadImage();
                          },
                          icon: Icon(Icons.edit)),
                      visible: image.isNotEmpty
                          ? (image[_current].mediaType == 'png' ||
                              image[_current].mediaType == 'jpg')
                          : false,
                    ),
                    IconButton(
                        splashRadius: 20,
                        onPressed: () {
                          _deletePic();
                        },
                        icon: Icon(Icons.delete)),
                  ],
                ),
              ),
              SizedBox(
                height: width * 100 / 1.5,
                child: Container(
                  width: width * 100,
                  height: width * 100 / 1.5,
                  child: image.isNotEmpty
                      ? PhotoViewGallery.builder(
                          backgroundDecoration:
                              BoxDecoration(color: Colors.white),
                          scrollPhysics: const BouncingScrollPhysics(),
                          builder: (BuildContext context, int imgIndex) {
                            return PhotoViewGalleryPageOptions(
                              onTapUp: (context, _, val) {
                                if (image[imgIndex].mediaType!.toLowerCase() ==
                                    'pdf') {
                                  Navigator.of(this.context)
                                      .push(MaterialPageRoute(
                                          builder: (context) => ViewPdf(
                                                pdfUrl:
                                                    '$fileBaseUrl${image[imgIndex].image}',
                                              )));
                                } else {
                                  _downloadPdf(
                                      '$fileBaseUrl${image[imgIndex].image}',
                                      image[imgIndex].mediaType);
                                }
                              },
                              imageProvider: image[imgIndex].mediaType ==
                                          'png' ||
                                      image[imgIndex].mediaType == 'jpg'
                                  ? NetworkImage(
                                      '${image[imgIndex].mediaType == 'jpg' ? fileBaseUrl : imageBaseUrl}${image[imgIndex].image}')
                                  : _getFileIcon(image[imgIndex].mediaType),
                              initialScale:
                                  PhotoViewComputedScale.contained * 0.8,
                            );
                          },
                          onPageChanged: (value) {
                            setState(() {
                              _current = value;
                            });
                          },
                          itemCount: image.length,
                          loadingBuilder: (context, event) => Center(
                            child: Container(
                              width: 40.0,
                              height: 40.0,
                              child: CircularProgressIndicator(
                                value: event == null
                                    ? 0
                                    : event.cumulativeBytesLoaded /
                                        event.expectedTotalBytes!,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.white,
                          child: Center(
                            child: Image.asset('images/noImage.png'),
                          ),
                        ),
                ),
              ),

              /// Carousel Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: image.map((item) {
                  int mIndex = image.indexOf(item);

                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == mIndex
                          ? Color.fromRGBO(0, 0, 0, 0.9)
                          : Color.fromRGBO(0, 0, 0, 0.4),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 10,
              ),

              /// Block
              Visibility(
                visible: hasPerm!,
                child: Visibility(
                  visible: !_isBlocked,
                  child: OutlinedButton(
                      onPressed: () {
                        _blockUnBlock('Y');
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Block',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            Icons.block_sharp,
                            color: AppColor.appRed,
                            size: 20,
                          )
                        ],
                      )),
                ),
              ),

              /// UnBlock
              Visibility(
                visible: hasPerm!,
                child: Visibility(
                  visible: _isBlocked,
                  child: OutlinedButton(
                      onPressed: () {
                        _blockUnBlock('N');
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'UnBlock',
                            style: TextStyle(fontSize: 18, color: Colors.green),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            Icons.done,
                            color: Colors.green,
                            size: 20,
                          )
                        ],
                      )),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Visibility(
                      visible: hasPerm!,
                      child: ElevatedButton(
                          onPressed: () {
                            _uploadUserPic(context);
                          },
                          child: Text('Upload Pic'))),
                  Visibility(
                      visible: hasPerm!,
                      child: ElevatedButton(
                          onPressed: () {
                            _filePickerBottomSheet(context);
                          },
                          child: Text('Upload Doc'))),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Visibility(
                      visible: hasPerm!,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DigitalSignature(
                                        empCode: employeeCode)));
                          },
                          child: Text('Add Signature'))),
                  Visibility(
                      visible: hasPerm!,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FingerPrint(
                                        empCode: employeeCode,
                                        empName: employeeName,
                                        compCode: compCode)));
                          },
                          child: Text('Add Fingerprint'))),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Table(
                border: TableBorder.all(),
                children: [
                  /// Employee Code
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text('Employee Code', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(employeeCode, style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Ls Code
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Ls Code', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(lsCode, style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Name
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Name', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(employeeName, style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Father Name
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text('Father Name', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(fatherName, style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Mother Name
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text('Mother Name', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(motherName, style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Gender
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Gender', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(gender, style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Marital Status
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Marital Status',
                          style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text(maritalStatus, style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Spouse Name
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text('Spouse Name', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(spouseName.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Nationality
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text('Nationality', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(nationality.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Religion
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Religion', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(religion.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Caste
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Caste', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(caste.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Height in CMS
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text('Height(cms)', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(heightCms.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Weight in KG
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Weight(kg)', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(weightKg.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Blood Group
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text('Blood Group', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(bloodGrp.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Identity Mark
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text('Identity Mark', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(identityMark.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Physically Disabled
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Physically Disabled',
                          style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(phydisableFlag.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Health Remarks
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Health Remarks',
                          style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(healthRemarks.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Current Address
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Current Address',
                          style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(currentAddress.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Current City
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text('Current City', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(currentCity.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Current Post Office
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Current Post Office',
                          style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(currentPostOffice.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Current Pin Code
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Current Pin Code',
                          style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(currentPinCode.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Current State
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text('Current State', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(currentState.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Permanent Address
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Permanent Address',
                          style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(permanentAddress.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Permanent City
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Permanent City',
                          style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(permanentCity.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Permanent Post Office
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Permanent Post Office',
                          style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(permanentPostOffice.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Permanent Pin Code
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Permanent Pin Code',
                          style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(permanentPinCode.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Permanent State
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Permanent State',
                          style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(permanentState.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Contact No
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Contact No', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: InkWell(
                        onTap: () async {
                          if (contactNo.trim().isEmpty || contactNo == 'N/A')
                            return;

                          /*    String url = !contactNo.contains('+91')
                              ? 'tel:+91$contactNo'
                              : contactNo; */

                          /*   try {
                            if (await canLaunch(url)) {
                              launch(url);
                            } else {
                              logIt('Cannot Launch the $url');
                            }
                          } catch (err, stack) {
                            logIt('Error-> $err $stack');
                          } */
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            children: [
                              Icon(Icons.call, size: 20),
                              SizedBox(width: 6),
                              Text(contactNo.handleEmpty(),
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),

                  /// Section
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Section', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(section.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Designation
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text('Designation', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(designation.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Designation Name
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Designation Name',
                          style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(designationName.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Department
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Department', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(department.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Employee In charge
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Employee Incharge',
                          style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(employeeIncharge.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /*/// Comp. In charge
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Comp. Incharge',
                          style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text('CXYZ Incharge', style: TextStyle(fontSize: 16)),
                    ),
                  ]),*/

                  /// Pay Basis
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Pay Basis', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(payBasis.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Approved By
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text('Approved By', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(approvedBy.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Date Of Birth
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text('Date Of Birth', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(dateOfBirth.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Date Of Joining
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Date Of Joining',
                          style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(dateOfJoining.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Date Of Leaving
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Date Of Leaving',
                          style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(dateOfLeaving.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Epf No
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Epf No', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(epfNo.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Uan No
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Uan No', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(uanNo.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Esi No
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Esi No', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(esiNo.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Account No
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Account No', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(bankAcNo.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Ifsc Code
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Ifsc Code', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(bankIfscCode.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),

                  /// Branch Code
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text('Branch Code', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(bankBranchCode.handleEmpty(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  ]),
                ],
              ),
              ListView.builder(
                  itemCount: _empDocList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Table(
                      border: TableBorder.all(),
                      children: [
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(_empDocList[index].docName,
                                style: TextStyle(fontSize: 16)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(_empDocList[index].docNo,
                                style: TextStyle(fontSize: 16)),
                          ),
                        ]),
                      ],
                    );
                  }),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('Employment History',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18)),
              ),
              Table(
                  border: TableBorder(
                    left: BorderSide(),
                    top: BorderSide(),
                    right: BorderSide(),
                    verticalInside: BorderSide(),
                  ),
                  children: [
                    TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Emp Code',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'From Date',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'To Date',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ]),
              ListView.builder(
                shrinkWrap: true,
                itemCount: emphistorylist.length,
                itemBuilder: (context, index) =>
                    Table(border: TableBorder.all(), children: [
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          emphistorylist[index].empcode!,
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          emphistorylist[index].fromdate!,
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          emphistorylist[index].todate!,
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  _getFileIcon(String? fileType) {
    switch (fileType) {
      case 'pdf':
        return AssetImage('images/pdf.png');
      case 'jpg':
        return AssetImage('images/jpg.png');
      case 'txt':
        return AssetImage('images/txt.png');
      case 'xlsx':
        return AssetImage('images/xls.png');
      case 'docx':
        return AssetImage('images/doc.png');
    }
  }

  _downloadPdf(String url, String? ext) async {
    List<int> bytes = [];

    String docCode = path.basename(url);

    var documentDirectory = await getTemporaryDirectory();
    var firstPath = documentDirectory.path + "/doc";
    var filePathAndName = documentDirectory.path + '/doc/$docCode';
    await Directory(firstPath).create(recursive: true);
    File file2 = new File(filePathAndName);

    Commons().showProgressbar(this.context);
    logIt('File does not exist -> $file2');

    final request = Request('GET', Uri.parse(url));
    final StreamedResponse res = await Client().send(request);

    res.stream.listen(
      (List<int> newBytes) {
        bytes.addAll(newBytes);
      },
      onDone: () async {
        await file2.writeAsBytes(bytes);
        popIt(this.context);

        /*  var res = await OpenFile.open(file2.absolute.path);

        if (res.type != ResultType.done) {
          showAlert(this.context, res.message, 'Error');
        } */
      },
      onError: (e) {
        popIt(this.context);
        showAlert(this.context, 'Error occurred while downloading', 'Error!');
        print(e);
      },
      cancelOnError: true,
    );
  }

  _downloadImage() async {
    List<int> bytes = [];

    var url = '$imageBaseUrl${image[_current].image}';

    logIt('Download Image-> $url');

    final request = Request('GET', Uri.parse(url));
    final StreamedResponse res = await Client().send(request);

    var documentDirectory = await getTemporaryDirectory();
    var firstPath = documentDirectory.path + "/images";
    var filePathAndName =
        documentDirectory.path + '/images/${image[_current].id}';

    await Directory(firstPath).create(recursive: true);
    File file2 = new File(filePathAndName);
    // final contentLength = res.contentLength;

    res.stream.listen(
      (List<int> newBytes) {
        bytes.addAll(newBytes);
        // final downloadedLength = bytes.length;
        // _progress = downloadedLength / contentLength;
        //setState(() {});
      },
      onDone: () async {
        await file2.writeAsBytes(bytes);
        mFile = file2;

        logIt('Downloaded-> ${file2.absolute.path}');
        var res = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ImageEditor(
                      isUpdate: true,
                      codePk: image[_current].id,
                      mFile: mFile,
                      isDoubleTap: false,
                    )));
        if (res != null) {
          mFile = res['file'];
          _updatePic(res['codePk']);
        }
      },
      onError: (e) {
        // setState(() {
        //   isDownloading = false;
        // });
        showAlert(context, 'Error occurred while downloading', 'Error!');
        print(e);
      },
      cancelOnError: true,
    );
    //file2.writeAsBytesSync(response.bodyBytes); // <-- 3
    // setState(() {
    //   // imageData = filePathAndName;
    //   isDownloading = false;
    // });
  }

  _blockUnBlock(String status) {
    Map jsonBody = {
      'user_id': getUserId(),
      'emp_code': employeeCode,
      'action_type': status
    };
    WebService.fromApi(AppConfig.employeeBlackList, this, jsonBody)
        .callPostService(this.context);
  }

  _getEmployeeDetails() {
    Map jsonBody = {'user_id': getUserId(), 'emp_code': widget.employeeCode};

    WebService.fromApi(AppConfig.getEmployeeDetails, this, jsonBody)
        .callPostService(context);
  }

  _uploadUserPic(context) async {
    var res = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ImageEditor(
                  title: '',
                )));

    if (res != null) {
      mFile = res['file'];
      if (mFile != null) {
        uploadPic('pic');
      }
    }
  }

  void _filePickerBottomSheet(context) {
    showModalBottomSheet(
        enableDrag: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(blurRadius: 10.9, color: Colors.grey[400]!)
            ]),
            height: 170,
            child: new Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: new Text("Select File Options"),
                ),
                Divider(
                  height: 1,
                ),
                new Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(Icons.photo_library),
                                    onPressed: () async {
                                      Navigator.of(context).pop();

                                      var mFile = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ImageEditor()));

                                      if (mFile == null) return;
                                      this.mFile = mFile['file'];

                                      setState(() {});

                                      uploadPic('doc');
                                    }),
                                SizedBox(width: 10),
                                Text("Upload Image")
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 24),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.file_copy_outlined),
                                  onPressed: () async {
                                    Navigator.of(context).pop();

                                    FilePickerResult? result =
                                        await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: [
                                        'pdf',
                                        'doc',
                                        'txt',
                                        'xlsx',
                                        'docx'
                                      ],
                                    );

                                    if (result != null) {
                                      File mFile =
                                          File(result.files.single.path!);

                                      // ignore: unnecessary_null_comparison
                                      if (mFile == null) return;

                                      this.mFile = mFile;

                                      setState(() {});

                                      uploadPic('doc');
                                    }
                                  }),
                              SizedBox(width: 10),
                              Text("Upload File")
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  getImage(ImageSource imgSrc) async {
    //  final pickedFile = await picker.getImage(source: imgSrc);
    final pickedFile = await picker.pickImage(source: imgSrc);

    if (pickedFile != null) {
      mFile = File(pickedFile.path);

      if (mFile != null) {
        uploadPic('pic');
      }
    } else {
      logIt('No image selected.');
    }
  }

  uploadPic(String type) {
    Map jsonBody = {
      'user_id': AppConfig.prefs.getString('user_id'),
      'emp_code': employeeCode,
      'file_type': type == 'doc' ? 'D' : 'E'
    };
    WebService.multipartApi(
            AppConfig.uploadEmployeePic, this, jsonBody, mFile!.absolute.path)
        .callMultipartPostService(context);
  }

  _updatePic(String? codePk) {
    Map jsonBody = {
      'user_id': getUserId(),
      'emp_code': employeeCode,
      'file_type': 'E',
      'code_pk': codePk,
    };

    WebService.multipartApi(
      AppConfig.editEmployeePic,
      this,
      jsonBody,
      mFile!.absolute.path,
    ).callMultipartPostService(context, fileName: 'filename');
  }

  _deletePic() {
    Map jsonBody = {
      'user_id': AppConfig.prefs.getString('user_id'),
      'emp_code': employeeCode,
      'code_pk': image[_current].id
    };

    WebService.fromApi(AppConfig.deleteEmployeePic, this, jsonBody)
        .callPostService(context);
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) {
    try {
      switch (requestCode) {
        case AppConfig.getEmployeeDetails:
          {
            var resp = jsonDecode(response!);

            if (resp['error'] == 'false') {
              image.clear();

              var data = resp['content'];

              compCode = getString(
                  data, 'comp_code'); //=='99'?'3':getString(data, 'comp_code');
              employeeCode = getString(data, 'code');
              lsCode = getString(data, 'ls_code');
              employeeName =
                  '${getString(data, 'first_name')} ${getString(data, 'middle_name')} ${getString(data, 'last_name')}';
              section = getString(data['emp_section_name'], 'name');
              department = getString(data['emp_department_name'], 'name');
              designation =
                  getString(data['emp_designation_code'], 'designation');
              designationName = getString(data['emp_designation_name'], 'name');
              employeeIncharge = '';
              if (getString(data, 'dob').isNotEmpty)
                dateOfBirth = getFormattedDate(getString(data, 'dob'),
                    outFormat: 'dd-MMM-yyyy');
              if (getString(data, 'doj').isNotEmpty)
                dateOfJoining = getFormattedDate(getString(data, 'doj'),
                    outFormat: 'dd-MMM-yyyy');
              if (getString(data, 'dol').isNotEmpty)
                dateOfLeaving = getFormattedDate(getString(data, 'dol'),
                    outFormat: 'dd-MMM-yyyy');
              fileBaseUrl = getString(resp, 'image_tiff_path');
              imageBaseUrl = getString(resp, 'image_png_path');
              payBasis = getString(data, 'pay_basis');

              gender = getString(data['emp_info'], 'sex');
              maritalStatus = getString(data['emp_info'], 'marital_status');
              approvedBy = getString(data, 'approved_user');
              fatherName = getString(data['emp_info'], 'father_name');
              motherName = getString(data['emp_info'], 'mother_name');

              contactNo = getString(data['emp_info'], 'phone');
              spouseName = getString(data['emp_info'], 'spouse_name');
              nationality = getString(data['emp_info'], 'nationality');
              religion = getString(data['emp_info'], 'religion');
              caste = getString(data['emp_info'], 'caste');
              heightCms = getString(data['emp_info'], 'height_cms');
              weightKg = getString(data['emp_info'], 'weight_kg');
              bloodGrp = getString(data['emp_info'], 'blood_grp');
              identityMark = getString(data['emp_info'], 'identity_mark');
              phydisableFlag = getString(data['emp_info'], 'phydisable_flag');
              healthRemarks = getString(data['emp_info'], 'health_remarks');

              currentAddress = getString(data['emp_info'], 'address');
              currentPostOffice = getString(data['emp_info'], 'post_office');
              currentPinCode = getString(data['emp_info'], 'pin_code');
              currentCity =
                  getString(data['emp_info']['addr_city_name'], 'name');
              currentState = getString(
                  data['emp_info']['addr_city_name']['state_name'], 'name');

              permanentAddress = getString(data['emp_info'], 'p_address');
              permanentPostOffice =
                  getString(data['emp_info'], 'p_post_office');
              permanentPinCode = getString(data['emp_info'], 'p_pin_code');
              permanentCity =
                  getString(data['emp_info']['p_addr_city_name'], 'name');
              permanentState = getString(
                  data['emp_info']['p_addr_city_name']['state_name'], 'name');

              epfNo = getString(data['emp_traninfo'], 'epf_no');
              uanNo = getString(data['emp_traninfo'], 'uan_no');
              esiNo = getString(data['emp_traninfo'], 'esi_no');

              bankAcNo = getString(data['emp_traninfo'], 'bank_ac');
              bankIfscCode = getString(data['emp_traninfo'], 'bank_ifsc');
              bankBranchCode =
                  getString(data['emp_traninfo'], 'bank_branch_code');

              _isBlocked = getString(data, 'blacklist') == 'Y';

              var empDocList = data['emp_id_doc'] as List;

              _empDocList.clear();

              _empDocList.addAll(
                  empDocList.map((e) => EmployeeDocModel.fromJson(e)).toList());
              var emphistorycontent = data['emp_working_history'] as List;
              emphistorylist.addAll(emphistorycontent
                  .map((e) => EmploymentHistoryModel.parsejson(e))
                  .toList());

              var _image = resp['images'] as List;

              image.addAll(_image.map((e) => ImageModel.parse(e)).toList());

              hasPerm = ifHasPermission(
                  compCode: compCode, permission: Permissions.EMP_IMAGES);

              setState(() {});
            }
          }
          break;

        case AppConfig.deleteEmployeePic:
          {
            var data = jsonDecode(response!);
            if (data['error'] == 'false') {
              showAlert(context, getString(data, 'message'), 'Success',
                  onOk: () {
                _getEmployeeDetails();
              });
              if (_current > 0) _current--;
            } else {
              showAlert(context, getString(data, 'message'), 'Error', onOk: () {
                setState(() {});
              });
            }
          }
          break;

        case AppConfig.editEmployeePic:
        case AppConfig.uploadEmployeePic:
          {
            var data = jsonDecode(response!);
            if (data['error'] == 'false') {
              showAlert(context, getString(data, 'message'), 'Success',
                  onOk: () {
                _getEmployeeDetails();
              });
            } else {
              showAlert(context, getString(data, 'message'), 'Error', onOk: () {
                setState(() {});
              });
            }
          }
          break;

        case AppConfig.employeeBlackList:
          {
            var data = jsonDecode(response!);
            if (data['error'] == 'false') {
              showAlert(context, data['message'], 'Success', onOk: () {
                setState(() {
                  _isBlocked = !_isBlocked;
                });
              });
            } else {
              showAlert(context, data['message'], 'Error');
            }
          }
          break;
      }
    } catch (err, stack) {
      logIt('onResponse-> $err $stack');
    }
  }
}

class EmployeeDocModel {
  final String id;
  final String docName;
  final String docNo;

  EmployeeDocModel({this.id = '', this.docName = '', this.docNo = ''});

  factory EmployeeDocModel.fromJson(Map<String, dynamic> data) {
    return EmployeeDocModel(
        id: getString(data, 'doc_id'),
        docNo: getString(data, 'doc_no'),
        docName: getString(data['doc_name'], 'doc_name'));
  }
}

class ImageModel {
  final String? id;
  final String? image;
  final String? mediaType;

  ImageModel({this.image, this.id, this.mediaType});

  factory ImageModel.parse(Map<String, dynamic> data) {
    return ImageModel(
        id: getString(data, 'image').split('.')[0],
        image: getString(data, 'image'),
        mediaType: getString(data, 'image').split('.')[1]);
  }
}

class EmploymentHistoryModel {
  String? empcode, fromdate, todate;
  EmploymentHistoryModel({this.empcode, this.fromdate, this.todate});
  factory EmploymentHistoryModel.parsejson(Map<String, dynamic> data) {
    return EmploymentHistoryModel(
      empcode: getString(data, 'emp_code'),
      fromdate: getString(data, 'from_date'),
      todate: getString(data, 'to_date'),
    );
  }
}
