class SearchUserModel {

  String? id;
  String? categoryName;

  SearchUserModel({this.id, this.categoryName});

  factory SearchUserModel.fromJSON(Map<String,dynamic> json){

    return SearchUserModel(
      id:json['user_id'],
      categoryName:json['name']
    );

  }

}
