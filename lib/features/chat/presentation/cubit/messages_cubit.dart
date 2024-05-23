import 'package:bloc/bloc.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:educonnect/core/utils/logger.dart';
import 'package:educonnect/features/chat/data/models/message_model.dart';
import 'package:educonnect/features/chat/domain/repositories/chat_repository.dart';
import 'package:equatable/equatable.dart';

part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  final ChatRepository chatRepository;
  MessagesCubit({
    required this.chatRepository,
  }) : super(MessagesInitial());

  Future<void> getMessages(int contactId) async {
    emit(MessagesLoading());
    final response = await chatRepository.getMessages(contactId);
    emit(response.fold(
      (failure) => MessagesError(failure.toString()),
      (messages) => MessagesLoaded(messages),
    ));
  }

  Future<void> sendMessage(
      String id,
      String message,
      int fromId,
      int toId,
      DateTime createdAt,
      DateTime updatedAt,
      String? firstName,
      String? lastName) async {
    final response = await chatRepository.sendMessage(toId, message);
    response.fold(
      (failure) => emit(MessagesError(failure.toString())),
      (_) {
        if (state is MessagesLoaded) {
          final currentMessages = (state as MessagesLoaded).messages;
          final newMessage = MessageModel(
            id: id,
            body: message,
            seen: false,
            fromId: fromId,
            toId: toId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            user: ChatUser(
              id: fromId.toString(),
              firstName: firstName,
              lastName: lastName,
            ),
          );
          emit(MessagesLoaded([newMessage, ...currentMessages]));
        }
      },
    );
  }

  void addNewMessage(MessageModel message) {
    if (state is MessagesLoaded) {
      final currentMessages = (state as MessagesLoaded).messages;
      emit(MessagesLoaded([message, ...currentMessages]));
    }
  }

  void resetChat() {
    emit(MessagesInitial());
  }
}
