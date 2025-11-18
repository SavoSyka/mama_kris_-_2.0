class CreateJobParams {
  final String title;
  final String description;
  final String salary;
  final bool salaryWithAgreement;
  final int contactsID;
  final String? link;
  final int? jobId; // For updates

  CreateJobParams({
    required this.title,
    required this.description,
    required this.salary,
    required this.salaryWithAgreement,
    required this.contactsID,
    this.link,
    this.jobId,
  });
}