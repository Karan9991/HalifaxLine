import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../models/user_profile.dart';
import '../../services/blocking_service.dart';
import '../../services/matching_service.dart';
import 'package:halifax_line/ui/screens/chat_screen.dart';

class ProfileDetailArgs {
  final String userId;
  ProfileDetailArgs({required this.userId});
}

class ProfileDetailScreen extends StatefulWidget {
  static const routeName = '/profile-detail';
  final ProfileDetailArgs args;
  const ProfileDetailScreen({super.key, required this.args});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  UserProfile? other;
  bool _loading = true;
  bool _blocking = false;

  Future<void> _load() async {
    final doc = await FirestoreService().userDoc(widget.args.userId).get();
    if (doc.exists) {
      setState(() {
        other = UserProfile.fromDoc(doc);
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _block() async {
    final me = context.read<AuthProvider>().user!.uid;
    setState(() => _blocking = true);
    await BlockingService().block(me, other!.uid);
    if (!mounted) return;
    setState(() => _blocking = false);
    Navigator.pop(context);
  }

  Future<void> _startChat() async {
    final me = context.read<AuthProvider>().user!.uid;
    final you = other!.uid;
    // Chat id consistent with matching id schema
    final dayKey = other!.dayKey ?? '';
    final bus = other!.activeBusRoute ?? '';
    final sorted = [me, you]..sort();
    final chatId = '${sorted[0]}_${sorted[1]}_$dayKey\_$bus';

    final chatRef = FirestoreService().chatDoc(chatId);
    final chat = await chatRef.get();
    if (!chat.exists) {
      await chatRef.set({
        'id': chatId,
        'members': [me, you],
        'busRoute': bus,
        'dayKey': dayKey,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, ChatScreen.routeName, arguments: ChatScreenArgs(chatId: chatId, title: other?.displayName ?? 'Chat'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.transparent,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : other == null
              ? const Center(child: Text('Profile not found'))
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircleAvatar(radius: 48, child: Text(other!.displayName != null && other!.displayName!.isNotEmpty ? other!.displayName![0] : 'H')),
                      const SizedBox(height: 12),
                      Text(other!.displayName ?? 'Halifax Rider', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 6),
                      Text('Bus ${other!.activeBusRoute ?? '-'} • Day ${other!.dayKey ?? '-'}'),
                      const Spacer(),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.chat_bubble_outline),
                        label: const Text('Start Chat'),
                        onPressed: _startChat,
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        icon: _blocking ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.block),
                        label: const Text('Block user'),
                        onPressed: _blocking ? null : _block,
                      ),
                    ],
                  ),
                ),
    );
  }
}