import 'package:flutter/widgets.dart';

const double kMaxContentWidth = 800;

class ConstrainedBody extends StatelessWidget {
  final Widget child;
  const ConstrainedBody({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
        child: child,
      ),
    );
  }
}
