import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pulse_provider.dart';
import '../utils/constants.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/telemetry_gauge.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PulseProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        double childAspectRatio;
        
        if (constraints.maxWidth > 1200) {
          crossAxisCount = 4;
          childAspectRatio = 1.0;
        } else if (constraints.maxWidth > 800) {
          crossAxisCount = 2;
          childAspectRatio = 1.3;
        } else if (constraints.maxWidth > 600) {
          crossAxisCount = 2;
          childAspectRatio = 1.1;
        } else {
          crossAxisCount = 1;
          childAspectRatio = 1.6;
        }

        final isDesktop = constraints.maxWidth > 800;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHealthOverviewCard(provider),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: childAspectRatio,
                children: [
                  _buildTemperatureCard(provider),
                  _buildCurrentCard(provider),
                  _buildMotionCard(provider),
                  _buildRelayCard(provider),
                ],
              ),
              const SizedBox(height: 20),
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 1, child: _buildDeviceMatrix(provider)),
                    const SizedBox(width: 16),
                    Expanded(flex: 1, child: _buildAlertPreview(provider)),
                  ],
                )
              else ...[
                _buildDeviceMatrix(provider),
                const SizedBox(height: 16),
                _buildAlertPreview(provider),
              ],
              const SizedBox(height: 24),
              _buildEmergencyButton(provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTemperatureCard(PulseProvider provider) {
    final isCritical = provider.currentTemp > provider.tempThreshold;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text("THERMAL LOAD", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: TelemetryGauge(
                value: provider.currentTemp,
                max: provider.tempThreshold * 1.2,
                unit: "°C",
                activeColor: isCritical ? AppColors.criticalNeon : AppColors.successNeon,
                icon: Icons.thermostat,
              ),
            ),
            Text(isCritical ? "THRESHOLD BREACH" : "NOMINAL", style: TextStyle(color: isCritical ? AppColors.criticalNeon : Colors.grey, fontSize: 11, fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentCard(PulseProvider provider) {
    final isCritical = provider.currentLoad > provider.currentThreshold;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text("CURRENT DRAW", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: TelemetryGauge(
                value: provider.currentLoad,
                max: provider.currentThreshold * 1.5,
                unit: "A",
                activeColor: isCritical ? AppColors.warningNeon : AppColors.accentNeon,
                icon: Icons.electric_bolt,
              ),
            ),
            Text(isCritical ? "OVERLOAD VECTOR" : "STABLE DRAW", style: TextStyle(color: isCritical ? AppColors.warningNeon : Colors.grey, fontSize: 11, fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }

  Widget _buildMotionCard(PulseProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("WORKSPACE SENSOR", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
            const Spacer(),
            Center(
              child: Column(
                children: [
                  Icon(provider.motionDetected ? Icons.directions_run : Icons.accessibility_new, size: 48, color: provider.motionDetected ? AppColors.successNeon : Colors.grey.shade700),
                  const SizedBox(height: 12),
                  Text(provider.motionDetected ? "OCCUPIED" : "IDLE", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                ],
              ),
            ),
            const Spacer(),
            const Center(child: Text("Zone 1 Radar Active", style: TextStyle(color: Colors.white38, fontSize: 11)))
          ],
        ),
      ),
    );
  }

  Widget _buildRelayCard(PulseProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("SAFETY RELAY BUS", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
            const Spacer(),
            Center(
              child: Column(
                children: [
                  Icon(provider.relayActive ? Icons.lock_open : Icons.lock, size: 48, color: provider.relayActive ? AppColors.successNeon : AppColors.criticalNeon),
                  const SizedBox(height: 12),
                  Text(provider.relayActive ? "ENGAGED" : "LOCKED OUT", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: provider.relayActive ? Colors.white : AppColors.criticalNeon, letterSpacing: 1.5)),
                ],
              ),
            ),
            const Spacer(),
            Center(child: Text(provider.emergencyShutdownActive ? "HARDWARE ESTOP TRIPPED" : "Circuit Closed", style: const TextStyle(color: Colors.white38, fontSize: 11)))
          ],
        ),
      ),
    );
  }

  Widget _buildHealthOverviewCard(PulseProvider provider) {
    Color statusColor = provider.emergencyShutdownActive ? AppColors.criticalNeon : AppColors.successNeon;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("WORKSPACE SYSTEM INDEX", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  const SizedBox(height: 8),
                  Text(provider.recommendation, style: const TextStyle(fontSize: 15, color: Colors.white70)),
                  const SizedBox(height: 12),
                  Text("Telemetry Refresh: ${provider.lastUpdated}", style: const TextStyle(color: Colors.white38, fontSize: 11)),
                ],
              ),
            ),
            StatusBadge(text: provider.overallStatus.toUpperCase(), color: statusColor),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceMatrix(PulseProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("CONNECTIONS FABRIC", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
            const Divider(color: AppColors.borderDark, height: 30),
            ...provider.devices.map((d) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      Text(d.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                      Row(
                        children: [
                          Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: d.isOnline ? AppColors.successNeon : AppColors.criticalNeon, boxShadow: [BoxShadow(color: (d.isOnline ? AppColors.successNeon : AppColors.criticalNeon).withOpacity(0.5), blurRadius: 4)])),
                          const SizedBox(width: 8),
                          Text(d.isOnline ? "ONLINE" : "OFFLINE", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: d.isOnline ? AppColors.successNeon : AppColors.criticalNeon)),
                        ],
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertPreview(PulseProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("CRITICAL THREAT FEED", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
            const Divider(color: AppColors.borderDark, height: 30),
            if (provider.alerts.isEmpty)
              const Text("No unresolved structural threats.", style: TextStyle(color: Colors.white54))
            else
              ...provider.alerts.take(3).map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.between,
                      children: [
                        Text(a.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        Text(a.timestamp, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(a.description, style: const TextStyle(color: Colors.white54, fontSize: 13)),
                  ],
                ),
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyButton(PulseProvider provider) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: provider.emergencyShutdownActive ? Colors.blueGrey.shade900 : AppColors.criticalNeon.withOpacity(0.9),
          foregroundColor: Colors.white,
          elevation: provider.emergencyShutdownActive ? 0 : 8,
          shadowColor: AppColors.criticalNeon.withOpacity(0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: () {
          if (provider.emergencyShutdownActive) {
            provider.resetEmergencyShutdown();
          } else {
            provider.triggerEmergencyShutdown();
          }
        },
        icon: Icon(provider.emergencyShutdownActive ? Icons.restart_alt : Icons.warning_amber_rounded, size: 28),
        label: Text(
          provider.emergencyShutdownActive ? "RESET & RE-ARM BUS" : "EMERGENCY SHUTDOWN (ESTOP)",
          style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 15),
        ),
      ),
    );
  }
}
