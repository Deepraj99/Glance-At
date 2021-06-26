import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageView extends StatefulWidget {
  final String imgUrl;
  ImageView({required this.imgUrl});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  var filePath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: widget.imgUrl,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.network(widget.imgUrl, fit: BoxFit.cover),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Stack(
              children: [
                // Container(
                //   height: 50.0,
                //   width: MediaQuery.of(context).size.width,
                //   alignment: Alignment.bottomCenter,
                //   decoration: BoxDecoration(
                //     color: Color(0xff1C1B1B).withOpacity(0.8),
                //     borderRadius: BorderRadius.circular(30),
                //   ),
                // ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Stack(
                      children: [
                        Center(
                          child: Container(
                            height: 50.0,
                            width: MediaQuery.of(context).size.width / 2,
                            alignment: Alignment.bottomCenter,
                            decoration: BoxDecoration(
                              color: Color(0xff1C1B1B).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        Container(
                          height: 131.0,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _save();
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white54, width: 1),
                                    borderRadius: BorderRadius.circular(30),
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0x36FFFFFF),
                                        Color(0x0FFFFFFF),
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Download",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white70),
                                      ),
                                      Text(
                                        "Image will be downloaded in gallery",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Cancle",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(height: 50),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _save() async {
    // if (Platform.isAndroid) {
    //   await _askPermission();
    // }

    var response = await Dio()
        .get(widget.imgUrl, options: Options(responseType: ResponseType.bytes));
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print(result);
    Navigator.pop(context);
  }

  // _askPermission() async {
  //   if (Platform.isIOS) {
  //     Map<PermissionGroup, PermissionStatus> permissions =

  //     await PermissionHandler().requestPermissions([PermissionGroup.photos]);
  //   } else {
  //      PermissionStatus permission =  await PermissionHandler()
  //         .checkPermissionStatus(PermissionGroup.storage);
  //   }
  // }
}
