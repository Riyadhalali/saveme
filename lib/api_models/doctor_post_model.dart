class DoctorPosts {
  //String doctorId;
  String doctorName;
  String doctorType;
  String openingTime;
  String doctorLocation;
  String doctorPhone;
  String doctorEmail;

  DoctorPosts(
      {
      //required this.doctorId,
      required this.doctorName,
      required this.doctorType,
      required this.openingTime,
      required this.doctorLocation,
      required this.doctorPhone,
      required this.doctorEmail});

  Map<String, dynamic> toJson() => {
        'doctorName': doctorName,
        'doctorType': doctorType,
        'openingTime': openingTime,
        'doctorLocation': doctorLocation,
        'doctorPhone': doctorPhone,
        'doctorEmail': doctorEmail
      };
}
