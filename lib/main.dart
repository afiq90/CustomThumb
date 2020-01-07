import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TimeReportTextField(0.2),
    );
  }
  
}

class TimeReportTextField extends StatefulWidget {
 double sliderValue;

  TimeReportTextField(this.sliderValue);

  @override
  _TimeReportTextFieldState createState() => _TimeReportTextFieldState();
}

class _TimeReportTextFieldState extends State<TimeReportTextField> {
  final textFieldController = TextEditingController();
  ui.Image customImage;

  Future<ui.Image> load(String asset) async {
    ByteData data = await rootBundle.load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  @override
  void initState() {
    load('assets/images/thumb_db.png').then((image) {
      setState(() {
        customImage = image;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Custom Thumb Slider'),
            SizedBox(height: 20,),
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 5,
                // activeTrackColor: Colors.blue,
                // inactiveTrackColor: Colors.blue,
                thumbShape: SliderThumbImage(customImage),
              ),
              child: Slider(
                activeColor: Colors.blue,
                inactiveColor: Colors.blue,
                min: 0.0,
                max: 1.0,
                onChanged: (value) {
                  // int a = int.parse(value);
                  double percent = value * 100;
                  setState(() {
                    widget.sliderValue = value;
                  });
                },
                // onChanged: null,
                value: widget.sliderValue,
              ),
            ),
            SizedBox(height: 10,),
            Text(widget.sliderValue.toString()),
          ],
        ));
  }
}

class SliderThumbImage extends SliderComponentShape {
  final ui.Image image;

  SliderThumbImage(this.image);

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(0, 0);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {Animation<double> activationAnimation,
      Animation<double> enableAnimation,
      bool isDiscrete,
      TextPainter labelPainter,
      RenderBox parentBox,
      SliderThemeData sliderTheme,
      TextDirection textDirection,
      double value}) {
    final canvas = context.canvas;
    final imageWidth = image?.width ?? 10;
    final imageHeight = image?.height ?? 10;


    Offset imageOffset = Offset(
      center.dx - (imageWidth / 2),
      center.dy - (imageHeight / 2),
    );

    Paint paint = Paint()..filterQuality = FilterQuality.high;

    if (image != null) {
      canvas.drawImage(image, imageOffset, paint);
    }
  }
}
