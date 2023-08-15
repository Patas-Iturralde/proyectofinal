import 'package:image_picker/image_picker.dart';

Future getImage() async{
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
// Capture a photo.
  final XFile? photo = await picker.pickImage(source: ImageSource.camera);
  return photo;
}