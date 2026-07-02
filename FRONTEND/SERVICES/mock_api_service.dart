import 'dart:convert';

class MockApiService {
  static const String mockDashboardData = '''
  {
    "overallStatus": "Optimal",
    "recommendation": "All systems functioning normal. Environment stable.",
    "lastUpdated": "Just Now",
    "temperature": 24.5,
    "current": 1.8,
    "motionDetected": true,
    "relayActive": true,
    "emergencyShutdown": false
  }
  ''';

  static const String mockDevices = '''
  [
    {"id": "1", "name": "Mobile App", "isOnline": true, "lastSync": "10s ago", "connectionHealth": 98},
    {"id": "2", "name": "Snapdragon AI PC", "isOnline": true, "lastSync": "2s ago", "connectionHealth": 100},
    {"id": "3", "name": "Arduino UNO", "isOnline": true, "lastSync": "100ms ago", "connectionHealth": 95},
    {"id": "4", "name": "Cloud Workspace", "isOnline": false, "lastSync": "5m ago", "connectionHealth": 0}
  ]
  ''';

  static const String mockAlerts = '''
  [
    {"id": "1", "title": "High Current Spike", "description": "Overcurrent detected on Line 1 bench outlet.", "severity": "Warning", "timestamp": "10:45 AM", "recommendation": "Check load distribution on bench supply."},
    {"id": "2", "title": "Thermal Exceeded", "description": "Thermal threshold breached at Rig 3 testing rig.", "severity": "Critical", "timestamp": "09:12 AM", "recommendation": "Engage auxiliary active fans immediately."},
    {"id": "3", "title": "Manual Intercept", "description": "Emergency system hard-shutdown executed.", "severity": "Shutdown", "timestamp": "Yesterday", "recommendation": "Inspect circuitry before resetting main breakers."}
  ]
  ''';

  static const String mockHistory = '''
  [
    {"id": "1", "type": "Temperature", "description": "Ambient profile log captured", "timestamp": "2026-07-02 10:00 AM", "value": "24.5°C"},
    {"id": "2", "type": "Current", "description": "Inrush load stabilized", "timestamp": "2026-07-02 09:45 AM", "value": "1.8 A"},
    {"id": "3", "type": "Motion", "description": "Workspace safety zone entered", "timestamp": "2026-07-02 09:30 AM", "value": "Occupied"},
    {"id": "4", "type": "Relay", "description": "Primary safety bus state closed", "timestamp": "2026-07-02 09:15 AM", "value": "Active"}
  ]
  ''';

  Future<Map<String, dynamic>> fetchDashboard() async => jsonDecode(mockDashboardData);
  Future<List<dynamic>> fetchDevices() async => jsonDecode(mockDevices);
  Future<List<dynamic>> fetchAlerts() async => jsonDecode(mockAlerts);
  Future<List<dynamic>> fetchHistory() async => jsonDecode(mockHistory);
}
