import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_profile.dart';
import '../../models/bus.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../services/matching_service.dart';
import '../../services/blocking_service.dart';
import '../../utils/time_utils.dart';
import 'profile_detail_screen.dart';

class AllActiveScreen extends StatefulWidget {
  static const routeName = '/all-active';
  const AllActiveScreen({super.key});

  @override
  State<AllActiveScreen> createState() => _AllActiveScreenState();
}

class _AllActiveScreenState extends State<AllActiveScreen> {
  final _matchSvc = MatchingService();

  final _search = TextEditingController();
  List<UserProfile> _all = [];
  List<UserProfile> _filtered = [];
  bool _loading = true;

  String _busLabel(String? code) {
    if (code == null || code.isEmpty) return 'Route N/A';
    final match = halifaxBusRoutes.firstWhere(
      (b) => b.code == code,
      orElse: () => BusRoute(code, ''),
    );
    return match.name.isNotEmpty ? '${match.code} — ${match.name}' : 'Route ${match.code}';
  }

  void _applyFilter() {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) {
      setState(() => _filtered = List.of(_all));
      return;
    }
    setState(() {
      _filtered = _all.where((u) {
        final code = (u.activeBusRoute ?? '').toLowerCase();
        final routeName = halifaxBusRoutes
            .firstWhere(
              (b) => b.code.toLowerCase() == code,
              orElse: () => BusRoute(u.activeBusRoute ?? '', ''),
            )
            .name
            .toLowerCase();
        return code.contains(q) || routeName.contains(q);
      }).toList();
    });
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
          _all = [];
          _filtered = [];
          _loading = false;
        });
        return;
      }

      final blocked = await BlockingService().getBlocked(auth.user!.uid);

      final allToday = await _matchSvc.allActiveTodayFor(me);

      final filtered = allToday
          .where((u) => !blocked.contains(u.uid))
          .toList();

      // Sort for UX: by bus, then by start time
      filtered.sort((a, b) {
        final c = (a.activeBusRoute ?? '').compareTo(b.activeBusRoute ?? '');
        if (c != 0) return c;
        final at = a.timeStart ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bt = b.timeStart ?? DateTime.fromMillisecondsSinceEpoch(0);
        return at.compareTo(bt);
      });

      setState(() {
        _all = filtered;
        _loading = false;
      });
      _applyFilter();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _all = [];
        _filtered = [];
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not load active users. ${e.toString()}')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _search.addListener(_applyFilter);
    _refresh();
  }

  @override
  void dispose() {
    _search.removeListener(_applyFilter);
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Everyone active today'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
              child: TextField(
                controller: _search,
                decoration: InputDecoration(
                  hintText: 'Search by bus or route name',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.08),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _filtered.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Text('No active riders found.'),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          itemBuilder: (_, i) {
                            final u = _filtered[i];
                            return Card(
                              color: Colors.white.withOpacity(0.06),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              child: ListTile(
                                leading: const CircleAvatar(child: Icon(Icons.person)),
                                title: Text(u.displayName ?? 'Halifax Rider'),
                                subtitle: Text('${_busLabel(u.activeBusRoute)} • ${formatTimeRange(u.timeStart, u.timeEnd)}'),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    ProfileDetailScreen.routeName,
                                    arguments: ProfileDetailArgs(userId: u.uid),
                                  );
                                },
                              ),
                            );
                          },
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemCount: _filtered.length,
                        ),
            ),
          ],
        ),
      ),
    );
  }
}