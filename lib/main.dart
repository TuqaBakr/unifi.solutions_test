import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/domain/services/locator.dart';
import 'core/routing/app_router.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await initApp();
  await locatorSetUp();
 // await LocalStorage.init();

  runApp(const MyApp());
}

initApp() async {
  await ScreenUtil.ensureScreenSize();
 // Bloc.observer = blocLogger;
 // await LocalStorage.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (buildContext, widget){
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
          title: 'Unifi Solutions Assessment',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
          ),
        );
      },
    );
  }
}