import 'package:flutter/material.dart';
import 'Routes/Routes.dart';
import 'Routes/RoutesName.dart';
import 'model_/Clock_model.dart';
import 'view_Model/Analoge_Provider.dart';
import 'view_Model/Digital_Provider.dart';
import 'view_Model/switch_provider.dart';
import 'deps/flutter_screenutil/flutter_screenutil.dart';
import 'deps/hive_flutter/adapters.dart';
import 'deps/provider/provider.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('clockBox'); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: getdesignSize(context),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_)=>SwitchProvider(),),
            ChangeNotifierProvider(create: (_) => DigitalProvider()),
            ChangeNotifierProvider(create: (_)=> AnalogeProvider(ClockModel())),
          ],

          child: Builder(
            builder: (BuildContext context) {
              final provi = Provider.of<SwitchProvider>(context);
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Clock App',
                themeMode: provi.themeMode,
                // theme: ThemeData(
                //   applyElevationOverlayColor: true,
                //   brightness: Brightness.light,
                //   appBarTheme: AppBarTheme(color: Colors.teal),
                //   primarySwatch: Colors.blue,
                //   textTheme: Typography.englishLike2018.apply(
                //     fontSizeFactor: 1.sp,
                //   ),
                // ),
                theme:provi.lightTheme,
                darkTheme: provi.darkTheme,
                initialRoute: Routesname.splash_view,
                onGenerateRoute: Routes.genrateRoute,
              );
            },
          ),
        );
      },
    );
  }
}


Size getdesignSize(BuildContext context) {
  double width = MediaQuery.of(context).size.width;

  if (width < 600) {
    return Size(360, 690);
  } else if (width < 1200) {
    return Size(834, 1194);
  } else {
    return Size(1440, 1024);
  }
}