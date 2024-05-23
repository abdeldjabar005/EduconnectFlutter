import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:educonnect/features/auth/data/models/user_model.dart';
import 'package:educonnect/features/auth/domain/entities/user.dart';
import 'package:educonnect/features/chat/data/models/contact_model.dart';
import 'package:flutter/material.dart';

class ChatListItem extends StatelessWidget {
  const ChatListItem({
    Key? key,
    required this.item,
    required this.currentUser,
    required this.onPressed,
    // this.lastMessage,
  }) : super(key: key);

  final ContactModel item;
  final User currentUser;
  // final String lastMessage;
  final void Function(ContactModel) onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.account_circle, size: 50.0),
      title: Text(
        item.firstName,
      ),
      subtitle: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              // lastMessage? ??
              "...",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          // Text(updatedAt.toString()),
          Text('sss'),
        ],
      ),
      onTap: () => onPressed(item),
    );
  }
}
