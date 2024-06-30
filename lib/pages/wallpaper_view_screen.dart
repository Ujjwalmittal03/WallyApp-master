 import 'package:cached_network_image/cached_network_image.dart';
 import 'package:cloud_firestore/cloud_firestore.dart';
 import 'package:firebase_auth/firebase_auth.dart';
 //import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
 import 'package:flutter/material.dart';
 import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
 //import 'package:share/share.dart';
import 'package:wallyapp/config/config.dart';
class WallpaperViewPage extends StatefulWidget {
  final DocumentSnapshot? data; // Make the data parameter nullable

  WallpaperViewPage({required this.data});

  @override
  _WallpaperViewPageState createState() => _WallpaperViewPageState();
}

class _WallpaperViewPageState extends State<WallpaperViewPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // List<dynamic>? tags = widget.data?["tags"]?.toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Container(
                child: Hero(
                  tag: widget.data?["wallpaperUrl"] ?? "defaultTag", // Use a default tag if url is null
                  child: CachedNetworkImage(
                    placeholder: (ctx, url) => Image(
                      image: AssetImage("assets/placeholder.jpg"),
                    ),
                    imageUrl: widget.data?["wallpaperUrl"] ?? "",
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),

                ),
              ),
              // if (tags != null)
              //   Container(
              //     margin: EdgeInsets.only(top: 20),
              //     child: Wrap(
              //       runSpacing: 10,
              //       spacing: 10,
              //       children: tags.map((tag) {
              //         return Chip(
              //           label: Text(tag ?? ""), // Provide a default empty string if tag is null
              //         );
              //       }).toList(),
              //     ),
              //   ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  children: [
                    MaterialButton(
                      child: Icon(Icons.file_download),
                      onPressed: _launchURL,
                    ),
                    MaterialButton(
                      child: Icon(Icons.favorite_border),
                      onPressed: _addToFavorite,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL() async {
    try {
      await launch(widget.data?["url"] ?? "", // Provide a default empty string if url is null
          customTabsOption: CustomTabsOption(toolbarColor: primaryColor));
    } catch (e) {
      print("Error launching URL: $e");
    }
  }

  void _addToFavorite() async {
    User? user = _auth.currentUser;

    if (user != null && widget.data != null) {
      String uid = user.uid;

      _db
          .collection("users")
          .doc(uid)
          .collection("favorites")
          .doc(widget.data!.id)
          .set((widget.data!.data() as Map<String, dynamic>?) ?? {}); // Provide an empty map if data is null
    }
  }
}