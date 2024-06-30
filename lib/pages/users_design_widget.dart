import 'package:flutter/material.dart';
import 'package:wallyapp/pages/user.dart';


class UsersDesignWidget extends StatefulWidget {
  Users? model;
  BuildContext? context;

  UsersDesignWidget({
    this.model,
    this.context, required String imageUrl,
});

  @override
  State<UsersDesignWidget> createState() => _UsersDesignWidgetState();
}

class _UsersDesignWidgetState extends State<UsersDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          height: 240,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.amberAccent,
                minRadius: 90.0,
                child: CircleAvatar(
                  radius: 80.0,
                  backgroundImage: NetworkImage(
                    widget.model!.userImage!,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Text(widget.model!.name!,
                style: TextStyle(
                  color: Colors.pink,
                  fontSize: 20,
                  fontFamily: "Bebas",
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                widget.model!.email!,
                style: TextStyle(
                  color: Colors.pink,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}