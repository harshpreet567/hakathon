class DeviceInfo {
  final String id;
  final String name;
  final bool isOnline;
  final String lastSync;
  final int connectionHealth;

  DeviceInfo({
    required this.id,
    required this.name,
    required this.isOnline,
    required this.lastSync,
    required this.connectionHealth,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      id: json['id'],
      name: json['name'],
      isOnline: json['isOnline'],
      lastSync: json['lastSync'],
      connectionHealth: json['connectionHealth'],
    );
  }
}

class AlertItem {
  final String id;
  final String title;
  final String description;
  final String severity;
  final String timestamp;
  final String recommendation;

  AlertItem({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.timestamp,
    required this.recommendation,
  });

  factory AlertItem.fromJson(Map<String, dynamic> json) {
    return AlertItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      severity: json['severity'],
      timestamp: json['timestamp'],
      recommendation: json['recommendation'],
    );
  }
}

class HistoryEvent {
  final String id;
  final String type;
  final String description;
  final String timestamp;
  final String value;

  HistoryEvent({
    required this.id,
    required this.type,
    required this.description,
    required this.timestamp,
    required this.value,
  });

  factory HistoryEvent.fromJson(Map<String, dynamic> json) {
    return HistoryEvent(
      id: json['id'],
      type: json['type'],
      description: json['description'],
      timestamp: json['timestamp'],
      value: json['value'],
    );
  }
}
