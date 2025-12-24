// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/chat_provider.dart';
// import '../../models/message.dart';

// class ChatScreenArgs {
//   final String chatId;
//   final String title;
//   ChatScreenArgs({required this.chatId, required this.title});
// }

// class ChatScreen extends StatefulWidget {
//   static const routeName = '/chat';
//   final ChatScreenArgs args;
//   const ChatScreen({super.key, required this.args});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final _controller = TextEditingController();

//   Future<void> _send() async {
//     final text = _controller.text.trim();
//     if (text.isEmpty) return;
//     final auth = context.read<AuthProvider>();
//     await context.read<ChatProvider>().sendMessage(
//       chatId: widget.args.chatId,
//       senderId: auth.user!.uid,
//       text: text,
//     );
//     _controller.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final chatProv = context.watch<ChatProvider>();
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.args.title)),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<List<Message>>(
//               stream: chatProv.messages(widget.args.chatId),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 final messages = snapshot.data!;
//                 return ListView.builder(
//                   reverse: true,
//                   padding: const EdgeInsets.all(16),
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final m = messages[index];
//                     final isMe = m.senderId == context.read<AuthProvider>().user!.uid;
//                     return Align(
//                       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//                       child: Container(
//                         margin: const EdgeInsets.symmetric(vertical: 4),
//                         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
//                         decoration: BoxDecoration(
//                           color: isMe ? Colors.blueAccent : Colors.white10,
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: Text(m.text),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _controller,
//                       minLines: 1,
//                       maxLines: 5,
//                       decoration: InputDecoration(
//                         hintText: 'Message',
//                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
//                         filled: true,
//                         fillColor: Colors.white.withOpacity(0.08),
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   FloatingActionButton.small(
//                     onPressed: _send,
//                     child: const Icon(Icons.send),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }







// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/chat_provider.dart';
// import '../../models/message.dart';

// class ChatScreenArgs {
//   final String chatId;
//   final String title;
//   ChatScreenArgs({required this.chatId, required this.title});
// }

// class ChatScreen extends StatefulWidget {
//   static const routeName = '/chat';
//   final ChatScreenArgs args;
//   const ChatScreen({super.key, required this.args});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final _controller = TextEditingController();

//   Future<void> _send() async {
//     final text = _controller.text.trim();
//     if (text.isEmpty) return;
//     final auth = context.read<AuthProvider>();
//     await context.read<ChatProvider>().sendMessage(
//       chatId: widget.args.chatId,
//       senderId: auth.user!.uid,
//       text: text,
//     );
//     _controller.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final chatProv = context.watch<ChatProvider>();
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.args.title)),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<List<Message>>(
//               stream: chatProv.messages(widget.args.chatId),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return const Center(child: Text('Could not load messages'));
//                 }
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 final messages = snapshot.data ?? [];
//                 if (messages.isEmpty) {
//                   return const Center(child: Text('Say hello 👋'));
//                 }
//                 return ListView.builder(
//                   reverse: true,
//                   padding: const EdgeInsets.all(16),
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final m = messages[index];
//                     final isMe = m.senderId == context.read<AuthProvider>().user!.uid;
//                     return Align(
//                       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//                       child: Container(
//                         margin: const EdgeInsets.symmetric(vertical: 4),
//                         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
//                         decoration: BoxDecoration(
//                           color: isMe ? Colors.blueAccent : Colors.white10,
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: Text(m.text),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _controller,
//                       minLines: 1,
//                       maxLines: 5,
//                       decoration: InputDecoration(
//                         hintText: 'Message',
//                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
//                         filled: true,
//                         fillColor: Colors.white.withOpacity(0.08),
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   FloatingActionButton.small(
//                     onPressed: _send,
//                     child: const Icon(Icons.send),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/chat_provider.dart';
// import '../../models/message.dart';
// import '../../services/firestore_service.dart';
// import '../../services/blocking_service.dart';
// import 'profile_detail_screen.dart';

// class ChatScreenArgs {
//   final String chatId;
//   final String title;
//   ChatScreenArgs({required this.chatId, required this.title});
// }

// class ChatScreen extends StatefulWidget {
//   static const routeName = '/chat';
//   final ChatScreenArgs args;
//   const ChatScreen({super.key, required this.args});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final _controller = TextEditingController();

//   String? _otherId;
//   String? _otherDisplayName;

//   bool _iBlocked = false;
//   bool _otherBlockedMe = false;

//   StreamSubscription? _subMyBlock;
//   StreamSubscription? _subOtherBlock;

//   final _fs = FirestoreService();
//   final _blockSvc = BlockingService();

//   @override
//   void initState() {
//     super.initState();
//     _initMeta();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _subMyBlock?.cancel();
//     _subOtherBlock?.cancel();
//     super.dispose();
//   }

//   Future<void> _initMeta() async {
//     final me = context.read<AuthProvider>().user!.uid;

//     // Fetch chat doc to resolve the other participant
//     final doc = await _fs.chatDoc(widget.args.chatId).get();
//     if (!doc.exists) return;
//     final data = (doc.data() as Map<String, dynamic>);
//     final members = (data['members'] as List).cast<String>();
//     final other = members.firstWhere((m) => m != me, orElse: () => '');

//     if (other.isEmpty) return;

//     setState(() {
//       _otherId = other;
//     });

//     // Load their display name (optional)
//     try {
//       final otherDoc = await _fs.userDoc(other).get();
//       final m = otherDoc.data() as Map<String, dynamic>?;
//       setState(() {
//         _otherDisplayName = (m?['displayName'] as String?) ?? '';
//       });
//     } catch (_) {}

//     // Listen to my block status (me -> other)
//     _subMyBlock = _blockSvc.blockStream(me, other).listen((blocked) {
//       if (mounted) setState(() => _iBlocked = blocked);
//     });

//     // Listen to their block status (other -> me)
//     _subOtherBlock = _blockSvc.blockStream(other, me).listen((blocked) {
//       if (mounted) setState(() => _otherBlockedMe = blocked);
//     });
//   }

//   Future<void> _send() async {
//     final text = _controller.text.trim();
//     if (text.isEmpty) return;

//     final me = context.read<AuthProvider>().user!.uid;

//     // Guard: don’t allow sending if either side has blocked.
//     if (_iBlocked) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('You have blocked this user. Unblock to send messages.')),
//       );
//       return;
//     }
//     if (_otherBlockedMe) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('This user has blocked you. You can’t send messages.')),
//       );
//       return;
//     }

//     await context.read<ChatProvider>().sendMessage(
//       chatId: widget.args.chatId,
//       senderId: me,
//       text: text,
//     );
//     _controller.clear();
//   }

//   Future<void> _blockOrUnblock() async {
//     if (_otherId == null) return;
//     final me = context.read<AuthProvider>().user!.uid;
//     final isBlocking = !_iBlocked;

//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(isBlocking ? 'Block user?' : 'Unblock user?'),
//         content: Text(isBlocking
//             ? 'They will not be able to contact you. You can unblock anytime.'
//             : 'You will be able to send and receive messages again.'),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: Text(isBlocking ? 'Block' : 'Unblock'),
//           ),
//         ],
//       ),
//     );

//     if (confirmed != true) return;

//     try {
//       if (isBlocking) {
//         await _blockSvc.block(me, _otherId!);
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User blocked.')));
//       } else {
//         await _blockSvc.unblock(me, _otherId!);
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User unblocked.')));
//       }
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Action failed: $e')));
//     }
//   }

//   void _viewProfile() {
//     if (_otherId == null) return;
//     Navigator.pushNamed(
//       context,
//       ProfileDetailScreen.routeName,
//       arguments: ProfileDetailArgs(userId: _otherId!),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final chatProv = context.watch<ChatProvider>();
//     final canSend = !(_iBlocked || _otherBlockedMe);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.args.title),
//         actions: [
//           PopupMenuButton<String>(
//             onSelected: (value) {
//               if (value == 'profile') _viewProfile();
//               if (value == 'toggle_block') _blockOrUnblock();
//             },
//             itemBuilder: (context) {
//               return [
//                 const PopupMenuItem(value: 'profile', child: Text('View profile')),
//                 PopupMenuItem(
//                   value: 'toggle_block',
//                   child: Text(_iBlocked ? 'Unblock user' : 'Block user'),
//                 ),
//               ];
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           if (_iBlocked)
//             Container(
//               width: double.infinity,
//               color: Colors.amber.withOpacity(0.2),
//               padding: const EdgeInsets.all(12),
//               child: const Text('You blocked this user. Unblock to send messages.'),
//             )
//           else if (_otherBlockedMe)
//             Container(
//               width: double.infinity,
//               color: Colors.red.withOpacity(0.2),
//               padding: const EdgeInsets.all(12),
//               child: const Text('This user has blocked you. You can’t send messages.'),
//             ),
//           Expanded(
//             child: StreamBuilder<List<Message>>(
//               stream: chatProv.messages(widget.args.chatId),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return const Center(child: Text('Could not load messages'));
//                 }
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 final messages = snapshot.data ?? [];
//                 if (messages.isEmpty) {
//                   return Center(
//                     child: Text(
//                       canSend ? 'Say hello 👋' : 'No messages yet',
//                       style: const TextStyle(color: Colors.white70),
//                     ),
//                   );
//                 }
//                 return ListView.builder(
//                   reverse: true,
//                   padding: const EdgeInsets.all(16),
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final m = messages[index];
//                     final isMe = m.senderId == context.read<AuthProvider>().user!.uid;
//                     return Align(
//                       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//                       child: Container(
//                         margin: const EdgeInsets.symmetric(vertical: 4),
//                         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
//                         decoration: BoxDecoration(
//                           color: isMe ? Colors.blueAccent : Colors.white10,
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: Text(m.text),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _controller,
//                       minLines: 1,
//                       maxLines: 5,
//                       enabled: canSend,
//                       decoration: InputDecoration(
//                         hintText: canSend ? 'Message' : 'Messaging disabled',
//                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
//                         filled: true,
//                         fillColor: Colors.white.withOpacity(0.08),
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   FloatingActionButton.small(
//                     onPressed: canSend ? _send : null,
//                     child: const Icon(Icons.send),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../models/message.dart';
import '../../services/firestore_service.dart';
import '../../services/blocking_service.dart';
import 'profile_detail_screen.dart';

class ChatScreenArgs {
  final String chatId;
  final String title;
  ChatScreenArgs({required this.chatId, required this.title});
}

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat';
  final ChatScreenArgs args;
  const ChatScreen({super.key, required this.args});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();

  String? _otherId;
  String? _otherDisplayName;

  bool _iBlocked = false;
  bool _otherBlockedMe = false;

  StreamSubscription? _subMyBlock;
  StreamSubscription? _subOtherBlock;

  final _fs = FirestoreService();
  final _blockSvc = BlockingService();

  @override
  void initState() {
    super.initState();
    _initMeta();
  }

  @override
  void dispose() {
    _controller.dispose();
    _subMyBlock?.cancel();
    _subOtherBlock?.cancel();
    super.dispose();
  }

  Future<void> _initMeta() async {
    final me = context.read<AuthProvider>().user!.uid;

    // Fetch chat doc to resolve other participant
    final doc = await _fs.chatDoc(widget.args.chatId).get();
    if (!doc.exists) return;
    final data = (doc.data() as Map<String, dynamic>);
    final members = (data['members'] as List).cast<String>();
    final other = members.firstWhere((m) => m != me, orElse: () => '');

    if (other.isEmpty) return;

    setState(() {
      _otherId = other;
    });

    // Load display name (optional)
    try {
      final otherDoc = await _fs.userDoc(other).get();
      final m = otherDoc.data() as Map<String, dynamic>?;
      setState(() {
        _otherDisplayName = (m?['displayName'] as String?) ?? '';
      });
    } catch (_) {}

    // Listen to block states
    _subMyBlock = _blockSvc.blockStream(me, other).listen((blocked) {
      if (mounted) setState(() => _iBlocked = blocked);
    });
    _subOtherBlock = _blockSvc.blockStream(other, me).listen((blocked) {
      if (mounted) setState(() => _otherBlockedMe = blocked);
    });
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final me = context.read<AuthProvider>().user!.uid;

    // Guard if blocked
    if (_iBlocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have blocked this user. Unblock to send messages.')),
      );
      return;
    }
    if (_otherBlockedMe) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This user has blocked you. You can’t send messages.')),
      );
      return;
    }

    await context.read<ChatProvider>().sendMessage(
      chatId: widget.args.chatId,
      senderId: me,
      text: text,
    );
    _controller.clear();
  }

  Future<void> _blockOrUnblock() async {
    if (_otherId == null) return;
    final me = context.read<AuthProvider>().user!.uid;
    final isBlocking = !_iBlocked;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isBlocking ? 'Block user?' : 'Unblock user?'),
        content: Text(isBlocking
            ? 'They will not be able to contact you. You can unblock anytime.'
            : 'You will be able to send and receive messages again.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(isBlocking ? 'Block' : 'Unblock'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      if (isBlocking) {
        await _blockSvc.block(me, _otherId!);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User blocked.')));
      } else {
        await _blockSvc.unblock(me, _otherId!);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User unblocked.')));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Action failed: $e')));
    }
  }

  Future<void> _deleteChatForMe() async {
    final me = context.read<AuthProvider>().user!.uid;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete chat?'),
        content: const Text('This will remove the conversation from your Chats. The other person will still see it.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await context.read<ChatProvider>().hideChatForUser(chatId: widget.args.chatId, uid: me);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Chat deleted from your view.')));
      Navigator.pop(context); // back to list
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
    }
  }

  void _viewProfile() {
    if (_otherId == null) return;
    Navigator.pushNamed(
      context,
      ProfileDetailScreen.routeName,
      arguments: ProfileDetailArgs(userId: _otherId!),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatProv = context.watch<ChatProvider>();
    final canSend = !(_iBlocked || _otherBlockedMe);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.args.title),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'profile') _viewProfile();
              if (value == 'toggle_block') _blockOrUnblock();
              if (value == 'delete_chat') _deleteChatForMe();
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(value: 'profile', child: Text('View profile')),
                PopupMenuItem(
                  value: 'toggle_block',
                  child: Text(_iBlocked ? 'Unblock user' : 'Block user'),
                ),
                const PopupMenuItem(
                  value: 'delete_chat',
                  child: Text('Delete chat for me'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_iBlocked)
            Container(
              width: double.infinity,
              color: Colors.amber.withOpacity(0.2),
              padding: const EdgeInsets.all(12),
              child: const Text('You blocked this user. Unblock to send messages.'),
            )
          else if (_otherBlockedMe)
            Container(
              width: double.infinity,
              color: Colors.red.withOpacity(0.2),
              padding: const EdgeInsets.all(12),
              child: const Text('This user has blocked you. You can’t send messages.'),
            ),
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: chatProv.messages(widget.args.chatId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Could not load messages'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data ?? [];
                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      canSend ? 'Say hello 👋' : 'No messages yet',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  );
                }
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final m = messages[index];
                    final isMe = m.senderId == context.read<AuthProvider>().user!.uid;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blueAccent : Colors.white10,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(m.text),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 5,
                      enabled: canSend,
                      decoration: InputDecoration(
                        hintText: canSend ? 'Message' : 'Messaging disabled',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.08),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton.small(
                    onPressed: canSend ? _send : null,
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}