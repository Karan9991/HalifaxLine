import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/time_utils.dart';
import '../../ui/widgets/gradient_scaffold.dart';
import '../../ui/widgets/glass_card.dart';
import '../../ui/widgets/primary_button.dart';
import '../../providers/auth_provider.dart';
import 'geofence_gate_screen.dart';

class AgeGateScreen extends StatefulWidget {
  static const routeName = '/age-gate';
  const AgeGateScreen({super.key});

  @override
  State<AgeGateScreen> createState() => _AgeGateScreenState();
}

class _AgeGateScreenState extends State<AgeGateScreen> {
  DateTime? _dob;
  bool _loading = false;

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final initial = DateTime(now.year - 18, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 100),
      lastDate: initial,
      helpText: 'Select your date of birth',
    );
    if (picked != null) {
      setState(() {
        _dob = picked;
      });
    }
  }

  Future<void> _continue() async {
    if (_dob == null) return;
    final ok = is18Plus(_dob!);
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be 18+ to use Halifax Line.')),
      );
      return;
    }
    setState(() => _loading = true);
    await context.read<AuthProvider>().setDobAndVerify(_dob!, ok);
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.pushReplacementNamed(context, GeofenceGateScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: const Text('Age Verification')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Are you 18 or older?',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  const Text(
                    'To protect our community, Halifax Line is 18+ only.',
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Your date of birth'),
                    subtitle: Text(_dob != null
                        ? '${_dob!.year}-${_dob!.month.toString().padLeft(2, '0')}-${_dob!.day.toString().padLeft(2, '0')}'
                        : 'Select your DOB'),
                    trailing: IconButton(
                      icon: const Icon(Icons.cake_outlined),
                      onPressed: _pickDob,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            PrimaryButton(
              text: 'Continue',
              icon: Icons.arrow_forward,
              loading: _loading,
              onPressed: _dob == null ? null : _continue,
            ),
          ],
        ),
      ),
    );
  }
}