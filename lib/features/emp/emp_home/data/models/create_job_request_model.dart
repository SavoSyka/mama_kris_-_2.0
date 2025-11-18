class CreateJobRequestModel {
  final int userID;
  final String description;
  final String dateTime;
  final int salary;
  final String status;
  final String title;
  final int contactsID;
  final String firstPublishedAt;
  final int? jobID;

  CreateJobRequestModel({
    required this.userID,
    required this.description,
    required this.dateTime,
    required this.salary,
    required this.status,
    required this.title,
    required this.contactsID,
    required this.firstPublishedAt,
    this.jobID,
  });

  factory CreateJobRequestModel.fromJson(Map<String, dynamic> json) {
    return CreateJobRequestModel(
      userID: json['userID'],
      description: json['description'],
      dateTime: json['dateTime'],
      salary: json['salary'],
      status: json['status'],
      title: json['title'],
      contactsID: json['contactsID'],
      firstPublishedAt: json['firstPublishedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = {
      'userID': userID,
      'description': description,
      'dateTime': dateTime,
      'salary': salary,
      'status': status,
      'title': title,
      'contactsID': contactsID,
      'firstPublishedAt': firstPublishedAt,
    };
    if (jobID != null) {
      map['jobID'] = jobID!;
    }
    return map;
  }
}