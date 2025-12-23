// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';
// import '../ui/screens/age_gate_screen.dart';
// import '../ui/screens/geofence_gate_screen.dart';
// import '../ui/screens/auth/sign_in_screen.dart';
// import '../ui/screens/auth/sign_up_screen.dart';
// import '../ui/screens/profile_setup_screen.dart';
// import '../ui/screens/discovery_screen.dart';
// import '../ui/screens/profile_detail_screen.dart';
// import '../ui/screens/chat_list_screen.dart';
// import '../ui/screens/chat_screen.dart';
// import '../ui/screens/settings_screen.dart';

// class AppRouter {
//   static String initialRoute(AuthProvider auth) {
//     // Auth gating: if not logged in => AgeGate -> GeoGate -> SignUp/SignIn
//     if (auth.isLoggedIn) {
//       if (!auth.hasProfileSetup) return ProfileSetupScreen.routeName;
//       return DiscoveryScreen.routeName;
//     }
//     return AgeGateScreen.routeName;
//   }

//   static Route<dynamic> onGenerateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case AgeGateScreen.routeName:
//         return MaterialPageRoute(builder: (_) => const AgeGateScreen());
//       case GeofenceGateScreen.routeName:
//         return MaterialPageRoute(builder: (_) => const GeofenceGateScreen());
//       case SignInScreen.routeName:
//         return MaterialPageRoute(builder: (_) => const SignInScreen());
//       case SignUpScreen.routeName:
//         return MaterialPageRoute(builder: (_) => const SignUpScreen());
//       case ProfileSetupScreen.routeName:
//         return MaterialPageRoute(builder: (_) => const ProfileSetupScreen());
//       case DiscoveryScreen.routeName:
//         return MaterialPageRoute(builder: (_) => const DiscoveryScreen());
//       case ProfileDetailScreen.routeName:
//         final args = settings.arguments as ProfileDetailArgs;
//         return MaterialPageRoute(builder: (_) => ProfileDetailScreen(args: args));
//       case ChatListScreen.routeName:
//         return MaterialPageRoute(builder: (_) => const ChatListScreen());
//       case ChatScreen.routeName:
//         final args = settings.arguments as ChatScreenArgs;
//         return MaterialPageRoute(builder: (_) => ChatScreen(args: args));
//       case SettingsScreen.routeName:
//         return MaterialPageRoute(builder: (_) => const SettingsScreen());
//       default:
//         return MaterialPageRoute(
//           builder: (_) => const Scaffold(body: Center(child: Text('Route not found'))),
//         );
//     }
//   }
// }











import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../ui/screens/home_screen.dart';
import '../ui/screens/age_gate_screen.dart';
import '../ui/screens/geofence_gate_screen.dart';
import '../ui/screens/auth/sign_in_screen.dart';
import '../ui/screens/auth/sign_up_screen.dart';
import '../ui/screens/profile_setup_screen.dart';
import '../ui/screens/discovery_screen.dart';
import '../ui/screens/profile_detail_screen.dart';
import '../ui/screens/chat_list_screen.dart';
import '../ui/screens/chat_screen.dart';
import '../ui/screens/settings_screen.dart';

class AppRouter {
  static String initialRoute(AuthProvider auth) {
    // If logged in, always land at Home (tabs). No way back to onboarding stack.
    if (auth.isLoggedIn) {
      return HomeScreen.routeName;
    }
    // Not logged in => start onboarding (Age -> Geo -> Auth)
    return AgeGateScreen.routeName;
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeScreen.routeName:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AgeGateScreen.routeName:
        return MaterialPageRoute(builder: (_) => const AgeGateScreen());
      case GeofenceGateScreen.routeName:
        return MaterialPageRoute(builder: (_) => const GeofenceGateScreen());
      case SignInScreen.routeName:
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case SignUpScreen.routeName:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case ProfileSetupScreen.routeName:
        return MaterialPageRoute(builder: (_) => const ProfileSetupScreen());
      case DiscoveryScreen.routeName:
        return MaterialPageRoute(builder: (_) => const DiscoveryScreen());
      case ProfileDetailScreen.routeName:
        final args = settings.arguments as ProfileDetailArgs;
        return MaterialPageRoute(builder: (_) => ProfileDetailScreen(args: args));
      case ChatListScreen.routeName:
        return MaterialPageRoute(builder: (_) => const ChatListScreen());
      case ChatScreen.routeName:
        final args = settings.arguments as ChatScreenArgs;
        return MaterialPageRoute(builder: (_) => ChatScreen(args: args));
      case SettingsScreen.routeName:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}