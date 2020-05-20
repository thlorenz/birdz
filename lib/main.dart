import 'dart:ui' as ui;

import "package:birdz/bird.dart" show Bird;
import 'package:birdz/util/images.dart';
import 'package:birdz/widgets/bird_widget.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final birdImage = await Images.loadFromMemory('assets/images/bird.jpg');
  runApp(MyApp(birdImage: birdImage));
}

class MyApp extends StatelessWidget {
  final ui.Image birdImage;

  const MyApp({@required this.birdImage}) : super();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(widgetTitle: 'Birdz', birdImage: birdImage),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  final ui.Image birdImage;
  final String widgetTitle;
  final EdgeInsets margins = EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0);

  MyHomePage({@required this.widgetTitle, @required this.birdImage}) : super();

  // TODO: convert Image to ui.Image somehow
  _MyHomePageState createState() =>
      _MyHomePageState(Bird(image: birdImage, margins: margins));
}

class _MyHomePageState extends State<MyHomePage> {
  final Bird bird;

  _MyHomePageState(this.bird);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: BirdWidget(bird)));
  }
}
