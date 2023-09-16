import 'package:dataproject2/itemMaster/model/ItemResultModel.dart';
import 'package:dataproject2/itemMaster/model/OtherDetailModel.dart';
import 'package:dataproject2/newmodel/ItemAttributeModel.dart';
import 'package:dataproject2/utils/Utils.dart';

class ItemMasterModel {

  String id;
  String? itemCode;
  String? item_Code;
  String itemName;
  String name;
  String itemCatalogName;
  String type;
  String itemTypeCode;
  String imgBaseUrl;
  String? category;
  String? subCategory;
  String? Type;
  String? MinStock;
  String? MaxStock;
  String? Uom;
  String? UomCode;
  String? Brand;
  String? Process;
  String? Material;
  String? Machine;
  String? Shade;
  String? Count;
  String? remarks;
  String catalog;
  String? catalogCode;
  String? countCode;
  String? materialCode;
  String quantity;
  String? quantityUom;
  String? quantityUomCode;
  String rate;
  String? rateUom;
  String? rateUomCode;
  String clbQuantity;
  String? clbQuantityUom;
  String? clbQuantityUomCode;
  String clbRate;
  String? clbRateUom;
  String? clbRateUomCode;
  String status;
  String catalogItemCode;
  String includeTax;
  String tax;
  String basicRate;
  String? brandCode;
  String? shadeCode;
  String? machineCode;

  String? itemParameter1;
  String? itemParameter1Code;
  String? itemValue1;
  String? itemValue1Code;
  String? itemUom1;
  String? itemUom1Code;

  String? itemParameter2;
  String? itemParameter2Code;
  String? itemValue2;
  String? itemValue2Code;
  String? itemUom2;
  String? itemUom2Code;

  String? itemParameter3;
  String? itemParameter3Code;
  String? itemValue3;
  String? itemValue3Code;
  String? itemUom3;
  String? itemUom3Code;
  String createdDate;
  String createdBy;
  bool isEnabled;

  List<String?>? imageList;
  List<String>? mediaTypeList;
  List<ItemAttributeModel>? attributeList;

  List<OtherDetailModel>? materialList;
  List<OtherDetailModel>? countList;
  List<OtherDetailModel>? brandList;
  List<OtherDetailModel>? shadeList;
  List<OtherDetailModel>? catalogMachineList;

  ItemMasterModel({this.itemCode = '',
    this.id = '0',
    this.item_Code = '',
    this.itemName = '',
    this.name = '',
    this.itemTypeCode = '',
    this.itemCatalogName = '',
    this.quantityUomCode = '',
    this.type = '',
    this.rateUomCode = '',
    this.clbQuantityUomCode = '',
    this.clbRateUomCode = '',
    this.imgBaseUrl = '',
    this.category = '',
    this.subCategory = '',
    this.Type = '',
    this.MinStock = '',
    this.MaxStock = '',
    this.Uom = '',
    this.UomCode = '',
    this.Brand = '',
    this.Process = '',
    this.Material = '',
    this.Machine = '',
    this.Shade = '',
    this.Count = '',
    this.remarks = '',
    this.catalog = '',
    this.catalogCode = '',
    this.countCode = '0',
    this.materialCode = '',
    this.quantity = '',
    this.quantityUom = '',
    this.rate = '0',
    this.rateUom = '',
    this.clbQuantity = '0',
    this.clbQuantityUom = '',
    this.clbRate = '0',
    this.clbRateUom = '',
    this.status = 'Yes',
    this.catalogItemCode = '',
    this.includeTax = 'No',
    this.tax = '',
    this.basicRate = '',
    this.brandCode = '',
    this.shadeCode = '',
    this.machineCode = '',
    this.itemParameter1 = '',
    this.itemValue1 = '',
    this.itemValue1Code = '',
    this.itemUom1 = '',
    this.itemParameter2 = '',
    this.itemValue2 = '',
    this.itemValue2Code = '',
    this.itemUom2 = '',
    this.itemParameter3 = '',
    this.itemValue3 = '',
    this.itemValue3Code = '',
    this.itemUom3 = '',
    this.itemUom1Code = '',
    this.itemUom2Code = '',
    this.itemUom3Code = '',
    this.itemParameter1Code = '',
    this.itemParameter2Code = '',
    this.itemParameter3Code = '',
    this.createdBy = '',
    this.createdDate = '',
    this.isEnabled = false,
    this.imageList,
    this.attributeList,
    this.materialList,
    this.countList,
    this.brandList,
    this.shadeList,
    this.catalogMachineList,
    this.mediaTypeList,
  });


  factory ItemMasterModel.fromJSON(Map<String, dynamic> json) {
    var imageList = json['item_multiple_image'] as List;
    var attrList = json['item_attrs'] as List;

    List<String?> mImageList = [];

    var materialList = json['material_lists'] as List;
    var countList = json['count_lists'] as List;
    var brandList = json['brand_lists'] as List;
    var shadeList = json['shade_lists'] as List;
    //  var catMachineList = json['catalog_machine_lists'] as List;

    List<OtherDetailModel> mMaterialList = [];
    List<OtherDetailModel> mCountList = [];
    List<OtherDetailModel> mBrandList = [];
    List<OtherDetailModel> mShadeList = [];
    List<OtherDetailModel> mCatMachineList = [];
    List<String> mMediaTypeList = [];

    imageList.forEach((element) {
      mImageList.add(element['code_pk']);
      mMediaTypeList.add('Image');
    });

    materialList.forEach((e) {
      mMaterialList.add(OtherDetailModel(
        code: e['material_name']['code'].toString(),
        name: e['material_name']['name'],
      ));
    });

    countList.forEach((e) {
      mCountList.add(OtherDetailModel(
        code: e['count_name']['code'].toString(),
        name: e['count_name']['name'],
      ));
    });

    brandList.forEach((e) {
      mBrandList.add(OtherDetailModel(
        code: e['brand_name']['code'].toString(),
        name: e['brand_name']['name'],
      ));
    });

    shadeList.forEach((e) {
      mShadeList.add(OtherDetailModel(
        code: e['shade_name']['code'].toString(),
        name: e['shade_name']['name'],
      ));
    });

    /* catMachineList.forEach((e) {
      mCatMachineList.add(OtherDetailModel(
        code: e['catalog_machine_lists']['code'].toString(),
        name: e['catalog_machine_lists']['name'],
      ));
    });*/

    return ItemMasterModel(
        type: '1',
        itemCode: json['code'].toString(),
        createdDate:getString(json, 'create_date'),
        createdBy:getString(json['item_creator'], 'name'),
        item_Code: json['item_code'] == null ? '' : json['item_code'],
        itemTypeCode: json['item_type_code'].toString(),
        itemName: json['name'].toString(),
        name: json['name'].toString(),
        MinStock: json['min_stock'] == null ? '' : json['min_stock'],
        MaxStock: json['max_stock'] == null ? '' : json['max_stock'],
        remarks: json['remarks'] == null ? '' : json['remarks'],
        Uom: json['item_unit'] == null ? '' : json['item_unit']['abv'],
        quantityUom: json['item_unit'] == null ? '' : json['item_unit']['abv'],
        UomCode: json['item_unit'] == null ? '' : json['item_unit']['code'],
        quantityUomCode: json['item_unit'] == null
            ? ''
            : json['item_unit']['code'],

        rateUom: json['item_unit'] == null ? '' : json['item_unit']['abv'],
        rateUomCode: json['item_unit'] == null ? '' : json['item_unit']['code'],
        clbRateUom: json['item_unit'] == null ? '' : json['item_unit']['abv'],
        clbRateUomCode: json['item_unit'] == null
            ? ''
            : json['item_unit']['code'],
        clbQuantityUom: json['item_unit'] == null
            ? ''
            : json['item_unit']['abv'],
        clbQuantityUomCode: json['item_unit'] == null
            ? ''
            : json['item_unit']['code'],

        Type:
        json['item_type']['name'] == null ? '' : json['item_type']['name'],
        // Uomx: json['item_type']['name'] == null ? '' : json['item_type']['name'],
        subCategory: json['item_type']['item_sub_cat']['name'] == null
            ? ''
            : json['item_type']['item_sub_cat']['name'],
        category:
        json['item_type']['item_sub_cat']['item_cat_name']['name'] == null
            ? ''
            : json['item_type']['item_sub_cat']['item_cat_name']['name'],
        Brand: json['item_brand'] == null
            ? ''
            : json['item_brand']['brand_name']['name'],
        brandCode: json['item_brand'] == null
            ? ''
            : json['item_brand']['brand_name']['code'],
        Process: json['item_process'] == null
            ? ''
            : json['item_process']['process_name']['name'],
        Material: json['item_material'] == null
            ? ''
            : json['item_material']['material_name']['name'],
        materialCode: json['item_material'] == null
            ? ''
            : json['item_material']['material_code'],
        Machine: json['item_machine'] == null
            ? ''
            : json['item_machine']['machine_name']['name'],
        machineCode: json['item_machine'] == null
            ? ''
            : json['item_machine']['machine_code'],
        Shade: json['item_shade'] == null
            ? ''
            : json['item_shade']['shade_name']['name'],
        shadeCode:
        json['item_shade'] == null
            ? ''
            : json['item_shade']['shade_name']['code'],
        Count: json['item_count'] == null
            ? ''
            : json['item_count']['count_name']['name'],
        countCode: json['item_count'] == null
            ? '0'
            : json['item_count']['count_name']['code'],
        imageList: mImageList,
        materialList: mMaterialList,
        countList: mCountList,
        brandList: mBrandList,
        shadeList: mShadeList,
        catalogMachineList: mCatMachineList,
        mediaTypeList: mMediaTypeList,
        attributeList: _getAttributeList(attrList));

  }

  factory ItemMasterModel.fromJSONCatalog(Map<String, dynamic> json) {
    ///
    var attrList = json['item_name']['item_attrs'] as List;
    var imageList = json['item_multiple_image'] as List;
    var pdfList = json['item_multiple_pdf'] as List;
    var materialList = json['material_lists'] as List;
    var countList = json['count_lists'] as List;
    var brandList = json['brand_lists'] as List;
    var shadeList = json['shade_lists'] as List;
    var catMachineList = json['catalog_machine_lists'] as List;

    List<String?> mImageList = [];
    List<String> mMediaTypeList = [];
    List<OtherDetailModel> mMaterialList = [];
    List<OtherDetailModel> mCountList = [];
    List<OtherDetailModel> mBrandList = [];
    List<OtherDetailModel> mShadeList = [];
    List<OtherDetailModel> mCatMachineList = [];

    imageList.forEach((element) {
      mImageList.add(element['code_pk']);
      mMediaTypeList.add('Image');
    });

    pdfList.forEach((element) {
      mImageList.add(element['code_pk']);
      mMediaTypeList.add(getString(element, 'file_extension'));
    });

    materialList.forEach((e) {
      mMaterialList.add(OtherDetailModel(
        code: e['material_name']['code'].toString(),
        name: e['material_name']['name'],
      ));
    });

    countList.forEach((e) {
      mCountList.add(OtherDetailModel(
        code: e['count_name']['code'].toString(),
        name: e['count_name']['name'],
      ));
    });

    brandList.forEach((e) {
      mBrandList.add(OtherDetailModel(
        code: e['brand_name']['code'].toString(),
        name: e['brand_name']['name'],
      ));
    });

    shadeList.forEach((e) {
      mShadeList.add(OtherDetailModel(
        code: e['shade_name']['code'].toString(),
        name: e['shade_name']['name'],
      ));
    });

    catMachineList.forEach((e) {
      mCatMachineList.add(OtherDetailModel(
        code: e['machine_code'].toString(),
        name: e['machine_name']['name'],
      ));
    });

    return ItemMasterModel(
        type: '2',
        isEnabled: json['block_catalog_status'] != null,
        itemCode: json['item_code'] == null ? '' : json['item_code'],
        item_Code: json['item_code'] == null ? '' : json['item_code'],
        catalogCode: json['code'] == null ? '' : json['code'],
        createdDate:getString(json, 'create_date'),
        createdBy:getString(json['item_creator'], 'name'),
        itemTypeCode: json['item_type_code'].toString(),
        name: json['item_name']['name'].toString(),
        itemName: ItemResultModel.getItemName(json),
        MinStock: json['min_stock'] == null ? '' : json['min_stock'],
        MaxStock: json['max_stock'] == null ? '' : json['max_stock'],
        remarks: json['remarks'] == null ? '' : json['remarks'],
        Uom: json['item_name'] == null
            ? ''
            : json['item_name']['item_unit']['abv'],
        UomCode: json['item_name'] == null
            ? ''
            : json['item_name']['item_unit']['code'],
        quantityUom: json['item_name'] == null
            ? ''
            : json['item_name']['item_unit']['abv'],
        quantityUomCode: json['item_name'] == null
            ? ''
            : json['item_name']['item_unit']['code'],

        rateUom: json['item_name'] == null
            ? ''
            : json['item_name']['item_unit']['abv'],
        rateUomCode: json['item_name'] == null
            ? ''
            : json['item_name']['item_unit']['code'],
        clbRateUom: json['item_name'] == null
            ? ''
            : json['item_name']['item_unit']['abv'],
        clbRateUomCode: json['item_name'] == null
            ? ''
            : json['item_name']['item_unit']['code'],
        clbQuantityUom: json['item_name'] == null
            ? ''
            : json['item_name']['item_unit']['abv'],
        clbQuantityUomCode: json['item_name'] == null
            ? ''
            : json['item_name']['item_unit']['code'],

        Type: json['item_name']['item_type']['name'] == null
            ? ''
            : json['item_name']['item_type']['name'],
        subCategory:
        json['item_name']['item_type']['item_sub_cat']['name'] == null
            ? ''
            : json['item_name']['item_type']['item_sub_cat']['name'],
        category: json['item_name']['item_type']['item_sub_cat']['item_cat_name']
        ['name'] ==
            null
            ? ''
            : json['item_name']['item_type']['item_sub_cat']['item_cat_name']
        ['name'],
        Brand: json['item_brand'] == null ? '' : json['item_brand']['name'],
        brandCode: json['item_brand'] == null ? '' : json['item_brand']['code'],
        Process: json['item_process'] == null
            ? ''
            : json['item_process']['name'],
        Material:
        json['item_material'] == null ? '' : json['item_material']['name'],
        materialCode: json['item_material'] == null
            ? ''
            : json['item_material']['code'],
        Shade: json['item_shade'] == null
            ? ''
            : json['item_shade']['name'],
        shadeCode:
        json['item_shade'] == null ? '' : json['item_shade']['code'],
        Count: json['item_count'] == null ? '' : json['item_count']['name'],
        countCode: json['item_count'] == null
            ? '0'
            : json['item_count']['code'],
        itemParameter1:
        json['item_code_1'] == null ? '' : json['item_code_1']['name'],
        itemParameter1Code:
        json['item_code_1'] == null ? '' : json['item_code_1']['code'],
        itemParameter2:
        json['item_code_2'] == null ? '' : json['item_code_2']['name'],
        itemParameter2Code:
        json['item_code_2'] == null ? '' : json['item_code_2']['code'],
        itemParameter3:
        json['item_code_3'] == null ? '' : json['item_code_3']['name'],
        itemParameter3Code:
        json['item_code_3'] == null ? '' : json['item_code_3']['code'],
        itemUom1: json['item_unit_1'] == null ? '' : json['item_unit_1']['abv'],
        itemUom1Code: json['item_unit_1'] == null
            ? ''
            : json['item_unit_1']['code'],
        itemUom2: json['item_unit_2'] == null ? '' : json['item_unit_2']['abv'],
        itemUom2Code: json['item_unit_2'] == null
            ? ''
            : json['item_unit_2']['code'],
        itemUom3: json['item_unit_3'] == null ? '' : json['item_unit_3']['abv'],
        itemUom3Code: json['item_unit_3'] == null
            ? ''
            : json['item_unit_3']['code'],
        itemValue1: json['iop1_val'],
        itemValue1Code: json['iop1_code'],
        itemValue2: json['iop2_val'],
        itemValue2Code: json['iop2_code'],
        itemValue3: json['iop3_val'],
        itemValue3Code: json['iop3_code'],
        imageList: mImageList,
        mediaTypeList: mMediaTypeList,
        materialList: mMaterialList,
        countList: mCountList,
        brandList: mBrandList,
        shadeList: mShadeList,
        catalogMachineList: mCatMachineList,
        attributeList: _getAttributeList(attrList)
    );
  }

  factory ItemMasterModel.parseEditable(Map<String, dynamic> json) {

    /// var attrList = json['item_name']['item_attrs'] as List;
    var imageList = json['item_detail']['item_multiple_image'] as List;
    var materialList = json['item_detail']['material_lists'] as List;
    var countList = json['item_detail']['count_lists'] as List;
    var brandList = json['item_detail']['brand_lists'] as List;
    var shadeList = json['item_detail']['shade_lists'] as List;

    List<String?> mImageList = [];
    List<OtherDetailModel> mMaterialList = [];
    List<OtherDetailModel> mCountList = [];
    List<OtherDetailModel> mBrandList = [];
    List<OtherDetailModel> mShadeList = [];
    List<String> mMediaTypeList = [];

    imageList.forEach((element) {
      mImageList.add(element['code_pk']);
      mMediaTypeList.add('Image');
    });

    materialList.forEach((e) {
      mMaterialList.add(OtherDetailModel(
        code: e['material_name']['code'].toString(),
        name: e['material_name']['name'],
      ));
    });

    countList.forEach((e) {
      mCountList.add(OtherDetailModel(
        code: e['count_name']['code'].toString(),
        name: e['count_name']['name'],
      ));
    });

    brandList.forEach((e) {
      mBrandList.add(OtherDetailModel(
        code: e['brand_name']['code'].toString(),
        name: e['brand_name']['name'],
      ));
    });

    shadeList.forEach((e) {
      mShadeList.add(OtherDetailModel(
        code: e['shade_name']['code'].toString(),
        name: e['shade_name']['name'],
      ));
    });

    var cat=json['udt_uid']['catalog_number'] as List;

    return ItemMasterModel(
      type: '2',
      id: getString(json, 'sqd_pk'),
      catalogCode: cat.isNotEmpty? getString(json['udt_uid']['catalog_number'][0], 'decodevalue'):'',
      itemCode: getString(json, 'item_code'),
      item_Code: getString(json, 'item_code'),
      quantity: getString(json, 'qty'),
      basicRate: getString(json, 'b_rate'),
      tax: getString(json, 'tax_per'),
      includeTax: getString(json, 'tax_tag')=='N'? 'No':'Yes',
      name: json['item_detail']['name'].toString(),
      itemName: ItemResultModel.getItemNameEdit(json),
      MinStock: getString(json['item_detail'], 'min_stock'),
      MaxStock: getString(json['item_detail'], 'max_stock'),
      remarks: getString(json, 'remarks'),
      Uom: json['item_detail'] == null ? ''
          : json['item_detail']['item_unit']['abv'],
      UomCode: json['item_detail'] == null ? ''
          : json['item_detail']['item_unit']['code'],
      quantityUom: json['item_detail'] == null ? ''
          : json['item_detail']['item_unit']['abv'],
      quantityUomCode: json['item_detail'] == null ? ''
          : json['item_detail']['item_unit']['code'],
      rateUom: json['item_detail'] == null
          ? ''
          : json['item_detail']['item_unit']['abv'],
      rateUomCode: json['item_detail'] == null
          ? ''
          : json['item_detail']['item_unit']['code'],
      clbRateUom: json['item_detail'] == null
          ? ''
          : json['item_detail']['item_unit']['abv'],
      clbRateUomCode: json['item_detail'] == null
          ? ''
          : json['item_detail']['item_unit']['code'],
      clbQuantityUom: json['item_detail'] == null
          ? ''
          : json['item_detail']['item_unit']['abv'],
      clbQuantityUomCode: json['item_detail'] == null
          ? ''
          : json['item_detail']['item_unit']['code'],

      Type: json['item_detail']['item_type']['name'] == null ? '' : json['item_detail']['item_type']['name'],
      Process: json['item_detail']['item_process'] == null ? '' : json['item_detail']['item_process']['process_name']['name'],
      Brand: getString(json['quotation_item_brand'], 'name'),
      brandCode: getString(json['quotation_item_brand'], 'code'),
      Material: getString(json['quotation_item_material'], 'name'),
      materialCode: getString(json['quotation_item_material'], 'code'),
      Shade: getString(json['quotation_item_shade'], 'name'),
      shadeCode: getString(json['quotation_item_shade'], 'code'),
      Count: getString(json['quotation_count_name'], 'name'),
      countCode:getString(json['quotation_count_name'], 'code'),
      itemParameter1:
      json['item_code_1'] == null ? '' : json['item_code_1']['name'],
      itemParameter1Code:
      json['item_code_1'] == null ? '' : json['item_code_1']['code'],
      itemParameter2:
      json['item_code_2'] == null ? '' : json['item_code_2']['name'],
      itemParameter2Code:
      json['item_code_2'] == null ? '' : json['item_code_2']['code'],
      itemParameter3:
      json['item_code_3'] == null ? '' : json['item_code_3']['name'],
      itemParameter3Code:
      json['item_code_3'] == null ? '' : json['item_code_3']['code'],
      itemUom1: json['item_unit_1'] == null ? '' : json['item_unit_1']['abv'],
      itemUom1Code: json['item_unit_1'] == null
          ? ''
          : json['item_unit_1']['code'],
      itemUom2: json['item_unit_2'] == null ? '' : json['item_unit_2']['abv'],
      itemUom2Code: json['item_unit_2'] == null
          ? ''
          : json['item_unit_2']['code'],
      itemUom3: json['item_unit_3'] == null ? '' : json['item_unit_3']['abv'],
      itemUom3Code: json['item_unit_3'] == null
          ? ''
          : json['item_unit_3']['code'],
      itemValue1: json['iop1_val'],
      itemValue1Code: json['iop1_code'],
      itemValue2: json['iop2_val'],
      itemValue2Code: json['iop2_code'],
      itemValue3: json['iop3_val'],
      itemValue3Code: json['iop3_code'],
      imageList: mImageList,
      materialList: mMaterialList,
      countList: mCountList,
      brandList: mBrandList,
      shadeList: mShadeList,
      mediaTypeList: mMediaTypeList
    );
  }

  static List<ItemAttributeModel> _getAttributeList(List<dynamic> attrList) {
    List<ItemAttributeModel> list = [];

    list.addAll(attrList.map((e) => ItemAttributeModel.fromJSON(e)).toList());

    list.sort((a, b) => b.at1!.trim().compareTo(a.at1!.trim()));

    if (list.isNotEmpty)
      list.insert(
          0,
          ItemAttributeModel(
            name: 'Attribute',
            isHeader: true,
            at1: 'At1',
            at2: 'At2',
            at3: 'At3',
            at4: 'At4',
            at5: 'At5',
            at6: 'At6',
            at7: 'At7',
            at8: 'At8',
            at9: 'At9',
            at10: 'At10',
            at11: 'At11',
            at12: 'At12',
            at13: 'At13',
            at14: 'At14',
            at15: 'At15',
            at16: 'At16',
            at17: 'At17',
            at18: 'At18',
            at19: 'At19',
            at20: 'At20',
            at21: 'At21',
            at22: 'At22',
            at23: 'At23',
            at24: 'At24',
            at25: 'At25',
          ));

    return list;
  }
}
