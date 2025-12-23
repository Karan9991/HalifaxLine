// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:uuid/uuid.dart';

// import '../../providers/auth_provider.dart';
// import '../../providers/profile_provider.dart';
// import '../../models/user_profile.dart';
// import '../../ui/widgets/gradient_scaffold.dart';
// import '../../ui/widgets/glass_card.dart';
// import '../../ui/widgets/primary_button.dart';
// import '../../ui/widgets/bus_selector.dart';
// import '../../ui/widgets/time_range_picker.dart';
// import '../../utils/time_utils.dart';
// import '../../services/storage_service.dart';
// import '../../services/matching_service.dart';
// import 'package:halifax_line/ui/screens/discovery_screen.dart';

// class ProfileSetupScreen extends StatefulWidget {
//   static const routeName = '/profile-setup';
//   const ProfileSetupScreen({super.key});

//   @override
//   State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
// }

// class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
//   String? _bus;
//   TimeOfDay? _start;
//   TimeOfDay? _end;
//   bool _saving = false;
//   File? _avatar;

//   Future<void> _pickAvatar() async {
//     // No external lib; recommend using image_picker in a real app.
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Avatar upload omitted in this sample. Add image_picker for full flow.')),
//     );
//   }

//   Future<void> _save() async {
//     final auth = context.read<AuthProvider>();
//     final pp = context.read<ProfileProvider>();
//     if (auth.user == null) return;
//     if (_bus == null || _start == null || _end == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select bus and time window.')),
//       );
//       return;
//     }
//     // Build DateTime today from time of day
//     final now = DateTime.now();
//     final start = DateTime(now.year, now.month, now.day, _start!.hour, _start!.minute);
//     final end = DateTime(now.year, now.month, now.day, _end!.hour, _end!.minute);
//     if (end.isBefore(start)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('End time must be after start time.')),
//       );
//       return;
//     }
//     final dk = dayKey(now);
//     final slots = slotKeysForRange(start, end);

//     setState(() => _saving = true);
//     try {
//       // Load current profile
//       await pp.load(auth.user!.uid);
//       var profile = pp.me ?? UserProfile(uid: auth.user!.uid, is18PlusVerified: true, isGeoVerified: true);
//       String? photoUrl = profile.photoUrl;

//       if (_avatar != null) {
//         photoUrl = await StorageService().uploadAvatar(auth.user!.uid, _avatar!);
//       }

//       profile = profile.copyWith(
//         photoUrl: photoUrl,
//         activeBusRoute: _bus,
//         timeStart: start,
//         timeEnd: end,
//         dayKey: dk,
//         activeSlotKeys: slots,
//       );

//       await pp.createOrUpdate(profile);
//       await MatchingService().generateMatchesForUser(profile);

//       context.read<AuthProvider>().setProfileSetup(true);
//       if (!mounted) return;
//       Navigator.pushNamedAndRemoveUntil(context, DiscoveryScreen.routeName, (_) => false);
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
//     } finally {
//       if (mounted) setState(() => _saving = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GradientScaffold(
//       appBar: AppBar(title: const Text('Set up your profile')),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             GlassCard(
//               child: Row(
//                 children: [
//                   const CircleAvatar(radius: 32, child: Icon(Icons.person, size: 32)),
//                   const SizedBox(width: 12),
//                   Expanded(child: Text('Make a good impression! Add a photo and your availability today.')),
//                   IconButton(icon: const Icon(Icons.camera_alt_outlined), onPressed: _pickAvatar),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             BusSelector(value: _bus, onChanged: (v) => setState(() => _bus = v)),
//             const SizedBox(height: 16),
//             TimeRangePicker(
//               start: _start,
//               end: _end,
//               onStartPicked: (t) => setState(() => _start = t),
//               onEndPicked: (t) => setState(() => _end = t),
//             ),
//             const Spacer(),
//             PrimaryButton(text: 'Save & Find Matches', icon: Icons.favorite, loading: _saving, onPressed: _saving ? null : _save),
//           ],
//         ),
//       ),
//     );
//   }
// }







import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../models/user_profile.dart';
import '../../ui/widgets/gradient_scaffold.dart';
import '../../ui/widgets/glass_card.dart';
import '../../ui/widgets/primary_button.dart';
import '../../ui/widgets/bus_selector.dart';
import '../../ui/widgets/time_range_picker.dart';
import '../../utils/time_utils.dart';
import '../../services/storage_service.dart';
import '../../services/matching_service.dart';
import 'home_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  static const routeName = '/profile-setup';
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  String? _bus;
  TimeOfDay? _start;
  TimeOfDay? _end;
  bool _saving = false;
  File? _avatar;

  Future<void> _pickAvatar() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Avatar upload omitted in this sample. Add image_picker for full flow.')),
    );
  }

  Future<void> _save() async {
    final auth = context.read<AuthProvider>();
    final pp = context.read<ProfileProvider>();
    if (auth.user == null) return;
    if (_bus == null || _start == null || _end == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select bus and time window.')),
      );
      return;
    }
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day, _start!.hour, _start!.minute);
    final end = DateTime(now.year, now.month, now.day, _end!.hour, _end!.minute);
    if (end.isBefore(start)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End time must be after start time.')),
      );
      return;
    }
    final dk = dayKey(now);
    final slots = slotKeysForRange(start, end);

    setState(() => _saving = true);
    try {
      await pp.load(auth.user!.uid);
      var profile = pp.me ?? UserProfile(uid: auth.user!.uid, is18PlusVerified: true, isGeoVerified: true);
      String? photoUrl = profile.photoUrl;

      if (_avatar != null) {
        photoUrl = await StorageService().uploadAvatar(auth.user!.uid, _avatar!);
      }

      profile = profile.copyWith(
        photoUrl: photoUrl,
        activeBusRoute: _bus,
        timeStart: start,
        timeEnd: end,
        dayKey: dk,
        activeSlotKeys: slots,
      );

      await pp.createOrUpdate(profile);
      await MatchingService().generateMatchesForUser(profile);

      context.read<AuthProvider>().setProfileSetup(true);
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (_) => false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: const Text('Set up your profile')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GlassCard(
              child: Row(
                children: [
                  const CircleAvatar(radius: 32, child: Icon(Icons.person, size: 32)),
                  const SizedBox(width: 12),
                  const Expanded(child: Text('Make a good impression! Add a photo and your availability today.')),
                  IconButton(icon: const Icon(Icons.camera_alt_outlined), onPressed: _pickAvatar),
                ],
              ),
            ),
            const SizedBox(height: 16),
            BusSelector(value: _bus, onChanged: (v) => setState(() => _bus = v)),
            const SizedBox(height: 16),
            TimeRangePicker(
              start: _start,
              end: _end,
              onStartPicked: (t) => setState(() => _start = t),
              onEndPicked: (t) => setState(() => _end = t),
            ),
            const Spacer(),
            PrimaryButton(text: 'Save & Find Matches', icon: Icons.favorite, loading: _saving, onPressed: _saving ? null : _save),
          ],
        ),
      ),
    );
  }
}