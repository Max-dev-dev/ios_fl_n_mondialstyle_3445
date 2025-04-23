import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ios_fl_n_mondialstyle_3445/cubit/clothes_cubit/clothes_cubit.dart';
import 'package:ios_fl_n_mondialstyle_3445/cubit/outfit_cubit/outfit_cubit.dart';
import 'package:ios_fl_n_mondialstyle_3445/screens/splash_screen/splash_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Color mainAppColor = const Color(0xFF1B2A1D);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => OutfitCubit()),
        BlocProvider(create: (context) => ClothesCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/app_background.png',
                  fit: BoxFit.cover,
                ),
              ),
              child ?? const SizedBox.shrink(),
            ],
          );
        },
        home: SplashScreen(),
        theme: ThemeData(
          fontFamily: 'Aquitaine Initials Std',
          scaffoldBackgroundColor: mainAppColor,
          appBarTheme: AppBarTheme(
            backgroundColor: mainAppColor,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
        ),
      ),
    );
  }
}
