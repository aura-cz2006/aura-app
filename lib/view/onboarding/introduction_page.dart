import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'home_page.dart';

void main() => runApp(TestScreen())
class TestScreen extends StatelessWidget {

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
    return IntroductionScreen(
      pages: listPagesViewModel,
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      onDone: () {
        // When done button is press
      },
    ); //Material App
  }
}
