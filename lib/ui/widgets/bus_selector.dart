import 'package:flutter/material.dart';
import '../../models/bus.dart';
import 'glass_card.dart';

class BusSelector extends StatelessWidget {
  final String? value;
  final void Function(String?) onChanged;
  const BusSelector({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: const InputDecoration(labelText: 'Which bus are you on?'),
        items: halifaxBusRoutes.map((b) => DropdownMenuItem(
          value: b.code, child: Text('${b.code} — ${b.name}')
        )).toList(),
        onChanged: onChanged,
      ),
    );
  }
}