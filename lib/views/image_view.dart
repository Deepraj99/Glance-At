import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageView extends StatefulWidget {
  final String imgUrl;
  ImageView({required this.imgUrl});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  var filePath;
  bool loading = false;
  double progress = 0.0;
  final Dio dio = Dio();

  Future<bool> saveFile(String url, String filename) async {
    var directory;

    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          // directory = await Directory("/sdcard/GlanceAt/images")
          //     .create(recursive: true);
          // var exists = await directory.exists();
          // exists ? print("Dir exists : Yes") : print("Dir exists : No");
          directory = await getExternalStorageDirectory();
          // inspect(dir);
        } else {
          return false;
        }
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        File saveFile = File(directory.path + "/$filename");
        await dio.download(url, saveFile.path,
            onReceiveProgress: (downloaded, totalSize) {
          setState(() {
            progress = downloaded / totalSize;
          });
        });
        if (Platform.isIOS) {
          await ImageGallerySaver.saveFile(saveFile.path,
              isReturnPathOfIOS: true);
        }
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  downloadFile() async {
    setState(() {
      loading = true;
    });

    bool downloaded = await saveFile(
        "https://images.pexels.com/photos/8369440/pexels-photo-8369440.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
        "image1.png");
    if (downloaded) {
      print("File downloaded");
    } else {
      print("File not downloaded");
    }

    setState(() {
      loading = false;
    });
  }

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
                              loading
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: LinearProgressIndicator(
                                        minHeight: 10,
                                        value: progress,
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        downloadFile();
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 8),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white54, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(30),
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

  // _save() async {
  //   // if (Platform.isAndroid) {
  //   //   await _askPermission();
  //   // }

  //   var response = await Dio()
  //       .get(widget.imgUrl, options: Options(responseType: ResponseType.bytes));
  //   final result =
  //       await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
  //   print(result);
  //   Navigator.pop(context);
  // }

  // // _askPermission() async {
  // //   if (Platform.isIOS) {
  // //     Map<PermissionGroup, PermissionStatus> permissions =

  // //     await PermissionHandler().requestPermissions([PermissionGroup.photos]);
  // //   } else {
  // //      PermissionStatus permission =  await PermissionHandler()
  // //         .checkPermissionStatus(PermissionGroup.storage);
  // //   }
  // // }
}
