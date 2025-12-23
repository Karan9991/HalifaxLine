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







import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../models/message.dart';

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

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final auth = context.read<AuthProvider>();
    await context.read<ChatProvider>().sendMessage(
      chatId: widget.args.chatId,
      senderId: auth.user!.uid,
      text: text,
    );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final chatProv = context.watch<ChatProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(widget.args.title)),
      body: Column(
        children: [
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
                  return const Center(child: Text('Say hello 👋'));
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
                      decoration: InputDecoration(
                        hintText: 'Message',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.08),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton.small(
                    onPressed: _send,
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