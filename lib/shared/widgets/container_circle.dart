import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContainerCircle extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;

  const ContainerCircle({
    super.key,
    required this.child,
    this.height = 140,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF5B7CFA),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: SvgPicture.asset('assets/svg/Circle.svg', width: 180),
          ),
          Padding(padding: const EdgeInsets.all(20), child: child),
        ],
      ),
    );
  }
}
