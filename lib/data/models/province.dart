class Province {
  final int? prId;
  final int? provinceId;
  final String? provinceName;

  Province({this.prId, this.provinceId, this.provinceName});

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      prId: json['prId'],
      provinceId: json['provinceId'],
      provinceName: json['provinceName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prId': prId,
      'provinceId': provinceId,
      'provinceName': provinceName,
    };
  }
}
