import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:educonnect/features/auth/data/models/user_model.dart';
import 'package:educonnect/features/auth/domain/entities/user.dart';
import 'package:educonnect/features/chat/data/models/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatListItem extends StatelessWidget {
  final ContactModel item;
  final User currentUser;
  final void Function(ContactModel) onPressed;

  const ChatListItem({
    Key? key,
    required this.item,
    required this.currentUser,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isRtl = Localizations.localeOf(context).languageCode == 'ar';

    return ListTile(
      leading: const Icon(Icons.account_circle, size: 50.0),
      title: Text(item.firstName),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              item.lastMessage ?? 'No message',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Text(
            isRtl ? timeAgoArabic(item.updatedAt!) : timeAgo(item.updatedAt!),
          ),
        ],
      ),
      onTap: () => onPressed(item),
    );
  }

  String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 4) {
      return '${difference.inDays}d';
    } else {
      return DateFormat.yMMMMd().format(date);
    }
  }

  String timeAgoArabic(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'منذ ${difference.inSeconds} ثواني';
    } else if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقائق';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعات';
    } else if (difference.inDays < 4) {
      return 'منذ ${difference.inDays} أيام';
    } else {
      return DateFormat.yMMMMd('ar_SA').format(date);
    }
  }
}
