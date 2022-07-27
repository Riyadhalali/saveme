class BookModel {
  String doctorId;
  String doctorName;
  String doctorType;
  String openingTime;
  String doctorLocation;
  String doctorPhone;
  String doctorEmail;
  String patientId;
  String patientName;
  String patientEmail;
  String patientPhone;
  String reviewDate; // the date that doctor modify
  String reviewState;

  BookModel(
      {required this.doctorId,
      required this.doctorName,
      required this.doctorType,
      required this.openingTime,
      required this.doctorLocation,
      required this.doctorPhone,
      required this.doctorEmail,
      required this.patientId,
      required this.patientName,
      required this.patientEmail,
      required this.patientPhone,
      required this.reviewDate,
      required this.reviewState}); // if the doctor accepted the request
// create json
  Map<String, dynamic> toJson() => {
        'doctorId': doctorId,
        'doctorName': doctorName,
        'doctorType': doctorType,
        'openingTime': openingTime,
        'doctorLocation': doctorLocation,
        'doctorPhone': doctorPhone,
        'doctorEmail': doctorEmail,
        'patientId': patientId,
        'patientName': patientName,
        'patientEmail': patientEmail,
        'patientPhone': patientPhone,
        'reviewDate': reviewDate,
        'reviewState': reviewState
      };

  static BookModel fromJson(Map<String, dynamic> json) => BookModel(
      doctorId: json['doctorId'],
      doctorName: json['doctorName'],
      doctorType: json['doctorType'],
      openingTime: json['openingTime'],
      doctorLocation: json['doctorLocation'],
      doctorPhone: json['doctorPhone'],
      doctorEmail: json['doctorEmail'],
      patientId: json['patientId'],
      patientName: json['patientName'],
      patientEmail: json['patientEmail'],
      patientPhone: json['patientPhone'],
      reviewDate: json['reviewDate'],
      reviewState: json['reviewState']);
} // end class
