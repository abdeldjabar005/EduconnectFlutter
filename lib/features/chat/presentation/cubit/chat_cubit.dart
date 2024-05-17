import 'package:bloc/bloc.dart';
import 'package:educonnect/features/chat/domain/entities/message.dart';
import 'package:educonnect/features/chat/domain/repositories/chat_repository.dart';
import 'package:educonnect/features/chat/domain/usecases/get_messages.dart';
import 'package:educonnect/features/chat/domain/usecases/send_message.dart';
import 'package:equatable/equatable.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository chatRepository;
  ChatCubit({
    required this.chatRepository,

  }) : super(ChatInitial());

  Future<void> loadMessages(String chatRoomId) async {
    emit(ChatLoading());
    final failureOrMessages = await chatRepository.getMessages(chatRoomId);
    failureOrMessages.fold(
      (failure) => emit(ChatError(failure.message)),
      (messages) => emit(ChatLoaded(messages)),
    );
  }

  Future<void> send(Message message) async {
    final failureOrUnit = await chatRepository.sendMessage(message);
    failureOrUnit.fold(
      (failure) => emit(ChatError(failure.message)),
      (_) => loadMessages(message.chatRoomId),
    );
  }
}
