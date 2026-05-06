import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection.dart' as di;
import 'presentation/bloc/aura_voice_cubit.dart';
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
      ],
      child: MaterialApp(
        title: 'AuraVoice',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          colorScheme: const ColorScheme.dark(
            primary: Colors.greenAccent,
            secondary: Colors.cyanAccent,
          ),
          useMaterial3: true,
        ),
        home: const HomeRecordPage(),
      ),
    );
  }
}
