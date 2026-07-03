import 'package:flutter/material.dart';
import '../utils/constants.dart';

class StatusBadge extends StatefulWidget {
  final String text;
  final Color color;

  const StatusBadge({super.key, required this.text, required this.color});

  @override
  State<StatusBadge> createState() => _StatusBadgeState();
}

class _StatusBadgeState extends State<StatusBadge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: widget.color.withOpacity(0.15 * _controller.value + 0.05),
            borderRadius: BorderRadius.circular(20),
            border: BorderSide(color: widget.color.withOpacity(_controller.value * 0.5 + 0.5), width: 1.5),
          ),
          child: Text(
            widget.text,
            style: TextStyle(color: widget.color, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
          ),
        );
      },
    );
  }
}

class MetricCard extends StatelessWidget {
  final String title;
  final Widget content;
  final IconData icon;

  const MetricCard({super.key, required this.title, required this.content, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.between,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
                Icon(icon, color: AppColors.accentNeon, size: 20),
              ],
            ),
            const Spacer(),
            content,
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
