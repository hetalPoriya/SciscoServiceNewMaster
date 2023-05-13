import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scisco_service/LoginSignup/Welcome/welcome_screen.dart';
import 'package:scisco_service/Services/url_service.dart';
import 'package:scisco_service/Utils/app_assets.dart';
import 'package:scisco_service/app_theme.dart';
import 'package:toast/toast.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:ui' as ui;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  // Pass all uncaught errors to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    precacheImage(AssetImage(AppAssets.installationPending), context);
    precacheImage(AssetImage(AppAssets.servicePending), context);
    precacheImage(AssetImage(AppAssets.installationDone), context);
    precacheImage(AssetImage(AppAssets.serviceDone), context);
    precacheImage(AssetImage(AppAssets.punchIn), context);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          UniversalPlatform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Color.fromRGBO(255, 255, 255, 1.0),
      systemNavigationBarDividerColor: Color.fromRGBO(255, 255, 255, 1.0),
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    RenderErrorBox.backgroundColor = Colors.transparent;
    RenderErrorBox.textStyle = ui.TextStyle(color: Colors.transparent);
    return GetMaterialApp(
        title: 'SCISCO',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
          primarySwatch: Colors.blue,
          textTheme: AppTheme.textTheme,
          platform: TargetPlatform.iOS,
        ),
        home: WelcomeScreen());
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
