import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trybapp/data/service_category_api.dart';
import 'package:trybapp/models/search_item.dart';
import 'package:trybapp/services/auth_service.dart';
import 'package:trybapp/services/log_manager.dart';
import 'package:trybapp/views/search_results.dart';
import 'package:trybapp/widgets/horizontal_list_view_item.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static final AppLog _log = LogManager.getLogger('DashboardPage');
  ScrollController _mainScrollController = ScrollController();
  TextEditingController _searchTextController = TextEditingController();

  bool _loading = false;

  ///constructor
  _DashboardPageState() {
    _allDataFuture = loadAllData();
    _recommendedDataFuture = loadRecommendedData();
    _popularDataFuture = loadPopularData();
  }

  ///Mimic load data
  List<HorizontalListViewItem> _allData = [];
  Future<List<HorizontalListViewItem>> _allDataFuture;
  int _currentPageAllData = 0, _limitAllData = 10;

  Future<List<HorizontalListViewItem>> loadAllData() async {
    var rng = Random();
    for (var i = _currentPageAllData; i < _currentPageAllData + _limitAllData; i++) {
      _allData.add(
        HorizontalListViewItem(
          rng.nextInt(9999).toString(),
          "Category" + rng.nextInt(9999).toString(),
          "https://i.pravatar.cc/300",
        ),
      );
    }
    _currentPageAllData += _limitAllData;
    return _allData;
  }

  List<HorizontalListViewItem> _recommendedData = [];
  Future<List<HorizontalListViewItem>> _recommendedDataFuture;
  int _currentPageRecommendedData = 0, _limitRecommendedData = 10;

  Future<List<HorizontalListViewItem>> loadRecommendedData() async {
    var rng = Random();
    for (var i = _currentPageRecommendedData; i < _currentPageRecommendedData + _limitRecommendedData; i++) {
      _recommendedData.add(HorizontalListViewItem(
        rng.nextInt(9999).toString(),
        "Category" + rng.nextInt(9999).toString(),
        "https://i.pravatar.cc/300",
      ));
    }
    _currentPageRecommendedData += _limitRecommendedData;
    return _recommendedData;
  }

  List<HorizontalListViewItem> _popularData = [];
  Future<List<HorizontalListViewItem>> _popularDataFuture;
  int _currentPagePopularData = 0, _limitPopularData = 10;

  Future<List<HorizontalListViewItem>> loadPopularData() async {
    var rng = Random();
    for (var i = _currentPagePopularData; i < _currentPagePopularData + _limitPopularData; i++) {
      _popularData.add(HorizontalListViewItem(
        rng.nextInt(9999).toString(),
        "Category" + rng.nextInt(9999).toString(),
        "https://i.pravatar.cc/300",
      ));
    }
    _currentPagePopularData += _limitPopularData;
    return _popularData;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(DashboardPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final double height = screenSize.height;
    final double width = screenSize.width;

    return ModalProgressHUD(
      progressIndicator: CircularProgressIndicator(
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      inAsyncCall: _loading,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            // When the child is tapped, show a snackbar.
            onTap: () {
              this._mainScrollController.animateTo(
                    0,
                    duration: Duration(milliseconds: 500),
                    curve: ElasticInOutCurve(),
                  );
            },
            behavior: HitTestBehavior.opaque,
            // The custom button
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300],
                      blurRadius: 20.0,
                      // has the effect of softening the shadow
                      spreadRadius: 10.0,
                      // has the effect of extending the shadow
                      offset: Offset(
                        0.0, // horizontal, move right 10
                        0.0, // vertical, move down 10
                      ),
                    )
                  ],
                ),
                child: TypeAheadField<SearchItem>(
                  suggestionsCallback: (pattern) async {
                    return await ServiceCategoryApi.instance.getSearchItems(pattern);
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      leading: Icon(Icons.filter_list),
                      title: Text(suggestion.title),
                      subtitle: Text(suggestion.subtitle),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SearchResultsPage(paramId: suggestion.id),
                      ),
                    );
                  },
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: _searchTextController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        suffixIcon: _searchTextController.text.isNotEmpty
                            ? GestureDetector(
                                child: Icon(Icons.cancel),
                                onTap: () {
                                  _searchTextController.text = "";
                                },
                              )
                            : Icon(Icons.search),
                        filled: true,
                        fillColor: Theme.of(context).backgroundColor,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              style: BorderStyle.none,
                              width: 0,
                            )),
                        hintText: "Search here"),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _mainScrollController,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(width / 20.0, 8, width / 20.0, 8),
                    child: Text(
                      "Hi " + AuthService.instance.currentGfbUser.displayName + ",",
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(width / 20.0, 8, width / 20.0, 8),
                    child: RichText(
                      text: TextSpan(
                          text: "What do you need help with",
                          children: [
                            TextSpan(text: "Today", style: Theme.of(context).primaryTextTheme.title),
                          ],
                          style: Theme.of(context).textTheme.title),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(width / 20.0, 8, width / 20.0, 8),
                    child: HorizontalListView(
                      height: height / 6.0,
                      onLoadMore: () {
                        this._allDataFuture = this.loadAllData();
                        setState(() {});
                      },
                      items: this._allDataFuture,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(width / 20.0, 8, width / 20.0, 8),
                    child: Text(
                      "Recommended for you",
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(width / 20.0, 8, width / 20.0, 8),
                    child: HorizontalListView(
                      height: height / 6.0,
                      onLoadMore: () {
                        this._recommendedDataFuture = this.loadRecommendedData();
                        setState(() {});
                      },
                      items: this._recommendedDataFuture,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(width / 20.0, 8, width / 20.0, 8),
                    child: Text(
                      "Popular in your area",
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(width / 20.0, 8, width / 20.0, 8),
                    child: HorizontalListView(
                      height: height / 6.0,
                      onLoadMore: () {
                        this._popularDataFuture = this.loadPopularData();
                        setState(() {});
                      },
                      items: this._popularDataFuture,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(width / 20.0, 8, width / 20.0, 8),
                    child: Text(
                      "Recommended to your friends",
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(
                          "Jason Bennet",
                          style: Theme.of(context).textTheme.display1,
                        ),
                        subtitle: Text(
                          "Financial Planner",
                          style: Theme.of(context).textTheme.display2,
                        ),
                        trailing: Container(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.heart,
                                ),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.timesCircle,
                                ),
                                onPressed: () {},
                              )
                            ],
                          ),
                        ),
                        leading: CachedNetworkImage(
                          imageUrl: "https://i.pravatar.cc/300",
                          imageBuilder: (context, imageProvider) => Container(
                            height: 60,
                            width: 60,
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
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ResultsPage {}
