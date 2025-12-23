import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'discovery_screen.dart';
import 'chat_list_screen.dart';
import 'settings_screen.dart';
import 'profile_setup_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  bool _checkedProfileOnce = false;

  final _pages = const [
    DiscoveryScreen(),
    ChatListScreen(),
    SettingsScreen(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Guard: if user hasn't set up profile, force them to ProfileSetup (one-time check).
    if (!_checkedProfileOnce) {
      _checkedProfileOnce = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final hasProfile = context.read<AuthProvider>().hasProfileSetup;
        if (!hasProfile) {
          Navigator.pushNamed(context, ProfileSetupScreen.routeName);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'Discover'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Chats'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}