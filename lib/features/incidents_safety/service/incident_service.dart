import 'package:yjeek_driver/features/incidents_safety/model/incident_model.dart';

class IncidentService {
  Future<List<IncidentModel>> getIncidents() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      IncidentModel(
        id: 'INC-001',
        title: 'Late delivery report',
        description: 'Customer reported late delivery for order #ORD-998',
        status: 'Resolved',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }

  Future<bool> submitReport({
    required String issueType,
    required String description,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> submitItemIssue({
    required List<String> issues,
    required String notes,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
