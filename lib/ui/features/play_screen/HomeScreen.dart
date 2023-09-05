import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Material(
            child: Align(
                child: Expanded(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
      InkWell(
          child: const Card(
              child: SizedBox(
                  width: 200,
                  height: 100,
                  child: Padding(padding: EdgeInsets.all(5), child: Align(alignment: Alignment.center, child: Text("CREATE NEW MATCH"))))),
          onTap: () async {
            Navigator.pushNamed(context, "/create");
          }),
      InkWell(
          child: const Card(
              child: SizedBox(
                  width: 200,
                  height: 100,
                  child: Padding(padding: EdgeInsets.all(5), child: Align(alignment: Alignment.center, child: Text("CONTINUE MATCH"))))),
          onTap: () async {
            Navigator.pushNamed(context, "/playscreen");
          })
    ])))));
  }
}
