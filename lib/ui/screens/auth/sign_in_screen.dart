// import 'package:flutter/material.dart';
// import 'package:halifax_line/ui/screens/discovery_screen.dart';
// import 'package:provider/provider.dart';
// import '../../../utils/validators.dart';
// import '../../../ui/widgets/gradient_scaffold.dart';
// import '../../../ui/widgets/glass_card.dart';
// import '../../../ui/widgets/input_field.dart';
// import '../../../ui/widgets/primary_button.dart';
// import '../../../services/auth_service.dart';
// import '../../../providers/auth_provider.dart';
// import 'package:halifax_line/ui/screens/profile_setup_screen.dart';

// class SignInScreen extends StatefulWidget {
//   static const routeName = '/sign-in';
//   const SignInScreen({super.key});

//   @override
//   State<SignInScreen> createState() => _SignInScreenState();
// }

// class _SignInScreenState extends State<SignInScreen> {
//   final _form = GlobalKey<FormState>();
//   final _email = TextEditingController();
//   final _password = TextEditingController();
//   bool _loading = false;

//   Future<void> _emailSignIn() async {
//     if (!_form.currentState!.validate()) return;
//     setState(() => _loading = true);
//     try {
//       await AuthService().signInWithEmail(_email.text.trim(), _password.text);
//       if (!mounted) return;
//       Navigator.pushNamedAndRemoveUntil(context, DiscoveryScreen.routeName, (_) => false);
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   Future<void> _googleSignIn() async {
//     setState(() => _loading = true);
//     try {
//       await AuthService().signInWithGoogle();
//       if (!mounted) return;
//       // If profile not set, go to setup
//       final ap = context.read<AuthProvider>();
//       if (!ap.hasProfileSetup) {
//         Navigator.pushNamedAndRemoveUntil(context, ProfileSetupScreen.routeName, (_) => false);
//       } else {
//         Navigator.pushNamedAndRemoveUntil(context, DiscoveryScreen.routeName, (_) => false);
//       }
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
//       appBar: AppBar(title: const Text('Welcome back')),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Form(
//           key: _form,
//           child: Column(
//             children: [
//               GlassCard(
//                 child: Column(
//                   children: [
//                     InputField(controller: _email, hint: 'Email', keyboardType: TextInputType.emailAddress, validator: validateEmail),
//                     const SizedBox(height: 12),
//                     InputField(controller: _password, hint: 'Password', obscure: true, validator: validatePassword),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16),
//               PrimaryButton(text: 'Sign in', icon: Icons.login, loading: _loading, onPressed: _loading ? null : _emailSignIn),
//               const SizedBox(height: 12),
//               OutlinedButton.icon(
//                 onPressed: _loading ? null : _googleSignIn,
//                 icon: const Icon(Icons.g_mobiledata, size: 28),
//                 label: const Text('Sign in with Google'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:halifax_line/ui/screens/home_screen.dart';
import 'package:provider/provider.dart';
import '../../../utils/validators.dart';
import '../../../ui/widgets/gradient_scaffold.dart';
import '../../../ui/widgets/glass_card.dart';
import '../../../ui/widgets/input_field.dart';
import '../../../ui/widgets/primary_button.dart';
import '../../../services/auth_service.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/sign-in';
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  Future<void> _emailSignIn() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await AuthService().signInWithEmail(_email.text.trim(), _password.text);
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (_) => false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _googleSignIn() async {
    setState(() => _loading = true);
    try {
      await AuthService().signInWithGoogle();
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
      appBar: AppBar(title: const Text('Welcome back')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _form,
          child: Column(
            children: [
              GlassCard(
                child: Column(
                  children: [
                    InputField(controller: _email, hint: 'Email', keyboardType: TextInputType.emailAddress, validator: validateEmail),
                    const SizedBox(height: 12),
                    InputField(controller: _password, hint: 'Password', obscure: true, validator: validatePassword),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(text: 'Sign in', icon: Icons.login, loading: _loading, onPressed: _loading ? null : _emailSignIn),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _loading ? null : _googleSignIn,
                icon: const Icon(Icons.g_mobiledata, size: 28),
                label: const Text('Sign in with Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}