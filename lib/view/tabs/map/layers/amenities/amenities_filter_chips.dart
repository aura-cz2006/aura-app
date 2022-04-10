import 'package:aura/managers/map_manager.dart';
import 'package:aura/models/amenity_category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AmenitiesFilterChips extends StatefulWidget {
  final VoidCallback onTap;
  const AmenitiesFilterChips({Key? key, required this.onTap}) : super(key: key);

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
                  .map((category) => _AmenityChipWrapper(category, widget.onTap))
                  .toList());
        }));
  }
}

Widget _AmenityChipWrapper(AmenityCategory category, VoidCallback onTap) {
  return Container(
      margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 30),
      //Spacing in between chips
      child: AmenityChipWidget(category: category, onTap: onTap));
}

class AmenityChipWidget extends StatefulWidget {
  final AmenityCategory category;
  final VoidCallback onTap; // new code

  const AmenityChipWidget(
      {Key? key, required this.category, required this.onTap})
      : super(key: key);

  @override
  _AmenityChipWidgetState createState() => _AmenityChipWidgetState();
}

class _AmenityChipWidgetState extends State<AmenityChipWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MapManager>(builder: (context, mapManager, child) {
      return GestureDetector(
        onTap: widget.onTap,
        child: ChoiceChip(
          label: Text(CategoryConvertor.getReadable(widget.category)!),
          labelStyle: const TextStyle(color: Colors.black),
          selected: mapManager.selectedCategories.contains(widget.category),
          elevation: 1.0,
          onSelected: (isSelected) {
            mapManager.setSelectedCategory(widget.category);
          },
          backgroundColor: Colors.white,
          selectedColor: Colors.lightBlueAccent,
          disabledColor: Colors.grey,
        ),
      );
    });
  }
}
