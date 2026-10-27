import 'package:flutter/material.dart';
import '../main.dart';

// ============================================================
// AVATAR (NEOBRUTALISM STYLE)
// ============================================================
class UserAvatar extends StatelessWidget {
  final String? url;
  final String name;
  final double radius;

  const UserAvatar({
    super.key,
    required this.name,
    this.url,
    this.radius = 26,
  });

  Widget _initial() {
    final letter = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';
    return Container(
      color: kSoft,
      alignment: Alignment.center,
      child: Text(
        letter,
        style: TextStyle(
          color: kBlack,
          fontWeight: FontWeight.w900,
          fontSize: radius * 0.85,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasUrl = url != null && url!.trim().isNotEmpty;
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: kBlack, width: 2.2),
        boxShadow: const [
          BoxShadow(
            color: kBlack,
            offset: Offset(2.5, 2.5),
            blurRadius: 0,
          ),
        ],
      ),
      child: ClipOval(
        child: !hasUrl
            ? _initial()
            : Image.network(
                url!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _initial(),
                loadingBuilder: (context, child, progress) =>
                    progress == null ? child : _initial(),
              ),
      ),
    );
  }
}