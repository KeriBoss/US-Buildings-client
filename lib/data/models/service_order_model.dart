class ServiceOrderModel {
  String? id;
  String? createdDate;
  String? serviceName;
  String? price;
  String? currentLocation;
  String? newLocation;
  String? clientFullName;
  String? clientPhoneNumber;
  String? bookingTime;
  String? totalPrice;
  String? clientRequest;
  String? repairManName;
  String? orderStatus;
  String? repairManRating;
  String? adminAuthor;
  String? appRating;
  String? userId;

  ServiceOrderModel({
    this.id,
    this.createdDate,
    this.serviceName,
    this.price,
    this.currentLocation,
    this.newLocation,
    this.clientFullName,
    this.clientPhoneNumber,
    this.bookingTime,
    this.totalPrice,
    this.clientRequest,
    this.repairManName,
    this.orderStatus,
    this.repairManRating,
    this.adminAuthor,
    this.appRating,
    this.userId,
  });

  static ServiceOrderModel fromJson(Map<String, dynamic> json) =>
      ServiceOrderModel(
        id: json['id'] as String,
        createdDate: json['created_date'] as String?,
        serviceName: json['tendichvu'] as String?,
        price: json['gia'] as String?,
        currentLocation: json['vitrihientai'] as String?,
        newLocation: json['themdiachimoi'] as String?,
        clientFullName: json['hovaten'] as String?,
        clientPhoneNumber: json['sodienthoai'] as String?,
        bookingTime: json['ngaygiodatlich'] as String?,
        totalPrice: json['giacuoicung'] as String?,
        clientRequest: json['nhapyeucaucuaban'] as String?,
        repairManName: json['chontho'] as String?,
        orderStatus: json['chon'] as String?,
        adminAuthor: json['quyenadmin'] as String?,
        repairManRating: json['danhgiatho'] as String?,
        appRating: json['danhgiaapp'] as String?,
        userId: json['userid'] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "id": id,
        "created_date": createdDate,
        "tendichvu": serviceName,
        "gia": price,
        "vitrihientai": currentLocation,
        "themdiachimoi": newLocation,
        "hovaten": clientFullName,
        "sodienthoai": clientPhoneNumber,
        "ngaygiodatlich": bookingTime,
        "giacuoicung": totalPrice,
        "nhapyeucaucuaban": clientRequest,
        "chontho": repairManName,
        "chon": orderStatus,
        "quyenadmin": adminAuthor,
        "danhgiatho": repairManRating,
        "danhgiaapp": appRating,
        "userid": userId,
      };

  @override
  String toString() {
    return 'ServiceOrderModel{id: $id, createdDate: $createdDate, serviceName: $serviceName, price: $price, currentLocation: $currentLocation, newLocation: $newLocation, clientFullName: $clientFullName, clientPhoneNumber: $clientPhoneNumber, bookingTime: $bookingTime, totalPrice: $totalPrice, clientRequest: $clientRequest, repairManName: $repairManName, orderStatus: $orderStatus, repairManRating: $repairManRating, adminAuthor: $adminAuthor, appRating: $appRating, userId: $userId}';
  }
}
