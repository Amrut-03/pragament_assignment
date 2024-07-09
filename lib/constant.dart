import 'package:flutter/material.dart';

class AppTemplate {
  static const Color textClr = Colors.white;
  static const Color otherClr = Colors.black;
}

class Txt extends StatelessWidget {
  final String txt;
  final Color fontClr;
  final double fontSz;
  final FontWeight fontWt;
  const Txt(
      {super.key,
      required this.txt,
      required this.fontClr,
      required this.fontSz,
      required this.fontWt});

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: TextStyle(color: fontClr, fontSize: fontSz, fontWeight: fontWt),
    );
  }
}

class Bttn extends StatelessWidget {
  final VoidCallback onClick;
  final String txt;
  final double fontSz;
  final Color fontClr;
  final FontWeight fontWt;
  const Bttn(
      {super.key,
      required this.onClick,
      required this.txt,
      required this.fontSz,
      required this.fontClr,
      required this.fontWt});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              txt,
              style: TextStyle(
                  color: fontClr, fontSize: fontSz, fontWeight: fontWt),
            ),
          )),
    );
  }
}

class IconBttn extends StatelessWidget {
  final VoidCallback onClick;
  final IconData icon;
  const IconBttn({super.key, required this.onClick, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTemplate.textClr),
      ),
      child: IconButton(
        onPressed: onClick,
        icon: Icon(
          icon,
          color: AppTemplate.textClr,
        ),
      ),
    );
  }
}
