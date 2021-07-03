import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar(
      {Key key,
      this.photoUrl,
      @required this.radius,
      this.borderColor = Colors.transparent})
      : super(key: key);
  final String photoUrl;
  final double radius;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 3.0,
        ),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.black12,
        backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
        child: photoUrl == null ? Icon(Icons.camera_alt, size: radius) : null,
      ),
    );
  }
}
