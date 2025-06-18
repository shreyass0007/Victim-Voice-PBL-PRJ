import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ImageService {
  static final _cacheManager = DefaultCacheManager();

  static Future<File?> optimizeImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) return null;

      // Resize if image is too large
      img.Image optimizedImage = image;
      if (image.width > 1920 || image.height > 1080) {
        optimizedImage = img.copyResize(
          image,
          width: image.width > 1920 ? 1920 : null,
          height: image.height > 1080 ? 1080 : null,
          interpolation: img.Interpolation.linear,
        );
      }

      // Compress the image
      final optimizedBytes = img.encodeJpg(optimizedImage, quality: 85);

      // Save optimized image
      final tempDir = await getTemporaryDirectory();
      final optimizedFile = File(
        '${tempDir.path}/optimized_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      await optimizedFile.writeAsBytes(optimizedBytes);
      return optimizedFile;
    } catch (e) {
      debugPrint('Error optimizing image: $e');
      return null;
    }
  }

  static Future<String?> cacheImage(String url) async {
    try {
      final fileInfo = await _cacheManager.downloadFile(url);
      return fileInfo.file.path;
    } catch (e) {
      debugPrint('Error caching image: $e');
      return null;
    }
  }

  static Widget cachedNetworkImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit? fit,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return FutureBuilder<FileInfo?>(
      future: _cacheManager.getFileFromCache(imageUrl),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Image.file(
            snapshot.data!.file,
            width: width,
            height: height,
            fit: fit,
          );
        }

        return FadeInImage.assetNetwork(
          placeholder: 'assets/images/placeholder.png',
          image: imageUrl,
          width: width,
          height: height,
          fit: fit ?? BoxFit.cover,
          imageErrorBuilder: (context, error, stackTrace) {
            return errorWidget ?? Icon(Icons.error);
          },
        );
      },
    );
  }

  static Future<void> clearImageCache() async {
    await _cacheManager.emptyCache();
  }

  static Future<void> removeFromCache(String url) async {
    await _cacheManager.removeFile(url);
  }
}
