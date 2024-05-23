import 'package:bloc/bloc.dart';
import 'package:educonnect/features/chat/data/models/contact_model.dart';
import 'package:educonnect/features/chat/domain/repositories/chat_repository.dart';
import 'package:equatable/equatable.dart';

part 'contacts_state.dart';


class ContactsCubit extends Cubit<ContactsState> {
  final ChatRepository chatRepository;
  ContactsCubit({
    required this.chatRepository,
  }) : super(ContactsInitial());

  Future<void> getContacts() async {
    emit(ContactsLoading());
    final response = await chatRepository.getContacts();
    emit(response.fold(
      (failure) => ContactsError(failure.toString()),
      (contacts) => ContactsLoaded(contacts),
    ));
  }
}
