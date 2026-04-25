import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ImageCompressionService {
  /// Compresses an image to a maximum size (default 200KB) for low-bandwidth upload.
  static Future<File> compressForUpload(File file, {int quality = 70, int maxWidth = 1024}) async {
    final bytes = await file.readAsBytes();
    img.Image? image = img.decodeImage(bytes);
    
    if (image == null) return file;

    // Resize if too wide
    if (image.width > maxWidth) {
      image = img.copyResize(image, width: maxWidth);
    }

    // Compress
    final compressedBytes = img.encodeJpg(image, quality: quality);
    
    final tempDir = await getTemporaryDirectory();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_compressed.jpg';
    final compressedFile = File(p.join(tempDir.path, fileName));
    
    return await compressedFile.writeAsBytes(compressedBytes);
  }
}
