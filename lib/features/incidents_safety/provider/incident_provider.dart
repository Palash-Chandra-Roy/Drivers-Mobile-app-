import 'package:flutter/foundation.dart';
import 'package:yjeek_driver/features/incidents_safety/model/incident_model.dart';
import 'package:yjeek_driver/features/incidents_safety/service/incident_service.dart';

class IncidentProvider extends ChangeNotifier {
  final IncidentService _service = IncidentService();

  bool _isLoading = false;
  List<IncidentModel> _incidents = [];

  bool get isLoading => _isLoading;
  List<IncidentModel> get incidents => _incidents;

  Future<void> loadIncidents() async {
    _isLoading = true;
    notifyListeners();
    _incidents = await _service.getIncidents();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> submitReport(String issueType, String description) async {
    _isLoading = true;
    notifyListeners();
    final result = await _service.submitReport(
      issueType: issueType,
      description: description,
    );
    _isLoading = false;
    notifyListeners();
    return result;
  }

  Future<bool> submitItemIssue(List<String> issues, String notes) async {
    _isLoading = true;
    notifyListeners();
    final result = await _service.submitItemIssue(issues: issues, notes: notes);
    _isLoading = false;
    notifyListeners();
    return result;
  }
}
