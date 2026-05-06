import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection.dart' as di;
import 'presentation/bloc/aura_voice_cubit.dart';
import 'presentation/bloc/voice_tuner_cubit.dart';
import 'presentation/pages/home_record_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const AuraVoiceApp());
}

class AuraVoiceApp extends StatelessWidget {
  const AuraVoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<AuraVoiceCubit>()..initEngine(),
        ),
        BlocProvider(
          create: (_) => di.sl<VoiceTunerCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'AuraVoice',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: const Color(0xFFF9FAFB), // Soft off-white
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF3B82F6), // Clean bright blue
            secondary: Color(0xFF60A5FA), // Soft blue for accents
            surface: Colors.white,
          ),
          useMaterial3: true,
          fontFamily: 'SF Pro Display', // Safe fallback for iOS-like feel if SF Pro isn't available, or use default which is system font
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Color(0xFF1A1A1C)), // Dark icons
            titleTextStyle: TextStyle(
              color: Color(0xFF1A1A1C),
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
        ),
        home: const HomeRecordPage(),
      ),
    );
  }
}
