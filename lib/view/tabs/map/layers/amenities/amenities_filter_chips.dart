import 'package:aura/managers/map_manager.dart';
import 'package:aura/models/amenity_category.dart';
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
                  .map((category) => _AmenityChipWrapper(category, 0x1111111))
                  .toList());
        }));
  }
}

Widget _AmenityChipWrapper(AmenityCategory category, int colour) {
  return Container(
      margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 30),
      //Spacing in between chips
      child: AmenityChipWidget(category: category));
}

class AmenityChipWidget extends StatefulWidget {
  final AmenityCategory category;

  const AmenityChipWidget({Key? key, required this.category}) : super(key: key);

  @override
  _AmenityChipWidgetState createState() => _AmenityChipWidgetState();
}

class _AmenityChipWidgetState extends State<AmenityChipWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MapManager>(builder: (context, mapManager, child) {
      return ChoiceChip(
        label: Text(CategoryConvertor.getReadable(widget.category)!),
        labelStyle: const TextStyle(color: Colors.black),
        selected: mapManager.selectedCategories.contains(widget.category),
        elevation: 1.0,
        onSelected: (isSelected) {
          mapManager.setSelectedCategory(widget.category);
        },
        backgroundColor: Colors.white,
        selectedColor: Colors.blue,
      );
    });
  }
}
