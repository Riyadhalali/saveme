import 'package:flutter/material.dart';

class ImageBackgroundWithFilter extends StatefulWidget {
  String imageAsset;
  ImageBackgroundWithFilter({required this.imageAsset});
  @override
  _ImageBackgroundWithFilterState createState() => _ImageBackgroundWithFilterState();
}

class _ImageBackgroundWithFilterState extends State<ImageBackgroundWithFilter> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35.0),
          image: DecorationImage(
              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
              image: AssetImage(widget.imageAsset),
              fit: BoxFit.cover),
        ),
      ),
    );
  }
}
