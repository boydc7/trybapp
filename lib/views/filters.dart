import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class FiltersPage extends StatefulWidget {
  FiltersPage({Key key}) : super(key: key);

  @override
  _FiltersPageState createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> with TickerProviderStateMixin {
  bool _loading = false;
  TabController _sortController;
  TabController _ratingController;

  @override
  void initState() {
    super.initState();
    _sortController = TabController(length: 4, vsync: this);
    _ratingController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: CircularProgressIndicator(
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      inAsyncCall: _loading,
      child: Scaffold(
        appBar: AppBar(
            actions: [],
            title: Text(
              "Refine your search",
              style: TextStyle(color: Colors.black),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context, false),
            )),
        body: ListView(
          children: [
            Container(
                color: Colors.grey[300],
                child: ListTile(
                  title: Text(
                    "Sort by",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                )),
            TabBar(
              controller: _sortController,
              tabs: <Widget>[
                Text(
                  "Price",
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  "Store",
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  "Distance",
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  "Recommended",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            Container(
                color: Colors.grey[300],
                child: ListTile(
                  title: Text(
                    "Categories",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                )),
            ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(
                  "Category" + index.toString(),
                ));
              },
              shrinkWrap: true,
              primary: false,
              itemCount: 4,
            ),
            Container(
                color: Colors.grey[300],
                child: ListTile(
                  title: Text(
                    "Filter by",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                )),
            Text(
              "Within:",
              style: TextStyle(color: Colors.black),
            ),
            Slider(
              value: 50,
              onChanged: (value) {},
              max: 500,
              min: 1,
            ),
            Row(
              children: <Widget>[
                Text(
                  "Gender:",
                  style: TextStyle(color: Colors.black),
                ),
                FlatButton(
                    onPressed: () {},
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.radio_button_checked),
                        Text("Male"),
                      ],
                    )),
                FlatButton(
                    onPressed: () {},
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.radio_button_unchecked),
                        Text("Female"),
                      ],
                    )),
                FlatButton(
                    onPressed: () {},
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.radio_button_unchecked),
                        Text("Any"),
                      ],
                    )),
              ],
            ),
            Text(
              "Price:",
              style: TextStyle(color: Colors.black),
            ),
            RangeSlider(
              values: RangeValues(50, 1000),
              onChanged: (values) {},
              max: 5000,
              min: 0,
              labels: RangeLabels("0\$", "100\$"),
            ),
            TabBar(
              controller: _ratingController,
              tabs: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "All",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      "2+",
                      style: TextStyle(color: Colors.black),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 10,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 10,
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      "3+",
                      style: TextStyle(color: Colors.black),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 10,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 10,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 10,
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      "4+",
                      style: TextStyle(color: Colors.black),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 10,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 10,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 10,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 10,
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
