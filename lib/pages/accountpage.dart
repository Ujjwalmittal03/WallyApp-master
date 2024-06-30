import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wallyapp/config/config.dart';
import 'package:wallyapp/pages/wallpaper_view_screen.dart';
//import 'add_wallpaper_screen.dart';



class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  final _db = FirebaseFirestore.instance;

  @override
  void initState() {
    _fetchUserData();
    super.initState();
  }

  Future<void> _fetchUserData() async {
    User? user = _auth.currentUser;
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: _user != null
            ? Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: FadeInImage(
                width: 200,
                height: 200,
                image: _user?.photoURL != null
                    ? NetworkImage("${_user!.photoURL}")
                    : NetworkImage("URL_TO_YOUR_PLACEHOLDER_IMAGE"),
                fit: BoxFit.cover,
                placeholder:
                AssetImage("assets/placeholder-image.png"), // Replace with your placeholder image asset
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text("${_user?.displayName ?? ''}"),
            SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: () {
                _auth.signOut();
              },
              child: Text("Logout"),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("My Wallpapers"),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => AddWallpaperScreen(),
                      //       fullscreenDialog: true,
                      //     ));
                    },
                  ),
                ],
              ),
            ),
            StreamBuilder(
              stream: _db
                  .collection("wallpapers")
                  .snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isNotEmpty) {
                    return GridView.builder(
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (ctx, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WallpaperViewPage(
                                  data: snapshot.data!.docs[index],
                                ),
                              ),
                            );
                          },
                          child: Stack(
                            children: <Widget>[
                              Image.network(
                                snapshot.data!.docs[index].get("wallpaperUrl"),
                                fit: BoxFit.cover,
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(18),
                                        ),
                                        title: Text("Confirmation"),
                                        content: Text(
                                            "Are you sure, you want to delete this wallpaper?"),
                                        actions: <Widget>[
                                          MaterialButton(
                                            child: Text("Cancel"),
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                          ),
                                          MaterialButton(
                                            child: Text("DELETE"),
                                            onPressed: () {
                                              _db
                                                  .collection("wallpapers")
                                                  .doc(snapshot
                                                  .data!
                                                  .docs[index]
                                                  .id)
                                                  .delete();
                                              Navigator.of(ctx).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Text("Upload wallpapers to see here...");
                  }
                }
                return Center(
                  child: SpinKitChasingDots(
                    color: primaryColor,
                    size: 50,
                  ),
                );
              },
            ),
            SizedBox(
              height: 80,
            ),
          ],
        )
            : Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}












