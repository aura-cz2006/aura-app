import 'package:aura/managers/map_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AmenitiesFilterChips extends StatefulWidget {
  const AmenitiesFilterChips({Key? key}) : super(key: key);

  @override
  State<AmenitiesFilterChips> createState() => _AmenitiesFilterChipsState();
}

class _AmenitiesFilterChipsState extends State<AmenitiesFilterChips> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Consumer<MapManager>(builder: (context, mapManager, child) {
          return Row(
              children: mapManager.categories
                  .map((category) => _amenityChipWrapper(category, 0x1111111))
                  .toList());
        }));
  }
}

Widget _amenityChipWrapper(String text, int colour) {
  return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 30),
      //Spacing in between chips
      child: amenityChipWidget(category: text));
}

class amenityChipWidget extends StatefulWidget {
  final String category;

  amenityChipWidget({required this.category});

  @override
  _amenityChipWidgetState createState() => _amenityChipWidgetState();
}

class _amenityChipWidgetState extends State<amenityChipWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MapManager>(builder: (context, mapManager, child) {
      return ChoiceChip(
        label: Text(widget.category),
        labelStyle: TextStyle(color: Colors.black),
        selected: mapManager.selectedCategories.contains(widget.category),
        elevation: 1.0,
        onSelected: (isSelected) {
          print("trying to select chip.....");
          mapManager.setSelectedCategory(widget.category);
        },
        backgroundColor: Colors.white,
        selectedColor: Colors.blue,
      );
    });
  }
}
