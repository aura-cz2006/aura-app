import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => context.pop(),
    );
  }
}
