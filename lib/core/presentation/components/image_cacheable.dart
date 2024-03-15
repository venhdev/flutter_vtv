import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageCacheable extends StatelessWidget {
  const ImageCacheable(
    this.imageUrl, {
    super.key,
    this.height,
    this.width,
    this.fit,
    this.borderRadius,
  });

  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        // placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
        progressIndicatorBuilder: (context, url, downloadProgress) => Center(
          child: CircularProgressIndicator(
            value: downloadProgress.progress,
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        height: height,
        width: width,
        fit: fit,
      ),
    );
  }
}
