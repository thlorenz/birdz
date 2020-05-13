import 'package:birdz/bird.dart';
import 'package:birdz/widgets/bird_widget.dart';
import 'package:flutter/material.dart';

void main() {
  final birdImage = Image.asset('assets/image/bird.jpg');
  runApp(MyApp(birdImage: birdImage));
}

class MyApp extends StatelessWidget {
  final Image birdImage;

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
      home: MyHomePage(widgetTitle: 'Birdz'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Image birdImage;
  final String widgetTitle;

  MyHomePage({@required this.widgetTitle, @required this.birdImage}) : super();

  // TODO: convert Image to ui.Image somehow
  _MyHomePageState createState() => _MyHomePageState(Bird());
}

class _MyHomePageState extends State<MyHomePage> {
  final Bird bird;

  _MyHomePageState(this.bird);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Text(widget.widgetTitle),
        ),
        body: SafeArea(child: BirdWidget(bird)));
  }
}
