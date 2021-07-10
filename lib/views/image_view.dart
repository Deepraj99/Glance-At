import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ImageView extends StatefulWidget {
  final String imgUrl;
  ImageView({required this.imgUrl});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  void initState() {
    super.initState();
  }

  var filePath;
  var imgUrl;
  bool loading = false;
  double progress = 0.0;
  final Dio dio = Dio();
  late String _localPath;
  late String imgPath;

  Future<bool> saveFile(String url, String filename) async {
    var directory;

    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
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
        String ss = saveFile.path;
        int pos = ss.indexOf('Android');
        imgPath = ss.substring(0, pos);

        imgPath += 'Download' + "/$filename";
        print(imgPath);
        await dio.download(url, imgPath,
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

    bool downloaded =
        await saveFile(widget.imgUrl, widget.imgUrl.substring(33, 40) + ".jpg");

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
    final key = new GlobalKey<ScaffoldState>();
    return Scaffold(
      key: key,
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
                        Container(
                          margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                          height: 132.0,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              loading
                                  ? Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: LinearProgressIndicator(
                                          color: Colors.grey,
                                          minHeight: 5,
                                          value: progress,
                                        ),
                                      ),
                                    )
                                  : Stack(
                                      children: [
                                        Container(
                                          height: 50.0,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          alignment: Alignment.bottomCenter,
                                          decoration: BoxDecoration(
                                            color: Color(0xff1C1B1B)
                                                .withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            downloadFile();
                                            _showToast(context);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            height: 50,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 8),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white54,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0x36FFFFFF),
                                                  Color(0x0FFFFFFF),
                                                ],
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Download",
                                                style: GoogleFonts.lato(
                                                    fontSize: 18,
                                                    color: Colors.white70),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                              SizedBox(height: 16),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Cancle",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ),
                              SizedBox(height: 40),
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

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text("Image saved in 'Download' folder."),
        // action: SnackBarAction(
        //     label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
