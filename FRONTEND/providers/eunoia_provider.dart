import 'package:flutter/material.dart';
import '../models/workspace_models.dart';
import '../services/mock_api_service.dart';

class PulseProvider with ChangeNotifier {
  final MockApiService _apiService = MockApiService();

  double _tempThreshold = 45.0;
  double _currentThreshold = 5.0;
  bool _autoShutdown = true;
  bool _notificationsEnabled = true;

  double get tempThreshold => _tempThreshold;
  double get currentThreshold => _currentThreshold;
  bool get autoShutdown => _autoShutdown;
  bool get notificationsEnabled => _notificationsEnabled;

  String overallStatus = "Loading...";
  String recommendation = "Analyzing workspace environment...";
  String lastUpdated = "Never";
  double currentTemp = 0.0;
  double currentLoad = 0.0;
  bool motionDetected = false;
  bool relayActive = false;
  bool emergencyShutdownActive = false;

  List<DeviceInfo> devices = [];
  List<AlertItem> alerts = [];
  List<HistoryEvent> historyEvents = [];

  PulseProvider() {
    refreshAllData();
  }

  void setTempThreshold(double val) { _tempThreshold = val; notifyListeners(); }
  void setCurrentThreshold(double val) { _currentThreshold = val; notifyListeners(); }
  void toggleAutoShutdown(bool val) { _autoShutdown = val; notifyListeners(); }
  void toggleNotifications(bool val) { _notificationsEnabled = val; notifyListeners(); }

  void triggerEmergencyShutdown() {
    emergencyShutdownActive = true;
    overallStatus = "SHUTDOWN";
    recommendation = "Emergency Power Off state active. Structural system clear.";
    relayActive = false;
    notifyListeners();
  }

  void resetEmergencyShutdown() {
    emergencyShutdownActive = false;
    refreshAllData();
  }

  Future<void> refreshAllData() async {
    try {
      final dash = await _apiService.fetchDashboard();
      if (!emergencyShutdownActive) {
        overallStatus = dash['overallStatus'];
        recommendation = dash['recommendation'];
        relayActive = dash['relayActive'];
      }
      lastUpdated = dash['lastUpdated'];
      currentTemp = dash['temperature'];
      currentLoad = dash['current'];
      motionDetected = dash['motionDetected'];

      final devList = await _apiService.fetchDevices();
      devices = devList.map((e) => DeviceInfo.fromJson(e)).toList();

      final alertList = await _apiService.fetchAlerts();
      alerts = alertList.map((e) => AlertItem.fromJson(e)).toList();

      final histList = await _apiService.fetchHistory();
      historyEvents = histList.map((e) => HistoryEvent.fromJson(e)).toList();

      notifyListeners();
    } catch (_) {}
  }

  void reconnectDevice(String id) {
    int idx = devices.indexWhere((element) => element.id == id);
    if (idx != -1) {
      devices[idx] = DeviceInfo(
        id: devices[idx].id,
        name: devices[idx].name,
        isOnline: true,
        lastSync: "Just Now",
        connectionHealth: 100,
      );
      notifyListeners();
    }
  }
}
