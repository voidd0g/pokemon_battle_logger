import 'package:image_picker/image_picker.dart';

class ImageUtil {
  static final ImageUtil _instance = ImageUtil._();
  static ImageUtil get instance => _instance;

  ImageUtil._();

  Future<String?> getImage({required ImageSource source}) async {
    final ImagePicker picker = ImagePicker();
    final file = await picker.pickImage(source: source);
    return file?.path;
  }
}
