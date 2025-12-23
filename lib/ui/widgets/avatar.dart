import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String? url;
  final double size;
  const Avatar({super.key, this.url, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size/2,
      backgroundColor: Colors.white24,
      backgroundImage: url != null && url!.isNotEmpty ? CachedNetworkImageProvider(url!) : null,
      child: (url == null || url!.isEmpty)
          ? Icon(Icons.person, size: size * 0.6, color: Colors.white70)
          : null,
    );
  }
}