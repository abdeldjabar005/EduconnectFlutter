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
import 'package:quotes/features/posts/presentation/cubit/comment_cubit.dart';
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
  sl.registerFactory<AuthCubit>(() => AuthCubit(authRepository: sl()));
  sl.registerFactory<PostCubit>(() => PostCubit(
        getPostsUseCase: sl(),
      ));
  sl.registerFactory<CommentsCubit>(() => CommentsCubit(getCommentsUseCase: sl()));

  // Use cases
  sl.registerLazySingleton<GetSavedLangUseCase>(
      () => GetSavedLangUseCase(langRepository: sl()));
  sl.registerLazySingleton<ChangeLangUseCase>(
      () => ChangeLangUseCase(langRepository: sl()));
  sl.registerLazySingleton<GetPosts>(() => GetPosts(postRepository: sl()));
sl.registerLazySingleton<GetComments>(() => GetComments(commentRepository: sl()));

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
