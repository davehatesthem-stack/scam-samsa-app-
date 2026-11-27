import 'package:dasturnomi/src/core/const/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class buildTopAppBar extends StatelessWidget {
  const buildTopAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset('assets/icons/logo_brand.svg', width: 77, height: 52),
        const SizedBox(width: 12),
        const Text(
          'Samsa Admin',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: darkText,
            fontFamily: 'Serif',
          ),
        ),
        const Spacer(),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFEDE2D5),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.person, color: Color(0xFF3A302A)),
        ),
      ],
    );
  }
}
