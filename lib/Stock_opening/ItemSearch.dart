import 'dart:convert';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/Commons/WebService.dart';
import 'package:dataproject2/Stock_opening/ItemSearchResult.dart';
import 'package:dataproject2/Stock_opening/ViewItemDetail.dart';
import 'package:dataproject2/appConfig/AppConfig.dart';
import 'package:dataproject2/datamodel/CategoryModel.dart';
import 'package:dataproject2/datamodel/SearchUserModel.dart';

import 'package:dataproject2/style/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'model/ItemResultModel.dart';

class ItemSearch extends StatefulWidget {
  final ComingFrom? comingFrom;

  const ItemSearch({Key? key, this.comingFrom}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemSearch();
}

class _ItemSearch extends State<ItemSearch> {
  String tempString = '';

  /// All Variables
  double tabHeight = 60;
  double tabFontSize = 16;
  static const double tabFontLeftPadding = 12.0;
  WidgetsFactory _selectedWidget = WidgetsFactory.Category;
  String? imgBaseUrl = '';

  DateTime selectedFromDt = DateTime.now();
  DateTime selectedToDt = DateTime.now();

  /// Lists
  List<ItemResultModel> resultList = [];
  List<CategoryModel> categoryList = [];
  List<CategoryModel> subCategoryList = [];
  List<CategoryModel> typeList = [];
  List<CategoryModel> partyList = [];
  List<CategoryModel> machineList = [];
  List<CategoryModel> brandList = [];
  List<CategoryModel> countList = [];
  List<CategoryModel> materialList = [];
  List<CategoryModel> processList = [];
  List<CategoryModel> shadeList = [];
  List<CategoryModel> itemList = [];
  List<SearchUserModel> userList = [];
  List<CategoryModel> attributeList = [];

  List<CategoryModel> mCatList = [];
  List<CategoryModel> mSubCatList = [];
  List<CategoryModel> mTypeList = [];
  List<CategoryModel> mPartyList = [];
  List<CategoryModel> mMachineList = [];
  List<CategoryModel> mBrandList = [];
  List<CategoryModel> mCountList = [];
  List<CategoryModel> mMaterialList = [];
  List<CategoryModel> mProcessList = [];
  List<CategoryModel> mShadeList = [];
  List<CategoryModel> mItemList = [];
  List<SearchUserModel> mUserList = [];
  List<CategoryModel> attList = [];

  /// Selected Items
  String? selectedCategory = '';
  String? selectedSubCategory = '';
  String? selectedType = '';
  String? selectedParty = '';
  String? selectedMachine = '';
  String? selectedBrand = '';
  String? selectedCount = '';
  String? selectedMaterial = '';
  String? selectedProcess = '';
  String? selectedShade = '';
  String? selectedItem = '';
  String? selectedUser = '';
  String selectedSimilarItem = '';
  String selectedFromDate = '';
  String selectedToDate = '';

  String? codeCategory = '';
  String? codeSubCategory = '';
  String? codeType = '';
  String? codeParty = '';
  String? codeMachine = '';
  String? codeBrand = '';
  String? codeCount = '';
  String? codeMaterial = '';
  String? codeProcess = '';
  String? codeShade = '';
  String? codeItem = '';
  String? codeUser = '';
  String codeSimilarItem = '';
  String codeFromDate = '';
  String codeToDate = '';

  String? codeAttrValWise = '';

  String? codeMultiAttrWiseHeader = '';
  String? codeMultiAttrWise1 = '';
  String? codeMultiAttrWise2 = '';
  String? codeMultiAttrWise3 = '';
  String? codeMultiAttrWise4 = '';
  String? codeMultiAttrWise5 = '';

  String? codeAttrComp1 = '';
  String? codeAttrComp2 = '';
  String? codeAttrComp3 = '';
  String? codeAttrComp4 = '';
  String? codeAttrComp5 = '';

  /// Controllers
  TextEditingController categoryController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController partyController = TextEditingController();
  TextEditingController machineController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController countController = TextEditingController();
  TextEditingController materialController = TextEditingController();
  TextEditingController processController = TextEditingController();
  TextEditingController shadeController = TextEditingController();
  TextEditingController itemController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController similarController = TextEditingController();

  /// Attribute Value Wise Controllers
  TextEditingController attrValueWiseController = TextEditingController();
  TextEditingController avw1Controller = TextEditingController();
  TextEditingController avw2Controller = TextEditingController();
  TextEditingController avw3Controller = TextEditingController();
  TextEditingController avw4Controller = TextEditingController();
  TextEditingController avw5Controller = TextEditingController();
  TextEditingController avw6Controller = TextEditingController();
  TextEditingController avw7Controller = TextEditingController();
  TextEditingController avw8Controller = TextEditingController();
  TextEditingController avw9Controller = TextEditingController();
  TextEditingController avw10Controller = TextEditingController();
  TextEditingController avw11Controller = TextEditingController();
  TextEditingController avw12Controller = TextEditingController();
  TextEditingController avw13Controller = TextEditingController();
  TextEditingController avw14Controller = TextEditingController();
  TextEditingController avw15Controller = TextEditingController();
  TextEditingController avw16Controller = TextEditingController();
  TextEditingController avw17Controller = TextEditingController();
  TextEditingController avw18Controller = TextEditingController();
  TextEditingController avw19Controller = TextEditingController();
  TextEditingController avw20Controller = TextEditingController();
  TextEditingController avw21Controller = TextEditingController();
  TextEditingController avw22Controller = TextEditingController();
  TextEditingController avw23Controller = TextEditingController();
  TextEditingController avw24Controller = TextEditingController();
  TextEditingController avw25Controller = TextEditingController();

  /// Multi Attribute Wise Controllers
  TextEditingController multiAttrWiseController = TextEditingController();

  ///First Group
  TextEditingController mawAttr1Controller = TextEditingController();
  TextEditingController mawAttrCode1Controller = TextEditingController();
  TextEditingController mawAttrValue1Controller = TextEditingController();

  ///First Group
  TextEditingController mawAttr2Controller = TextEditingController();
  TextEditingController mawAttrCode2Controller = TextEditingController();
  TextEditingController mawAttrValue2Controller = TextEditingController();

  ///First Group
  TextEditingController mawAttr3Controller = TextEditingController();
  TextEditingController mawAttrCode3Controller = TextEditingController();
  TextEditingController mawAttrValue3Controller = TextEditingController();

  ///First Group
  TextEditingController mawAttr4Controller = TextEditingController();
  TextEditingController mawAttrCode4Controller = TextEditingController();
  TextEditingController mawAttrValue4Controller = TextEditingController();

  ///First Group
  TextEditingController mawAttr5Controller = TextEditingController();
  TextEditingController mawAttrCode5Controller = TextEditingController();
  TextEditingController mawAttrValue5Controller = TextEditingController();

  /// Attribute Comparison Controllers
  TextEditingController attrCompController = TextEditingController();

  /// First
  TextEditingController attrCompValue1Controller = TextEditingController();
  TextEditingController attrCompType1Controller = TextEditingController();
  TextEditingController attrCompFrom1Controller = TextEditingController();
  TextEditingController attrCompTo1Controller = TextEditingController();

  /// Second
  TextEditingController attrCompValue2Controller = TextEditingController();
  TextEditingController attrCompType2Controller = TextEditingController();
  TextEditingController attrCompFrom2Controller = TextEditingController();
  TextEditingController attrCompTo2Controller = TextEditingController();

  /// Third
  TextEditingController attrCompValue3Controller = TextEditingController();
  TextEditingController attrCompType3Controller = TextEditingController();
  TextEditingController attrCompFrom3Controller = TextEditingController();
  TextEditingController attrCompTo3Controller = TextEditingController();

  /// Fourth
  TextEditingController attrCompValue4Controller = TextEditingController();
  TextEditingController attrCompType4Controller = TextEditingController();
  TextEditingController attrCompFrom4Controller = TextEditingController();
  TextEditingController attrCompTo4Controller = TextEditingController();

  /// Fourth
  TextEditingController attrCompValue5Controller = TextEditingController();
  TextEditingController attrCompType5Controller = TextEditingController();
  TextEditingController attrCompFrom5Controller = TextEditingController();
  TextEditingController attrCompTo5Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getList();
    });
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios)),
        backgroundColor: Color(0xFFFF0000),
        automaticallyImplyLeading: false,
        title: Text(
          'Item Search',
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              _clearAll();
              setState(() {});
            },
            child: Text(
              'Clear Filters',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          /// Category (Right Side)
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: MediaQuery.of(context).size.width / 1.5,
              color: Colors.white,
              child: _getWidgets(_selectedWidget),
            ),
          ),

          /// Category List (Left Side)
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              width: MediaQuery.of(context).size.width / 3,
              child: Column(
                children: [
                  /// Category
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.Category;
                      if (categoryList.isEmpty) {
                        _getList();
                      }
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.Category
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: tabFontLeftPadding),
                              child: Text(
                                'Category',
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: tabFontSize),
                              ),
                            ),
                            Visibility(
                              visible: selectedCategory!.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// Sub Category
                  GestureDetector(
                    onTap: () {
                      if (selectedCategory!.isNotEmpty) {
                        _selectedWidget = WidgetsFactory.SubCategory;
                        _getSubCategory();
                        setState(() {});
                      } else {
                        Commons.showToast('First Select the category');
                      }
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.SubCategory
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding,
                                    left: tabFontLeftPadding),
                                child: Text(
                                  'Sub Category',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: selectedSubCategory!.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// Type
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.Type;
                      if (typeList.isEmpty) {
                        _getList();
                      }
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.Type
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding,
                                    left: tabFontLeftPadding),
                                child: Text(
                                  'Type',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: selectedType!.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// Item
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.Item;
                      if (itemList.isEmpty) {
                        _getList();
                      }
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.Item
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: tabFontLeftPadding),
                                child: Text(
                                  'Item',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: selectedItem!.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// Party
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.Party;
                      if (partyList.isEmpty) {
                        _getList();
                      }
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.Party
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding,
                                    left: tabFontLeftPadding),
                                child: Text(
                                  'Party',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: selectedParty!.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// Machine
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.Machine;
                      if (machineList.isEmpty) {
                        _getList();
                      }
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.Machine
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding,
                                    left: tabFontLeftPadding),
                                child: Text(
                                  'Machine',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: selectedMachine!.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// Brand
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.Brand;
                      if (brandList.isEmpty) {
                        _getList();
                      }
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.Brand
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding,
                                    left: tabFontLeftPadding),
                                child: Text(
                                  'Brand',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: selectedBrand!.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// Count
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.Count;
                      if (countList.isEmpty) {
                        _getList();
                      }
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.Count
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: tabFontLeftPadding,
                                    right: tabFontLeftPadding),
                                child: Text(
                                  'Count',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: selectedCount!.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// Material
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.Material;
                      if (materialList.isEmpty) {
                        _getList();
                      }
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.Material
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: tabFontLeftPadding),
                                child: Text(
                                  'Material',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: selectedMaterial!.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// Process
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.Process;
                      if (processList.isEmpty) {
                        _getList();
                      }
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.Process
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: tabFontLeftPadding),
                                child: Text(
                                  'Process',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: selectedProcess!.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// Shade
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.Shade;
                      if (shadeList.isEmpty) {
                        _getList();
                      }
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.Shade
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: tabFontLeftPadding),
                                child: Text(
                                  'Shade',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: selectedShade!.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// User
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.User;
                      if (userList.isEmpty) {
                        _getList();
                      }
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.User
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: tabFontLeftPadding),
                                child: Text(
                                  'User',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: selectedUser!.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// Similar Items
                  Visibility(
                    visible: false,
                    child: GestureDetector(
                      onTap: () {
                        _selectedWidget = WidgetsFactory.SimilarItems;
                        setState(() {});
                      },
                      child: Container(
                          color: _selectedWidget == WidgetsFactory.SimilarItems
                              ? Colors.white
                              : Colors.transparent,
                          height: tabHeight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: tabFontLeftPadding),
                                  child: Text(
                                    'Similar Items',
                                    softWrap: true,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: tabFontSize),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible:
                                    similarController.text.trim().isNotEmpty,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: tabFontLeftPadding),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(3),
                                      child: Container(
                                        height: 6,
                                        width: 6,
                                        color: AppColor.appRed,
                                      )),
                                ),
                              )
                            ],
                          )),
                    ),
                  ),

                  /// From Date
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.FromDate;
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.FromDate
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: tabFontLeftPadding),
                                child: Text(
                                  'From Date',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: selectedFromDate.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// To Date
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.ToDate;
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.ToDate
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: tabFontLeftPadding),
                                child: Text(
                                  'To Date',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: selectedToDate.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// Attribute Multiple Value Wise
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.AttributeValueWise;
                      if (attributeList.isEmpty) {
                        _getList();
                      }
                      setState(() {});
                    },
                    child: Container(
                        color:
                            _selectedWidget == WidgetsFactory.AttributeValueWise
                                ? Colors.white
                                : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: tabFontLeftPadding),
                                child: Text(
                                  'Attribute Value Wise',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),

                  ///  Multi Attribute Wise
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.MultiAttributeWise;
                      if (attributeList.isEmpty) {
                        _getList();
                      }
                      setState(() {});
                    },
                    child: Container(
                        color:
                            _selectedWidget == WidgetsFactory.MultiAttributeWise
                                ? Colors.white
                                : Colors.transparent,
                        height: tabHeight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: tabFontLeftPadding,
                              right: tabFontLeftPadding),
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  'Multi Attribute Wise',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                              Visibility(
                                visible: false,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      height: 24,
                                      width: 24,
                                      color: Colors.red,
                                      child: Center(
                                          child: Text(
                                        '9',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      )),
                                    )),
                              )
                            ],
                          ),
                        )),
                  ),

                  /// Attribute Comparison
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.AttributeComparison;
                      if (attributeList.isEmpty) {
                        _getList();
                      }
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget ==
                                WidgetsFactory.AttributeComparison
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: tabFontLeftPadding,
                                    right: tabFontLeftPadding),
                                child: Text(
                                  'Attribute Comparison',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),

                  SizedBox(
                    height: 58,
                  ),
                ],
              ),
            ),
          ),

          /// Bottom Count and Button
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 62,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Item Result Count
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${resultList.length}',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            Text(
                              'items Found',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            )
                          ]),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: ElevatedButton(
                        // color: AppColor.appRed,
                        onPressed: () {
                          if (_validated()) {
                            _getFilteredItems();
                          }
                        },
                        child: Text(
                          'Apply',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _init() {
    attList.clear();

    for (int i = 0; i <= 24; i++) {
      attList.add(CategoryModel(id: '$i', categoryName: 'At${i + 1}'));
    }
  }

  Widget _getWidgets(WidgetsFactory type) {
    switch (type) {
      case WidgetsFactory.Category:
        return categoryList.isEmpty
            ? Center(
                child: Text('No data found.'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                        controller: categoryController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        onChanged: (char) {
                          if (char.trim().isNotEmpty) {
                            var res = categoryList.where((element) => element
                                .categoryName!
                                .toLowerCase()
                                .startsWith(char.trim().toLowerCase()));
                            mCatList.clear();
                            setState(() {
                              mCatList.addAll(res);
                            });
                          } else {
                            mCatList.clear();
                            mCatList.addAll(categoryList);
                            setState(() {});
                          }
                          //  debugPrint('SearchString => $char');
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                categoryController.clear();
                                mCatList.clear();
                                mCatList.addAll(categoryList);
                                setState(() {});
                              },
                              child: Icon(Icons.clear)),
                          isDense: true,
                          labelText: 'Category',
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 3, 12, 3),
                    child: Text(
                      'Total category:${categoryList.length}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: mCatList[index].categoryName,
                              onChanged: (dynamic value) {
                                setState(() {
                                  debugPrint('Category $value');
                                  selectedCategory = value;
                                  codeCategory = mCatList[index].id;
                                  selectedSubCategory = '';
                                  codeSubCategory = '';
                                });
                              },
                              activeColor: AppColor.appRed,
                              groupValue: selectedCategory,
                            ),
                            Text(mCatList[index].categoryName!),
                          ],
                        );
                      },
                      itemCount: mCatList.length,
                    ),
                  ),
                ],
              );

      case WidgetsFactory.SubCategory:
        return subCategoryList.isEmpty
            ? Center(
                child: Text('No data found.'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 12, 12, 3),
                    child: Text(
                      'Total subcategory:${subCategoryList.length}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: subCategoryList[index].categoryName,
                              onChanged: (dynamic value) {
                                setState(() {
                                  selectedSubCategory = value;
                                  codeSubCategory = subCategoryList[index].id;
                                });
                              },
                              activeColor: AppColor.appRed,
                              groupValue: selectedSubCategory,
                            ),
                            Text(subCategoryList[index].categoryName!),
                          ],
                        );
                      },
                      itemCount: subCategoryList.length,
                    ),
                  ),
                ],
              );
      // break;

      case WidgetsFactory.Type:
        return typeList.isEmpty
            ? Center(
                child: Text('No data found.'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                        controller: typeController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        onChanged: (char) {
                          if (char.trim().isNotEmpty) {
                            var res = typeList.where((element) => element
                                .categoryName!
                                .toLowerCase()
                                .startsWith(char.trim().toLowerCase()));
                            mTypeList.clear();
                            setState(() {
                              mTypeList.addAll(res);
                            });
                          } else {
                            mTypeList.clear();
                            mTypeList.addAll(typeList);
                            setState(() {});
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                typeController.clear();
                                mTypeList.clear();
                                mTypeList.addAll(typeList);
                                setState(() {});
                              },
                              child: Icon(Icons.clear)),
                          isDense: true,
                          labelText: 'Type',
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 3, 12, 3),
                    child: Text(
                      'Total type:${typeList.length}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: mTypeList[index].categoryName,
                              onChanged: (dynamic value) {
                                setState(() {
                                  selectedType = value;
                                  codeType = mTypeList[index].id;
                                });
                              },
                              activeColor: AppColor.appRed,
                              groupValue: selectedType,
                            ),
                            Flexible(
                                child: Text(mTypeList[index].categoryName!)),
                          ],
                        );
                      },
                      itemCount: mTypeList.length,
                    ),
                  ),
                ],
              );
      // break;

      case WidgetsFactory.Party:
        return partyList.isEmpty
            ? Center(
                child: Text('No data found.'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                        controller: partyController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        onChanged: (char) {
                          if (char.trim().isNotEmpty) {
                            var res = partyList.where((element) => element
                                .categoryName!
                                .toLowerCase()
                                .startsWith(char.trim().toLowerCase()));
                            mPartyList.clear();
                            setState(() {
                              mPartyList.addAll(res);
                            });
                          } else {
                            mPartyList.clear();
                            mPartyList.addAll(partyList);
                            setState(() {});
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                partyController.clear();
                                mPartyList.clear();
                                mPartyList.addAll(partyList);
                                setState(() {});
                              },
                              child: Icon(Icons.clear)),
                          isDense: true,
                          labelText: 'Party',
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 3, 12, 3),
                    child: Text(
                      'Total party:${partyList.length}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: mPartyList[index].categoryName,
                              onChanged: (dynamic value) {
                                setState(() {
                                  selectedParty = value;
                                  codeParty = mPartyList[index].id;
                                });
                              },
                              activeColor: AppColor.appRed,
                              groupValue: selectedParty,
                            ),
                            Flexible(
                                child: Text(mPartyList[index].categoryName!)),
                          ],
                        );
                      },
                      itemCount: mPartyList.length,
                    ),
                  ),
                ],
              );

      case WidgetsFactory.Machine:
        return machineList.isEmpty
            ? Center(
                child: Text('No data found.'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                        controller: machineController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        onChanged: (char) {
                          if (char.trim().isNotEmpty) {
                            var res = machineList.where((element) => element
                                .categoryName!
                                .toLowerCase()
                                .startsWith(char.trim().toLowerCase()));
                            mMachineList.clear();
                            setState(() {
                              mMachineList.addAll(res);
                            });
                          } else {
                            mMachineList.clear();
                            mMachineList.addAll(machineList);
                            setState(() {});
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                partyController.clear();
                                mMachineList.clear();
                                mMachineList.addAll(machineList);
                                setState(() {});
                              },
                              child: Icon(Icons.clear)),
                          isDense: true,
                          labelText: 'Machine',
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 3, 12, 3),
                    child: Text(
                      'Total machine:${machineList.length}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: mMachineList[index].categoryName,
                              onChanged: (dynamic value) {
                                setState(() {
                                  selectedMachine = value;
                                  codeMachine = mMachineList[index].id;
                                });
                              },
                              activeColor: AppColor.appRed,
                              groupValue: selectedMachine,
                            ),
                            Flexible(
                                child: Text(mMachineList[index].categoryName!)),
                          ],
                        );
                      },
                      itemCount: mMachineList.length,
                    ),
                  ),
                ],
              );

      case WidgetsFactory.Brand:
        return brandList.isEmpty
            ? Center(
                child: Text('No data found.'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                        controller: brandController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        onChanged: (char) {
                          if (char.trim().isNotEmpty) {
                            var res = brandList.where((element) => element
                                .categoryName!
                                .toLowerCase()
                                .startsWith(char.trim().toLowerCase()));
                            mBrandList.clear();
                            setState(() {
                              mBrandList.addAll(res);
                            });
                          } else {
                            mBrandList.clear();
                            mBrandList.addAll(brandList);
                            setState(() {});
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                partyController.clear();
                                mBrandList.clear();
                                mBrandList.addAll(brandList);
                                setState(() {});
                              },
                              child: Icon(Icons.clear)),
                          isDense: true,
                          labelText: 'Brand',
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 3, 12, 3),
                    child: Text(
                      'Total brand:${brandList.length}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: mBrandList[index].categoryName,
                              onChanged: (dynamic value) {
                                setState(() {
                                  selectedBrand = value;
                                  codeBrand = mBrandList[index].id;
                                });
                              },
                              activeColor: AppColor.appRed,
                              groupValue: selectedBrand,
                            ),
                            Flexible(
                                child: Text(mBrandList[index].categoryName!)),
                          ],
                        );
                      },
                      itemCount: mBrandList.length,
                    ),
                  ),
                ],
              );

      case WidgetsFactory.Count:
        return countList.isEmpty
            ? Center(
                child: Text('No data found.'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                        controller: countController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        onChanged: (char) {
                          if (char.trim().isNotEmpty) {
                            var res = countList.where((element) => element
                                .categoryName!
                                .toLowerCase()
                                .startsWith(char.trim().toLowerCase()));
                            mCountList.clear();
                            setState(() {
                              mCountList.addAll(res);
                            });
                          } else {
                            mCountList.clear();
                            mCountList.addAll(countList);
                            setState(() {});
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                countController.clear();
                                mCountList.clear();
                                mCountList.addAll(countList);
                                setState(() {});
                              },
                              child: Icon(Icons.clear)),
                          isDense: true,
                          labelText: 'Count',
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 3, 12, 3),
                    child: Text(
                      'Total count:${countList.length}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: mCountList[index].categoryName,
                              onChanged: (dynamic value) {
                                setState(() {
                                  selectedCount = value;
                                  codeCount = mCountList[index].id;
                                });
                              },
                              activeColor: AppColor.appRed,
                              groupValue: selectedCount,
                            ),
                            Flexible(
                                child: Text(mCountList[index].categoryName!)),
                          ],
                        );
                      },
                      itemCount: mCountList.length,
                    ),
                  ),
                ],
              );

      case WidgetsFactory.Material:
        return materialList.isEmpty
            ? Center(
                child: Text('No data found.'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                        controller: materialController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        onChanged: (char) {
                          if (char.trim().isNotEmpty) {
                            var res = materialList.where((element) => element
                                .categoryName!
                                .toLowerCase()
                                .startsWith(char.trim().toLowerCase()));
                            mMaterialList.clear();
                            setState(() {
                              mMaterialList.addAll(res);
                            });
                          } else {
                            mMaterialList.clear();
                            mMaterialList.addAll(materialList);
                            setState(() {});
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                materialController.clear();
                                mMaterialList.clear();
                                mMaterialList.addAll(materialList);
                                setState(() {});
                              },
                              child: Icon(Icons.clear)),
                          isDense: true,
                          labelText: 'Material',
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 3, 12, 3),
                    child: Text(
                      'Total material:${materialList.length}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: mMaterialList[index].categoryName,
                              onChanged: (dynamic value) {
                                setState(() {
                                  selectedMaterial = value;
                                  codeMaterial = mMaterialList[index].id;
                                });
                              },
                              activeColor: AppColor.appRed,
                              groupValue: selectedMaterial,
                            ),
                            Flexible(
                                child:
                                    Text(mMaterialList[index].categoryName!)),
                          ],
                        );
                      },
                      itemCount: mMaterialList.length,
                    ),
                  ),
                ],
              );

      case WidgetsFactory.Process:
        return processList.isEmpty
            ? Center(
                child: Text('No data found.'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                        controller: processController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        onChanged: (char) {
                          if (char.trim().isNotEmpty) {
                            var res = processList.where((element) => element
                                .categoryName!
                                .toLowerCase()
                                .startsWith(char.trim().toLowerCase()));
                            mProcessList.clear();
                            setState(() {
                              mProcessList.addAll(res);
                            });
                          } else {
                            mProcessList.clear();
                            mProcessList.addAll(processList);
                            setState(() {});
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                processController.clear();
                                mProcessList.clear();
                                mProcessList.addAll(processList);
                                setState(() {});
                              },
                              child: Icon(Icons.clear)),
                          isDense: true,
                          labelText: 'Process',
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 3, 12, 3),
                    child: Text(
                      'Total process:${processList.length}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: mProcessList[index].categoryName,
                              onChanged: (dynamic value) {
                                setState(() {
                                  selectedProcess = value;
                                  codeProcess = mProcessList[index].id;
                                });
                              },
                              activeColor: AppColor.appRed,
                              groupValue: selectedProcess,
                            ),
                            Flexible(
                                child: Text(mProcessList[index].categoryName!)),
                          ],
                        );
                      },
                      itemCount: mProcessList.length,
                    ),
                  ),
                ],
              );

      case WidgetsFactory.Shade:
        return shadeList.isEmpty
            ? Center(
                child: Text('No data found.'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                        controller: shadeController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        onChanged: (char) {
                          if (char.trim().isNotEmpty) {
                            var res = shadeList.where((element) => element
                                .categoryName!
                                .toLowerCase()
                                .startsWith(char.trim().toLowerCase()));
                            mShadeList.clear();
                            setState(() {
                              mShadeList.addAll(res);
                            });
                          } else {
                            mShadeList.clear();
                            mShadeList.addAll(shadeList);
                            setState(() {});
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                shadeController.clear();
                                mShadeList.clear();
                                mShadeList.addAll(shadeList);
                                setState(() {});
                              },
                              child: Icon(Icons.clear)),
                          isDense: true,
                          labelText: 'Shade',
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 3, 12, 3),
                    child: Text(
                      'Total shade:${shadeList.length}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: mShadeList[index].categoryName,
                              onChanged: (dynamic value) {
                                setState(() {
                                  selectedShade = value;
                                  codeShade = mShadeList[index].id;
                                });
                              },
                              activeColor: AppColor.appRed,
                              groupValue: selectedShade,
                            ),
                            Flexible(
                                child: Text(mShadeList[index].categoryName!)),
                          ],
                        );
                      },
                      itemCount: mShadeList.length,
                    ),
                  ),
                ],
              );

      case WidgetsFactory.Item:
        return itemList.isEmpty
            ? Center(
                child: Text('No data found.'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                        controller: itemController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        onChanged: (char) {
                          if (char.trim().isNotEmpty) {
                            var res = itemList.where((element) => element
                                .categoryName!
                                .toLowerCase()
                                .startsWith(char.trim().toLowerCase()));
                            mItemList.clear();
                            setState(() {
                              mItemList.addAll(res);
                            });
                          } else {
                            mItemList.clear();
                            mItemList.addAll(itemList);
                            setState(() {});
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                itemController.clear();
                                mItemList.clear();
                                mItemList.addAll(itemList);
                                setState(() {});
                              },
                              child: Icon(Icons.clear)),
                          isDense: true,
                          labelText: 'Item',
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 3, 12, 3),
                    child: Text(
                      'Total items:${itemList.length}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: mItemList[index].categoryName,
                              onChanged: (dynamic value) {
                                setState(() {
                                  selectedItem = value;
                                  codeItem = mItemList[index].id;
                                });
                              },
                              activeColor: AppColor.appRed,
                              groupValue: selectedItem,
                            ),
                            Flexible(
                                child: Text(mItemList[index].categoryName!)),
                          ],
                        );
                      },
                      itemCount: mItemList.length,
                    ),
                  ),
                ],
              );
      //break;

      case WidgetsFactory.User:
        return userList.isEmpty
            ? Center(
                child: Text('No data found.'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                        controller: userController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        onChanged: (char) {
                          if (char.trim().isNotEmpty) {
                            var res = userList.where((element) => element
                                .categoryName!
                                .toLowerCase()
                                .startsWith(char.trim().toLowerCase()));
                            mUserList.clear();
                            setState(() {
                              mUserList.addAll(res);
                            });
                          } else {
                            mUserList.clear();
                            mUserList.addAll(userList);
                            setState(() {});
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                userController.clear();
                                mUserList.clear();
                                mUserList.addAll(userList);
                                setState(() {});
                              },
                              child: Icon(Icons.clear)),
                          isDense: true,
                          labelText: 'User',
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 3, 12, 3),
                    child: Text(
                      'Total users:${userList.length}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: mUserList[index].categoryName,
                              onChanged: (dynamic value) {
                                setState(() {
                                  selectedUser = value;
                                  codeUser = mUserList[index].id;
                                });
                              },
                              activeColor: AppColor.appRed,
                              groupValue: selectedUser,
                            ),
                            Flexible(
                                child: Text(mUserList[index].categoryName!)),
                          ],
                        );
                      },
                      itemCount: mUserList.length,
                    ),
                  ),
                ],
              );
      //break;

      case WidgetsFactory.SimilarItems:
        return Visibility(
          visible: false,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextFormField(
                    keyboardType: TextInputType.text,
                    controller: similarController,
                    cursorColor: Colors.black,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      labelText: 'Similar Item',
                    )),
              ],
            ),
          ),
        );
      //break;

      case WidgetsFactory.FromDate:
        DateTime now = DateTime.now();
        return Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          child: CalendarDatePicker(
            initialCalendarMode: DatePickerMode.year,
            lastDate: now,
            firstDate: DateTime(2001, 01, 01),
            initialDate: selectedFromDt,
            onDateChanged: (date) {
              selectedFromDt = date;
              selectedFromDate = '${date.year}-${date.month}-${date.day}';
              //  setState(() {});
            },
          ),
        );
      //break;

      case WidgetsFactory.ToDate:
        DateTime now = DateTime.now();
        return Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          child: CalendarDatePicker(
            initialCalendarMode: DatePickerMode.year,
            lastDate: now,
            firstDate: DateTime(2001, 01, 01),
            initialDate: selectedToDt,
            onDateChanged: (date) {
              selectedToDt = date;
              selectedToDate = '${date.year}-${date.month}-${date.day}';
              // setState(() {});
            },
          ),
        );
      // break;

      case WidgetsFactory.AttributeValueWise:
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(10.0, 14, 10.0, 10.0),
          child: Column(
            children: [
              TextFormField(
                  controller: attrValueWiseController,
                  readOnly: true,
                  onTap: () {
                    _attributeSheet(
                        context, attrValueWiseController, 'codeAttrValWise');
                  },
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.keyboard_arrow_down),
                    border: OutlineInputBorder(),
                    isDense: true,
                    labelText: 'Attribute',
                  )),

              /// At1 At2
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: avw1Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'At1',
                        )),
                  ),
                  SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child: TextFormField(
                        controller: avw2Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'At2',
                        )),
                  )
                ],
              ),

              /// At3 At4
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: avw3Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'At3',
                        )),
                  ),
                  SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: avw4Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'At4',
                        )),
                  )
                ],
              ),

              /// At5 At6
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: avw5Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'At5',
                        )),
                  ),
                  SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: avw6Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'At6',
                        )),
                  )
                ],
              ),

              /// At7 At8
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: avw7Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'At7',
                        )),
                  ),
                  SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: avw8Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'At8',
                        )),
                  )
                ],
              ),

              /// At9 At10
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: avw9Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'At9',
                        )),
                  ),
                  SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: avw10Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'At10',
                        )),
                  )
                ],
              ),

              /// At11 At12
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: avw11Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'At11',
                        )),
                  ),
                  SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: avw12Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'At12',
                        )),
                  )
                ],
              ),

              /// At13 At14
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: avw13Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'At13',
                        )),
                  ),
                  SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: avw14Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'At14',
                        )),
                  )
                ],
              ),

              /// At15 At16
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: avw15Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'At15',
                        )),
                  ),
                  SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: avw16Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'At16',
                        )),
                  )
                ],
              ),

              /// At17 At18
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: avw17Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'At17',
                        )),
                  ),
                  SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: avw18Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'At18',
                        )),
                  )
                ],
              ),

              /// At19 At20
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: avw19Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'At19',
                        )),
                  ),
                  SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: avw20Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'At20',
                        )),
                  )
                ],
              ),

              /// At21 At22
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: avw21Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'At21',
                        )),
                  ),
                  SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: avw22Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'At22',
                        )),
                  )
                ],
              ),

              /// At23 At24
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: avw23Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'At23',
                        )),
                  ),
                  SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: avw24Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'At24',
                        )),
                  )
                ],
              ),

              /// At25
              SizedBox(
                height: 10,
              ),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: avw25Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'At25',
                        )),
                  ),
                ],
              ),

              SizedBox(
                height: 58,
              ),
            ],
          ),
        );
      // break;

      case WidgetsFactory.MultiAttributeWise:
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(10.0, 14, 10.0, 10.0),
          child: Column(
            children: [
              /// Attribute Selector
              TextFormField(
                  controller: multiAttrWiseController,
                  readOnly: true,
                  onTap: () {
                    _attListSheet(context, multiAttrWiseController);
                  },
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.keyboard_arrow_down),
                    border: OutlineInputBorder(),
                    isDense: true,
                    hintText: 'Multi Attribute',
                  )),

              SizedBox(
                height: 10,
              ),

              Divider(
                color: Colors.black,
              ),

              SizedBox(
                height: 10,
              ),

              /// First Group
              /// Attribute Field
              TextFormField(
                  readOnly: true,
                  controller: mawAttr1Controller,
                  onTap: () {
                    if (multiAttrWiseController.text.trim().isNotEmpty) {
                      _attributeSheet(
                          context, mawAttr1Controller, 'codeMultiAttrWise1');
                    } else {
                      Commons.showToast('First select the header.');
                    }
                  },
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.keyboard_arrow_down),
                    border: OutlineInputBorder(),
                    isDense: true,
                    labelText: 'Attribute',
                  )),

              SizedBox(
                height: 12,
              ),

              Row(
                children: [
                  /// Attribute Code
                  Expanded(
                    child: TextFormField(
                        readOnly: true,
                        controller: mawAttrCode1Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Att Code',
                        )),
                  ),

                  SizedBox(width: 10),

                  /// Attribute Value
                  Expanded(
                    child: TextFormField(
                        controller: mawAttrValue1Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Att Value',
                        )),
                  )
                ],
              ),

              SizedBox(
                height: 10,
              ),

              Divider(
                color: Colors.black,
              ),

              SizedBox(
                height: 10,
              ),

              /// Second Group
              /// Attribute Field
              TextFormField(
                  readOnly: true,
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.next,
                  controller: mawAttr2Controller,
                  onTap: () {
                    if (multiAttrWiseController.text.trim().isNotEmpty) {
                      _attributeSheet(
                          context, mawAttr2Controller, 'codeMultiAttrWise2');
                    } else {
                      Commons.showToast('First select the header.');
                    }
                  },
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.keyboard_arrow_down),
                    border: OutlineInputBorder(),
                    isDense: true,
                    labelText: 'Attribute',
                  )),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  /// Attribute Code
                  Expanded(
                    child: TextFormField(
                        readOnly: true,
                        controller: mawAttrCode2Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Att Code',
                        )),
                  ),

                  SizedBox(width: 10),

                  /// Attribute Value
                  Expanded(
                    child: TextFormField(
                        controller: mawAttrValue2Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Att Value',
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Colors.black,
              ),
              SizedBox(
                height: 10,
              ),

              /// Third Group
              /// Attribute Field
              TextFormField(
                  readOnly: true,
                  controller: mawAttr3Controller,
                  onTap: () {
                    if (multiAttrWiseController.text.trim().isNotEmpty) {
                      _attributeSheet(
                          context, mawAttr3Controller, 'codeMultiAttrWise3');
                    } else {
                      Commons.showToast('First select the header.');
                    }
                  },
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.keyboard_arrow_down),
                    border: OutlineInputBorder(),
                    isDense: true,
                    labelText: 'Attribute',
                  )),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  /// Attribute Code
                  Expanded(
                    child: TextFormField(
                        readOnly: true,
                        controller: mawAttrCode3Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Att Code',
                        )),
                  ),
                  SizedBox(width: 10),

                  /// Attribute Value
                  Expanded(
                    child: TextFormField(
                        controller: mawAttrValue3Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Att Value',
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),

              Divider(
                color: Colors.black,
              ),

              SizedBox(
                height: 10,
              ),

              /// Fourth Group
              /// Attribute Field
              TextFormField(
                  readOnly: true,
                  controller: mawAttr4Controller,
                  onTap: () {
                    if (multiAttrWiseController.text.trim().isNotEmpty) {
                      _attributeSheet(
                          context, mawAttr4Controller, 'codeMultiAttrWise4');
                    } else {
                      Commons.showToast('First select the header.');
                    }
                  },
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.keyboard_arrow_down),
                    border: OutlineInputBorder(),
                    isDense: true,
                    labelText: 'Attribute',
                  )),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  /// Attribute Code
                  Expanded(
                    child: TextFormField(
                        readOnly: true,
                        controller: mawAttrCode4Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Att Code',
                        )),
                  ),
                  SizedBox(width: 10),

                  /// Attribute Value
                  Expanded(
                    child: TextFormField(
                        controller: mawAttrValue4Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Att Value',
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Colors.black,
              ),
              SizedBox(
                height: 10,
              ),

              /// Fifth Group
              /// Attribute Field
              TextFormField(
                  readOnly: true,
                  controller: mawAttr5Controller,
                  onTap: () {
                    if (multiAttrWiseController.text.trim().isNotEmpty) {
                      _attributeSheet(
                          context, mawAttr5Controller, 'codeMultiAttrWise5');
                    } else {
                      Commons.showToast('First select the header.');
                    }
                  },
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.keyboard_arrow_down),
                    border: OutlineInputBorder(),
                    isDense: true,
                    labelText: 'Attribute',
                  )),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  /// Attribute Code
                  Expanded(
                    child: TextFormField(
                        readOnly: true,
                        controller: mawAttrCode5Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Att Code',
                        )),
                  ),
                  SizedBox(width: 10),

                  /// Attribute Value
                  Expanded(
                    child: TextFormField(
                        controller: mawAttrValue5Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Att Value',
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 78,
              ),
            ],
          ),
        );
      //break;

      case WidgetsFactory.AttributeComparison:
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(10.0, 14, 10.0, 10.0),
          child: Column(
            children: [
              /// First Group
              /// Attribute Field
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        controller: attrCompValue1Controller,
                        readOnly: true,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {
                          _attributeCompSheet(
                              context,
                              attrCompValue1Controller,
                              'codeAttrComp1',
                              'At1',
                              attrCompType1Controller,
                              attrCompFrom1Controller,
                              attrCompTo1Controller);
                        },
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Attribute',
                        )),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TextFormField(
                        controller: attrCompType1Controller,
                        readOnly: true,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {
                          _attListSheet(context, attrCompType1Controller);
                        },
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Type',
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  /// From
                  Expanded(
                    child: TextFormField(
                        controller: attrCompFrom1Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'From',
                        )),
                  ),

                  SizedBox(width: 10),

                  /// To
                  Expanded(
                    child: TextFormField(
                        controller: attrCompTo1Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'To',
                        )),
                  )
                ],
              ),

              SizedBox(
                height: 10,
              ),

              Divider(
                color: Colors.black,
              ),

              SizedBox(
                height: 10,
              ),

              /// Second Group
              /// Attribute Field
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        controller: attrCompValue2Controller,
                        readOnly: true,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {
                          _attributeCompSheet(
                              context,
                              attrCompValue2Controller,
                              'codeAttrComp2',
                              'At1',
                              attrCompType2Controller,
                              attrCompFrom2Controller,
                              attrCompTo2Controller);
                        },
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Attribute',
                        )),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TextFormField(
                        controller: attrCompType2Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {
                          _attListSheet(context, attrCompType2Controller);
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Type',
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  /// From
                  Expanded(
                    child: TextFormField(
                        controller: attrCompFrom2Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'From',
                        )),
                  ),

                  SizedBox(width: 10),

                  /// To
                  Expanded(
                    child: TextFormField(
                        controller: attrCompTo2Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'To',
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),

              Divider(
                color: Colors.black,
              ),

              SizedBox(
                height: 10,
              ),

              /// Third Group
              /// Attribute Field
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        controller: attrCompValue3Controller,
                        readOnly: true,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {
                          _attributeCompSheet(
                              context,
                              attrCompValue3Controller,
                              'codeAttrComp3',
                              'At1',
                              attrCompType3Controller,
                              attrCompFrom3Controller,
                              attrCompTo3Controller);
                        },
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Attribute',
                        )),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TextFormField(
                        controller: attrCompType3Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {
                          _attListSheet(context, attrCompType3Controller);
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Type',
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  /// From
                  Expanded(
                    child: TextFormField(
                        controller: attrCompFrom3Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'From',
                        )),
                  ),

                  SizedBox(width: 10),

                  /// To
                  Expanded(
                    child: TextFormField(
                        controller: attrCompTo3Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'To',
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),

              Divider(
                color: Colors.black,
              ),

              SizedBox(
                height: 10,
              ),

              /// Fourth Group
              /// Attribute Field
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        controller: attrCompValue4Controller,
                        readOnly: true,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {
                          _attributeCompSheet(
                              context,
                              attrCompValue4Controller,
                              'codeAttrComp4',
                              'At1',
                              attrCompType4Controller,
                              attrCompFrom4Controller,
                              attrCompTo4Controller);
                        },
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Attribute',
                        )),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TextFormField(
                        controller: attrCompType4Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {
                          _attListSheet(context, attrCompType4Controller);
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Type',
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  /// From
                  Expanded(
                    child: TextFormField(
                        controller: attrCompFrom4Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'From',
                        )),
                  ),

                  SizedBox(width: 10),

                  /// To
                  Expanded(
                    child: TextFormField(
                        controller: attrCompTo4Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'To',
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),

              Divider(
                color: Colors.black,
              ),

              SizedBox(
                height: 10,
              ),

              /// Fifth Group
              /// Attribute Field
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        controller: attrCompValue5Controller,
                        readOnly: true,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {
                          _attributeCompSheet(
                              context,
                              attrCompValue5Controller,
                              'codeAttrComp5',
                              'At1',
                              attrCompType5Controller,
                              attrCompFrom5Controller,
                              attrCompTo5Controller);
                        },
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Attribute',
                        )),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TextFormField(
                        controller: attrCompType5Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {
                          _attListSheet(context, attrCompType5Controller);
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Type',
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  /// From
                  Expanded(
                    child: TextFormField(
                        controller: attrCompFrom5Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'From',
                        )),
                  ),

                  SizedBox(width: 10),

                  /// To
                  Expanded(
                    child: TextFormField(
                        controller: attrCompTo5Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'To',
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 78,
              ),
            ],
          ),
        );

      default:
        return Center(child: Text('Wrong Widget Parameter'));
    }
  }

  String _getTableName() {
    switch (_selectedWidget) {
      case WidgetsFactory.Category:
        return 'ITEM_CATAGORY';

      case WidgetsFactory.Type:
        return 'ITEM_TYPE';

      case WidgetsFactory.Party:
        return 'ACC_MASTER';

      case WidgetsFactory.Machine:
        return 'MACHINE_MASTER';

      case WidgetsFactory.Brand:
        return 'BRAND_MASTER';

      case WidgetsFactory.Count:
        return 'COUNT_MASTER';

      case WidgetsFactory.Material:
        return 'MATERIAL_MASTER';

      case WidgetsFactory.Process:
        return 'PROCESS_MASTER';

      case WidgetsFactory.Shade:
        return 'SHADE_MASTER';

      case WidgetsFactory.Item:
        return 'ITEM_MASTER';

      case WidgetsFactory.User:
        return 'USERS';

      case WidgetsFactory.AttributeComparison:
      case WidgetsFactory.AttributeValueWise:
      case WidgetsFactory.MultiAttributeWise:
        return 'ATTR_MASTER';

      default:
        return '';
    }
  }

  _getList() {
    String? userId = AppConfig.prefs.getString('user_id');

    Commons().showProgressbar(context);

    var jsonEncoder = jsonEncode(
        <String, dynamic>{'user_id': userId, 'table_name': _getTableName()});

    debugPrint('getList $jsonEncoder');

    WebService()
        .post(context, AppConfig.searchItemParameters, jsonEncoder)
        .then((value) => {Navigator.pop(context), _parse(value!)});
  }

  _parse(Response value) {
    if (value.statusCode == 200) {
      var data = jsonDecode(value.body);

      if (data['error'] == 'false') {
        var contentList = data['content'] as List?;

        switch (_selectedWidget) {
          case WidgetsFactory.Category:
            categoryList.clear();
            categoryList.addAll(
                contentList!.map((e) => CategoryModel.fromJSON(e)).toList());
            mCatList.addAll(categoryList);
            debugPrint('partyList ${categoryList.length}');
            break;

          case WidgetsFactory.Type:
            typeList.clear();
            typeList.addAll(
                contentList!.map((e) => CategoryModel.fromJSON(e)).toList());
            mTypeList.addAll(typeList);
            debugPrint('partyList ${typeList.length}');
            break;

          case WidgetsFactory.Party:
            partyList.clear();
            partyList.addAll(
                contentList!.map((e) => CategoryModel.fromJSON(e)).toList());
            mPartyList.addAll(partyList);
            debugPrint('partyList ${partyList.length}');
            break;

          case WidgetsFactory.Machine:
            machineList.clear();
            machineList.addAll(
                contentList!.map((e) => CategoryModel.fromJSON(e)).toList());
            mMachineList.addAll(machineList);
            debugPrint('partyList ${machineList.length}');
            break;

          case WidgetsFactory.Brand:
            brandList.clear();
            brandList.addAll(
                contentList!.map((e) => CategoryModel.fromJSON(e)).toList());
            mBrandList.addAll(brandList);
            debugPrint('partyList ${brandList.length}');
            break;

          case WidgetsFactory.Count:
            countList.clear();
            countList.addAll(
                contentList!.map((e) => CategoryModel.fromJSON(e)).toList());
            mCountList.addAll(countList);
            debugPrint('partyList ${countList.length}');
            break;

          case WidgetsFactory.Material:
            materialList.clear();
            materialList.addAll(
                contentList!.map((e) => CategoryModel.fromJSON(e)).toList());
            mMaterialList.addAll(materialList);
            debugPrint('partyList ${materialList.length}');
            break;

          case WidgetsFactory.Process:
            processList.clear();
            processList.addAll(
                contentList!.map((e) => CategoryModel.fromJSON(e)).toList());
            mProcessList.addAll(processList);
            debugPrint('partyList ${processList.length}');
            break;

          case WidgetsFactory.Shade:
            shadeList.clear();
            shadeList.addAll(
                contentList!.map((e) => CategoryModel.fromJSON(e)).toList());
            mShadeList.addAll(shadeList);
            debugPrint('partyList ${shadeList.length}');
            break;

          case WidgetsFactory.Item:
            itemList.clear();
            itemList.addAll(
                contentList!.map((e) => CategoryModel.fromJSON(e)).toList());
            mItemList.addAll(itemList);
            debugPrint('partyList ${itemList.length}');
            break;

          case WidgetsFactory.User:
            userList.clear();
            userList.addAll(
                contentList!.map((e) => SearchUserModel.fromJSON(e)).toList());
            mUserList.addAll(userList);
            debugPrint('partyList ${userList.length}');
            break;

          case WidgetsFactory.AttributeComparison:
          case WidgetsFactory.AttributeValueWise:
          case WidgetsFactory.MultiAttributeWise:
            attributeList.clear();
            attributeList.addAll(
                contentList!.map((e) => CategoryModel.fromJSON(e)).toList());

            debugPrint('partyList ${attributeList.length}');

            break;
          case WidgetsFactory.SubCategory:
            break;
          case WidgetsFactory.SimilarItems:
            break;
          case WidgetsFactory.FromDate:
            break;
          case WidgetsFactory.ToDate:
            break;
        }

        setState(() {});
      }
    }
  }

  _getSubCategory() {
    String? userId = AppConfig.prefs.getString('user_id');

    Commons().showProgressbar(context);

    var jsonEncoder = jsonEncode(
        <String, dynamic>{'user_id': userId, 'item_cat_code': codeCategory});

    debugPrint('getList $jsonEncoder');

    WebService()
        .post(context, AppConfig.getSubCategory, jsonEncoder)
        .then((value) => {Navigator.pop(context), _parseSubCategory(value!)});
  }

  _parseSubCategory(Response value) {
    if (value.statusCode == 200) {
      var data = jsonDecode(value.body);

      if (data['error'] == 'false') {
        var contentList = data['content'] as List;

        subCategoryList.clear();
        subCategoryList
            .addAll(contentList.map((e) => CategoryModel.fromJSON(e)).toList());
        mSubCatList.addAll(subCategoryList);
        debugPrint('SubCategory ${subCategoryList.length}');
        setState(() {});
      }
    }
  }

  void _attributeSheet(context, TextEditingController valueController, attId) {
    showModalBottomSheet(
        enableDrag: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 10),
              itemBuilder: (context, index) => ListTile(
                title: Row(
                  //  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${index + 1}.'),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(attributeList[index].categoryName!),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  valueController.text = attributeList[index].categoryName!;
                  //  attId = attributeList[index].id;
                  _addToCodes(attId, attributeList[index].id);
                  debugPrint('SelectedAttCode $attId');
                  Navigator.of(context).pop();
                },
              ),
              itemCount: attributeList.length,
            ),
          );
        });
  }

  void _attributeCompSheet(
      context,
      TextEditingController valueController,
      attId,
      String atValue,
      TextEditingController attrCompTypeController,
      TextEditingController attrCompFromController,
      TextEditingController attrCompToController) {
    showModalBottomSheet(
        enableDrag: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 10),
              itemBuilder: (context, index) => ListTile(
                title: Row(
                  //  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${index + 1}.'),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(attributeList[index].categoryName!),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  valueController.text = attributeList[index].categoryName!;
                  _addToCodes(attId, attributeList[index].id);
                  attrCompTypeController.text = atValue;
                  attrCompFromController.text = '0';
                  attrCompToController.text = '0';
                  Navigator.of(context).pop();
                },
              ),
              itemCount: attributeList.length,
            ),
          );
        });
  }

  _addToCodes(field, data) {
    switch (field) {
      case 'codeAttrValWise':
        codeAttrValWise = data;
        break;
      case 'codeMultiAttrWiseHeader':
        codeMultiAttrWiseHeader = data;
        break;
      case 'codeMultiAttrWise1':
        codeMultiAttrWise1 = data;
        mawAttrCode1Controller.text = data;
        break;
      case 'codeMultiAttrWise2':
        codeMultiAttrWise2 = data;
        mawAttrCode2Controller.text = data;
        break;
      case 'codeMultiAttrWise3':
        codeMultiAttrWise3 = data;
        mawAttrCode3Controller.text = data;
        break;
      case 'codeMultiAttrWise4':
        codeMultiAttrWise4 = data;
        mawAttrCode4Controller.text = data;
        break;
      case 'codeMultiAttrWise5':
        codeMultiAttrWise5 = data;
        mawAttrCode5Controller.text = data;
        break;
      case 'codeAttrComp1':
        codeAttrComp1 = data;
        break;
      case 'codeAttrComp2':
        codeAttrComp2 = data;
        break;
      case 'codeAttrComp3':
        codeAttrComp3 = data;
        break;
      case 'codeAttrComp4':
        codeAttrComp4 = data;
        break;
      case 'codeAttrComp5':
        codeAttrComp5 = data;
        break;
      default:
        print('defaultexcuted');
    }
  }

  void _attListSheet(context, TextEditingController teCont) {
    showModalBottomSheet(
        enableDrag: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 10),
              itemBuilder: (context, index) => ListTile(
                title: Row(
                  children: [
                    //  Text('${index + 1}.'),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(attList[index].categoryName!),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  teCont.text = attList[index].categoryName!;
                  debugPrint('SelectedAttCode ${attList[index].id}');
                  Navigator.of(context).pop();
                },
              ),
              itemCount: attList.length,
            ),
          );
        });
  }

  /// Validation for dependent values
  bool _validated() {
    FocusScope.of(context).unfocus();

    /// Attribute Value Wise
    if (attrValueWiseController.text.isNotEmpty) {
      if (avw1Controller.text.trim().isEmpty &&
          avw2Controller.text.trim().isEmpty &&
          avw3Controller.text.trim().isEmpty &&
          avw4Controller.text.trim().isEmpty &&
          avw5Controller.text.trim().isEmpty &&
          avw6Controller.text.trim().isEmpty &&
          avw7Controller.text.trim().isEmpty &&
          avw8Controller.text.trim().isEmpty &&
          avw9Controller.text.trim().isEmpty &&
          avw10Controller.text.trim().isEmpty &&
          avw11Controller.text.trim().isEmpty &&
          avw12Controller.text.trim().isEmpty &&
          avw13Controller.text.trim().isEmpty &&
          avw14Controller.text.trim().isEmpty &&
          avw15Controller.text.trim().isEmpty &&
          avw16Controller.text.trim().isEmpty &&
          avw17Controller.text.trim().isEmpty &&
          avw18Controller.text.trim().isEmpty &&
          avw19Controller.text.trim().isEmpty &&
          avw20Controller.text.trim().isEmpty &&
          avw21Controller.text.trim().isEmpty &&
          avw22Controller.text.trim().isEmpty &&
          avw23Controller.text.trim().isEmpty &&
          avw24Controller.text.trim().isEmpty &&
          avw25Controller.text.trim().isEmpty) {
        Commons().showAlert(
            context,
            'You have selected Attribute header,please enter atleast one value.',
            'Attribute Value Wise');
        return false;
      }
    }

    /// Multi Attribute Wise
    if (multiAttrWiseController.text.trim().isNotEmpty) {
      if (mawAttr1Controller.text.trim().isNotEmpty) {
        if ((mawAttrCode1Controller.text.trim().isEmpty ||
            mawAttrValue1Controller.text.trim().isEmpty)) {
          Commons().showAlert(
              context,
              'You have selected Attribute header,please enter at least one value.',
              'Multi Attribute Wise');

          return false;
        }
      }
      if (mawAttr2Controller.text.trim().isNotEmpty) {
        if ((mawAttrCode2Controller.text.trim().isEmpty ||
            mawAttrValue2Controller.text.trim().isEmpty)) {
          Commons().showAlert(
              context,
              'You have selected Attribute header,please enter at least one value.',
              'Multi Attribute Wise');

          return false;
        }
      }
      if (mawAttr3Controller.text.trim().isNotEmpty) {
        if ((mawAttrCode3Controller.text.trim().isEmpty ||
            mawAttrValue3Controller.text.trim().isEmpty)) {
          Commons().showAlert(
              context,
              'You have selected Attribute header,please enter at least one value.',
              'Multi Attribute Wise');

          return false;
        }
      }
      if (mawAttr4Controller.text.trim().isNotEmpty) {
        if ((mawAttrCode4Controller.text.trim().isEmpty ||
            mawAttrValue4Controller.text.trim().isEmpty)) {
          Commons().showAlert(
              context,
              'You have selected Attribute header,please enter at least one value.',
              'Multi Attribute Wise');

          return false;
        }
      }
      if (mawAttr5Controller.text.trim().isNotEmpty) {
        if ((mawAttrCode5Controller.text.trim().isEmpty ||
            mawAttrValue5Controller.text.trim().isEmpty)) {
          Commons().showAlert(
              context,
              'You have selected Attribute header,please enter at least one value.',
              'Multi Attribute Wise');

          return false;
        }
      }

      if (mawAttr1Controller.text.trim().isEmpty &&
          mawAttr2Controller.text.trim().isEmpty &&
          mawAttr3Controller.text.trim().isEmpty &&
          mawAttr4Controller.text.trim().isEmpty &&
          mawAttr5Controller.text.trim().isEmpty) {
        Commons().showAlert(
            context,
            'You have selected Attribute header,please enter at least one value.',
            'Multi Attribute Wise');

        return false;
      }
    }

    /// Attribute Comparison

    if (attrCompValue1Controller.text.trim().isNotEmpty ||
        attrCompType1Controller.text.trim().isNotEmpty) {
      if ((attrCompFrom1Controller.text.trim().isEmpty ||
          attrCompTo1Controller.text.trim().isEmpty)) {
        Commons().showAlert(
            context,
            'You have selected Attribute header,please enter at least one value.',
            'Attribute Comparison');

        return false;
      }
    }

    if (attrCompValue2Controller.text.trim().isNotEmpty ||
        attrCompType2Controller.text.trim().isNotEmpty) {
      if ((attrCompFrom2Controller.text.trim().isEmpty ||
          attrCompTo2Controller.text.trim().isEmpty)) {
        Commons().showAlert(
            context,
            'You have selected Attribute header,please enter at least one value.',
            'Attribute Comparison');

        return false;
      }
    }

    if (attrCompValue3Controller.text.trim().isNotEmpty ||
        attrCompType3Controller.text.trim().isNotEmpty) {
      if ((attrCompFrom3Controller.text.trim().isEmpty ||
          attrCompTo3Controller.text.trim().isEmpty)) {
        Commons().showAlert(
            context,
            'You have selected Attribute header,please enter at least one value.',
            'Attribute Comparison');

        return false;
      }
    }

    if (attrCompValue4Controller.text.trim().isNotEmpty ||
        attrCompType4Controller.text.trim().isNotEmpty) {
      if ((attrCompFrom4Controller.text.trim().isEmpty ||
          attrCompTo4Controller.text.trim().isEmpty)) {
        Commons().showAlert(
            context,
            'You have selected Attribute header,please enter at least one value.',
            'Attribute Comparison');

        return false;
      }
    }

    if (attrCompValue5Controller.text.trim().isNotEmpty ||
        attrCompType5Controller.text.trim().isNotEmpty) {
      if ((attrCompFrom5Controller.text.trim().isEmpty ||
          attrCompTo5Controller.text.trim().isEmpty)) {
        Commons().showAlert(
            context,
            'You have selected Attribute header,please enter at least one value.',
            'Attribute Comparison');

        return false;
      }
    }

    return true;
  }

  _clearAll() {
    /// Selected Items
    selectedCategory = '';
    selectedSubCategory = '';
    selectedType = '';
    selectedParty = '';
    selectedMachine = '';
    selectedBrand = '';
    selectedCount = '';
    selectedMaterial = '';
    selectedProcess = '';
    selectedShade = '';
    selectedItem = '';
    selectedUser = '';
    selectedSimilarItem = '';
    selectedFromDate = '';
    selectedToDate = '';

    codeCategory = '';
    codeSubCategory = '';
    codeParty = '';
    codeCount = '';
    codeShade = '';
    codeMachine = '';
    codeMaterial = '';
    codeItem = '';
    codeType = '';
    codeBrand = '';
    codeProcess = '';
    codeUser = '';

    /// Controllers
    categoryController.clear();
    typeController.clear();
    partyController.clear();
    machineController.clear();
    brandController.clear();
    countController.clear();
    materialController.clear();
    processController.clear();
    shadeController.clear();
    itemController.clear();
    userController.clear();
    similarController.clear();

    /// Attribute Value Wise Controllers
    attrValueWiseController.clear();
    avw1Controller.clear();
    avw2Controller.clear();
    avw3Controller.clear();
    avw4Controller.clear();
    avw5Controller.clear();
    avw6Controller.clear();
    avw7Controller.clear();
    avw8Controller.clear();
    avw9Controller.clear();
    avw10Controller.clear();
    avw11Controller.clear();
    avw12Controller.clear();
    avw13Controller.clear();
    avw14Controller.clear();
    avw15Controller.clear();
    avw16Controller.clear();
    avw17Controller.clear();
    avw18Controller.clear();
    avw19Controller.clear();
    avw20Controller.clear();
    avw21Controller.clear();
    avw22Controller.clear();
    avw23Controller.clear();
    avw24Controller.clear();
    avw25Controller.clear();

    codeAttrValWise = '';

    codeMultiAttrWiseHeader = '';
    codeMultiAttrWise1 = '';
    codeMultiAttrWise2 = '';
    codeMultiAttrWise3 = '';
    codeMultiAttrWise4 = '';
    codeMultiAttrWise5 = '';

    codeAttrComp1 = '';
    codeAttrComp2 = '';
    codeAttrComp3 = '';
    codeAttrComp4 = '';
    codeAttrComp5 = '';

    /// Multi Attribute Wise Controllers
    multiAttrWiseController.clear();

    ///First Group
    mawAttr1Controller.clear();
    mawAttrCode1Controller.clear();
    mawAttrValue1Controller.clear();

    ///First Group
    mawAttr2Controller.clear();
    mawAttrCode2Controller.clear();
    mawAttrValue2Controller.clear();

    ///First Group
    mawAttr3Controller.clear();
    mawAttrCode3Controller.clear();
    mawAttrValue3Controller.clear();

    ///First Group
    mawAttr4Controller.clear();
    mawAttrCode4Controller.clear();
    mawAttrValue4Controller.clear();

    ///First Group
    mawAttr5Controller.clear();
    mawAttrCode5Controller.clear();
    mawAttrValue5Controller.clear();

    /// Attribute Comparison Controllers
    attrCompController.clear();

    /// First
    attrCompValue1Controller.clear();
    attrCompType1Controller.clear();
    attrCompFrom1Controller.clear();
    attrCompTo1Controller.clear();

    /// Second
    attrCompValue2Controller.clear();
    attrCompType2Controller.clear();
    attrCompFrom2Controller.clear();
    attrCompTo2Controller.clear();

    /// Third
    attrCompValue3Controller.clear();
    attrCompType3Controller.clear();
    attrCompFrom3Controller.clear();
    attrCompTo3Controller.clear();

    /// Fourth
    attrCompValue4Controller.clear();
    attrCompType4Controller.clear();
    attrCompFrom4Controller.clear();
    attrCompTo4Controller.clear();

    /// Fourth
    attrCompValue5Controller.clear();
    attrCompType5Controller.clear();
    attrCompFrom5Controller.clear();
    attrCompTo5Controller.clear();

    mCatList.clear();
    mCatList.addAll(categoryList);

    mSubCatList.clear();
    mSubCatList.addAll(subCategoryList);

    mTypeList.clear();
    mTypeList.addAll(typeList);

    mPartyList.clear();
    mPartyList.addAll(partyList);

    mMachineList.clear();
    mMachineList.addAll(machineList);

    mBrandList.clear();
    mBrandList.addAll(brandList);

    mCountList.clear();
    mCountList.addAll(countList);

    mMaterialList.clear();
    mMaterialList.addAll(materialList);

    mProcessList.clear();
    mProcessList.addAll(processList);

    mShadeList.clear();
    mShadeList.addAll(shadeList);

    mItemList.clear();
    mItemList.addAll(itemList);

    mUserList.clear();
    mUserList.addAll(userList);

    selectedFromDt = DateTime.now();
    selectedToDt = DateTime.now();

    FocusScope.of(context).unfocus();
  }

  _getFilteredItems() {
    /// All Empty Validation
    if (codeCategory!.isEmpty &&
        codeSubCategory!.isEmpty &&
        codeParty!.isEmpty &&
        codeCount!.isEmpty &&
        codeShade!.isEmpty &&
        codeMachine!.isEmpty &&
        codeMaterial!.isEmpty &&
        codeItem!.isEmpty &&
        codeType!.isEmpty &&
        codeBrand!.isEmpty &&
        codeProcess!.isEmpty &&
        codeUser!.isEmpty &&
        selectedFromDate.isEmpty &&
        selectedToDate.isEmpty &&
        attrValueWiseController.text.trim().isEmpty &&
        multiAttrWiseController.text.trim().isEmpty &&
        attrCompValue1Controller.text.trim().isEmpty &&
        attrCompValue2Controller.text.trim().isEmpty &&
        attrCompValue3Controller.text.trim().isEmpty &&
        attrCompValue4Controller.text.trim().isEmpty &&
        attrCompValue5Controller.text.trim().isEmpty) {
      Commons()
          .showAlert(context, 'Please select at least one value.', 'Error');
      return null;
    }

    Commons().showProgressbar(context);

    String? userId = AppConfig.prefs.getString('user_id');

    Map<String, dynamic> data = {
      'user_id': userId,
      'category': codeCategory,
      'sub_cat': codeSubCategory,
      'party': codeParty,
      'count': codeCount,
      'shade': codeShade,
      'machine': codeMachine,
      'material': codeMaterial,
      'item_id': codeItem,
      'type': codeType,
      'brand': codeBrand,
      'process': codeProcess,
      'search_user_id': codeUser,
      'from_date': selectedFromDate,
      'to_date': selectedToDate,
    };

    if (attrValueWiseController.text.trim().isNotEmpty) {
      var dt = {
        'attr_multiple_value_wise_status': 1,
        'attr_code': codeAttrValWise,
        'at1': avw1Controller.text.trim().toLowerCase(),
        'at2': avw2Controller.text.trim().toLowerCase(),
        'at3': avw3Controller.text.trim().toLowerCase(),
        'at4': avw4Controller.text.trim().toLowerCase(),
        'at5': avw5Controller.text.trim().toLowerCase(),
        'at6': avw6Controller.text.trim().toLowerCase(),
        'at7': avw7Controller.text.trim().toLowerCase(),
        'at8': avw8Controller.text.trim().toLowerCase(),
        'at9': avw9Controller.text.trim().toLowerCase(),
        'at10': avw10Controller.text.trim().toLowerCase(),
        'at11': avw11Controller.text.trim().toLowerCase(),
        'at12': avw12Controller.text.trim().toLowerCase(),
        'at13': avw13Controller.text.trim().toLowerCase(),
        'at14': avw14Controller.text.trim().toLowerCase(),
        'at15': avw15Controller.text.trim().toLowerCase(),
        'at16': avw16Controller.text.trim().toLowerCase(),
        'at17': avw17Controller.text.trim().toLowerCase(),
        'at18': avw18Controller.text.trim().toLowerCase(),
        'at19': avw19Controller.text.trim().toLowerCase(),
        'at20': avw20Controller.text.trim().toLowerCase(),
        'at21': avw21Controller.text.trim().toLowerCase(),
        'at22': avw22Controller.text.trim().toLowerCase(),
        'at23': avw23Controller.text.trim().toLowerCase(),
        'at24': avw24Controller.text.trim().toLowerCase(),
        'at25': avw25Controller.text.trim().toLowerCase(),
      };

      data.addAll(dt);
    }

    if (multiAttrWiseController.text.trim().isNotEmpty) {
      var dt = {
        'attr_multiple_wise_status': 1,
        'attr_multiple_wise_type':
            multiAttrWiseController.text.trim().toLowerCase(),
        'attr_multi_code': _getAttrMultiCode(),
        'attr_multi_value': _getAttrMultiValue()
      };

      data.addAll(dt);
    }

    if (attrCompValue1Controller.text.trim().isNotEmpty ||
        attrCompValue2Controller.text.trim().isNotEmpty ||
        attrCompValue3Controller.text.trim().isNotEmpty ||
        attrCompValue4Controller.text.trim().isNotEmpty ||
        attrCompValue5Controller.text.trim().isNotEmpty) {
      var dt = {
        'attr_comparison_status': 1,
        'attr_comparison_code': _getAttrCompCode(),
        'attr_comparison_type': _getAttrCompType(),
        'attr_comparison_from': _getAttrCompFrom(),
        'attr_comparison_to': _getAttrCompTo()
      };
      data.addAll(dt);
    }

    debugPrint('ParamsAre => $data');

    var json = jsonEncode(data);

    WebService().post(context, AppConfig.searchItems, json).then((value) => {
          Navigator.pop(context),
          _parseResult(value!),
        });
  }

  _parseResult(Response value) async {
    if (value.statusCode == 200) {
      var data = jsonDecode(value.body);

      if (data['error'] == 'false') {
        resultList.clear();
        List<ItemResultModel> itemList = [];
        List<ItemResultModel> catalogList = [];
        List<ItemResultModel> paraCatalogList = [];
        List<ItemResultModel> attrCatalogList = [];
        imgBaseUrl = data['image_tiff_path'];

        var contentList = data['content'] as List;
        var catalogContentList = data['catalog_content'] as List;

        tempString =
            'Y: ${contentList.length} R: ${catalogContentList.length} ';

        catalogList.addAll(catalogContentList
            .map((e) => ItemResultModel.fromJSONParse2(e))
            .toList());
        itemList.addAll(
            contentList.map((e) => ItemResultModel.fromJSON(e)).toList());

        var blockedCatalog = data['block_catalog'] as List;
        resultList.addAll(catalogList);

        /// Checking for Blocked Items
        for (int i = 0; i < blockedCatalog.length; i++) {
          for (int j = 0; j < resultList.length; j++) {
            if (resultList[j].itemCode == blockedCatalog[i]) {
              resultList[j].isEnabled = false;
            }
          }
        }

        /// Checking for Attr Items
        for (int j = 0; j < resultList.length; j++) {
          if (resultList[j].itemType == '2') {
            attrCatalogList.add(resultList[j]);
          }
        }

        if (catalogList.isEmpty) {
          resultList.addAll(itemList);
        }

        debugPrint('ResultList ${resultList.length}');

        if (resultList.isEmpty) {
          Commons().showAlert(context, 'No item found', 'Item Search');
        } else {
          var result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ItemSearchResult(
                        resultList: resultList,
                        imgBaseUrl: imgBaseUrl,
                        comingFrom: widget.comingFrom,
                        tempCount: tempString,
                        paraList: paraCatalogList,
                        attrList: attrCatalogList,
                        catalogList: catalogList,
                        itemList: itemList,
                      )));

          debugPrint('OnActivityResult => $result ');
        }
      }
    }
  }

  String? _getAttrMultiCode() {
    var data;

    if (codeMultiAttrWise1!.isNotEmpty) {
      if (data == null) {
        data = '$codeMultiAttrWise1';
      } else {
        data = "$data,$codeMultiAttrWise1";
      }
    }

    if (codeMultiAttrWise2!.isNotEmpty) {
      if (data == null) {
        data = '$codeMultiAttrWise2';
      } else {
        data = "$data,$codeMultiAttrWise2";
      }
    }

    if (codeMultiAttrWise3!.isNotEmpty) {
      if (data == null) {
        data = '$codeMultiAttrWise3';
      } else {
        data = "$data,$codeMultiAttrWise3";
      }
    }
    if (codeMultiAttrWise4!.isNotEmpty) {
      if (data == null) {
        data = '$codeMultiAttrWise4';
      } else {
        data = "$data,$codeMultiAttrWise4";
      }
    }
    if (codeMultiAttrWise5!.isNotEmpty) {
      if (data == null) {
        data = '$codeMultiAttrWise5';
      } else {
        data = "$data,$codeMultiAttrWise5";
      }
    }

    return data;
  }

  String? _getAttrMultiValue() {
    var data;

    if (mawAttrValue1Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${mawAttrValue1Controller.text.trim()}';
      } else {
        data = "$data,${mawAttrValue1Controller.text.trim()}";
      }
    }

    if (mawAttrValue2Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${mawAttrValue2Controller.text.trim()}';
      } else {
        data = "$data,${mawAttrValue2Controller.text.trim()}";
      }
    }

    if (mawAttrValue3Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${mawAttrValue3Controller.text.trim()}';
      } else {
        data = "$data,${mawAttrValue3Controller.text.trim()}";
      }
    }

    if (mawAttrValue4Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${mawAttrValue4Controller.text.trim()}';
      } else {
        data = "$data,${mawAttrValue4Controller.text.trim()}";
      }
    }

    if (mawAttrValue5Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${mawAttrValue5Controller.text.trim()}';
      } else {
        data = "$data,${mawAttrValue5Controller.text.trim()}";
      }
    }

    return data;
  }

  String? _getAttrCompType() {
    var data;

    if (attrCompType1Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompType1Controller.text.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompType1Controller.text.trim().toLowerCase()}";
      }
    }

    if (attrCompType2Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompType2Controller.text.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompType2Controller.text.trim().toLowerCase()}";
      }
    }

    if (attrCompType3Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompType3Controller.text.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompType3Controller.text.trim().toLowerCase()}";
      }
    }

    if (attrCompType4Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompType4Controller.text.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompType4Controller.text.trim().toLowerCase()}";
      }
    }

    if (attrCompType5Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompType5Controller.text.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompType5Controller.text.trim().toLowerCase()}";
      }
    }

    return data;
  }

  String? _getAttrCompFrom() {
    var data;

    if (attrCompFrom1Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompFrom1Controller.text.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompFrom1Controller.text.trim().toLowerCase()}";
      }
    }

    if (attrCompFrom2Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompFrom2Controller.text.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompFrom2Controller.text.trim().toLowerCase()}";
      }
    }

    if (attrCompFrom3Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompFrom3Controller.text.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompFrom3Controller.text.trim().toLowerCase()}";
      }
    }

    if (attrCompFrom4Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompFrom4Controller.text.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompFrom4Controller.text.trim().toLowerCase()}";
      }
    }

    if (attrCompFrom5Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompFrom5Controller.text.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompFrom5Controller.text.trim().toLowerCase()}";
      }
    }

    return data;
  }

  String? _getAttrCompTo() {
    var data;

    if (attrCompTo1Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompTo1Controller.text.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompTo1Controller.text.trim().toLowerCase()}";
      }
    }

    if (attrCompTo2Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompTo2Controller.text.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompTo2Controller.text.trim().toLowerCase()}";
      }
    }

    if (attrCompTo3Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompTo3Controller.text.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompTo3Controller.text.trim().toLowerCase()}";
      }
    }

    if (attrCompTo4Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompTo4Controller.text.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompTo4Controller.text.trim().toLowerCase()}";
      }
    }

    if (attrCompTo5Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompTo5Controller.text.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompTo5Controller.text.trim().toLowerCase()}";
      }
    }

    return data;
  }

  String? _getAttrCompCode() {
    var data;

    if (codeAttrComp1!.isNotEmpty) {
      if (data == null) {
        data = '$codeAttrComp1';
      } else {
        data = "$data,$codeAttrComp1";
      }
    }

    if (codeAttrComp2!.isNotEmpty) {
      if (data == null) {
        data = '$codeAttrComp2';
      } else {
        data = "$data,$codeAttrComp2";
      }
    }

    if (codeAttrComp3!.isNotEmpty) {
      if (data == null) {
        data = '$codeAttrComp3';
      } else {
        data = "$data,$codeAttrComp3";
      }
    }

    if (codeAttrComp4!.isNotEmpty) {
      if (data == null) {
        data = '$codeAttrComp4';
      } else {
        data = "$data,$codeAttrComp4";
      }
    }

    if (codeAttrComp5!.isNotEmpty) {
      if (data == null) {
        data = '$codeAttrComp5';
      } else {
        data = "$data,$codeAttrComp5";
      }
    }

    return data;
  }
}

enum WidgetsFactory {
  Category,
  SubCategory,
  Type,
  Party,
  Machine,
  Brand,
  Count,
  Material,
  Process,
  Shade,
  Item,
  User,
  SimilarItems,
  FromDate,
  ToDate,
  AttributeValueWise,
  MultiAttributeWise,
  AttributeComparison,
}
