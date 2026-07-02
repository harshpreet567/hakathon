import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pulse_provider.dart';
import '../utils/constants.dart';
import '../models/workspace_models.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  String activeFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PulseProvider>();
    
    final totalAll = provider.alerts.length;
    final totalWarnings = provider.alerts.where((a) => a.severity.toLowerCase() == 'warning').length;
    final totalCritical = provider.alerts.where((a) => a.severity.toLowerCase() == 'critical').length;
    final totalShutdowns = provider.alerts.where((a) => a.severity.toLowerCase() == 'shutdown').length;

    final filteredAlerts = provider.alerts.where((a) {
      if (activeFilter == 'All') return true;
      return a.severity.toLowerCase() == activeFilter.toLowerCase();
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("SYSTEM DIAGNOSTIC FILTERS", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', totalAll, AppColors.accentNeon),
                const SizedBox(width: 8),
                _buildFilterChip('Warning', totalWarnings, AppColors.warningNeon),
                const SizedBox(width: 8),
                _buildFilterChip('Critical', totalCritical, AppColors.criticalNeon),
                const SizedBox(width: 8),
                _buildFilterChip('Shutdown', totalShutdowns, Colors.purpleAccent),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text("INCIDENT CHRONOLOGY MATRIX", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
          const SizedBox(height: 16),
          Expanded(
            child: filteredAlerts.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: filteredAlerts.length,
                    itemBuilder: (context, i) {
                      final item = filteredAlerts[i];
                      final isLast = i == filteredAlerts.length - 1;
                      return _buildTimelineItem(item, isLast);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int count, Color color) {
    final isSelected = activeFilter == label;
    return ChoiceChip(
      selected: isSelected,
      onSelected: (_) => setState(() => activeFilter = label),
      backgroundColor: AppColors.surfaceDark,
      selectedColor: color.withOpacity(0.15),
      side: BorderSide(color: isSelected ? color : AppColors.borderDark, width: isSelected ? 1.5 : 1.0),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSelected ? color : Colors.white70)),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: isSelected ? color.withOpacity(0.2) : AppColors.borderDark, borderRadius: BorderRadius.circular(8)),
            child: Text('$count', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isSelected ? color : Colors.white38)),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(AlertItem item, bool isLast) {
    Color severityColor = AppColors.warningNeon;
    if (item.severity.toLowerCase() == 'critical') severityColor = AppColors.criticalNeon;
    if (item.severity.toLowerCase() == 'shutdown') severityColor = Colors.purpleAccent;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.bgDark, border: BorderSide(color: severityColor, width: 3), boxShadow: [BoxShadow(color: severityColor.withOpacity(0.4), blurRadius: 6)]),
              ),
              Expanded(child: Container(width: 2, color: isLast ? Colors.transparent : AppColors.borderDark)),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Card(
                margin: EdgeInsets.zero,
                child: ExpansionTile(
                  collapsedIconColor: Colors.white38,
                  iconColor: AppColors.accentNeon,
                  shape: const Border(),
                  title: Row(
                    children: [
                      Expanded(child: Text(item.title.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13))),
                      Text(item.timestamp, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      children: [
                        Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: severityColor)),
                        const SizedBox(width: 6),
                        Text(item.severity.toUpperCase(), style: TextStyle(color: severityColor, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(color: AppColors.borderDark, height: 1),
                          const SizedBox(height: 12),
                          const Text("TELEMETRY BRIEF", style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(item.description, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
                          const SizedBox(height: 16),
                          const Text("AI MITIGATION RECOMMENDATION", style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: AppColors.accentNeon.withOpacity(0.05), borderRadius: BorderRadius.circular(8), border: BorderSide(color: AppColors.accentNeon.withOpacity(0.2))),
                            child: Text(item.recommendation, style: const TextStyle(color: AppColors.accentNeon, fontSize: 12, fontWeight: FontWeight.w500, height: 1.4)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shield, size: 48, color: Colors.grey.shade800),
          const SizedBox(height: 16),
          Text("FILTER MATRIX CLEAR", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600, letterSpacing: 1)),
          const SizedBox(height: 4),
          const Text("No logs match this classification vector.", style: TextStyle(color: Colors.white24, fontSize: 12)),
        ],
      ),
    );
  }
}
