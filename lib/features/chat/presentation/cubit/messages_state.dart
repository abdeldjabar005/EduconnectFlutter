part of 'messages_cubit.dart';

abstract class MessagesState extends Equatable {
  const MessagesState();

  @override
  List<Object> get props => [];
}

class MessagesInitial extends MessagesState {}

class MessagesLoading extends MessagesState {
  final List<MessageModel>? currentMessages;

  const MessagesLoading({this.currentMessages});

  @override
  List<Object> get props => [currentMessages ?? []];
}

class MessagesLoaded extends MessagesState {
  final List<MessageModel> messages;

  const MessagesLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class MessageSent extends MessagesState {
  final String message;

  const MessageSent(this.message);

  @override
  List<Object> get props => [message];
}

class MessagesError extends MessagesState {
  final String message;

  const MessagesError(this.message);

  @override
  List<Object> get props => [message];
}