import 'package:trybapp/models/search_item.dart';
import 'package:trybapp/models/service_category.dart';

import 'base_api.dart';

class ServiceCategoryApi extends BaseApi {
  static final ServiceCategoryApi _instance = ServiceCategoryApi._internal();

  ServiceCategoryApi._internal();

  static ServiceCategoryApi get instance => _instance;

  Future<ServiceCategory> getServiceCategory(int id) async {
    // TODO: Populate
    return ServiceCategory(
      id: '123',
      name: 'House Sitter',
      imageUrl: '',
    );
  }

  Future<List<ServiceCategory>> getAllServiceCategories() async {
    return [
      ServiceCategory(
        id: '123',
        name: 'House Sitter',
        imageUrl: '',
      ),
      ServiceCategory(
        id: '456',
        name: 'Plumber',
        imageUrl: '',
      ),
    ];
  }

  Future<List<ServiceCategory>> getRecommendedServiceCategories() async {
    return getAllServiceCategories();
  }

  Future<List<ServiceCategory>> getPopularServiceCategories() async {
    return getAllServiceCategories();
  }

  Future<List<SearchItem>> getSearchItems(String query) async {
    List<SearchItem> allItems = [
      SearchItem(title: "Sample1", subtitle: "Item1", id: "i1"),
      SearchItem(title: "Sample2", subtitle: "Item2", id: "i2"),
      SearchItem(title: "Sample3", subtitle: "Item3", id: "i3"),
      SearchItem(title: "Sample4", subtitle: "Item4", id: "i4"),
    ];

    return allItems.where((el) {
      return el.title.toLowerCase().contains(query) || el.subtitle.toLowerCase().contains(query);
    }).toList();
  }
}
