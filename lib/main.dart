import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:pharmacy_guide2/data/favorite_drug_provider.dart';
import 'package:pharmacy_guide2/data/hitory_provider.dart';
import 'package:provider/provider.dart';

import 'home_menu.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
 // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
 // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);


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
      ],
      child: MyApp(),
    ),
  );

}


class MyApp extends StatefulWidget {
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
