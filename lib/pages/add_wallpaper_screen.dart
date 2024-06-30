// import 'dart:io';
// //import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// //import 'package:firebase_ml_vision/firebase_ml_vision.dart';
// //import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class AddWallpaperScreen extends StatefulWidget {
//   @override
//   _AddWallpaperScreenState createState() => _AddWallpaperScreenState();
// }
//
// class _AddWallpaperScreenState extends State<AddWallpaperScreen> {
//   late File _image ;
//   final ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
//   List<String> labelsInString = [];
//   final Firestore _db = Firestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//
//   @override
//   void dispose() {
//     labeler.close();
//     super.dispose();
//   }
//
//   Future<void> _loadImage() async {
//     try {
//       var image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 30);
//
//       if (image == null) {
//         // User canceled image picking
//         return;
//       }
//
//       final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(image);
//       List<ImageLabel> labels = await labeler.processImage(visionImage);
//
//       setState(() {
//         _image = image;
//         labelsInString = labels.map((label) => label.text).toList();
//       });
//     } catch (e) {
//       print("Error picking image: $e");
//     }
//   }
//
//   Future<void> _uploadWallpaper() async {
//     try {
//       if (_image == null) {
//         throw Exception("No image selected");
//       }
//
//       String fileName = _image.path.split('/').last;
//       User user = await _auth.currentUser();
//       String uid = user.uid;
//
//       UploadTask task = storageReference.putFile(_image);
//       TaskSnapshot taskSnapshot = await task.whenComplete(() {});
//       String url = await taskSnapshot.ref.getDownloadURL();
//
//       _db.collection("wallpaperUrl").add({
//         "url": url,
//         "date": DateTime.now(),
//         "uploaded_by": uid,
//         "tags": labelsInString,
//       });
//
//       Navigator.of(context).pop();
//     } catch (e) {
//   print("Error uploading image: $e");
//
//       showDialog(
//         context: context,
//         builder: (ctx) {
//           return AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(18),
//             ),
//             title: Text("Error"),
//             content: Text("Error uploading image: $e"),
//             actions: <Widget>[
//               RaisedButton(
//                 onPressed: () {
//                   Navigator.of(ctx).pop();
//                 },
//                 child: Text("OK"),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Add Wallpaper"),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           width: MediaQuery.of(context).size.width,
//           child: Column(
//             children: <Widget>[
//               InkWell(
//                 onTap: _loadImage,
//                 child: _image != null ? Image.file(_image) : Image(
//                   image: AssetImage("assets/placeholder.jpg"),
//                 ),
//               ),
//               Text("Click to select image"),
//               SizedBox(height: 20),
//               labelsInString.isNotEmpty
//                   ? Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Wrap(
//                   spacing: 10,
//                   children: labelsInString.map((label) {
//                     return Chip(
//                       label: Text(label),
//                     );
//                   }).toList(),
//                 ),
//               )
//                   : Container(),
//               SizedBox(height: 40),
//               _isUploading ? Text("Uploading wallpaper...") : Container(),
//               _isCompletedUploading ? Text("Upload Completed") : Container(),
//               SizedBox(height: 40),
//               ElevatedButton(
//                 onPressed: _uploadWallpaper,
//                 child: Text("Upload Wallpaper"),
//               ),
//               SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class AddWallpaperScreen extends StatefulWidget {
//   @override
//   _AddWallpaperScreenState createState() => _AddWallpaperScreenState();
// }
//
// class _AddWallpaperScreenState extends State<AddWallpaperScreen> {
//   late File _image;
//   final ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
//   List<String> labelsInString = [];
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//
//   bool _isUploading = false;
//   bool _isCompletedUploading = false;
//
//   @override
//   void dispose() {
//     labeler.close();
//     super.dispose();
//   }
//
//   Future<void> _loadImage() async {
//     try {
//       var imagePicker = ImagePicker();
//       var image = await imagePicker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 30,
//       );
//
//       if (image == null) {
//         // User canceled image picking
//         return;
//       }
//
//       final FirebaseVisionImage visionImage =
//       FirebaseVisionImage.fromFile(File(image.path));
//       List<ImageLabel> labels = await labeler.processImage(visionImage);
//
//       setState(() {
//         _image = File(image.path);
//         labelsInString = labels.map((label) => label.text).toList();
//       });
//     } catch (e) {
//       print("Error picking image: $e");
//     }
//   }
//
//   Future<void> _uploadWallpaper() async {
//     try {
//       if (_image == null) {
//         throw Exception("No image selected");
//       }
//
//       setState(() {
//         _isUploading = true;
//       });
//
//       String fileName = _image.path.split('/').last;
//       User? user = _auth.currentUser;
//       String uid = user!.uid;
//
//       UploadTask task = _storage.ref().child(fileName).putFile(_image);
//       TaskSnapshot taskSnapshot = await task.whenComplete(() {});
//       String url = await taskSnapshot.ref.getDownloadURL();
//
//       await _db.collection("wallpaperUrl").add({
//         "url": url,
//         "date": DateTime.now(),
//         "uploaded_by": uid,
//         "tags": labelsInString,
//       });
//
//       setState(() {
//         _isCompletedUploading = true;
//         _isUploading = false;
//       });
//
//       Navigator.of(context).pop();
//     } catch (e) {
//       print("Error uploading image: $e");
//
//       setState(() {
//         _isUploading = false;
//       });
//
//       showDialog(
//         context: context,
//         builder: (ctx) {
//           return AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(18),
//             ),
//             title: Text("Error"),
//             content: Text("Error uploading image: $e"),
//             actions: <Widget>[
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(ctx).pop();
//                 },
//                 child: Text("OK"),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Add Wallpaper"),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           width: MediaQuery.of(context).size.width,
//           child: Column(
//             children: <Widget>[
//               InkWell(
//                 onTap: _loadImage,
//                 child: _image != null
//                     ? Image.file(_image)
//                     : Image.asset("assets/placeholder.jpg"),
//               ),
//               Text("Click to select image"),
//               SizedBox(height: 20),
//               labelsInString.isNotEmpty
//                   ? Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Wrap(
//                   spacing: 10,
//                   children: labelsInString.map((label) {
//                     return Chip(
//                       label: Text(label),
//                     );
//                   }).toList(),
//                 ),
//               )
//                   : Container(),
//               SizedBox(height: 40),
//               _isUploading ? Text("Uploading wallpaper...") : Container(),
//               _isCompletedUploading ? Text("Upload Completed") : Container(),
//               SizedBox(height: 40),
//               ElevatedButton(
//                 onPressed: _uploadWallpaper,
//                 child: Text("Upload Wallpaper"),
//               ),
//               SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
