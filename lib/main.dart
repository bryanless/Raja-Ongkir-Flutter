import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:raja_ongkir_flutter/theme/theme.dart';
import 'package:raja_ongkir_flutter/views/pages.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        return MaterialApp(
          title: 'Raja Ongkir',
          theme: DynamicTheme.lightTheme(lightColorScheme),
          darkTheme: DynamicTheme.darkTheme(darkColorScheme),
          home: const HomePage(),
        );
      },
    );
  }
}
