import 'package:flutter/material.dart';

class SearchFilter {
  GlobalKey key;
  String id;
  String label;
  String type;
  dynamic options;
  dynamic value;

  SearchFilter({
    this.id,
    this.label,
    this.type,
    this.value,
    this.options,
    this.key,
  });
}
