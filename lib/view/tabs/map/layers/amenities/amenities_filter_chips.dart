import 'package:aura/managers/map_manager.dart';
import 'package:aura/models/amenity_category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef AmenityChipTapCallback = void Function(AmenityCategory category);

class AmenityChip extends StatefulWidget {
  final void Function(bool)? onSelected;
  final AmenityCategory category;

  const AmenityChip(
      {Key? key, required this.category, this.onSelected})
      : super(key: key);

  @override
  _AmenityChipState createState() => _AmenityChipState();
}

class _AmenityChipState extends State<AmenityChip> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MapManager>(builder: (context, mapManager, child) {
      return Container(
            margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 30),
            //Spacing in between chips
            child: ChoiceChip(
              label: Text(CategoryConvertor.getReadable(widget.category)!),
              labelStyle: const TextStyle(color: Colors.black),
              selected: mapManager.selectedCategories.contains(widget.category),
              elevation: 1.0,
              onSelected: widget.onSelected,
              backgroundColor: Colors.white,
              //todo
              selectedColor: Colors.lightBlueAccent,
              disabledColor: Colors.grey,
            ),);
    });
  }
}
