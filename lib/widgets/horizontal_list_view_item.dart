import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HorizontalListViewItem {
  final String title;
  final String subtitle;
  final String imageUrl;

  const HorizontalListViewItem(this.title, this.subtitle, this.imageUrl);
}

class HorizontalListView extends StatefulWidget {
  HorizontalListView({
    Key key,
    this.height,
    this.items,
    this.onLoadMore,
  }) : super(key: key);

  final double height;
  final Function() onLoadMore;
  final Future<List<HorizontalListViewItem>> items;

  @override
  _HorizontalListViewState createState() {
    return _HorizontalListViewState();
  }
}

class _HorizontalListViewState extends State<HorizontalListView> {
  ScrollController _controller = ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      var isEnd = _controller.offset == _controller.position.maxScrollExtent;

      if (isEnd) {
        widget.onLoadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: FutureBuilder(
        future: widget.items,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<HorizontalListViewItem> loaded = snapshot.data;
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: loaded.length,
              controller: _controller,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            loaded[index].imageUrl,
                          ),
                        )),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              color: Theme.of(context).backgroundColor,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    loaded[index].title,
                                    style: Theme.of(context).textTheme.display1,
                                  ),
                                  Text(
                                    loaded[index].subtitle,
                                    style: Theme.of(context).textTheme.display2,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  height: widget.height * 0.98,
                  width: widget.height * 0.98,
                );
              },
            );
          }
          return LinearProgressIndicator();
        },
      ),
    );
  }
}
