// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../utils/validators.dart';
// import '../../../ui/widgets/gradient_scaffold.dart';
// import '../../../ui/widgets/glass_card.dart';
// import '../../../ui/widgets/input_field.dart';
// import '../../../ui/widgets/primary_button.dart';
// import '../../../services/auth_service.dart';
// import '../../../services/firestore_service.dart';
// import '../../../models/user_profile.dart';
// import '../../../providers/auth_provider.dart';
// import 'package:halifax_line/ui/screens/profile_setup_screen.dart';

// class SignUpScreen extends StatefulWidget {
//   static const routeName = '/sign-up';
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final _form = GlobalKey<FormState>();
//   final _email = TextEditingController();
//   final _password = TextEditingController();
//   final _name = TextEditingController();
//   bool _loading = false;

//   Future<void> _emailSignUp() async {
//     final ap = context.read<AuthProvider>();
//     if (!ap.ageVerified || !ap.geoVerified) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('Please complete Age and Location verification first.'),
//       ));
//       return;
//     }
//     if (!_form.currentState!.validate()) return;

//     setState(() => _loading = true);
//     try {
//       final cred = await AuthService().signUpWithEmail(_email.text.trim(), _password.text);
//       final uid = cred.user!.uid;

//       final profile = UserProfile(
//         uid: uid,
//         displayName: _name.text.trim(),
//         dob: ap.savedDob,
//         is18PlusVerified: true,
//         isGeoVerified: true,
//       );

//       await FirestoreService().userDoc(uid).set(profile.toMap(), SetOptions(merge: true));
//       if (!mounted) return;
//       Navigator.pushNamedAndRemoveUntil(context, ProfileSetupScreen.routeName, (_) => false);
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   Future<void> _googleSignUp() async {
//     final ap = context.read<AuthProvider>();
//     if (!ap.ageVerified || !ap.geoVerified) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('Please complete Age and Location verification first.'),
//       ));
//       return;
//     }
//     setState(() => _loading = true);
//     try {
//       final cred = await AuthService().signInWithGoogle();
//       final uid = cred.user!.uid;
//       final userDoc = await FirestoreService().userDoc(uid).get();
//       if (!userDoc.exists) {
//         // first time -> create profile
//         final profile = UserProfile(
//           uid: uid,
//           displayName: cred.user?.displayName ?? '',
//           photoUrl: cred.user?.photoURL,
//           dob: ap.savedDob,
//           is18PlusVerified: true,
//           isGeoVerified: true,
//         );
//         await FirestoreService().userDoc(uid).set(profile.toMap(), SetOptions(merge: true));
//       }
//       if (!mounted) return;
//       Navigator.pushNamedAndRemoveUntil(context, ProfileSetupScreen.routeName, (_) => false);
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GradientScaffold(
//       appBar: AppBar(title: const Text('Create your account')),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Form(
//           key: _form,
//           child: Column(
//             children: [
//               GlassCard(
//                 child: Column(
//                   children: [
//                     InputField(controller: _name, hint: 'Display name', validator: validateDisplayName),
//                     const SizedBox(height: 12),
//                     InputField(controller: _email, hint: 'Email', keyboardType: TextInputType.emailAddress, validator: validateEmail),
//                     const SizedBox(height: 12),
//                     InputField(controller: _password, hint: 'Password', obscure: true, validator: validatePassword),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16),
//               PrimaryButton(text: 'Sign up', icon: Icons.person_add, loading: _loading, onPressed: _loading ? null : _emailSignUp),
//               const SizedBox(height: 12),
//               OutlinedButton.icon(
//                 onPressed: _loading ? null : _googleSignUp,
//                 icon: const Icon(Icons.g_mobiledata, size: 28),
//                 label: const Text('Sign up with Google'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }






import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/validators.dart';
import '../../../ui/widgets/gradient_scaffold.dart';
import '../../../ui/widgets/glass_card.dart';
import '../../../ui/widgets/input_field.dart';
import '../../../ui/widgets/primary_button.dart';
import '../../../services/auth_service.dart';
import '../../../services/firestore_service.dart';
import '../../../models/user_profile.dart';
import '../../../providers/auth_provider.dart';
import 'package:halifax_line/ui/screens/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/sign-up';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  bool _loading = false;

  Future<void> _emailSignUp() async {
    final ap = context.read<AuthProvider>();
    if (!ap.ageVerified || !ap.geoVerified) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please complete Age and Location verification first.'),
      ));
      return;
    }
    if (!_form.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final cred = await AuthService().signUpWithEmail(_email.text.trim(), _password.text);
      final uid = cred.user!.uid;

      final profile = UserProfile(
        uid: uid,
        displayName: _name.text.trim(),
        dob: ap.savedDob,
        is18PlusVerified: true,
        isGeoVerified: true,
      );

      await FirestoreService().userDoc(uid).set(profile.toMap(), SetOptions(merge: true));
      if (!mounted) return;
      // Go straight to Home; Home will forward to Profile Setup if needed.
      Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (_) => false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _googleSignUp() async {
    final ap = context.read<AuthProvider>();
    if (!ap.ageVerified || !ap.geoVerified) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please complete Age and Location verification first.'),
      ));
      return;
    }
    setState(() => _loading = true);
    try {
      final cred = await AuthService().signInWithGoogle();
      final uid = cred.user!.uid;
      final userDoc = await FirestoreService().userDoc(uid).get();
      if (!userDoc.exists) {
        final profile = UserProfile(
          uid: uid,
          displayName: cred.user?.displayName ?? '',
          photoUrl: cred.user?.photoURL,
          dob: ap.savedDob,
          is18PlusVerified: true,
          isGeoVerified: true,
        );
        await FirestoreService().userDoc(uid).set(profile.toMap(), SetOptions(merge: true));
      }
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (_) => false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: const Text('Create your account')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _form,
          child: Column(
            children: [
              GlassCard(
                child: Column(
                  children: [
                    InputField(controller: _name, hint: 'Display name', validator: validateDisplayName),
                    const SizedBox(height: 12),
                    InputField(controller: _email, hint: 'Email', keyboardType: TextInputType.emailAddress, validator: validateEmail),
                    const SizedBox(height: 12),
                    InputField(controller: _password, hint: 'Password', obscure: true, validator: validatePassword),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(text: 'Sign up', icon: Icons.person_add, loading: _loading, onPressed: _loading ? null : _emailSignUp),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _loading ? null : _googleSignUp,
                icon: const Icon(Icons.g_mobiledata, size: 28),
                label: const Text('Sign up with Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}