import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/ui/widgets/animated_dialog.dart';

class AddMemoryCard extends StatefulWidget {
  final OverlayEntry parentOverlay;
  final File selectedImage;
  const AddMemoryCard({Key? key, required this.parentOverlay, required this.selectedImage})
      : super(key: key);

  @override
  State<AddMemoryCard> createState() => _AddMemoryCardState();
}

class _AddMemoryCardState extends State<AddMemoryCard> {
  @override
  Widget build(BuildContext context) {
    return BackButtonListener(
      onBackButtonPressed: () {
        widget.parentOverlay.remove();
        return Future.value(true);
      },
      child: AnimatedDialog(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.amber,
          child: ListView(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: double.infinity,
                    maxHeight: MediaQuery.of(context).size.height * 0.82),
                child: Container(
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.grey.shade900, width: 3)),
                  child: Image.file(
                    widget.selectedImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              MaterialButton(
                child: Text("Exit"),
                color: Colors.blue,
                onPressed: () {
                  widget.parentOverlay.remove();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
