import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 50.0),
      child: SvgPicture.asset(
        'assets/logo.svg',
        width: 40,
        height: 40,
      ),
    );
  }
}
