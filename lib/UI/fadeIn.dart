// import 'package:flutter/material.dart';

// // class FadeInAnimation extends StatefulWidget {
// //   const FadeInAnimation({super.key, required this.child, required this.delay});

// //   final Widget child;
// //   final double delay;

// //   @override
// //   State<FadeInAnimation> createState() => _FadeInAnimationState();
// // }

// // class _FadeInAnimationState extends State<FadeInAnimation>
// //     with TickerProviderStateMixin {
// //   late AnimationController controller;
// //   late Animation<double> animation;
// //   late Animation<double> animation2;

// //   @override
// //   void initState() {
// //     super.initState();
// //     controller = AnimationController(
// //         duration: Duration(milliseconds: (500 * widget.delay).round()),
// //         vsync: this);
// //     animation2 = Tween<double>(begin: -40, end: 0).animate(controller)
// //       ..addListener(() {
// //         setState(() {});
// //       });

// //     animation = Tween<double>(begin: 0, end: 1).animate(controller)
// //       ..addListener(() {
// //         setState(() {
// //           // The state that has changed here is the animation object’s value.
// //         });
// //       });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     controller.forward();
// //     return Transform.translate(
// //       offset: Offset(0, animation2.value),
// //       child: Opacity(
// //         opacity: animation.value,
// //         child: widget.child,
// //       ),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     controller.dispose();
// //     super.dispose();
// //   }
// // }

// class SlideInContainerPage extends StatefulWidget {
//   @override
//   _SlideInContainerPageState createState() => _SlideInContainerPageState();
// }

// class _SlideInContainerPageState extends State<SlideInContainerPage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );
//     _animation = Tween<Offset>(
//       begin: Offset(0.0, -1.0), // Start off-screen (above)
//       end: Offset.zero,         // End at its original position
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOut,
//     ));
//     _controller.forward(); // Start the animation when the page loads
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
