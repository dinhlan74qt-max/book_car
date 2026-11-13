import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import 'package:book_car/core/network/auth_interceptor.dart';
import 'package:book_car/core/storage/user_local_storage.dart';
import 'package:book_car/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:book_car/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:book_car/features/auth/domain/repositories/auth_repository.dart';
import 'package:book_car/features/auth/domain/usecases/login.dart';
import 'package:book_car/features/auth/domain/usecases/send_otp.dart';
import 'package:book_car/features/auth/domain/usecases/verify_otp.dart';
import 'package:book_car/features/auth/presentation/bloc/login_bloc.dart';
import 'package:book_car/features/auth/presentation/bloc/send_otp_bloc.dart';

import 'package:book_car/features/ai_assistant/data/datasources/ai_remote_data_source.dart';
import 'package:book_car/features/ai_assistant/data/repositories/ai_repository_impl.dart';
import 'package:book_car/features/ai_assistant/domain/repositories/ai_repository.dart';
import 'package:book_car/features/ai_assistant/domain/usecases/send_ai_chat_message.dart';
import 'package:book_car/features/ai_assistant/presentation/bloc/ai_assistant_bloc.dart';

import 'package:book_car/features/wallet/data/datasources/wallet_remote_data_source.dart';
import 'package:book_car/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:book_car/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:book_car/features/wallet/domain/usecases/deposit.dart';
import 'package:book_car/features/wallet/domain/usecases/get_my_wallet.dart';
import 'package:book_car/features/wallet/domain/usecases/withdraw.dart';
import 'package:book_car/features/wallet/presentation/bloc/deposit_bloc.dart';
import 'package:book_car/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:book_car/features/wallet/presentation/bloc/withdraw_bloc.dart';

final sl = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
<<<<<<< HEAD
  // Storage
=======
  // HTTP Client
  if (!sl.isRegistered<http.Client>()) {
    sl.registerLazySingleton<http.Client>(() => http.Client());
  }

  // 1. Storage
>>>>>>> a3764cc6c36a0dbc2b2f92e41578b08ef1633385
  if (!sl.isRegistered<UserLocalStorage>()) {
    sl.registerLazySingleton<UserLocalStorage>(() => UserLocalStorage());
  }

<<<<<<< HEAD
  // Dio Client
  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton<Dio>(
      () => Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 120),
          sendTimeout: const Duration(seconds: 60),
          headers: const {
=======
  // 2. Dio Client có gắn Auth Interceptor
  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton<Dio>(() {
      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          headers: {
>>>>>>> a3764cc6c36a0dbc2b2f92e41578b08ef1633385
            'Accept': 'application/json, text/plain, */*',
            'X-Requested-With': 'XMLHttpRequest',
          },
        ),
<<<<<<< HEAD
      ),
    );
  }

  // AI Assistant Data Source & Repo
=======
      );
      dio.interceptors.add(AuthInterceptor(sl<UserLocalStorage>()));
      return dio;
    });
  }

  // 3. Auth Data Source & Repo
  if (!sl.isRegistered<AuthRemoteDataSource>()) {
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl<http.Client>()),
    );
  }
  if (!sl.isRegistered<AuthRepository>()) {
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
    );
  }

  // 4. UseCase & BLoC
  if (!sl.isRegistered<Login>()) {
    sl.registerFactory<Login>(() => Login(sl<AuthRepository>()));
  }
  if (!sl.isRegistered<SendOtp>()) {
    sl.registerFactory<SendOtp>(() => SendOtp(sl<AuthRepository>()));
  }
  if (!sl.isRegistered<VerifyOtp>()) {
    sl.registerFactory<VerifyOtp>(() => VerifyOtp(sl<AuthRepository>()));
  }

  if (!sl.isRegistered<LoginBloc>()) {
    sl.registerFactory<LoginBloc>(
      () => LoginBloc(sl<Login>(), sl<UserLocalStorage>()),
    );
  }
  if (!sl.isRegistered<SendOtpBloc>()) {
    sl.registerFactory<SendOtpBloc>(
      () => SendOtpBloc(sl<SendOtp>()),
    );
  }

  // 5. AI Assistant
>>>>>>> a3764cc6c36a0dbc2b2f92e41578b08ef1633385
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
<<<<<<< HEAD

  // UseCase & BLoC
=======
>>>>>>> a3764cc6c36a0dbc2b2f92e41578b08ef1633385
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
<<<<<<< HEAD
=======

  // 6. Wallet Feature
  if (!sl.isRegistered<WalletRemoteDataSource>()) {
    sl.registerLazySingleton<WalletRemoteDataSource>(
      () => WalletRemoteDataSourceImpl(sl<Dio>(), sl<UserLocalStorage>()),
    );
  }

  if (!sl.isRegistered<WalletRepository>()) {
    sl.registerLazySingleton<WalletRepository>(
      () => WalletRepositoryImpl(sl<WalletRemoteDataSource>()),
    );
  }

  if (!sl.isRegistered<GetMyWallet>()) {
    sl.registerFactory<GetMyWallet>(() => GetMyWallet(sl<WalletRepository>()));
  }

  if (!sl.isRegistered<Deposit>()) {
    sl.registerFactory<Deposit>(() => Deposit(sl<WalletRepository>()));
  }

  if (!sl.isRegistered<Withdraw>()) {
    sl.registerFactory<Withdraw>(() => Withdraw(sl<WalletRepository>()));
  }

  if (!sl.isRegistered<WalletBloc>()) {
    sl.registerFactory<WalletBloc>(() => WalletBloc(sl<WalletRepository>()));
  }

  if (!sl.isRegistered<DepositBloc>()) {
    sl.registerFactory<DepositBloc>(() => DepositBloc(sl<Deposit>()));
  }

  if (!sl.isRegistered<WithdrawBloc>()) {
    sl.registerFactory<WithdrawBloc>(() => WithdrawBloc(sl<Withdraw>()));
  }
>>>>>>> a3764cc6c36a0dbc2b2f92e41578b08ef1633385
}
