import 'package:flutter/material.dart';

double? slider = 0.0;

class Sliders extends StatefulWidget {
  final sizevalue;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeEnd;

  const Sliders({Key? key, this.sizevalue, this.onChanged, this.onChangeEnd})
      : super(key: key);

  @override
  _SlidersState createState() => _SlidersState();
}

class _SlidersState extends State<Sliders> {
  @override
  void initState() {
    slider = widget.sizevalue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 120,
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text("Text Size"),
        ),
        Divider(
          height: 1,
        ),
        Slider(
            value: slider!,
            min: 0.0,
            max: 100.0,
            onChangeEnd: (v) {
              setState(() {
                widget.onChangeEnd!(v);
              });
            },
            onChanged: (v) {
              setState(() {
                slider = v;
                widget.onChanged!(v);
              });
            }),
      ],
    ));
  }
}
