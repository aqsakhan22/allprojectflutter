import 'dart:typed_data';

import 'package:flutter/material.dart';

class ProfilePicWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;
  final Uint8List? avatar;

  const ProfilePicWidget({
    Key? key,
    required this.avatar,
    required this.imagePath,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
        ],
      ),
    );
  }

  Widget buildImage() {
    final ImageProvider image;
    if (avatar != null) {
      image = MemoryImage(avatar!);
    } else {
      image = const AssetImage('assets/raw_profile_pic.png');
    }

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 100,
          height: 100,
          child: InkWell(onTap: onClicked),
        ),
      ),
    );
  }
}
