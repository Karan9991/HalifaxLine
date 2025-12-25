// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:halifax_line/ui/screens/chat_screen.dart';
// import 'package:provider/provider.dart';

// import '../../providers/auth_provider.dart';
// import '../../providers/profile_provider.dart';
// import '../../providers/match_provider.dart';
// import '../../models/user_profile.dart';
// import '../../services/firestore_service.dart';
// import '../../services/matching_service.dart';
// import '../../services/blocking_service.dart';
// import '../../ui/widgets/gradient_scaffold.dart';
// import '../../ui/widgets/glass_card.dart';
// import '../../ui/widgets/primary_button.dart';
// import '../../ui/widgets/empty_state.dart';
// import 'package:halifax_line/ui/screens/chat_list_screen.dart';
// import 'package:halifax_line/ui/screens/settings_screen.dart';
// import 'package:halifax_line/ui/screens/profile_setup_screen.dart';
// import 'package:halifax_line/ui/screens/profile_detail_screen.dart';

// class DiscoveryScreen extends StatefulWidget {
//   static const routeName = '/discovery';
//   const DiscoveryScreen({super.key});

//   @override
//   State<DiscoveryScreen> createState() => _DiscoveryScreenState();
// }

// class _DiscoveryScreenState extends State<DiscoveryScreen> {
//   List<UserProfile> _suggestions = [];
//   bool _loading = true;

//   Future<void> _refreshSuggestions() async {
//     final auth = context.read<AuthProvider>();
//     final pp = context.read<ProfileProvider>();
//     if (auth.user == null) return;
//     await pp.load(auth.user!.uid);
//     final me = pp.me;
//     if (me == null || me.activeBusRoute == null || me.activeSlotKeys.isEmpty) {
//       setState(() {
//         _suggestions = [];
//         _loading = false;
//       });
//       return;
//     }
//     final blocked = await BlockingService().getBlocked(auth.user!.uid);
//     final matches = await MatchingService().potentialMatches(me);
//     setState(() {
//       _suggestions = matches.where((u) => !blocked.contains(u.uid)).toList();
//       _loading = false;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _refreshSuggestions();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final auth = context.watch<AuthProvider>();
//     final matchProv = context.watch<MatchProvider>();

//     return GradientScaffold(
//       appBar: AppBar(
//         title: const Text('Halifax Line'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.settings),
//             onPressed: () => Navigator.pushNamed(context, SettingsScreen.routeName),
//           ),
//           IconButton(
//             icon: const Icon(Icons.chat_bubble_outline),
//             onPressed: () => Navigator.pushNamed(context, ChatListScreen.routeName),
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: _refreshSuggestions,
//         child: ListView(
//           padding: const EdgeInsets.all(20),
//           children: [
//             GlassCard(
//               child: Row(
//                 children: [
//                   const Icon(Icons.directions_bus, color: Colors.white70),
//                   const SizedBox(width: 12),
//                   Expanded(child: Text('We match people on the same bus with overlapping time windows. No swipes, just chats.')),
//                   IconButton(
//                     icon: const Icon(Icons.edit_calendar),
//                     onPressed: () => Navigator.pushNamed(context, ProfileSetupScreen.routeName),
//                   )
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text('People on your route now', style: Theme.of(context).textTheme.titleLarge),
//             const SizedBox(height: 10),
//             if (_loading)
//               const Center(child: Padding(
//                 padding: EdgeInsets.all(24.0),
//                 child: CircularProgressIndicator(),
//               ))
//             else if (_suggestions.isEmpty)
//               const EmptyState(
//                 title: 'No suggestions right now',
//                 subtitle: 'Try adjusting your time window or check back soon.',
//               )
//             else
//               ..._suggestions.map((u) => _SuggestionTile(user: u)),
//             const SizedBox(height: 24),
//             Text('Your matches', style: Theme.of(context).textTheme.titleLarge),
//             const SizedBox(height: 10),
//             StreamBuilder(
//               stream: matchProv.matchesFor(auth.user!.uid),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(child: Padding(
//                     padding: EdgeInsets.all(24.0),
//                     child: CircularProgressIndicator(),
//                   ));
//                 }
//                 final matches = snapshot.data!;
//                 if (matches.isEmpty) {
//                   return const EmptyState(
//                     title: 'No matches yet',
//                     subtitle: 'When you overlap with someone on the same bus, you’ll see them here.',
//                     icon: Icons.favorite_border,
//                   );
//                 }
//                 return Column(
//                   children: matches.map((m) => ListTile(
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                     tileColor: Colors.white.withOpacity(0.06),
//                     leading: const CircleAvatar(child: Icon(Icons.favorite)),
//                     title: Text('Chat on ${m.busRoute}'),
//                     subtitle: Text('Day ${m.dayKey}'),
//                     trailing: const Icon(Icons.chevron_right),
//                     onTap: () => Navigator.pushNamed(context, '/chat', arguments: ChatScreenArgs(chatId: m.chatId, title: 'Chat on ${m.busRoute}')),
//                   )).toList(),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _SuggestionTile extends StatelessWidget {
//   final UserProfile user;
//   const _SuggestionTile({required this.user});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.white.withOpacity(0.06),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: ListTile(
//         leading: const CircleAvatar(child: Icon(Icons.person)),
//         title: Text(user.displayName ?? 'Halifax Rider'),
//         subtitle: Text('On bus ${user.activeBusRoute}'),
//         trailing: ElevatedButton(
//           child: const Text('View'),
//           onPressed: () {
//             Navigator.pushNamed(context, ProfileDetailScreen.routeName, arguments: ProfileDetailArgs(userId: user.uid));
//           },
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../providers/auth_provider.dart';
// import '../../providers/profile_provider.dart';
// import '../../providers/match_provider.dart';
// import '../../models/user_profile.dart';
// import '../../services/matching_service.dart';
// import '../../services/blocking_service.dart';
// import '../../ui/widgets/gradient_scaffold.dart';
// import '../../ui/widgets/glass_card.dart';
// import '../../ui/widgets/primary_button.dart';
// import '../../ui/widgets/empty_state.dart';
// import 'package:halifax_line/ui/screens/profile_setup_screen.dart';
// import 'package:halifax_line/ui/screens/profile_detail_screen.dart';
// import 'package:halifax_line/ui/screens/chat_screen.dart';

// class DiscoveryScreen extends StatefulWidget {
//   static const routeName = '/discovery';
//   const DiscoveryScreen({super.key});

//   @override
//   State<DiscoveryScreen> createState() => _DiscoveryScreenState();
// }

// class _DiscoveryScreenState extends State<DiscoveryScreen> {
//   List<UserProfile> _suggestions = [];
//   bool _loading = true;

//   Future<void> _refreshSuggestions() async {
//     final auth = context.read<AuthProvider>();
//     final pp = context.read<ProfileProvider>();
//     if (auth.user == null) return;
//     await pp.load(auth.user!.uid);
//     final me = pp.me;
//     if (me == null || me.activeBusRoute == null || me.activeSlotKeys.isEmpty) {
//       setState(() {
//         _suggestions = [];
//         _loading = false;
//       });
//       return;
//     }
//     final blocked = await BlockingService().getBlocked(auth.user!.uid);
//     final matches = await MatchingService().potentialMatches(me);
//     setState(() {
//       _suggestions = matches.where((u) => !blocked.contains(u.uid)).toList();
//       _loading = false;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _refreshSuggestions();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final auth = context.watch<AuthProvider>();
//     final matchProv = context.watch<MatchProvider>();

//     return GradientScaffold(
//       appBar: AppBar(
//         title: const Text('Discover'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit_calendar),
//             onPressed: () => Navigator.pushNamed(context, ProfileSetupScreen.routeName),
//             tooltip: 'Change availability',
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: _refreshSuggestions,
//         child: ListView(
//           padding: const EdgeInsets.all(20),
//           children: [
//             GlassCard(
//               child: Row(
//                 children: const [
//                   Icon(Icons.directions_bus, color: Colors.white70),
//                   SizedBox(width: 12),
//                   Expanded(child: Text('We match people on the same bus with overlapping time windows. No swipes, just chats.')),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text('People on your route now', style: Theme.of(context).textTheme.titleLarge),
//             const SizedBox(height: 10),
//             if (_loading)
//               const Center(child: Padding(
//                 padding: EdgeInsets.all(24.0),
//                 child: CircularProgressIndicator(),
//               ))
//             else if (_suggestions.isEmpty)
//               const EmptyState(
//                 title: 'No suggestions right now',
//                 subtitle: 'Try adjusting your time window or check back soon.',
//               )
//             else
//               ..._suggestions.map((u) => _SuggestionTile(user: u)),
//             const SizedBox(height: 24),
//             Text('Your matches', style: Theme.of(context).textTheme.titleLarge),
//             const SizedBox(height: 10),
//             StreamBuilder(
//               stream: matchProv.matchesFor(auth.user!.uid),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return const EmptyState(
//                     title: 'No matches yet',
//                     subtitle: 'We’ll show matches here once you overlap on the same bus.',
//                     icon: Icons.favorite_border,
//                   );
//                 }
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: Padding(
//                     padding: EdgeInsets.all(24.0),
//                     child: CircularProgressIndicator(),
//                   ));
//                 }
//                 final matches = snapshot.data ?? [];
//                 if (matches.isEmpty) {
//                   return const EmptyState(
//                     title: 'No matches yet',
//                     subtitle: 'When you overlap with someone on the same bus, you’ll see them here.',
//                     icon: Icons.favorite_border,
//                   );
//                 }
//                 return Column(
//                   children: matches.map((m) => ListTile(
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                     tileColor: Colors.white.withOpacity(0.06),
//                     leading: const CircleAvatar(child: Icon(Icons.favorite)),
//                     title: Text('Chat on ${m.busRoute}'),
//                     subtitle: Text('Day ${m.dayKey}'),
//                     trailing: const Icon(Icons.chevron_right),
//                     onTap: () => Navigator.pushNamed(
//                       context,
//                       ChatScreen.routeName,
//                       arguments: ChatScreenArgs(chatId: m.chatId, title: 'Chat on ${m.busRoute}'),
//                     ),
//                   )).toList(),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _SuggestionTile extends StatelessWidget {
//   final UserProfile user;
//   const _SuggestionTile({required this.user});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.white.withOpacity(0.06),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: ListTile(
//         leading: const CircleAvatar(child: Icon(Icons.person)),
//         title: Text(user.displayName ?? 'Halifax Rider'),
//         subtitle: Text('On bus ${user.activeBusRoute}'),
//         trailing: ElevatedButton(
//           child: const Text('View'),
//           onPressed: () {
//             Navigator.pushNamed(context, ProfileDetailScreen.routeName, arguments: ProfileDetailArgs(userId: user.uid));
//           },
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:halifax_line/ui/screens/chat_screen.dart';
// import 'package:halifax_line/ui/screens/profile_detail_screen.dart';
// import 'package:halifax_line/ui/screens/profile_setup_screen.dart';
// import 'package:provider/provider.dart';

// import '../../providers/auth_provider.dart';
// import '../../providers/profile_provider.dart';
// import '../../providers/match_provider.dart';
// import '../../models/user_profile.dart';
// import '../../services/matching_service.dart';
// import '../../services/blocking_service.dart';
// import '../../ui/widgets/gradient_scaffold.dart';
// import '../../ui/widgets/glass_card.dart';
// import '../../ui/widgets/primary_button.dart';
// import '../../ui/widgets/empty_state.dart';

// class DiscoveryScreen extends StatefulWidget {
//   static const routeName = '/discovery';
//   const DiscoveryScreen({super.key});

//   @override
//   State<DiscoveryScreen> createState() => _DiscoveryScreenState();
// }

// class _DiscoveryScreenState extends State<DiscoveryScreen> {
//   List<UserProfile> _onRouteNow = [];
//   bool _loading = true;

//   Future<void> _refresh() async {
//     final auth = context.read<AuthProvider>();
//     final pp = context.read<ProfileProvider>();
//     try {
//       if (auth.user == null) return;
//       await pp.load(auth.user!.uid);
//       final me = pp.me;
//       if (me == null || me.activeBusRoute == null || me.activeSlotKeys.isEmpty) {
//         setState(() {
//           _onRouteNow = [];
//           _loading = false;
//         });
//         return;
//       }

//       // Auto-generate matches for any new overlaps since last save.
//       await MatchingService().generateMatchesForUser(me);

//       final blocked = await BlockingService().getBlocked(auth.user!.uid);
//       final overlaps = await MatchingService().overlapsForUser(me);

//       setState(() {
//         _onRouteNow = overlaps.where((u) => !blocked.contains(u.uid)).toList();
//         _loading = false;
//       });
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         _onRouteNow = [];
//         _loading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Could not load people on your route. ${e.toString()}')),
//       );
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _refresh();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final auth = context.watch<AuthProvider>();
//     final matchProv = context.watch<MatchProvider>();

//     return GradientScaffold(
//       appBar: AppBar(
//         title: const Text('Discover'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit_calendar),
//             onPressed: () async {
//               await Navigator.pushNamed(context, ProfileSetupScreen.routeName);
//               if (!mounted) return;
//               _refresh();
//             },
//             tooltip: 'Change availability',
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: _refresh,
//         child: ListView(
//           padding: const EdgeInsets.all(20),
//           children: [
//             GlassCard(
//               child: Row(
//                 children: const [
//                   Icon(Icons.directions_bus, color: Colors.white70),
//                   SizedBox(width: 12),
//                   Expanded(child: Text('We match people on the same bus with overlapping time windows. No swipes, just chats.')),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text('People on your route now', style: Theme.of(context).textTheme.titleLarge),
//             const SizedBox(height: 10),
//             if (_loading)
//               const Center(child: Padding(
//                 padding: EdgeInsets.all(24.0),
//                 child: CircularProgressIndicator(),
//               ))
//             else if (_onRouteNow.isEmpty)
//               const EmptyState(
//                 title: 'No one visible at the moment',
//                 subtitle: 'Try adjusting your time window or check back shortly.',
//               )
//             else
//               ..._onRouteNow.map((u) => _OnRouteTile(user: u)),
//             const SizedBox(height: 24),
//             Text('Your matches', style: Theme.of(context).textTheme.titleLarge),
//             const SizedBox(height: 10),
//             StreamBuilder(
//               stream: matchProv.matchesFor(auth.user!.uid),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return const EmptyState(
//                     title: 'No matches yet',
//                     subtitle: 'We’ll show matches here once you overlap on the same bus.',
//                     icon: Icons.favorite_border,
//                   );
//                 }
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: Padding(
//                     padding: EdgeInsets.all(24.0),
//                     child: CircularProgressIndicator(),
//                   ));
//                 }
//                 final matches = snapshot.data ?? [];
//                 if (matches.isEmpty) {
//                   return const EmptyState(
//                     title: 'No matches yet',
//                     subtitle: 'When you overlap with someone on the same bus, you’ll see them here.',
//                     icon: Icons.favorite_border,
//                   );
//                 }
//                 return Column(
//                   children: matches.map((m) => ListTile(
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                     tileColor: Colors.white.withOpacity(0.06),
//                     leading: const CircleAvatar(child: Icon(Icons.favorite)),
//                     title: Text('Chat on ${m.busRoute}'),
//                     subtitle: Text('Day ${m.dayKey}'),
//                     trailing: const Icon(Icons.chevron_right),
//                     onTap: () => Navigator.pushNamed(
//                       context,
//                       ChatScreen.routeName,
//                       arguments: ChatScreenArgs(chatId: m.chatId, title: 'Chat on ${m.busRoute}'),
//                     ),
//                   )).toList(),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _OnRouteTile extends StatelessWidget {
//   final UserProfile user;
//   const _OnRouteTile({required this.user});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.white.withOpacity(0.06),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: ListTile(
//         leading: const CircleAvatar(child: Icon(Icons.person)),
//         title: Text(user.displayName ?? 'Halifax Rider'),
//         subtitle: Text('On bus ${user.activeBusRoute}'),
//         trailing: ElevatedButton(
//           child: const Text('View'),
//           onPressed: () {
//             Navigator.pushNamed(
//               context,
//               ProfileDetailScreen.routeName,
//               arguments: ProfileDetailArgs(userId: user.uid),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:halifax_line/providers/chat_provider.dart';
import 'package:halifax_line/ui/screens/chat_screen.dart';
import 'package:halifax_line/ui/screens/profile_detail_screen.dart';
import 'package:halifax_line/ui/screens/profile_setup_screen.dart';
import 'package:provider/provider.dart';

import '../../models/bus.dart';
import '../../models/user_profile.dart';
import '../../providers/auth_provider.dart';
import '../../providers/match_provider.dart';
import '../../providers/profile_provider.dart';
import '../../services/blocking_service.dart';
import '../../services/matching_service.dart';
import '../../ui/widgets/empty_state.dart';
import '../../ui/widgets/glass_card.dart';
import '../../ui/widgets/gradient_scaffold.dart';
import '../../utils/time_utils.dart';

class DiscoveryScreen extends StatefulWidget {
  static const routeName = '/discovery';
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  final _matchSvc = MatchingService();

  List<UserProfile> _activeToday = [];
  List<UserProfile> _onRouteNow = [];
  bool _loading = true;

  String _busLabel(String? code) {
    if (code == null || code.isEmpty) return 'Route N/A';
    final match = halifaxBusRoutes.firstWhere(
      (b) => b.code == code,
      orElse: () => BusRoute(code, ''),
    );
    return match.name.isNotEmpty
        ? '${match.code} — ${match.name}'
        : 'Route ${match.code}';
  }

  Future<void> _refresh() async {
    final auth = context.read<AuthProvider>();
    final pp = context.read<ProfileProvider>();

    try {
      if (auth.user == null) return;
      await pp.load(auth.user!.uid);
      final me = pp.me;
      if (me == null || me.dayKey == null) {
        setState(() {
          _activeToday = [];
          _onRouteNow = [];
          _loading = false;
        });
        return;
      }

      // Ensure matches are generated for overlaps.
      await _matchSvc.generateMatchesForUser(me);

      final blocked = await BlockingService().getBlocked(auth.user!.uid);

      // Everyone active today (any route/time)
      final allToday = await _matchSvc.allActiveTodayFor(me);
      // Filter blocked
      final allTodayFiltered =
          allToday.where((u) => !blocked.contains(u.uid)).toList();

      // People on your route now (overlap)
      List<UserProfile> onRoute = [];
      if (me.activeBusRoute != null && me.activeSlotKeys.isNotEmpty) {
        onRoute = await _matchSvc.overlapsForUser(me);
        onRoute = onRoute.where((u) => !blocked.contains(u.uid)).toList();
      }

      // Sort for nicer UX
      allTodayFiltered.sort((a, b) {
        // First by bus code, then by start time
        final c = (a.activeBusRoute ?? '').compareTo(b.activeBusRoute ?? '');
        if (c != 0) return c;
        final at = a.timeStart ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bt = b.timeStart ?? DateTime.fromMillisecondsSinceEpoch(0);
        return at.compareTo(bt);
      });
      onRoute.sort((a, b) {
        final at = a.timeStart ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bt = b.timeStart ?? DateTime.fromMillisecondsSinceEpoch(0);
        return at.compareTo(bt);
      });

      setState(() {
        _activeToday = allTodayFiltered;
        _onRouteNow = onRoute;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _activeToday = [];
        _onRouteNow = [];
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not load discovery. ${e.toString()}')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final matchProv = context.watch<MatchProvider>();

    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Discover'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_calendar),
            onPressed: () async {
              await Navigator.pushNamed(context, ProfileSetupScreen.routeName);
              if (!mounted) return;
              _refresh();
            },
            tooltip: 'Change availability',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            GlassCard(
              child: Row(
                children: const [
                  Icon(Icons.directions_bus, color: Colors.white70),
                  SizedBox(width: 12),
                  Expanded(
                      child: Text(
                          'We match people on the same bus with overlapping time windows. No swipes, just chats.')),
                ],
              ),
            ),

            // NEW: Everyone active today
            // const SizedBox(height: 20),
            // Text('Everyone active today', style: Theme.of(context).textTheme.titleLarge),
            // const SizedBox(height: 10),
            // NEW: Everyone active today header with "See all"
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text('Everyone active today',
                      style: Theme.of(context).textTheme.titleLarge),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/all-active'),
                  child: const Text('See all'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (_loading)
              const Center(
                  child: Padding(
                padding: EdgeInsets.all(24.0),
                child: CircularProgressIndicator(),
              ))
            else if (_activeToday.isEmpty)
              const EmptyState(
                title: 'No one active just yet',
                subtitle:
                    'As more riders set their time windows today, you’ll see them here.',
              )
            else
              ..._activeToday.map((u) => _ActiveTodayTile(
                    user: u,
                    busLabel: _busLabel(u.activeBusRoute),
                    timeLabel: formatTimeRange(u.timeStart, u.timeEnd),
                  )),

            // Existing: People on your route now (overlaps)
            const SizedBox(height: 24),
            Text('People on your route now',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            if (_loading)
              const Center(
                  child: Padding(
                padding: EdgeInsets.all(24.0),
                child: CircularProgressIndicator(),
              ))
            else if (_onRouteNow.isEmpty)
              const EmptyState(
                title: 'No one visible at the moment',
                subtitle:
                    'Try adjusting your time window or check back shortly.',
              )
            else
              ..._onRouteNow.map((u) =>
                  _OnRouteTile(user: u, busLabel: _busLabel(u.activeBusRoute))),

            // Existing: Your matches
            const SizedBox(height: 24),
            Text('Your matches', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            // Your matches (use chats stream so hiddenFor is respected)
const SizedBox(height: 24),
Text('Your matches', style: Theme.of(context).textTheme.titleLarge),
const SizedBox(height: 10),
StreamBuilder<List<Map<String, dynamic>>>(
  stream: context.read<ChatProvider>().myChats(auth.user!.uid),
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return const EmptyState(
        title: 'No matches yet',
        subtitle: 'We’ll show matches here once you overlap on the same bus.',
        icon: Icons.favorite_border,
      );
    }
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(24.0),
        child: CircularProgressIndicator(),
      ));
    }
    final chats = snapshot.data ?? [];
    if (chats.isEmpty) {
      return const EmptyState(
        title: 'No matches yet',
        subtitle: 'When you overlap with someone on the same bus, you’ll see them here.',
        icon: Icons.favorite_border,
      );
    }
    return Column(
      children: chats.map((c) {
        final last = c['lastMessage'] as Map<String, dynamic>?;
        final subtitle = last != null ? (last['text'] as String? ?? '') : 'Say hi!';
        return ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          tileColor: Colors.white.withOpacity(0.06),
          leading: const CircleAvatar(child: Icon(Icons.favorite)),
          title: Text('Chat on ${c['busRoute'] ?? ''}'),
          subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.pushNamed(
            context,
            ChatScreen.routeName,
            arguments: ChatScreenArgs(
              chatId: c['id'],
              title: 'Chat on ${c['busRoute'] ?? ''}',
            ),
          ),
        );
      }).toList(),
    );
  },
),
            // StreamBuilder(
            //   stream: matchProv.matchesFor(auth.user!.uid),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasError) {
            //       return const EmptyState(
            //         title: 'No matches yet',
            //         subtitle:
            //             'We’ll show matches here once you overlap on the same bus.',
            //         icon: Icons.favorite_border,
            //       );
            //     }
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return const Center(
            //           child: Padding(
            //         padding: EdgeInsets.all(24.0),
            //         child: CircularProgressIndicator(),
            //       ));
            //     }
            //     final matches = snapshot.data ?? [];
            //     if (matches.isEmpty) {
            //       return const EmptyState(
            //         title: 'No matches yet',
            //         subtitle:
            //             'When you overlap with someone on the same bus, you’ll see them here.',
            //         icon: Icons.favorite_border,
            //       );
            //     }
            //     return Column(
            //       children: matches
            //           .map((m) => ListTile(
            //                 shape: RoundedRectangleBorder(
            //                     borderRadius: BorderRadius.circular(16)),
            //                 tileColor: Colors.white.withOpacity(0.06),
            //                 leading:
            //                     const CircleAvatar(child: Icon(Icons.favorite)),
            //                 title: Text('Chat on ${m.busRoute}'),
            //                 subtitle: Text('Day ${m.dayKey}'),
            //                 trailing: const Icon(Icons.chevron_right),
            //                 onTap: () => Navigator.pushNamed(
            //                   context,
            //                   ChatScreen.routeName,
            //                   arguments: ChatScreenArgs(
            //                       chatId: m.chatId,
            //                       title: 'Chat on ${m.busRoute}'),
            //                 ),
            //               ))
            //           .toList(),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

class _ActiveTodayTile extends StatelessWidget {
  final UserProfile user;
  final String busLabel;
  final String timeLabel;
  const _ActiveTodayTile({
    super.key,
    required this.user,
    required this.busLabel,
    required this.timeLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.06),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(user.displayName ?? 'Halifax Rider'),
        subtitle: Text('$busLabel • $timeLabel'),
        trailing: ElevatedButton(
          child: const Text('View'),
          onPressed: () {
            Navigator.pushNamed(
              context,
              ProfileDetailScreen.routeName,
              arguments: ProfileDetailArgs(userId: user.uid),
            );
          },
        ),
      ),
    );
  }
}

class _OnRouteTile extends StatelessWidget {
  final UserProfile user;
  final String busLabel;
  const _OnRouteTile({super.key, required this.user, required this.busLabel});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.06),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(user.displayName ?? 'Halifax Rider'),
        subtitle: Text(busLabel),
        trailing: ElevatedButton(
          child: const Text('View'),
          onPressed: () {
            Navigator.pushNamed(
              context,
              ProfileDetailScreen.routeName,
              arguments: ProfileDetailArgs(userId: user.uid),
            );
          },
        ),
      ),
    );
  }
}
