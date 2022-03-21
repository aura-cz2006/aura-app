// meet ups layer
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:aura/view/map/map_tab.dart';

class MeetUpMarker extends StatefulWidget {
  const  MeetUpMarker({Key? key}) : super(key: key);

  @override
  State< MeetUpMarker> createState() =>  _MeetUpMarker();
}

class _MeetUpMarker extends  State< MeetUpMarker> {

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: IconButton(
        icon: const Icon(Icons.location_pin),
        color: Colors.red,
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 200,
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Monopoly Night!', style: TextStyle(
                        fontSize: 20),), //title,
                      Text("by User1234", style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],),),
                      Text("Time: 7pm - 10pm, Today"),
                      Text("Location: SCSE Lounge"),
                      Text("Join me for a round of Monopoly and snacks!"),
                      IconButton(
                          icon:  Icon(Icons.arrow_forward),
                        onPressed: (){
                          setState((){
                          });
                          },
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),);
  }

}

//title, by USER, date and time, short desc

class MeetUpsButton extends StatefulWidget {
  const  MeetUpsButton({Key? key}) : super(key: key);

  @override
  State< MeetUpsButton> createState() => _MeetUpsButton();
}


class _MeetUpsButton extends State< MeetUpsButton> {
  bool showWidget = false;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
          child: Ink(
            decoration: const ShapeDecoration(
              color: Colors.redAccent,
              shape: CircleBorder(),
            ),
            child: IconButton(
              icon: const Icon(Icons.emoji_people_rounded),
              color: Colors.black,
              onPressed: () {
                setState((){
                  showWidget = !showWidget;
                  [showWidget ?
                  [print("clicled22"), //if
                    meetupMarkersList.add(
                        Marker(
                            width: 40,
                            height: 40,
                            point: LatLng(1.3461,103.6814),
                            builder: (context) =>  MeetUpMarker()
                        )
                    )]
                      : [meetupMarkersList.removeAt(0), //else
                    print("clicled")]
                  ];
                });
              },
            ),
          )
      ),
    );
  }
}



