class RepairManModel {
  String? id;
  String? createdDate;
  String? name;
  String? userName;
  String? password;
  String? registerDate;
  String? userId;

  RepairManModel({
    this.id,
    this.createdDate,
    this.name,
    this.userName,
    this.password,
    this.registerDate,
    this.userId,
  });

  static RepairManModel fromJson(Map<String, dynamic> json) => RepairManModel(
        id: json['id'] as String,
        createdDate: json['created_date'] as String,
        name: json['tentho'] as String,
        userName: json['username'] as String,
        password: json['password'] as String,
        registerDate: json['ngaydangky'] as String?,
        userId: json['userId'] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'created_date': createdDate,
        'tentho': name,
        'username': userName,
        'password': password,
        'ngaydangky': registerDate,
        'userId': userId,
      };
}
