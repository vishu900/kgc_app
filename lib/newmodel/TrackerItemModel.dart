class TrackerItemModel {
  String? user = '';
  String? userId = '';
  String? docSrl = '';
  String? docType = '';
  String? compCode = '';
  String? totalDocs = '';
  String? companyName = '';
  String? logo = '';

  TrackerItemModel(
      {this.user,
      this.totalDocs,
      this.userId,
      this.docSrl,
      this.docType,
      this.compCode,
      this.companyName,
      this.logo});

  factory TrackerItemModel.fromJson(Map<String, dynamic> json) {
    return TrackerItemModel(
      user: json['user_name'] == null ? '' : json['user_name'],
      userId: json['user_id'] == null ? '' : json['user_id'],
      docSrl: json['doc_srl'] == null ? '' : json['doc_srl'],
      docType: json['doc_type'] == null ? '' : json['doc_type'],
      totalDocs: json['total_docs'] == null ? '' : json['total_docs'],
      compCode:
          json['company_detail'] == null ? '' : json['company_detail']['code'],
      companyName: json['comp_abv'] == null ? '' : json['comp_abv'],
      logo: json['company_detail'] == null
          ? ''
          : json['company_detail']['logo_name'],
    );
  }
}
