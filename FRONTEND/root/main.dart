import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/pulse_provider.dart';
import 'theme/app_theme.dart';
import 'screens/dashboard_screen.dart';
import 'screens/alerts_screen.dart';
import 'screens/devices_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';
import 'utils/constants.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PulseProvider(),
      child: const PulseApp(),
    ),
  );
}

class PulseApp extends StatelessWidget {
  const PulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pulse Safety Platform',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const AlertsScreen(),
    const DevicesScreen(),
    const HistoryScreen(),
    const SettingsScreen(),
  ];

  final List<String> _titles = [
    "PULSE CONTROL CENTER",
    "ALERT LOG MANAGEMENT",
    "NODE CONNECTIONS FABRIC",
    "HISTORICAL TELEMETRY MATRIX",
    "CORE SYSTEM CONFIG"
  ];

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex], style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1.5, color: AppColors.accentNeon)),
        backgroundColor: AppColors.bgDark,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync, color: AppColors.accentNeon),
            onPressed: () => context.read<PulseProvider>().refreshAllData(),
          )
        ],
      ),
      body: isLargeScreen
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
                  backgroundColor: AppColors.surfaceDark,
                  indicatorColor: AppColors.accentNeon.withOpacity(0.2),
                  selectedIconTheme: const IconThemeData(color: AppColors.accentNeon),
                  unselectedIconTheme: const IconThemeData(color: Colors.white38),
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text("Dash")),
                    NavigationRailDestination(icon: Icon(Icons.warning), label: Text("Alerts")),
                    NavigationRailDestination(icon: Icon(Icons.developer_board), label: Text("Nodes")),
                    NavigationRailDestination(icon: Icon(Icons.history), label: Text("History")),
                    NavigationRailDestination(icon: Icon(Icons.settings), label: Text("Config")),
                  ],
                ),
                const VerticalDivider(width: 1, color: AppColors.borderDark),
                Expanded(child: _screens[_currentIndex]),
              ],
            )
          : _screens[_currentIndex],
      bottomNavigationBar: isLargeScreen
          ? null
          : BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (idx) => setState(() => _currentIndex = idx),
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppColors.surfaceDark,
              selectedItemColor: AppColors.accentNeon,
              unselectedItemColor: Colors.white38,
              showUnselectedLabels: true,
              selectedFontSize: 11,
              unselectedFontSize: 11,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dash"),
                BottomNavigationBarItem(icon: Icon(Icons.warning), label: "Alerts"),
                BottomNavigationBarItem(icon: Icon(Icons.developer_board), label: "Nodes"),
                BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Config"),
              ],
            ),
    );
  }
}
