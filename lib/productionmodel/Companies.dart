class Companies {
  Companies({
      this.username, 
      this.password, 
       this.code,
       this.name,
      this.userId, 
      this.functionName, 
      this.tid, 
      this.corpTaskFlag, 
      this.taskName,});

  Companies.fromJson(dynamic json) {
    username = json['username'];
    password = json['password'];
    code = json['Code'];
    name = json['name'];
    userId = json['user_id'];
    functionName = json['function_name'];
    tid = json['tid'];
    corpTaskFlag = json['corp_task_flag'];
    taskName = json['task_name'];
  }
  dynamic username;
  dynamic password;
  int? code;
  String? name;
  dynamic userId;
  dynamic functionName;
  dynamic tid;
  dynamic corpTaskFlag;
  dynamic taskName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = username;
    map['password'] = password;
    map['Code'] = code;
    map['name'] = name;
    map['user_id'] = userId;
    map['function_name'] = functionName;
    map['tid'] = tid;
    map['corp_task_flag'] = corpTaskFlag;
    map['task_name'] = taskName;
    return map;
  }



}