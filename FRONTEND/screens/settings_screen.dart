import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pulse_provider.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PulseProvider>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader("HARDWARE TRIP SAFETY LIMITS"),
        const SizedBox(height: 12),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("THERMAL MAXIMUM BOUNDARY", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        Text("System triggers alarm if environment passes this point.", style: TextStyle(color: Colors.white38, fontSize: 11)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.warningNeon.withOpacity(0.1), borderRadius: BorderRadius.circular(6), border: BorderSide(color: AppColors.warningNeon.withOpacity(0.3))),
                      child: Text("${provider.tempThreshold.round()}°C", style: const TextStyle(color: AppColors.warningNeon, fontWeight: FontWeight.black, fontSize: 13)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SliderTheme(
                  data: _getSliderTheme(AppColors.warningNeon),
                  child: Slider(value: provider.tempThreshold, min: 20.0, max: 100.0, onChanged: (val) => provider.setTempThreshold(val)),
                ),
                const SizedBox(height: 20),
                const Divider(color: AppColors.borderDark, height: 1),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("CURRENT LOAD CEILING", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        Text("Protects custom testing rigs from overcurrent draws.", style: TextStyle(color: Colors.white38, fontSize: 11)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.accentNeon.withOpacity(0.1), borderRadius: BorderRadius.circular(6), border: BorderSide(color: AppColors.accentNeon.withOpacity(0.3))),
                      child: Text("${provider.currentThreshold.toStringAsFixed(1)} A", style: const TextStyle(color: AppColors.accentNeon, fontWeight: FontWeight.black, fontSize: 13)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SliderTheme(
                  data: _getSliderTheme(AppColors.accentNeon),
                  child: Slider(value: provider.currentThreshold, min: 1.0, max: 20.0, onChanged: (val) => provider.setCurrentThreshold(val)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildSectionHeader("AUTOMATION INTERCEPT CONFIG"),
        const SizedBox(height: 12),
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              _buildSwitchRow(title: "Hardware Intercept Auto-Shutdown", subtitle: "Instantly drops safety relay bus when thresholds breach.", value: provider.autoShutdown, onChanged: (val) => provider.toggleAutoShutdown(val), icon: Icons.bolt),
              const Divider(color: AppColors.borderDark, height: 1),
              _buildSwitchRow(title: "Matrix Push System Notifications", subtitle: "Broadcast telemetry alerts across multi-device framework.", value: provider.notificationsEnabled, onChanged: (val) => provider.toggleNotifications(val), icon: Icons.cell_tower),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white38, letterSpacing: 1.5));
  }

  SliderThemeData _getSliderTheme(Color neonColor) {
    return SliderThemeData(activeTrackColor: neonColor, inactiveTrackColor: AppColors.borderDark, thumbColor: neonColor, trackHeight: 4);
  }

  Widget _buildSwitchRow({required String title, required String subtitle, required bool value, required ValueChanged<bool> onChanged, required IconData icon}) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.accentNeon,
      secondary: Icon(icon, color: value ? AppColors.accentNeon : Colors.white38),
      title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 11)),
    );
  }
}
