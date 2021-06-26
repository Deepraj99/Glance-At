import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:glance_at/data/data.dart';
import 'package:glance_at/model/categories_model.dart';
import 'package:glance_at/model/wallpaper_model.dart';
import 'package:glance_at/views/categories.dart';
import 'package:glance_at/views/search.dart';
import 'package:glance_at/widgets/widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  List<CategoriesModel> categories = [];
  List<WallpaperModel> wallpapers = [];
  TextEditingController searchController = new TextEditingController();
  getTrendingWallpapers() async {
    // "https://api.pexels.com/v1/curated?page=1&per_page=40"
    var API_URI =
        Uri.parse("https://api.pexels.com/v1/curated?page=1&per_page=200");
    var response = await http.get(API_URI, headers: {"Authorization": apiKey});

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    List<WallpaperModel> tempWallpapers = [];
    jsonData["photos"].forEach((element) {
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
    getTrendingWallpapers();
    categories = getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: brandName(),
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
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Search(
                                searchQuery: searchController.text,
                              ),
                            ));
                      },
                      child: Icon(Icons.search),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(
                height: 65,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  itemCount: categories.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    // wallpapers[index].src.portrait
                    return CategoriesTile(
                      title: categories[index].categoriesName,
                      imgUrl: categories[index].imgUrl,
                    );
                  },
                ),
              ),
              wallpapersList(wallpapers: wallpapers, context: context)
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesTile extends StatelessWidget {
  final String imgUrl, title;
  CategoriesTile({required this.title, required this.imgUrl});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Categorie(
                      categorieName: title.toLowerCase(),
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
        ),
        margin: EdgeInsets.only(right: 4),
        child: Stack(
          children: [
            Container(
              height: 50.0,
              width: 100.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(imgUrl, fit: BoxFit.cover),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
              height: 50,
              width: 100,
              alignment: Alignment.center,
              child: Text(
                title,
                style: GoogleFonts.robotoMono(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
