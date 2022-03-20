import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'home_page.dart';

void main() => runApp(IntroScreen());
class IntroScreen extends StatelessWidget {

  List<PageViewModel> listPagesViewModel = [
    PageViewModel(
      title: "Title of first page",
      body: "The map tab",
      image: Center(
        child: Image.network("https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg", height: 175.0),
      ),
    ),
    PageViewModel(
      title: "Title of second page",
      body: "The community tab",
      image: Center(
        child: Image.network("https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg", height: 175.0),
      ),
    )
  ];


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    home: IntroductionScreen(
      pages: listPagesViewModel,
      showNextButton: false,
      showBackButton: false,
      showSkipButton: false,
      showDoneButton: false,
      // skip: const Text("Skip"),
      // done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),

    ),
    );//Material App
  }
}
