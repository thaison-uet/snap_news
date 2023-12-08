import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_app/src/utils/constants/common_constants.dart';

class SignUpViewTopImage extends StatelessWidget {
  const SignUpViewTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Sign Up".toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: CommonConstants.defaultPadding),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: SvgPicture.asset("assets/icons/signup.svg"),
            ),
            const Spacer(),
          ],
        ),
        SizedBox(height: CommonConstants.defaultPadding),
      ],
    );
  }
}
