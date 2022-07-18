class DoctorPosts {
  String doctorId;
  String doctorName;
  String doctorType;
  String openingTime;
  String doctorLocation;
  String doctorPhone;
  String doctorEmail;

  DoctorPosts(
      {required this.doctorId,
      required this.doctorName,
      required this.doctorType,
      required this.openingTime,
      required this.doctorLocation,
      required this.doctorPhone,
      required this.doctorEmail});

  Map<String, dynamic> toJson() => {
        'doctorId': doctorId,
        'doctorName': doctorName,
        'doctorType': doctorType,
        'openingTime': openingTime,
        'doctorLocation': doctorLocation,
        'doctorPhone': doctorPhone,
        'doctorEmail': doctorEmail
      };

  static DoctorPosts fromJson(Map<String, dynamic> json) => DoctorPosts(
      doctorId: json['doctorId'],
      doctorName: json['doctorName'],
      doctorType: json['doctorType'],
      openingTime: json['openingTime'],
      doctorLocation: json['doctorLocation'],
      doctorPhone: json['doctorPhone'],
      doctorEmail: json['doctorEmail']);
}
