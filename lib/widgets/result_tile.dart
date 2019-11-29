import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ResultTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String superTitle;
  final String rating;
  final String trailingTitle;
  final String trailingSubtitle;
  final String imageUrl;

  final Function() onTap;

  ResultTile({
    this.title,
    this.onTap,
    this.subtitle,
    this.superTitle,
    this.rating,
    this.trailingTitle,
    this.trailingSubtitle,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final double height = screenSize.height;
    final double width = screenSize.width;
    return ListTile(
      onTap: this.onTap,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(this.superTitle != null ? this.superTitle : "", style: Theme.of(context).primaryTextTheme.display1),
          Text(
            this.title != null ? this.title : "",
            style: Theme.of(context).textTheme.display1,
          )
        ],
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(this.subtitle != null ? this.subtitle : "", style: Theme.of(context).textTheme.display2),
          this.rating != null
              ? Row(
                  children: <Widget>[
                    Text(this.rating, style: Theme.of(context).textTheme.display2),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: Theme.of(context).textTheme.display2.fontSize,
                    ),
                  ],
                )
              : Container()
        ],
      ),
      trailing: Container(
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            this.trailingTitle != null
                ? Text(
                    this.trailingTitle,
                  )
                : Container(),
            this.trailingSubtitle != null
                ? Text(
                    this.trailingSubtitle,
                  )
                : Container()
          ],
        ),
      ),
      leading: this.imageUrl != null
          ? CachedNetworkImage(
              imageUrl: this.imageUrl,
              imageBuilder: (context, imageProvider) => Container(
                height: width / 6,
                width: width / 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            )
          : null,
    );
  }
}
