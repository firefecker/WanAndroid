import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/home_detail.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainMenu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Container(
      constraints: const BoxConstraints(maxHeight: 240.0),
      child: new ListView(
        padding: const EdgeInsets.only(left: 5.0),
        children: <Widget>[
          _buildListItem("Memories", Icons.camera, () {
            Navigator.of(context).push(new PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return new HomeDetail(title: "这是详情页");
                },
                transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                  return new FadeTransition(
                    opacity: animation,
                    child: new SlideTransition(position: new Tween<Offset>(
                      begin: const Offset(0.0, 1.0),
                      end: Offset.zero,
                    ).animate(animation), child: child),
                  );
                }
            ),);
          }),
          _buildListItem("Favourites", Icons.favorite, () {}),
          _buildListItem("Presents", Icons.card_giftcard, () {}),
          _buildListItem("Friends", Icons.people, () {}),
          _buildListItem("Achievement", FontAwesomeIcons.trophy, () {}),
        ],
      ),
    );
  }

  Widget _buildListItem(String title, IconData iconData, VoidCallback action) {
    final textStyle = new TextStyle(
        color: Colors.black54, fontSize: 18.0, fontWeight: FontWeight.w600);

    return new InkWell(
      onTap: action,
      child: new Padding(
        padding: const EdgeInsets.only(
            left: 10.0, right: 10.0, bottom: 5.0, top: 5.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Container(
              width: 35.0,
              height: 35.0,
              margin: const EdgeInsets.only(right: 10.0),
              decoration: new BoxDecoration(
                color: Colors.purple,
                borderRadius: new BorderRadius.circular(5.0),
              ),
              alignment: Alignment.center,
              child: new Icon(iconData, color: Colors.white, size: 24.0),
            ),
            new Text(title, style: textStyle),
            new Expanded(child: new Container()),
            new IconButton(
                icon: new Icon(Icons.chevron_right, color: Colors.black26),
                onPressed: action)
          ],
        ),
      ),
    );
  }

}