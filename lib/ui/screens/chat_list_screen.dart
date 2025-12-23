// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../providers/auth_provider.dart';
// import '../../providers/chat_provider.dart';
// import 'package:halifax_line/ui/screens/chat_screen.dart';

// class ChatListScreen extends StatelessWidget {
//   static const routeName = '/chats';
//   const ChatListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final auth = context.watch<AuthProvider>();
//     final chatProv = context.watch<ChatProvider>();

//     return Scaffold(
//       appBar: AppBar(title: const Text('Chats')),
//       body: StreamBuilder<List<Map<String, dynamic>>>(
//         stream: chatProv.myChats(auth.user!.uid),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: Padding(
//               padding: EdgeInsets.all(24.0),
//               child: CircularProgressIndicator(),
//             ));
//           }
//           final chats = snapshot.data!;
//           if (chats.isEmpty) {
//             return const Center(child: Text('No chats yet'));
//           }
//           return ListView.separated(
//             padding: const EdgeInsets.all(16),
//             itemCount: chats.length,
//             separatorBuilder: (_, __) => const SizedBox(height: 8),
//             itemBuilder: (context, index) {
//               final c = chats[index];
//               final last = c['lastMessage'] as Map<String, dynamic>?;
//               final subtitle = last != null ? (last['text'] as String? ?? '') : 'Say hi!';
//               return ListTile(
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                 tileColor: Colors.white.withOpacity(0.06),
//                 leading: const CircleAvatar(child: Icon(Icons.directions_bus)),
//                 title: Text('Chat on ${c['busRoute'] ?? ''}'),
//                 subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
//                 trailing: const Icon(Icons.chevron_right),
//                 onTap: () {
//                   Navigator.pushNamed(context, ChatScreen.routeName, arguments: ChatScreenArgs(
//                     chatId: c['id'],
//                     title: 'Chat on ${c['busRoute'] ?? ''}',
//                   ));
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }









import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import 'package:halifax_line/ui/screens/chat_screen.dart';
import '../widgets/empty_state.dart';

class ChatListScreen extends StatelessWidget {
  static const routeName = '/chats';
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final chatProv = context.watch<ChatProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: chatProv.myChats(auth.user!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const EmptyState(
              title: 'No chats yet',
              subtitle: 'Once you match with someone, your chat will appear here.',
              icon: Icons.chat_bubble_outline,
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
              title: 'No chats yet',
              subtitle: 'Say hi when you get a match.',
              icon: Icons.chat_bubble_outline,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: chats.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final c = chats[index];
              final last = c['lastMessage'] as Map<String, dynamic>?;
              final subtitle = last != null ? (last['text'] as String? ?? '') : 'Say hi!';
              return ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                tileColor: Colors.white.withOpacity(0.06),
                leading: const CircleAvatar(child: Icon(Icons.directions_bus)),
                title: Text('Chat on ${c['busRoute'] ?? ''}'),
                subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pushNamed(context, ChatScreen.routeName, arguments: ChatScreenArgs(
                    chatId: c['id'],
                    title: 'Chat on ${c['busRoute'] ?? ''}',
                  ));
                },
              );
            },
          );
        },
      ),
    );
  }
}