import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:quotes/core/api/api_consumer.dart';
import 'package:quotes/core/api/dio_consumer.dart';
import 'package:quotes/core/network/netwok_info.dart';
import 'package:quotes/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:quotes/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:quotes/features/auth/data/repositories/token_repository.dart';
import 'package:quotes/features/auth/domain/repositories/auth_repository.dart';
import 'package:quotes/features/posts/data/datasources/post_local_data_source.dart';
import 'package:quotes/features/posts/domain/usecases/check_liked.dart';
import 'package:quotes/features/posts/domain/usecases/get_comment.dart';
import 'package:quotes/features/posts/domain/usecases/get_post.dart';
import 'package:quotes/features/posts/domain/usecases/like_comment.dart';
import 'package:quotes/features/posts/domain/usecases/like_post.dart';
import 'package:quotes/features/posts/domain/usecases/like_reply.dart';
import 'package:quotes/features/posts/domain/usecases/post_comment.dart';
import 'package:quotes/features/posts/domain/usecases/post_reply.dart';
import 'package:quotes/features/posts/presentation/cubit/comment_cubit.dart';
import 'package:quotes/features/posts/presentation/cubit/like_cubit.dart';
import 'package:quotes/features/splash/data/datasources/lang_local_data_source.dart';
import 'package:quotes/features/splash/data/repositories/lang_repository_impl.dart';
import 'package:quotes/features/splash/domain/repositories/lang_repository.dart';
import 'package:quotes/features/splash/domain/usecases/change_lang.dart';
import 'package:quotes/features/splash/domain/usecases/get_saved_lang.dart';
import 'package:quotes/features/splash/presentation/cubit/locale_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quotes/features/auth/presentation/cubit/auth_cubit.dart';
import 'core/api/app_interceptors.dart';
import 'package:quotes/features/posts/data/datasources/post_remote_data_source.dart';
import 'package:quotes/features/posts/data/repositories/post_repository_impl.dart';
import 'package:quotes/features/posts/domain/repositories/post_repository.dart';
import 'package:quotes/features/posts/domain/usecases/get_posts.dart';
import 'package:quotes/features/posts/presentation/cubit/post_cubit.dart';
import 'package:quotes/features/posts/domain/usecases/get_comments.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features

  // Blocs
  sl.registerFactory<LocaleCubit>(
      () => LocaleCubit(getSavedLangUseCase: sl(), changeLangUseCase: sl()));
  sl.registerLazySingleton<AuthCubit>(() => AuthCubit(authRepository: sl()));
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
      postCubit: sl()));
  sl.registerFactory<LikeCubit>(() => LikeCubit(
      likePostUseCase: sl(),
      likeCommentUseCase: sl(),
      likeReplyUseCase: sl())); // Use cases
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
  // Repository
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: sl(), secureStorage: sl()));
  sl.registerLazySingleton<PostRepository>(() => PostRepositoryImpl(
      networkInfo: sl(), remoteDataSource: sl(), localDataSource: sl()));

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
