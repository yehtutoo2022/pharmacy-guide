import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pharmacy_guide2/data/bookmark_provider.dart';
import 'package:pharmacy_guide2/data/favorite_drug_provider.dart';
import 'package:pharmacy_guide2/data/history_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'home_menu.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

   WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
   FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  await Locales.init(
      [
        'en',
        'my'
      ]
  );


  runApp(
    // MyApp(),
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FavoriteDrugProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => HistoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BookmarkProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
  // Remove splash screen after the app is ready
  FlutterNativeSplash.remove();

}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  //const MyApp({Key? key}) : super(key: key);
  static void setTheme(BuildContext context, ThemeData themeData) {
    final _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setThemeData(themeData);
  }


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData _themeData = ThemeData.light();

  void setThemeData(ThemeData themeData) {
    setState(() {
      _themeData = themeData;
    });
  }

  @override
  Widget build(BuildContext context) {

    return LocaleBuilder(
      builder: (locale) => MaterialApp(
        title: 'MM Pharmacy Guide',
        localizationsDelegates: Locales.delegates,
        supportedLocales: Locales.supportedLocales,
        locale: locale,
        theme: _themeData,
        home: const HomeMenu(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
