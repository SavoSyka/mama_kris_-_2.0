import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mama_kris/core/constants/app_palette.dart';


class CustomImageView extends StatelessWidget {
  final String? imagePath;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit? fit;
  final String placeHolder;
  final Alignment? alignment;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? radius;
  final BoxBorder? border;

  const CustomImageView({
    super.key,
    required this.imagePath,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.margin,
    this.border,
    this.placeHolder ='',
  });
  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(alignment: alignment!, child: _buildWidget())
        : _buildWidget();
  }

  Widget _buildWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(onTap: onTap, child: _buildImage()),
    );
  }

  Widget _buildImage() {
    Widget imageWidget = _buildImageView();

    if (radius != null) {
      imageWidget = ClipRRect(borderRadius: radius!, child: imageWidget);
    }

    if (border != null) {
      imageWidget = Container(
        decoration: BoxDecoration(border: border, borderRadius: radius),
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildImageView() {
    if (imagePath == null || imagePath == "") {
      return const Icon(
        Icons.error_outline, 
        size: 48, 
        color: AppPalette.primaryColor,
      );
    }

    switch (imagePath!.imageType) {
      case ImageType.svg:
        return _buildSvgImage();
      case ImageType.file:
        return _buildFileImage();
      case ImageType.network:
        return _buildNetworkImage();
      case ImageType.gif:
        return _buildGifImage();
      case ImageType.base64:
        return _buildBase64Image();
      case ImageType.png:
      default:
        return _buildAssetImage();
    }
  }

  Widget _buildSvgImage() {
    return SizedBox(
      height: height,
      width: width,
      child: SvgPicture.asset(
        imagePath!,
        height: height,
        width: width,
        fit: fit ?? BoxFit.contain,
        colorFilter:
            color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      ),
    );
  }

  Widget _buildFileImage() {
    return Image.file(
      File(imagePath!),
      height: height,
      width: width,
      fit: fit ?? BoxFit.cover,
      color: color,
    );
  }

  Widget _buildNetworkImage() {
    return CachedNetworkImage(
      height: height,
      width: width,
      fit: fit,
      imageUrl: imagePath!,
      cacheKey: imagePath!,
      color: color,
      placeholder:
          (context, url) => SizedBox(
            height: height ?? 50,
            width: width ?? 30,
            child: LinearProgressIndicator(
              color: Colors.grey.shade200,
              backgroundColor: Colors.grey.shade100,
            ),
          ),
      errorWidget: (context, url, error) {
        debugPrint('❌ Failed to load: $url');
        debugPrint('Error: $error');
        return _buildPlaceholder();
      },
    );
  }

  Widget _buildGifImage() {
    debugPrint('GIF Image Path: $imagePath');
    return Image.asset(
      imagePath!,
      height: height,
      width: width,
      fit: fit ?? BoxFit.cover,
      errorBuilder:
          (context, error, stackTrace) => Image.asset(
            placeHolder,
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
          ),
    );
  }

  Widget _buildBase64Image() {
    String base64String = imagePath!.split(',').last;
    Uint8List imageBytes = base64Decode(base64String);

    return Image.memory(
      imageBytes,
      height: height,
      width: width,
      fit: fit ?? BoxFit.cover,
      color: color,
    );
  }

  // Widget _buildAssetImage() {
  //   return Image.asset(
  //     imagePath!,
  //     height: height,
  //     width: width,
  //     fit: fit ?? BoxFit.cover,
  //     color: color,
  //   );
  // }
  Widget _buildAssetImage() {
    return Image.asset(
      imagePath!,
      height: height,
      width: width,
      fit: fit ?? BoxFit.cover,
      color: color,
      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    if (placeHolder.endsWith('.svg')) {
      return SvgPicture.asset(
        placeHolder,
        height: height,
        width: width,
        fit: fit ?? BoxFit.contain,
        colorFilter:
            color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      );
    } else {
      return Image.asset(
        placeHolder,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        color: color,
      );
    }
  }
}

extension ImageTypeExtension on String {
  ImageType get imageType {
    if (startsWith('data:image')) {
      return ImageType.base64;
    } else if (startsWith('http') || startsWith('https')) {
      return ImageType.network;
    } else if (endsWith('.svg')) {
      return ImageType.svg;
    } else if (startsWith('file://')) {
      return ImageType.file;
    } else if (endsWith('.gif')) {
      return ImageType.gif;
    } else {
      return ImageType.png;
    }
  }
}

enum ImageType { svg, png, network, gif, file, base64, unknown }
