import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Search',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SearchPostScreen(),
    );
  }
}

class SearchPostScreen extends StatefulWidget {
  @override
  _SearchPostScreenState createState() => _SearchPostScreenState();
}

class _SearchPostScreenState extends State<SearchPostScreen> {
  final String apiKey = 'JsHXWbu2Ty28NQ14WVfp65dnrqBHFJXry9GsMi7sopJiV8dH2wgDfHJR';
  final TextEditingController _searchController = TextEditingController();
  List<String> _imageUrls = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search Images...',
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _fetchImages(_searchController.text);
              },
            ),
          ),
        ),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: _imageUrls.length,
        itemBuilder: (context, index) {
          return Image.network(
            _imageUrls[index],
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }

  Future<void> _fetchImages(String query) async {
    final String apiUrl =
        'https://api.pexels.com/v1/search?query=$query&per_page=10';

    final http.Response response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Authorization': apiKey},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> photos = data['photos'];

      setState(() {
        _imageUrls = photos.map<String>((photo) {
          return photo['src']['medium']; // Use 'medium' size image URL
        }).toList();
      });
    } else {
      throw Exception('Failed to load images');
    }
  }
}

