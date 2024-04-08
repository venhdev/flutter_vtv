import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewPage extends StatelessWidget {
  const PhotoViewPage({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: PhotoView(
              backgroundDecoration: const BoxDecoration(color: Colors.black),
              imageProvider: NetworkImage(imageUrl),
              maxScale: PhotoViewComputedScale.covered * 2.5,
              minScale: PhotoViewComputedScale.contained * 0.8,
            ),
          ),
          Positioned(
            top: 24,
            right: 12,
            child: IconButton(
              icon: const Icon(Icons.close),
              color: Colors.white,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white24),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
