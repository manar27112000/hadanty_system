import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gobeauty/core/app_service/api_service.dart';
import 'package:gobeauty/features/login/repository/login_repo.dart';
import 'core/route/app_router.dart';
import 'core/route/path_router.dart';
import 'core/theme/dark_theme.dart';
import 'core/theme/light_theme.dart';
import 'features/login/viewmodel/login_cubit.dart';
import 'features/login/viewmodel/token_storage.dart';
import 'features/more/view_model/locale cubit/locale_cubit.dart';
import 'generated/l10n.dart';
import 'my_bloc_observer.dart';
import 'core/app_service/dio_helper.dart';
import 'package:intl/intl.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
late LoginRepo loginRepository;

/// Test fake API request to check if token send with request
Future<void> testFakeApiRequest() async {
  try {
    final response = await DioHelper.dio.get(
      "https://api-dev.gb.salon/api/scf/Salon",
    );
    print("🌐 API Response: ${response.data}");
  } catch (e) {
    print("❌ API Error: $e");
  }
}

//used to check if the app is in arabic check padding from right and left
bool isArabic() {
  return Intl.getCurrentLocale() == "ar";
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  final apiService = ApiService(DioHelper.dio);
   loginRepository = LoginRepo(apiService);
  await TokenStorage.loadTokens();
  final savedLocale = await LocaleCubit.loadSavedLocale();
  final localeCubit = LocaleCubit(savedLocale);
  ///////////////////////////////////////////////////////////////////
  /// testing
  /// valid valid =>layout    ==>success
  // await TokenStorage.saveTokens(
  //   newAccessToken: "valid_access",
  //   newRefreshToken: "valid_refresh",
  //   accessTokenExpiryString: DateTime.now().add(Duration(minutes: 5)).toIso8601String(),
  //   refreshTokenExpiryString: DateTime.now().add(Duration(hours: 1)).toIso8601String(),
  // );
  ///valid invalid =>layout    ==>success
  //await TokenStorage.saveTokens(
  //  newAccessToken:
  // " eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiJiODdhYjRhNS1lNjQ5LTQzNDgtYWQ5Ny0zNWIzMDE4ZjlhODUiLCJ1cHIiOiIxIiwic2lkIjoiMSIsImRldiI6IjM4IiwibmJmIjoxNzUzODc2ODExLCJleHAiOjE3NTUxNzI4MTEsImlhdCI6MTc1Mzg3NjgxMSwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo3MDA4IiwiYXVkIjoiaHR0cDovL2xvY2FsaG9zdDo3MDA4In0.o6bRc2t0Wp1rHKZWdRX8VNFK_9ezRLEoQ1tsUj9rE-s",
  // newRefreshToken: " MKy0KmeYhcLkSdbtEmwwBNx6Oir3ZECDrzSsBnuAfPycii+ZNYlOe341B8RDK1xRlZ4Jj2o+wr0HcsTIGKoP2A==",
  //accessTokenExpiryString: "2020-01-01T00:00:00Z",
  //  refreshTokenExpiryString: "2025-08-14T12:00:11.5118303Z",
  //);
  ///invalid invalid =>login  ==>success
  // await TokenStorage.saveTokens(
  //   newAccessToken: "expired_access",
  //   newRefreshToken: "expired_refresh",
  //   accessTokenExpiryString: "2020-01-01T00:00:00Z", // منتهي
  //   refreshTokenExpiryString: "2020-01-01T00:00:00Z", // منتهي
  // );
  ///invalid valid =>login  ==>success
  //await TokenStorage.saveTokens(
  // newAccessToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiJiODdhYjRhNS1lNjQ5LTQzNDgtYWQ5Ny0zNWIzMDE4ZjlhODUiLCJ1cHIiOiIxIiwic2lkIjoiMSIsImRldiI6IjE2IiwibmJmIjoxNzUzODE4NzkzLCJleHAiOjE3NTUxMTQ3OTMsImlhdCI6MTc1MzgxODc5MywiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo3MDA4IiwiYXVkIjoiaHR0cDovL2xvY2FsaG9zdDo3MDA4In0.M07xXpQiKXVxylQHrYSyHK-dL4gF0rbwkXt2o_cqLBM",
  // newRefreshToken: "TxTkNdPO9N3swq2re3fr/r9gm7LG5Rw6gYoGwFZgJhMHWisyNC2PIt8MQDAe4kLwcqHpm10wAfHK72p7xbvfzA==",
  // accessTokenExpiryString: "2025-08-13T19:53:13.3013279Z",
  // refreshTokenExpiryString: "2020-01-01T00:00:00Z",
  //);


  //await testFakeApiRequest();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
        (value) =>
        runApp(
          DevicePreview(
            enabled: false,
            builder: (context) => BlocProvider.value(
              value: localeCubit,
              child: const MyApp(),
            ),
          ),
        ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LoginCubit>(create: (_) => LoginCubit(loginRepository)),
        ],
        child: BlocBuilder<LocaleCubit, Locale>(
          builder: (context, locale) {
            return MaterialApp(
              locale: locale,
              localizationsDelegates: [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,

              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              navigatorKey: navigatorKey,
              themeMode: ThemeMode.system,
              onGenerateRoute: generateRoute,
              initialRoute: AppRoutes.splashRoute,
              // home: LoginScreen(),
              // home: BottomModalSheet(),
            );
          },
        ),
      ),
    );
  }
}

