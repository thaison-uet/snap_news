import 'package:flutter/material.dart';
import 'package:news_app/src/core/core.dart';
import 'package:news_app/src/presentation/login_signup/view/login_view.dart';
import 'package:news_app/src/presentation/login_signup/view/sign_up_view.dart';

class LoginAndSignupBtn extends StatelessWidget {
  const LoginAndSignupBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return LoginView();
                },
              ),
            );
          },
          child: Text(
            "Login".toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return SignUpView();
                },
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: colorPrimary.withOpacity(0.5),
            elevation: 0,
          ),
          child: Text(
            "Sign Up".toUpperCase(),
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
