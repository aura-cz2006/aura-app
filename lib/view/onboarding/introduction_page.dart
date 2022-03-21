import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'home_page.dart';

void main() => runApp(IntroScreen());

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final addresstxt_Controller = TextEditingController();

  List<PageViewModel> listPagesViewModel = [];

  @override
  void initState(){
    listPagesViewModel = [
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
      ),
      PageViewModel(
        title: "User's Home Address",
        bodyWidget: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: homeAdd_Field(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50),
              child: homeadd_SubmitButton(context),
            ),
          ],
        ),
        image: Center(
          child: Icon(Icons.home, size: 175, color: Colors.lightBlueAccent),),
      ),
    ];
  }

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
    ); //Material App
  }

  Widget homeAdd_Field() =>
      TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        controller: addresstxt_Controller,
        decoration: const InputDecoration(
            labelText: "Home Address",
            hintText: "Enter your home address here",
            border: OutlineInputBorder()),
      );

  Widget homeadd_SubmitButton(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              )
          )
      ),
      child: Text("Submit"),
      onPressed: () {
        setState(() {
          /* userManager.updateHomeAdd(addresstxt_Controller.text); //Update User's home address
          );*/
        });
        /*context.go('${GoRouter
            .of(context)
            .location}/???'); //After setState user info, go to main page*/
      },
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    addresstxt_Controller.dispose();
    super.dispose();
  }
}