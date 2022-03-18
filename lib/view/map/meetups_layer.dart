// meet ups layer
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class meetupsButton extends StatefulWidget {
  const  meetupsButton({Key? key}) : super(key: key);

  @override
  State< meetupsButton> createState() => _meetupsButton();
}

class _meetupsButton extends State< meetupsButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child: Ink(
          decoration: const ShapeDecoration(
            color: Colors.redAccent,
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: const Icon(Icons.emoji_people_rounded),
            color: Colors.black,
            onPressed: () {},
          ),
        )
      ),
    );
  }
}
//meet up at scse, 1.3461° N, 103.6814° E