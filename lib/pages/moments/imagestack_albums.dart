library image_stack;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Creates an image stack
class ImageStack extends StatelessWidget {
  final List<String> imageList;
  final double imageRadius;
  final int imageCount;
  final int totalCount;
  final double imageBorderWidth;
  final Color imageBorderColor;
  final TextStyle extraCountTextStyle;
  final Color backgroundColor;

  ImageStack({
    Key key,
    @required this.imageList,
    this.imageRadius = 25,
    this.imageCount = 3,
    this.totalCount,
    this.imageBorderWidth = 2,
    this.imageBorderColor = Colors.grey,
    this.extraCountTextStyle = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w600,
    ),
    this.backgroundColor = Colors.white,
  })  : assert(imageList != null),
        assert(extraCountTextStyle != null),
        assert(imageBorderColor != null),
        assert(backgroundColor != null),
        assert(totalCount != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var images = List<Widget>();
    int _size = imageCount;
    if (imageList.isNotEmpty) images.add(circularImage(imageList[0]));

    if (imageList.length > 1) {
      if (imageList.length < _size) {
        _size = imageList.length;
      }
      images.addAll(imageList
          .sublist(1, _size)
          .asMap()
          .map((index, image) => MapEntry(
                index,
                Positioned(
                  right: -(0.8 * imageRadius * (index + 1.0)),
                  child: circularImage(image),
                ),
              ))
          .values
          .toList());
    }
    return Container(
      child: Row(
        children: <Widget>[
          images.isNotEmpty
              ? Stack(
                  // overflow: Overflow.visible,
                  textDirection: TextDirection.ltr,
                  children: images,
                )
              : SizedBox(),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: totalCount - images.length > 0
                ? Container(
                    constraints: BoxConstraints(minWidth: imageRadius),
                    padding: EdgeInsets.all(3),
                    height: imageRadius,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(imageRadius),
                        border: Border.all(
                            color: imageBorderColor, width: imageBorderWidth),
                        color: backgroundColor),
                    child: Center(
                      child: Text(
                        (totalCount - images.length).toString(),
                        textAlign: TextAlign.center,
                        style: extraCountTextStyle,
                      ),
                    ),
                  )
                : SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget circularImage(String imageUrl) {
    return Container(
      height: imageRadius + 60,
      width: imageRadius,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        border: Border.all(
          color: Colors.white,
          width: imageBorderWidth,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white,
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
