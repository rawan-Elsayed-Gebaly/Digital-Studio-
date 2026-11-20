import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'presentation/screens/registeration/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://fuytrnvmoobhzxxjuett.supabase.co',
    publishableKey: 'sb_publishable_izVzPHp2WkcgRv0uO_kgNA_WN6kGvNg',
  );

  runApp(const SystemManagementApp());
}

class SystemManagementApp extends StatelessWidget {
  const SystemManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'System Management Rawan',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B1C33)),
      ),
      home: const LoginPage(),
    );
  }
}
