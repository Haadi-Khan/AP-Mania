// import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:hse_assassin/constants/constants.dart';
// import 'package:hse_assassin/util/google_drive.dart';
// import 'package:image_picker/image_picker.dart';

// class TestView extends StatefulWidget {
//   const TestView({Key? key}) : super(key: key);

//   @override
//   State<TestView> createState() => _TestViewState();
// }

// class _TestViewState extends State<TestView> {
//   final ImagePicker _picker = ImagePicker();
//   File? image;
//   String? url;

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return SafeArea(
//       child: Column(
//         children: [
//           SizedBox(
//             width: size.width * 0.6,
//             child: OutlinedButton(
//               onPressed: () async {
//                 var temp = await _picker.pickImage(source: ImageSource.gallery);
//                 if (temp != null) {
//                   setState(() {
//                     image = File(temp.path);
//                   });
//                 }
//               },
//               style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all<Color>(kGreyColor),
//                 side: MaterialStateProperty.all<BorderSide>(BorderSide.none),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: const [
//                   FaIcon(FontAwesomeIcons.images, color: kWhiteColor),
//                   Text(textChoosePhoto, style: generalText),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(height: size.height * 0.01),
//           SizedBox(
//             height: size.height * 0.3,
//             width: size.width * 0.8,
//             child: image == null
//                 ? null
//                 : Image.file(
//                     image!,
//                     fit: BoxFit.contain,
//                   ),
//           ),
//           SizedBox(height: size.height * 0.01),
//           SizedBox(
//             width: size.width * 0.6,
//             child: OutlinedButton(
//               onPressed: () async {
//                 url = await uploadFileToGoogleDrive(image!);
//               },
//               style: ButtonStyle(
//                   foregroundColor:
//                       MaterialStateProperty.all<Color>(kBlackColor),
//                   backgroundColor:
//                       MaterialStateProperty.all<Color>(kWhiteColor),
//                   side: MaterialStateProperty.all<BorderSide>(BorderSide.none)),
//               child: const Text(textSignUp),
//             ),
//           ),
//           SizedBox(height: size.height * 0.01),
//           SizedBox(
//             height: size.height * 0.3,
//             width: size.width * 0.8,
//             child: url != null
//                 ? CachedNetworkImage(
//                     imageUrl: url!,
//                     placeholder: (context, url) => const Center(
//                       child: CircularProgressIndicator(
//                         color: kCyanColor,
//                       ),
//                     ),
//                   )
//                 : const SizedBox(),
//           ),
//         ],
//       ),
//     );
//   }
// }
