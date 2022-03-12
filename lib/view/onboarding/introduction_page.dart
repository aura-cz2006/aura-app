import 'package:flutter/material.dart';
//TODO: import main screen (routing to this onboarding screen)

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: IntroductionScreen(
        scrollPhysics: const BouncingScrollPhysics(), //Default is BouncingScrollPhysics
        pages: [
          //List of PageViewModel
        ],
        rawPages: [
          //If you don't want to use PageViewModel you can use this
        ],
        //If you provide both rawPages and pages parameter, pages will be used.
        onChange: (e){
          // When something changes
        },
        onDone: () {
          // When done button is press
        },
        onSkip: () {
          // You can also override onSkip callback
        },
        showSkipButton: true, //Is the skip button should be display
        skip: const Icon(Icons.skip_next),
        next: const Icon(Icons.forward),
        done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),

        dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: Theme.of(context).progressIndicatorTheme.color!,
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0))),
      ),
    );
  }
}