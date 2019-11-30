import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_tags/tag.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:trybapp/data/service_category_api.dart';
import 'package:trybapp/models/search_item.dart';
import 'package:trybapp/services/log_manager.dart';
import 'package:trybapp/views/search_results.dart';
import 'package:url_launcher/url_launcher.dart';

class MyTrybPage extends StatefulWidget {
  @override
  _MyTrybPageState createState() => _MyTrybPageState();
}

class _MyTrybPageState extends State<MyTrybPage> {
  static final AppLog _log = LogManager.getLogger('MyTrybPage');
  ScrollController _mainScrollController = ScrollController();
  TextEditingController _searchTextController = TextEditingController();

  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  _callNumber(String number) async {
    var url = 'tel:' + number;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _sendSms(String number) async {
    var url = 'sms:' + number;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final double height = screenSize.height;

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
                            borderSide: BorderSide(style: BorderStyle.none, width: 0)),
                        hintText: "Search here"),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _mainScrollController,
              itemCount: 12,
              itemBuilder: (context, index) {
                GlobalKey _slidableDismissKey = GlobalKey();
                return Slidable(
                  key: _slidableDismissKey,
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  dismissal: SlidableDismissal(
                    child: SlidableDrawerDismissal(),
                    onDismissed: (actionType) {
                      setState(
                        () {
                          if (actionType == SlideActionType.secondary) {
                            _callNumber("+421905095");
                          } else {
                            print("schedule");
                          }
                        },
                      );
                    },
                  ),
                  actions: <Widget>[
                    IconSlideAction(
                      caption: 'Schedule',
                      color: Theme.of(context).accentColor,
                      icon: Icons.calendar_today,
                      onTap: () {
                        print("schedule");
                      },
                    ),
                  ],
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Call Now',
                      color: Theme.of(context).accentColor,
                      icon: Icons.call,
                      onTap: () {
                        _callNumber("+421905905");
                      },
                    ),
                  ],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ListTile(
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
                        title: Container(
                          height: height / 20.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text("First Name, Last Name", style: Theme.of(context).textTheme.display1),
                              Text("Job Category", style: Theme.of(context).textTheme.display2),
                            ],
                          ),
                        ),
                        trailing: Container(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.message),
                                onPressed: () {
                                  _sendSms("+421905905");
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.call),
                                onPressed: () {
                                  _callNumber("+421905905");
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(85, 0, 0, 0),
                        child: Tags(
                          itemCount: 3,
                          spacing: 2,
                          horizontalScroll: true,
                          itemBuilder: (int index) {
                            return ItemTags(
                              index: index,
                              textScaleFactor: 0.9,
                              active: true,
                              onPressed: (item) {
                                setState(
                                  () {},
                                );
                              },
                              onRemoved: () {
                                setState(
                                  () {},
                                );
                              },
                              elevation: 0,
                              activeColor: Theme.of(context).primaryColor,
                              highlightColor: Theme.of(context).primaryColor,
                              splashColor: Theme.of(context).primaryColor,
                              title: "tag - " + index.toString(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
