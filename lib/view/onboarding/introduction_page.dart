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
    ),
    PageViewModel(
      title: "User's Home Address",
      bodyWidget: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: homeadd_textbox(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 50),
            child: homeadd_submitButton()
          ),
        ],
      ),
      image: Center(child: Icon(Icons.home,size: 175,color: Colors.lightBlueAccent),),
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

Widget homeadd_textbox(){
  return Container(
      decoration: BoxDecoration(
        color: Color(0x11111111),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 15, right: 15, top: 5),
        child: TextFormField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Enter your home's address:",
            )
        ),
      )
  );
}

Widget homeadd_submitButton() {
  return ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)
              )
          )
      ),
      child: Text("Submit"),
      onPressed: (){
        /*Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ???()),*/
      },
    );
}
