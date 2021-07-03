import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:glance_at/data/data.dart';
import 'package:glance_at/model/wallpaper_model.dart';
import 'package:glance_at/views/nextPrePage.dart';
import 'package:glance_at/widgets/widget.dart';
import 'package:http/http.dart' as http;

class Categorie extends StatefulWidget {
  late final String categorieName;
  Categorie({required this.categorieName});

  @override
  _CategorieState createState() => _CategorieState();
}

class _CategorieState extends State<Categorie> {
  int page = 1;
  List<WallpaperModel> wallpapers = [];

  getSearchWallpapers(String query) async {
    print(query);
    var response = await http.get(
        Uri.parse(
            "https://api.pexels.com/v1/search?query=$query&per_page=40&page=$page"),
        headers: {"Authorization": apiKey});

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    List<WallpaperModel> tempWallpapers = [];
    jsonData["photos"].forEach((element) {
      print(element);
      WallpaperModel wallpaperModel = new WallpaperModel.fromMap(element);
      tempWallpapers.add(wallpaperModel);
    });
    setState(() {
      wallpapers = [...tempWallpapers];
    });
  }

  @override
  void initState() {
    getSearchWallpapers(widget.categorieName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: brandNameWithBackButton(),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 16),
              wallpapersList(wallpapers: wallpapers, context: context),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (page > 1) {
                          page -= 1;
                        } else {
                          page = page;
                        }
                      });
                      print(page);
                      getSearchWallpapers(widget.categorieName);
                    },
                    child: prePage(),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        page += 1;
                      });
                      getSearchWallpapers(widget.categorieName);
                    },
                    child: nextPage(),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
