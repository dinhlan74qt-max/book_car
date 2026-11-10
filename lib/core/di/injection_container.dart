import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'package:book_car/core/storage/user_local_storage.dart';
import 'package:book_car/features/ai_assistant/data/datasources/ai_remote_data_source.dart';
import 'package:book_car/features/ai_assistant/data/repositories/ai_repository_impl.dart';
import 'package:book_car/features/ai_assistant/domain/repositories/ai_repository.dart';
import 'package:book_car/features/ai_assistant/domain/usecases/send_ai_chat_message.dart';
import 'package:book_car/features/ai_assistant/presentation/bloc/ai_assistant_bloc.dart';

final sl = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // Storage
  if (!sl.isRegistered<UserLocalStorage>()) {
    sl.registerLazySingleton<UserLocalStorage>(() => UserLocalStorage());
  }

  // Dio Client
  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton<Dio>(
      () => Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 120),
          sendTimeout: const Duration(seconds: 60),
          headers: const {
            'Accept': 'application/json, text/plain, */*',
            'X-Requested-With': 'XMLHttpRequest',
          },
        ),
      ),
    );
  }

  // AI Assistant Data Source & Repo
  if (!sl.isRegistered<AiRemoteDataSource>()) {
    sl.registerLazySingleton<AiRemoteDataSource>(
      () => AiRemoteDataSourceImpl(sl<Dio>(), sl<UserLocalStorage>()),
    );
  }
  if (!sl.isRegistered<AiRepository>()) {
    sl.registerLazySingleton<AiRepository>(
      () => AiRepositoryImpl(sl<AiRemoteDataSource>()),
    );
  }

  // UseCase & BLoC
  if (!sl.isRegistered<SendAiChatMessage>()) {
    sl.registerFactory<SendAiChatMessage>(
      () => SendAiChatMessage(sl<AiRepository>()),
    );
  }
  if (!sl.isRegistered<AiAssistantBloc>()) {
    sl.registerFactory<AiAssistantBloc>(
      () => AiAssistantBloc(sl<SendAiChatMessage>()),
    );
  }
}
