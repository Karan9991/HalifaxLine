import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ui/widgets/gradient_scaffold.dart';
import '../../ui/widgets/glass_card.dart';
import '../../ui/widgets/primary_button.dart';
import '../../services/location_service.dart';
import '../../providers/auth_provider.dart';
import 'auth/sign_up_screen.dart';
import 'auth/sign_in_screen.dart';

class GeofenceGateScreen extends StatefulWidget {
  static const routeName = '/geo-gate';
  const GeofenceGateScreen({super.key});

  @override
  State<GeofenceGateScreen> createState() => _GeofenceGateScreenState();
}

class _GeofenceGateScreenState extends State<GeofenceGateScreen> {
  bool _checking = false;
  bool? _inside;

  Future<void> _check() async {
    setState(() => _checking = true);
    final inside = await LocationService().requestAndCheckHalifax();
    if (!mounted) return;
    setState(() {
      _checking = false;
      _inside = inside;
    });
    if (inside) {
      await context.read<AuthProvider>().setGeoVerified(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: const Text('Location Check')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Sign-ups are Halifax-only', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  SizedBox(height: 8),
                  Text('We use your location once to confirm you are within Halifax. '
                      'No background tracking, and your exact location is not stored.'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (_inside == false)
              const Text('You appear to be outside Halifax. You can still sign in if you already have an account.'),
            const Spacer(),
            PrimaryButton(
              text: _checking ? 'Checking...' : 'Verify location',
              icon: Icons.my_location,
              loading: _checking,
              onPressed: _checking ? null : _check,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, SignUpScreen.routeName),
                    child: const Text('Create account'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, SignInScreen.routeName),
                    child: const Text('Sign in'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}