import 'package:aura/widgets/app_bar_back_button.dart';
import 'package:flutter/material.dart';

class AuraAppBar extends AppBar {
  AuraAppBar({Key? key, bool? hasBackButton, Text? title, List<Widget>? actions, PreferredSizeWidget? bottom})
      : super(
          key: key,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          actionsIconTheme: const IconThemeData(color: Colors.black),
          titleTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 21,
              fontWeight: FontWeight.w900),
          leading: (hasBackButton == null || hasBackButton) ? const AppBarBackButton() : null,
          title: title,
          actions: (actions?.isNotEmpty ?? false) ? actions : null,
          bottom: bottom,
        );
}
