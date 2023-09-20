import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class DraggableSheetFeedback extends StatefulWidget {
  final Widget child;

  const DraggableSheetFeedback({super.key, required this.child});

  @override
  State<DraggableSheetFeedback> createState() => _DraggableSheetFeedbackState();
}

class _DraggableSheetFeedbackState extends State<DraggableSheetFeedback> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.22,
          minChildSize: 0.20,
          maxChildSize: 0.65,
          builder: (_, scrollController) => SafeArea(
                child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        widget.child,
                      ],
                    )),
              )),
    );
  }
}
