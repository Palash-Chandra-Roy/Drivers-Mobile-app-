/// Local in-memory return submission for Scheduled Vape orders only.
class ScheduledVapeReturnState {
  ScheduledVapeReturnState._();

  static ScheduledVapeReturnSubmission? lastSubmission;

  static void save(ScheduledVapeReturnSubmission submission) {
    lastSubmission = submission;
  }
}

class ScheduledVapeReturnSubmission {
  const ScheduledVapeReturnSubmission({
    required this.orderId,
    required this.reason,
    required this.photoBytes,
    required this.submittedAt,
    this.status = 'Return to Vendor',
  });

  final String orderId;
  final String reason;
  final List<int> photoBytes;
  final DateTime submittedAt;
  final String status;
}
