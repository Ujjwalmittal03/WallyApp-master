import 'package:flutter/material.dart';
import 'package:wallyapp/pages/accountpage.dart';
import 'package:wallyapp/pages/explorepage.dart';
import 'package:wallyapp/pages/favoritespage.dart';
import 'package:wallyapp/pages/search_post.dart';
import 'chat_module/chat.dart';  // Import the FavoritesPage class


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPageIndex = 0;

  var _pages = [ExplorePage(), FavoritesPage(), AccountPage() , ChatScreen(), SearchPostScreen()];  // Include FavoritesPage in the list

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WallyApp"),

      ),
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Explore",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: "Favorites",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Account",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image_search_rounded),
            label: "Search",
          ),

        ],
        currentIndex: _selectedPageIndex,
        onTap: (index) {
          setState(() {
            _selectedPageIndex = index;
          });
        },
      ),
    );
  }
}
