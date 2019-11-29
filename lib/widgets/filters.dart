import 'package:flutter/material.dart';
import 'package:flutter_tags/tag.dart';
import 'package:overlay_container/overlay_container.dart';
import 'package:trybapp/models/search_filter.dart';
import 'package:trybapp/views/filters.dart';

class Filters extends StatefulWidget {
  Filters({
    Key key,
    this.onLoadMore,
    this.filters,
  }) : super(key: key);
  final List<SearchFilter> filters;
  final Function() onLoadMore;

  @override
  _FiltersState createState() {
    return _FiltersState();
  }
}

class _FiltersState extends State<Filters> {
  // ScrollController _controller = ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
  List<Widget> filterWidgets = [];
  List<SearchFilter> _filters = [];
  SearchFilter _selectedFilter;
  double _leftArrow = 0.0;

  @override
  void initState() {
    super.initState();
    loadData(true);
  }

  Future<void> loadData(bool reload) async {
    //Get all available filters
    if (reload) {
      this._filters = [];
      var categoryValue;
      var catFilters = widget.filters != null
          ? widget.filters.where(
              (el) {
                return el.id == "categoryFilter";
              },
            ).toList()
          : [];
      if (catFilters.isNotEmpty) {
        categoryValue = catFilters.first.value;
      }
      this._filters.add(
            SearchFilter(
              id: "categoryFilter",
              label: "Cat",
              type: "multiSelect",
              options: ["Cat1", "Cat2", "Cat3"],
              value: categoryValue,
              key: GlobalKey(debugLabel: "categoryFilter"),
            ),
          );

      var distanceValue;
      var distFilters = widget.filters != null
          ? widget.filters.where(
              (el) {
                return el.id == "distanceFilter";
              },
            ).toList()
          : [];
      if (distFilters.isNotEmpty) {
        distanceValue = distFilters.first.value;
      }
      this._filters.add(
            SearchFilter(
              id: "distanceFilter",
              label: "Dist",
              type: "sliderSelect",
              options: [0.0, 100.0],
              value: distanceValue,
              key: GlobalKey(debugLabel: "distanceFilter"),
            ),
          );

      var rateValue;
      var rateFilters = widget.filters != null
          ? widget.filters.where((el) {
              return el.id == "ratingFilter";
            }).toList()
          : [];
      if (rateFilters.isNotEmpty) {
        rateValue = rateFilters.first.value;
      }
      this._filters.add(
            SearchFilter(
              id: "ratingFilter",
              label: "Rate",
              type: "singleSelect",
              options: ["4 starts and up", "3 starts and up", "2 starts and up", "1 starts and up"],
              value: rateValue,
              key: GlobalKey(debugLabel: "ratingFilter"),
            ),
          );

      //Get Rest
      var otherFilters = widget.filters != null
          ? widget.filters.where(
              (el) {
                return el.id != "categoryFilter" && el.id != "distanceFilter" && el.id != "ratingFilter";
              },
            ).toList()
          : [];

      this._filters.add(
            SearchFilter(
              id: "moreFilter",
              label: "More" + (otherFilters.isNotEmpty ? ":" + otherFilters.length.toString() : ""),
              type: "other",
              options: [],
              value: widget.filters,
              key: GlobalKey(debugLabel: "moreFilter"),
            ),
          );
    }
    filterWidgets = _selectedFilter != null ? await getFilterItems(_selectedFilter) : [];
    setState(() {});
  }

  Future<List<Widget>> getFilterItems(SearchFilter filter) async {
    List<Widget> result = [];
    print("getFilterItems - " + filter.id);
    if (filter.id != null) {
      switch (filter.id) {
        case "categoryFilter":
          {
            List<String> values = filter.value != null ? filter.value : [];
            List<String> options = filter.options;
            options.forEach(
              (option) {
                result.add(
                  ListTile(
                    title: Text(option),
                    leading: Icon(values.contains(option) ? Icons.check_box : Icons.check_box_outline_blank),
                    onTap: () {
                      var index = _filters.indexOf(filter);
                      if (index >= 0 && index < _filters.length) {
                        if (values.contains(option)) {
                          values.remove(option);
                          _filters[index].value = values;
                        } else {
                          values.add(option);
                          _filters[index].value = values;
                        }
                        loadData(false);
                      }
                    },
                  ),
                );
              },
            );
          }
          break;
        case "distanceFilter":
          {
            double value = filter.value != null ? filter.value : 0.0;
            List<double> options = filter.options;
            result.add(
              ListTile(
                title: Text("Within (miles)"),
                subtitle: Slider(
                  value: value,
                  onChanged: (value) {
                    filter.value = value;
                    loadData(false);
                  },
                  max: options[1],
                  min: options[0],
                ),
              ),
            );
          }
          break;
        case "ratingFilter":
          {
            String value = filter.value != null ? filter.value : null;
            List<String> options = filter.options;

            options.forEach(
              (option) {
                result.add(
                  ListTile(
                    title: Text(option),
                    leading: Icon(
                      Icons.star,
                      color: option == value ? Colors.yellow : Colors.grey,
                    ),
                    onTap: () {
                      filter.value = option;
                      loadData(false);
                    },
                  ),
                );
              },
            );
          }
          break;
        case "moreFilter":
          {
            //This actually should not happen -> advanced filters
          }
          break;
      }
    }
    return result;
  }

  @override
  void deactivate() {
    _selectedFilter = null;
    super.deactivate();
  }

  double getLeftOffset(SearchFilter filter, List<SearchFilter> filters) {
    var index = filters.indexOf(filter);
    if (index >= 0 && filters[index].key != null) {
      final RenderBox box = filters[index].key.currentContext.findRenderObject();
      final center = box.localToGlobal(box.size.centerLeft(Offset.zero));

      return center.dx;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Tags(
          itemCount: this._filters.length,
          spacing: 8,
          itemBuilder: (int index) {
            return GestureDetector(
              onTap: () {
                if (this._filters[index] != _selectedFilter || _selectedFilter == null) {
                  if (this._filters[index].id == "moreFilter") {
                    _selectedFilter = null;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FiltersPage(),
                      ),
                    );
                  } else {
                    _selectedFilter = this._filters[index];
                    _leftArrow = getLeftOffset(_selectedFilter, this._filters);
                  }
                  loadData(false);
                }
              },
              child: ItemTags(
                index: index,
                key: this._filters[index].key,
                pressEnabled: false,
                active: true,
                removeButton: ItemTagsRemoveButton(
                  backgroundColor: Colors.transparent,
                ),
                onRemoved: () {
                  // Clear values
                  _selectedFilter.value = null;
                  _selectedFilter = null;
                  loadData(false);
                },
                color: Theme.of(context).primaryColorLight,
                textColor: Colors.white,
                elevation: 0,
                activeColor: Theme.of(context).primaryColor,
                highlightColor: Theme.of(context).primaryColor,
                splashColor: Theme.of(context).primaryColor,
                textActiveColor: Colors.white,
                title: this._filters[index].label,
                customData: this._filters[index],
              ),
            );
          },
        ),
        _selectedFilter != null
            ? Container(
                height: 10,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      child: Icon(
                        Icons.arrow_drop_up,
                        color: Theme.of(context).primaryColor,
                        size: 50,
                      ),
                      left: _leftArrow,
                      top: -18,
                    ),
                  ],
                ),
              )
            : Container(),
        OverlayContainer(
          show: _selectedFilter != null,
          position: OverlayContainerPosition(
            0,
            0,
          ),
          asWideAsParent: true,
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Theme.of(context).primaryColor,
                  blurRadius: 0,
                  spreadRadius: 2,
                )
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              primary: true,
              itemBuilder: (context, index) {
                return filterWidgets[index];
              },
              itemCount: filterWidgets.length,
            ),
          ),
        ),
      ],
    );
  }
}
