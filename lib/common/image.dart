import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loar_flutter/common/util/images.dart';

enum ImageWidgetType { asset, network, file }

/// 图片组件
class ImageWidget extends StatelessWidget {
  final String url;
  final ImageWidgetType type;
  final double? radius;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Color? backgroundColor;
  final Color? borderColor;
  final ExtendedImageMode? mode;
  final Widget Function(
    BuildContext context,
    ImageProvider provider,
    Widget completed,
    Size? size,
  )? builder;

  const ImageWidget({
    Key? key,
    required this.type,
    required this.url,
    this.radius,
    this.mode,
    this.borderColor,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.backgroundColor,
    this.builder,
  }) : super(key: key);

  const ImageWidget.url(
    this.url, {
    Key? key,
    this.mode,
    this.radius,
    this.borderColor,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.backgroundColor,
    this.builder,
  })  : type = ImageWidgetType.network,
        super(key: key);

  const ImageWidget.asset(
    this.url, {
    Key? key,
    this.mode,
    this.radius,
    this.borderColor,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.backgroundColor,
    this.builder,
  })  : type = ImageWidgetType.asset,
        super(key: key);

  const ImageWidget.file(
    this.url, {
    Key? key,
    this.mode,
    this.radius,
    this.borderColor,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.backgroundColor,
    this.builder,
  })  : type = ImageWidgetType.file,
        super(key: key);

  Widget get _placeholder => placeholder ?? Container();

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.all(
      Radius.circular(radius ?? 0),
    );
    Widget? image;
    switch (type) {
      case ImageWidgetType.asset:
        image = ExtendedImage.asset(
          url,
          mode: mode ?? ExtendedImageMode.none,
          width: width,
          height: height,
          fit: fit,
          shape: BoxShape.rectangle,
          borderRadius: borderRadius,
          loadStateChanged: (state) => _buildLoadState(context, state),
        );
        break;
      case ImageWidgetType.network:
        if (!url.contains('http')) break;

        image = ExtendedImage.network(
          url,
          width: width,
          height: height,
          fit: fit,
          mode: mode ?? ExtendedImageMode.none,
          shape: BoxShape.rectangle,
          borderRadius: borderRadius,
          border: Border.all(
            color: borderColor ?? Colors.transparent,
          ),
          loadStateChanged: (state) => _buildLoadState(context, state),
        );
        break;
      case ImageWidgetType.file:
        image = ExtendedImage.file(
          mode: mode ?? ExtendedImageMode.none,
          File(url),
          width: width,
          height: height,
          fit: fit,
          shape: BoxShape.rectangle,
          borderRadius: borderRadius,
          loadStateChanged: (state) => _buildLoadState(context, state),
        );
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      width: width,
      height: height,
      child: image ?? _placeholder,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
    );
  }

  Widget _buildLoadState(BuildContext context, ExtendedImageState state) {
    switch (state.extendedImageLoadState) {
      case LoadState.loading:
        return _placeholder;
      case LoadState.completed:
        Size? size;
        if (state.extendedImageInfo != null) {
          size = Size(
            state.extendedImageInfo!.image.width.toDouble(),
            state.extendedImageInfo!.image.height.toDouble(),
          );
        }
        final provider = state.imageProvider;
        final completed = state.completedWidget;
        return builder?.call(context, provider, completed, size) ?? completed;
      case LoadState.failed:
        return ImageWidget.asset(
          AssetsImages.defaultImage,
        );
    }
  }
}
