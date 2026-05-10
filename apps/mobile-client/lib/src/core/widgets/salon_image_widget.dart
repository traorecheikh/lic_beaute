import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'app_icon.dart';

class SalonImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const SalonImageWidget({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    final clip = borderRadius != null
        ? ClipRRect(
            borderRadius: borderRadius!,
            child: _content(url),
          )
        : _content(url);
    return SizedBox(width: width, height: height, child: clip);
  }

  Widget _content(String? url) {
    if (url == null || url.isEmpty) return _placeholder();

    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (_, _) => _shimmer(),
      errorWidget: (_, _, _) => _placeholder(),
    );
  }

  Widget _shimmer() => Shimmer.fromColors(
        baseColor: const Color(0xFFE0E0E0),
        highlightColor: const Color(0xFFF5F5F5),
        child: Container(color: Colors.white, width: width, height: height),
      );

  Widget _placeholder() => Container(
        width: width,
        height: height,
        color: const Color(0xFFF5F5F0),
        child: const AppIcon('image', size: 32, color: Color(0xFFBDB9B4)),
      );
}
