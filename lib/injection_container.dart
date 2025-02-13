import 'package:dio/dio.dart';
import 'package:educonnect/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:educonnect/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:educonnect/features/chat/domain/repositories/chat_repository.dart';
import 'package:educonnect/features/chat/presentation/cubit/contacts_cubit.dart';
import 'package:educonnect/features/chat/presentation/cubit/messages_cubit.dart';
import 'package:educonnect/features/posts/presentation/cubit/search_cubit.dart';
import 'package:educonnect/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:educonnect/core/api/api_consumer.dart';
import 'package:educonnect/core/api/dio_consumer.dart';
import 'package:educonnect/core/network/netwok_info.dart';
import 'package:educonnect/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:educonnect/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:educonnect/features/auth/data/repositories/token_repository.dart';
import 'package:educonnect/features/auth/domain/repositories/auth_repository.dart';
import 'package:educonnect/features/classrooms/data/datasources/classroom_remote_data_source.dart';
import 'package:educonnect/features/classrooms/data/repositories/classroom_repository_impl.dart';
import 'package:educonnect/features/classrooms/domain/repositories/classroom_repository.dart';
import 'package:educonnect/features/classrooms/domain/usecases/get_class.dart';
import 'package:educonnect/features/classrooms/domain/usecases/get_memebrs.dart';
import 'package:educonnect/features/classrooms/presentation/cubit/class_cubit.dart';
import 'package:educonnect/features/classrooms/presentation/cubit/members_cubit.dart';
import 'package:educonnect/features/classrooms/presentation/cubit/post2_cubit.dart';
import 'package:educonnect/features/posts/data/datasources/post_local_data_source.dart';
import 'package:educonnect/features/posts/domain/usecases/check_liked.dart';
import 'package:educonnect/features/posts/domain/usecases/get_comment.dart';
import 'package:educonnect/features/posts/domain/usecases/get_post.dart';
import 'package:educonnect/features/posts/domain/usecases/like_comment.dart';
import 'package:educonnect/features/posts/domain/usecases/like_post.dart';
import 'package:educonnect/features/posts/domain/usecases/like_reply.dart';
import 'package:educonnect/features/posts/domain/usecases/post_comment.dart';
import 'package:educonnect/features/posts/domain/usecases/post_reply.dart';
import 'package:educonnect/features/posts/presentation/cubit/comment_cubit.dart';
import 'package:educonnect/features/posts/presentation/cubit/like_cubit.dart';
import 'package:educonnect/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:educonnect/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:educonnect/features/profile/domain/repositories/profile_repository.dart';
import 'package:educonnect/features/profile/domain/usecases/add_child.dart';
import 'package:educonnect/features/profile/domain/usecases/get_children.dart';
import 'package:educonnect/features/profile/domain/usecases/remove_child.dart';
import 'package:educonnect/features/profile/domain/usecases/update_child.dart';
import 'package:educonnect/features/profile/presentation/cubit/children_cubit.dart';
import 'package:educonnect/features/splash/data/datasources/lang_local_data_source.dart';
import 'package:educonnect/features/splash/data/repositories/lang_repository_impl.dart';
import 'package:educonnect/features/splash/domain/repositories/lang_repository.dart';
import 'package:educonnect/features/splash/domain/usecases/change_lang.dart';
import 'package:educonnect/features/splash/domain/usecases/get_saved_lang.dart';
import 'package:educonnect/features/splash/presentation/cubit/locale_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:educonnect/features/auth/presentation/cubit/auth_cubit.dart';
import 'core/api/app_interceptors.dart';
import 'package:educonnect/features/posts/data/datasources/post_remote_data_source.dart';
import 'package:educonnect/features/posts/data/repositories/post_repository_impl.dart';
import 'package:educonnect/features/posts/domain/repositories/post_repository.dart';
import 'package:educonnect/features/posts/domain/usecases/get_posts.dart';
import 'package:educonnect/features/posts/presentation/cubit/post_cubit.dart';
import 'package:educonnect/features/posts/domain/usecases/get_comments.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features

  // Blocs
  sl.registerFactory<LocaleCubit>(
      () => LocaleCubit(getSavedLangUseCase: sl(), changeLangUseCase: sl()));
  sl.registerLazySingleton<AuthCubit>(() => AuthCubit(
      authRepository: sl(), tokenProvider: sl(), secureStorage: sl()));
  sl.registerFactory<PostCubit>(() => PostCubit(
        getPostsUseCase: sl(),
        getPostUseCase: sl(),
        checkIfPostIsLikedUseCase: sl(),
        postRepository: sl(),
      ));
  sl.registerFactory<CommentsCubit>(() => CommentsCubit(
      getCommentsUseCase: sl(),
      getCommentUseCase: sl(),
      postCommentUseCase: sl(),
      postReplyUseCase: sl(),
      authCubit: sl(),
      postCubit: sl(),));
  sl.registerFactory<LikeCubit>(() => LikeCubit(
      likePostUseCase: sl(), likeCommentUseCase: sl(), likeReplyUseCase: sl()));
  sl.registerFactory<ClassCubit>(() => ClassCubit(
        classroomRepository: sl(),
        getMembersUseCase: sl(),
        authCubit: sl(),
      ));
  sl.registerFactory<MembersCubit>(() => MembersCubit(
        classroomRepository: sl(),
        getMembersUseCase: sl(),
      ));
  sl.registerFactory<Post2Cubit>(() => Post2Cubit(
        classroomRepository: sl(),
        getClassroomPostsUseCase: sl(),
        postRepository: sl(),
      ));
  sl.registerFactory<ChildrenCubit>(() => ChildrenCubit(
      getChildrenUseCase: sl(),
      addChildUseCase: sl(),
      removeChildUseCase: sl(),
      updateChildUseCase: sl()));
  sl.registerFactory<MessagesCubit>(() => MessagesCubit(
        chatRepository: sl(),
      ));
  sl.registerFactory<ContactsCubit>(() => ContactsCubit(
        chatRepository: sl(),
      ));
  sl.registerFactory<ProfileCubit>(() => ProfileCubit(
        profileRepository: sl(),
        authCubit: sl(),
      ));
  sl.registerFactory<SearchCubit>(() => SearchCubit(postRepository: sl()));
  // Use cases
  sl.registerLazySingleton<GetSavedLangUseCase>(
      () => GetSavedLangUseCase(langRepository: sl()));
  sl.registerLazySingleton<ChangeLangUseCase>(
      () => ChangeLangUseCase(langRepository: sl()));
  sl.registerLazySingleton<GetPosts>(() => GetPosts(postRepository: sl()));
  sl.registerLazySingleton<GetComments>(
      () => GetComments(commentRepository: sl()));
  sl.registerLazySingleton<PostComment>(() => PostComment(sl()));
  sl.registerLazySingleton<GetPost>(() => GetPost(postRepository: sl()));
  sl.registerLazySingleton<LikePost>(() => LikePost(postRepository: sl()));
  sl.registerLazySingleton<LikeComment>(
      () => LikeComment(postRepository: sl()));
  sl.registerLazySingleton<LikeReply>(() => LikeReply(postRepository: sl()));
  sl.registerLazySingleton<CheckIfPostIsLiked>(
      () => CheckIfPostIsLiked(postRepository: sl()));
  sl.registerLazySingleton<GetComment>(
      () => GetComment(commentRepository: sl()));
  sl.registerLazySingleton<PostReply>(() => PostReply(sl()));
  sl.registerLazySingleton<GetPostsUseCase>(
      () => GetPostsUseCase(classroomRepository: sl()));
  sl.registerLazySingleton<GetMembersUseCase>(
      () => GetMembersUseCase(classroomRepository: sl()));
  sl.registerLazySingleton<GetChildren>(
      () => GetChildren(profileRepository: sl()));
  sl.registerLazySingleton<AddChildUseCase>(
      () => AddChildUseCase(profileRepository: sl()));
  sl.registerLazySingleton<RemoveChild>(() => RemoveChild(repository: sl()));
  sl.registerLazySingleton<UpdateChildUseCase>(
      () => UpdateChildUseCase(profileRepository: sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: sl(), secureStorage: sl()));
  sl.registerLazySingleton<PostRepository>(() => PostRepositoryImpl(
      networkInfo: sl(), remoteDataSource: sl(), localDataSource: sl()));
  sl.registerLazySingleton<ClassroomRepository>(() => ClassroomRepositoryImpl(
        networkInfo: sl(),
        remoteDataSource: sl(),
      ));
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(
        networkInfo: sl(),
        remoteDataSource: sl(),
      ));
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl(),
      ));
  sl.registerLazySingleton<LangRepository>(
      () => LangRepositoryImpl(langLocalDataSource: sl()));

  // Data Sources
  sl.registerLazySingleton<LangLocalDataSource>(
      () => LangLocalDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(apiConsumer: sl()));
  sl.registerLazySingleton<PostRemoteDataSource>(
      () => PostRemoteDataSourceImpl(apiConsumer: sl()));
  sl.registerLazySingleton<PostLocalDataSource>(
      () => PostLocalDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<ClassroomRemoteDataSource>(
      () => ClassroomRemoteDataSourceImpl(apiConsumer: sl()));
  sl.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(apiConsumer: sl()));
  sl.registerLazySingleton<ChatRemoteDataSource>(() => ChatRemoteDataSourceImpl(
        apiConsumer: sl(),
      ));
  //! Core
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectionChecker: sl()));
  sl.registerLazySingleton(() => TokenProvider(secureStorage: sl()));

  sl.registerLazySingleton<ApiConsumer>(
      () => DioConsumer(client: sl(), tokenProvider: sl<TokenProvider>()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => AppInterceptors());
  sl.registerLazySingleton(() => LogInterceptor(
      request: true,
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
      error: true));
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => const FlutterSecureStorage());
}
