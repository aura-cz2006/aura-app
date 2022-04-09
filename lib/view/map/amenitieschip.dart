import 'package:aura/managers/map_manager.dart';
import 'package:aura/models/amenity_category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(Settings());

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
              title: Center(child: Text('Settings')),
              automaticallyImplyLeading: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context, false),
              )),
          body: rowChips(),
        ));
  }
}

Widget rowChips() {
  return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Consumer<MapManager>(builder: (context, mapManager, child) {
        return Row(
            children: mapManager.categories
                .map((category) => _amenityChipWrapper(category, 0x1111111))
                .toList());
      }));
}

/*
* Controls spacing between chips
* */
Widget _amenityChipWrapper(AmenityCategory text, int colour) {
  return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 30), //Spacing in between chips
      child: amenityChipWidget(category: text));
}

// class AmenityChipDisplay extends StatefulWidget {
//   @override
//   _AmenityChipDisplayState createState() => _AmenityChipDisplayState();
// }

class amenityChipWidget extends StatefulWidget {
  final AmenityCategory category;

  amenityChipWidget({required this.category});

  @override
  _amenityChipWidgetState createState() => _amenityChipWidgetState();
}

class _amenityChipWidgetState extends State<amenityChipWidget> {
  var _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<MapManager>(builder: (context, mapManager, child) {
      return ChoiceChip(
        label: Text(CategoryConvertor.getReadable(widget.category)??""),
        labelStyle: TextStyle(color: Colors.black),
        selected: mapManager.selectedCategories.contains(widget.category),
        elevation: 1.0,
        onSelected: (isSelected) {
          print("trying to select chip.....");
          mapManager.toggleSelectedCategory(widget.category);
        },
        backgroundColor: Colors.white,
        selectedColor: Colors.blue,
      );
    });
  }
}
