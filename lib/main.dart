import 'package:flutter/material.dart';
import 'package:vadsanvad/screens/welcome_screen.dart';
import 'package:vadsanvad/screens/login_screen.dart';
import 'package:vadsanvad/screens/registration_screen.dart';
import 'package:vadsanvad/screens/chat_screen.dart';

void main() => runApp(const FlashChat());

class FlashChat extends StatelessWidget {
  const FlashChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(hintColor: Colors.black45),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        RegistrationScreen.id: (context) => const RegistrationScreen(),
        ChatScreen.id: (context) => const ChatScreen(),
      },
    );
  }
}
