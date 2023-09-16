class SearchResultModel {
  String? id = '';
  String? qtnNo = '';
  String? qtnDate = '';
  String? qtnFinYear = '';
  String? compName = '';
  String? compLogo = '';
  String? partyName = '';
  String? partyCode = '';

  SearchResultModel(
      {this.qtnNo,
      this.id,
      this.qtnDate,
      this.qtnFinYear,
      this.compName,
      this.compLogo,
      this.partyCode,
      this.partyName});

  factory SearchResultModel.fromJSON(Map<String, dynamic> json) {
    return SearchResultModel(
      id: json['sqh_pk'] == null ? '' : json['sqh_pk'].toString(),
      qtnNo: json['qtn_no'] == null ? '' : json['qtn_no'].toString(),
      qtnDate: json['qtn_date'] == null
          ? ''
          : json['qtn_date'].toString(), //Commons().getDDMMYYYYDate(),
      qtnFinYear:
          json['qtn_finyear'] == null ? '' : json['qtn_finyear'].toString(),
      compName: json['company_detail'] == null
          ? ''
          : json['company_detail']['abv'].toString(),
      compLogo: json['company_detail'] == null
          ? ''
          : json['company_detail']['logo_name'].toString(),
      partyName: json['party_detail'] == null
          ? ''
          : json['party_detail']['name'].toString(),
      partyCode: json['party_detail'] == null
          ? ''
          : json['party_detail']['code'].toString(),
    );
  }
}
