import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pulse_provider.dart';
import '../utils/constants.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String searchString = "";

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PulseProvider>();
    final list = provider.historyEvents.where((e) => e.type.toLowerCase().contains(searchString.toLowerCase()) || e.description.toLowerCase().contains(searchString.toLowerCase())).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: "Query bus event registers...",
              prefixIcon: const Icon(Icons.search, color: AppColors.accentNeon),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onChanged: (v) => setState(() => searchString = v),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, i) {
                final ev = list[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.timeline, color: AppColors.accentNeon),
                    title: Text("${ev.type} Stream -> ${ev.value}"),
                    subtitle: Text(ev.description),
                    trailing: Text(ev.timestamp, style: const TextStyle(fontSize: 11, color: Colors.white38)),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
