import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:trybapp/data/service_category_api.dart';
import 'dart:async';

import 'package:trybapp/models/search_item.dart';
import 'package:trybapp/widgets/filters.dart';
import 'package:trybapp/widgets/result_tile.dart';

class SearchResultsPage extends StatefulWidget {
  SearchResultsPage({
    Key key,
    this.paramId,
  }) : super(key: key);

  final String paramId;

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  bool _loading = false;
  bool _isList = true;
  LocationData _currentLocation;
  var _location = Location();

  TextEditingController _searchTextController = TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(51.5074, 0.1278),
    zoom: 15,
  );

  @override
  void initState() {
    super.initState();
    // Platform messages may fail, so we use a try/catch PlatformException.
    _location.getLocation().then((newLocation) {
      _currentLocation = newLocation;
      setState(() {});
    });
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context, false),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  setState(() {
                    _isList = !_isList;
                  });
                },
                child: Text("Map"))
          ],
          title: Text(
            "Search Results",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Stack(
          children: <Widget>[
            _isList
                ? Container()
                : GoogleMap(
                    compassEnabled: true,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    mapType: MapType.normal,
                    initialCameraPosition: _currentLocation != null
                        ? CameraPosition(
                            target: LatLng(
                              _currentLocation.latitude,
                              _currentLocation.longitude,
                            ),
                            zoom: 15,
                          )
                        : _kGooglePlex,
                    onTap: (latlng) {
                      setState(() {});
                    },
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  // When the child is tapped, show a snackbar.
                  onTap: () {
//                  this._mainScrollController.animateTo(0,
//                      duration: Duration(milliseconds: 500),
//                      curve: ElasticInOutCurve());
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
                          ),
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
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(style: BorderStyle.none, width: 0)),
                              hintText: "Search here"),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: Filters(),
                ),
                _isList
                    ? Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: 50,
                          itemBuilder: (BuildContext context, int index) {
                            return ResultTile(
                              title: "Megan Stevens",
                              subtitle: "Personal Trainer",
                              imageUrl: "https://i.pravatar.cc/300",
                              rating: "4.5",
                              superTitle: "Top Rated",
                              trailingSubtitle: "Per Session",
                              trailingTitle: "\$120",
                              onTap: () {
                                print("tapped");
                              },
                            );
                          },
                        ),
                      )
                    : Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: FloatingActionButton.extended(
                                onPressed: () {},
                                backgroundColor: Colors.white,
                                icon: Icon(
                                  Icons.add,
                                  color: Theme.of(context).primaryColor,
                                ),
                                label: Text("Invite Contact",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    )),
                              ),
                            ),
                            Container(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        ResultTile(
                                          title: "Megan Stevens",
                                          subtitle: "Personal Trainer",
                                          imageUrl: "https://i.pravatar.cc/300",
                                          rating: "4.5",
                                          superTitle: "Top Rated",
                                          trailingSubtitle: "Per Session",
                                          trailingTitle: "\$120",
                                          onTap: () {
                                            print("tapped");
                                          },
                                        ),
                                        RaisedButton(
                                          child: Text(
                                            "Schedule Booking",
                                            style: TextStyle(color: Theme.of(context).backgroundColor),
                                          ),
                                          color: Theme.of(context).primaryColor,
                                          onPressed: () {},
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
