import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_app/src/utils/constants/common_constants.dart';

class LoginViewTopImage extends StatelessWidget {
  const LoginViewTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "LOGIN",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: CommonConstants.defaultPadding * 2),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: SvgPicture.asset("assets/icons/login.svg"),
            ),
            const Spacer(),
          ],
        ),
        SizedBox(height: CommonConstants.defaultPadding * 2),
      ],
    );
  }
}
