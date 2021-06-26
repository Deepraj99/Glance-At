import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:glance_at/data/data.dart';
import 'package:glance_at/model/wallpaper_model.dart';
import 'package:glance_at/widgets/widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  late final String searchQuery;
  Search({required this.searchQuery});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<WallpaperModel> wallpapers = [];
  TextEditingController searchController = new TextEditingController();

  getSearchWallpapers(String query) async {
    print(query);
    var response = await http.get(
        Uri.parse(
            "https://api.pexels.com/v1/search?query=$query&per_page=15&page=1"),
        headers: {"Authorization": apiKey});

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    List<WallpaperModel> tempWallpapers = [];
    jsonData["photos"].forEach((element) {
      print(element);
      // WallpaperModel wallpaperModel = new WallpaperModel();
      WallpaperModel wallpaperModel = new WallpaperModel.fromMap(element);
      tempWallpapers.add(wallpaperModel);
    });
    setState(() {
      wallpapers = [...tempWallpapers];
    });
  }

  @override
  void initState() {
    getSearchWallpapers(widget.searchQuery);
    super.initState();
    searchController.text = widget.searchQuery;
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
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Color(0xfff5f8fd),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: "Search wallpapers",
                          hintStyle: GoogleFonts.robotoMono(),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        getSearchWallpapers(searchController.text);
                      },
                      child: Icon(Icons.search),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              wallpapersList(wallpapers: wallpapers, context: context),
            ],
          ),
        ),
      ),
    );
  }
}
