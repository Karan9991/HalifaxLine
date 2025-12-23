import 'package:flutter/material.dart';
import 'glass_card.dart';

class TimeRangePicker extends StatelessWidget {
  final TimeOfDay? start;
  final TimeOfDay? end;
  final void Function(TimeOfDay) onStartPicked;
  final void Function(TimeOfDay) onEndPicked;

  const TimeRangePicker({
    super.key,
    required this.start,
    required this.end,
    required this.onStartPicked,
    required this.onEndPicked,
  });

  Future<void> _pickTime(BuildContext context, bool isStart) async {
    final initial = isStart ? (start ?? TimeOfDay.now()) : (end ?? TimeOfDay.now());
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      if (isStart) onStartPicked(picked);
      else onEndPicked(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Start time'),
              subtitle: Text(start != null ? start!.format(context) : 'Select'),
              trailing: IconButton(
                icon: const Icon(Icons.schedule),
                onPressed: () => _pickTime(context, true),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('End time'),
              subtitle: Text(end != null ? end!.format(context) : 'Select'),
              trailing: IconButton(
                icon: const Icon(Icons.schedule_outlined),
                onPressed: () => _pickTime(context, false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}