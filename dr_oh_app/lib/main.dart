import 'package:dr_oh_app/components/color_service.dart';
import 'package:dr_oh_app/view/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'binding/init_bindings.dart';
import 'firebase_options.dart';

void main() async {
  // Date: 2023-01-09, jyh
  // firebase 연동
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeDateFormatting('ko', 'KR').then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // Date: 2023-01-07, SangwonKim
        // 프라이머리 스와치 컬러 : figma > primary-진하게 > colorcode: 5B9D46
        // Update Date: 2023-01-08, SangwonKim
        // color code 변경: primary > 99CD89
        primarySwatch: ColorService.createMaterialColor(
            const Color.fromARGB(255, 239, 173, 115)),
        primaryColorDark: const Color.fromARGB(153, 190, 97, 15),
        primaryColorLight: const Color.fromARGB(255, 246, 191, 143),
        // Date: 2023-01-07, SangwonKim
        // Desc: app바 테마 설정
        appBarTheme: AppBarTheme(
          color: Colors.grey[50],
          foregroundColor: Colors.black,
        ),
      ),
      darkTheme: ThemeData.dark(),
      initialBinding: InitBinding(),
      home: const Login(),
    );
  }
}
