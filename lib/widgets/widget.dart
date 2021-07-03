import 'package:flutter/material.dart';
import 'package:glance_at/model/wallpaper_model.dart';
import 'package:glance_at/views/image_view.dart';
import 'package:google_fonts/google_fonts.dart';

Widget brandName() {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Glance',
          style: GoogleFonts.lato(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        Text(
          'At',
          style: GoogleFonts.lato(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Colors.blue,
          ),
        ),
      ],
    ),
  );
}

Widget brandNameWithBackButton() {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Glance',
          style: GoogleFonts.lato(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Text(
          'At',
          style: GoogleFonts.lato(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.blue,
          ),
        ),
        SizedBox(width: 28.0),
      ],
    ),
  );
}

Widget wallpapersList({required List<WallpaperModel> wallpapers, context}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8),
    child: GridView.count(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 0.6,
      mainAxisSpacing: 6.0,
      crossAxisSpacing: 6.0,
      children: wallpapers.map((wallpaper) {
        return GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ImageView(
                            imgUrl: wallpaper.src.portrait,
                          )));
            },
            child: Hero(
              tag: wallpaper.src.portrait,
              child: Container(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(wallpaper.src.portrait,
                          fit: BoxFit.cover))),
            ),
          ),
        );
      }).toList(),
    ),
  );
}
