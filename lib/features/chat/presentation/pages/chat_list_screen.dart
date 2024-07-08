import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:educonnect/features/auth/data/repositories/token_repository.dart';
import 'package:educonnect/features/chat/data/models/contact_model.dart';
import 'package:educonnect/features/chat/presentation/cubit/contacts_cubit.dart';
import 'package:educonnect/features/chat/presentation/cubit/messages_cubit.dart';
import 'package:educonnect/features/chat/presentation/pages/chat_screen.dart';
import 'package:educonnect/features/chat/presentation/widgets/chat_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:educonnect/features/auth/presentation/cubit/auth_cubit.dart';

import 'package:educonnect/core/api/laravel_echo.dart';
import 'package:educonnect/features/chat/presentation/widgets/startup_container.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:search_page/search_page.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  static const routeName = "chat-list";

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    bool isRtl = Localizations.localeOf(context).languageCode == 'ar';

    final authCubit = context.read<AuthCubit>();
    final currentUser = authCubit.currentUser!;
    final messagesCubit = context.read<MessagesCubit>();
    final contactsCubit = context.read<ContactsCubit>();
    final secureStorage = FlutterSecureStorage();
    final tokenProvider = TokenProvider(secureStorage: secureStorage);
    return StartUpContainer(
      onInit: () async {
        contactsCubit.getContacts();
        // userCubit.loadUsers();
        String? token = await tokenProvider.getToken();
        // LaravelPusher.init(token: token);
      },
      onDisposed: () {
        // LaravelPusher.instance.disconnect();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.translate("contacts")!),
              Text(
                "${AppLocalizations.of(context)!.translate("username")!} ${currentUser.firstName}",
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            contactsCubit.getContacts();
          },
          child: BlocConsumer<ContactsCubit, ContactsState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is ContactsLoaded) {
                if (state.contacts.isEmpty) {
                  return Center(
                    child: Text(AppLocalizations.of(context)!
                            .translate("no_chat_available")!
                        // "No chat available"
                        ),
                  );
                }

                return ListView.separated(
                  itemBuilder: (context, index) {
                    final item = state.contacts[index];

                    return ChatListItem(
                      key: ValueKey(item.id),
                      item: item,
                      currentUser: currentUser,
                      onPressed: (contact) {
                        Navigator.of(context).pushNamed(ChatScreen.routeName,
                            arguments: contact);
                      },
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(
                    height: 1.5,
                  ),
                  itemCount: state.contacts.length,
                );
              } else if (state is ContactsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ContactsError) {
                return Center(child: Text(state.message));
              } else {
                return Center(
                  child: Text(AppLocalizations.of(context)!
                      .translate("no_chat_available")!),
                );
              }
            },
          ),
        ),
        floatingActionButton:
            BlocSelector<ContactsCubit, ContactsState, List<ContactModel>>(
          selector: (state) {
            if (state is ContactsLoaded) {
              return state.contacts;
            }
            return [];
          },
          builder: (context, state) {
            return FloatingActionButton(
              onPressed: () => _showSearch(context, state),
              child: const Icon(Icons.search),
            );
          },
        ),
      ),
    );
  }

  void _showSearch(BuildContext context, List<ContactModel> users) {
    showSearch(
      context: context,
      delegate: SearchPage<ContactModel>(
        items: users,
        searchLabel: AppLocalizations.of(context)!.translate("search_people")!,
        suggestion: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.search,
                size: 25.0,
                color: Colors.grey,
              ),
              Text(
                AppLocalizations.of(context)!.translate("search_user_by_name")!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        failure: Center(
          child: Text(
            AppLocalizations.of(context)!.translate("no_user_found")!,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
        filter: (user) => [
          user.email,
        ],
        builder: (user) => ListTile(
          leading: const Icon(Icons.account_circle, size: 50.0),
          title: Text(user.firstName),
          subtitle: Text(user.email),
          onTap: () {
            Navigator.of(context)
                .pushNamed(ChatScreen.routeName, arguments: user);
          },
        ),
      ),
    );
  }
}
