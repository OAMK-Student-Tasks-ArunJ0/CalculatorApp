import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Laskin',
      theme: new ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: new MyHomePage(title: 'Laskin'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String tulos = "";
  String lasku = "";
  String laskin = "";
  int type = 1;
  String napTxt2 = "";

  NappiPainettu(String napTxt) {
    setState(() {
      if(lasku.length == 92 && napTxt != "⌫" && napTxt != "CC" && napTxt != "1|2") {
        napTxt = "";
      }
      if(napTxt == "CC"){
        lasku = "0";
        tulos = "0";
      }
      else if(napTxt == "⌫"){
        lasku = lasku.substring(0, lasku.length - 1);
        if(lasku == ""){
          lasku = "0";
        }
      }
      else if(napTxt == "=") {
        laskin = lasku;
        laskin = laskin.replaceAll('x', '*');
        laskin = laskin.replaceAll('π', '3.1415926');
        laskin = laskin.replaceAll('√', 'sqrt(');
        laskin = laskin.replaceAll('%', '/100');


        try {
          Parser p = Parser();
          Expression lask = p.parse(laskin);

          ContextModel cm = ContextModel();
          tulos = '${lask.evaluate(EvaluationType.REAL, cm)}';
        } catch (e) {
          if (laskin.contains("sqrt(")) {
            tulos = "If '√' used use ')' at end";
          } else if(laskin.contains("cos(")) {
            tulos = "If 'cos(' used use ')' at end";
          } else if(laskin.contains("sin(")) {
            tulos = "If 'sin(' used use ')' at end";
          } else if(laskin.contains("tan(")) {
            tulos = "If 'tan(' used use ')' at end";
          } else {
            tulos = "Error";
          }
        }
      }
      else if(napTxt == "1|2") {
        if (type == 1) {
          type = 2;
        } else {
          type = 1;
        }
      }
      else{
        if(lasku == "0"){
          lasku = napTxt;
        }else {
          lasku = lasku + napTxt;
        }
      }
    });
  }
  Widget NappiRaken(String napTxt){
    if(napTxt == "=" ||napTxt == "CC" ||napTxt == "1|2" ||napTxt == "⌫") {
      return new Expanded(
        child: new OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.all(20),
            backgroundColor: Colors.grey
          ),
          onPressed: () => {
            NappiPainettu(napTxt),
          },
          child: Text(napTxt,
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)
          ),
        ),
      );
    } else {
      return new Expanded(
        child: new OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.all(20),
          ),
          onPressed: () => {
            NappiPainettu(napTxt),
          },
          child: Text(napTxt,
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new Container(
          child: new Column(children: <Widget>[
            new Container(
              alignment: Alignment.centerLeft,
              padding: new EdgeInsets.symmetric(vertical: 20, horizontal: 10,),
              child: new Text(lasku,
                style: new TextStyle(fontSize: 30.0, color: Colors.black,),),
            ),
            new Container(
              alignment: Alignment.centerLeft,
              padding: new EdgeInsets.symmetric(vertical: 20, horizontal: 10,),
              child: new Text(tulos,
                style: new TextStyle(fontSize: 30.0, color: Colors.black,),),
            ),
            new Expanded(
              child: new Divider(),
            ),
            if(type==2)...[Napit2()]
            else ...[Napit1()],
          ],),
        )
    );
  }
  Widget Napit1() {
    return new Column(children: [
      new Row(children: [
        NappiRaken("7"),
        NappiRaken("8"),
        NappiRaken("9"),
        NappiRaken("/")
      ],),
      new Row(children: [
        NappiRaken("4"),
        NappiRaken("5"),
        NappiRaken("6"),
        NappiRaken("x")
      ],),
      new Row(children: [
        NappiRaken("1"),
        NappiRaken("2"),
        NappiRaken("3"),
        NappiRaken("-")
      ],),
      new Row(children: [
        NappiRaken("0"),
        NappiRaken("("),
        NappiRaken(")"),
        NappiRaken("+")
      ],),
      new Row(children: [
        NappiRaken("1|2"),
        NappiRaken("CC"),
        NappiRaken("⌫"),
        NappiRaken("="),
      ],),
    ],);
  }
  Widget Napit2() {
    return new Column(children: [
      new Row(children: [
        NappiRaken("7"),
        NappiRaken("8"),
        NappiRaken("9"),
        NappiRaken("sin("),
      ],),
      new Row(children: [
        NappiRaken("4"),
        NappiRaken("5"),
        NappiRaken("6"),
        NappiRaken("cos("),
      ],),
      new Row(children: [
        NappiRaken("1"),
        NappiRaken("2"),
        NappiRaken("3"),
        NappiRaken("tan(")
      ],),
      new Row(children: [
        NappiRaken("."),
        NappiRaken("√"),
        NappiRaken("π"),
        NappiRaken("%"),
      ],),
      new Row(children: [
        NappiRaken("1|2"),
        NappiRaken("CC"),
        NappiRaken("⌫"),
        NappiRaken("="),
      ],),
    ],);
  }
}
