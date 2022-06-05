import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [_TopBox(), const _HeaderIcon(), child],
        ));
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.height * 0.2,
        child: const Image(
          image: AssetImage('assets/images/icon/icon-logo-dragon-v2.png'),
          fit: BoxFit.contain,
        ),
      ),
    )
        //   const Icon(Icons.access_alarms_outlined,
        //       size: 100, color: Colors.white70),
        // ),
        );
  }
}

class _TopBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        width: double.infinity,
        height: size.height * 1,
        decoration: _topBoxBackground(),
        child: Stack(children: [
          // Positioned(top: 90, left: 30, child: _Bubble()),
          // Positioned(top: -40, left: -30, child: _Bubble()),
          // Positioned(top: -50, right: -20, child: _Bubble()),
          // Positioned(bottom: -50, left: 10, child: _Bubble()),
          // Positioned(bottom: 120, right: 20, child: _Bubble()),
        ]));
  }

  BoxDecoration _topBoxBackground() => const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color.fromARGB(255, 0, 0, 0), Color.fromARGB(255, 16, 0, 0)],
        ),
      );
}

class _Bubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: const Color.fromARGB(183, 170, 2, 2)),
    );
  }
}
