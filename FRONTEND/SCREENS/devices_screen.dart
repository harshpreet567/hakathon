import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pulse_provider.dart';
import '../utils/constants.dart';

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PulseProvider>();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.devices.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        mainAxisExtent: 180,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, i) {
        final d = provider.devices[i];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    Text(d.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: d.isOnline ? AppColors.successNeon : AppColors.criticalNeon)),
                  ],
                ),
                const SizedBox(height: 12),
                Text("Telemetry Link: ${d.isOnline ? 'Active' : 'Dropped'}", style: const TextStyle(color: Colors.white60, fontSize: 13)),
                Text("Last Heartbeat: ${d.lastSync}", style: const TextStyle(color: Colors.white38, fontSize: 12)),
                const SizedBox(height: 8),
                Text("Sync Integrity: ${d.connectionHealth}%", style: const TextStyle(fontSize: 13)),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton.icon(
                    style: TextButton.styleFrom(foregroundColor: AppColors.accentNeon),
                    onPressed: () => provider.reconnectDevice(d.id),
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text("FORCE SYNC"),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
