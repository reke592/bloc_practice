import 'dart:async';

import 'package:flutter/foundation.dart';

enum FilterSort {
  ascending,
  descending,
}

/// {@template filter_tag_options}
/// tag selection for filters
/// {@endtemplate}
class FilterTagOptions<T> {
  final String name;
  final bool Function(T record, String tag) resolve;
  final List<String> options;
  final List<String> selected;

  /// test record for matched tag
  bool test(T record) {
    if (selected.isEmpty) return true;
    for (var tag in selected) {
      if (resolve(record, tag)) return true;
    }
    return false;
  }

  /// {@macro filter_tag_options}
  FilterTagOptions({
    required this.name,
    required this.options,
    required this.resolve,
    this.selected = const [],
  });

  FilterTagOptions<T> copyWith({
    String? name,
    bool Function(T record, String tag)? resolve,
    List<String>? options,
    List<String>? selected,
  }) =>
      FilterTagOptions(
        name: name ?? this.name,
        options: options ?? this.options,
        resolve: resolve ?? this.resolve,
        selected: selected ?? this.selected,
      );

  FilterTagOptions<T> withSelected(List<String> value) =>
      copyWith(selected: value);
}

/// Object mixin to enable list filtering options [FilterOptions]
///
/// abstract implementation of filtering to allow any kind of object to be a filter option controller.
mixin FilterDataProperties<T> on Object {
  int _totalRecords = 0;
  int _visibleRecords = 0;
  FilterSort sortDirection = FilterSort.ascending;

  /// {@template filter_search_text}
  /// filter resutls by text pattern
  /// {@endtemplate}
  String filterSearchText = '';

  /// {@template filter_sort_by}
  /// sort reference for results
  /// {@endtemplate}
  String? filterSortBy;

  /// {@template filter_tags}
  /// display tagged results
  /// {@endtemplate}
  List<String> filterActiveTags = [];

  /// {@template filter_sort_options}
  /// sort options
  /// {@endtemplate}
  late Map<String, int Function(T a, T b)> filterSortOptions =
      initialSortOptions();
  Map<String, int Function(T a, T b)> initialSortOptions();

  /// {@template filter_tag_options}
  /// tag options
  /// {@endtemplate}
  final Map<String, FilterTagOptions<T>> tagOptions = {};

  /// add or update tag options for filter options
  @protected
  void addTagOptions({
    required String name,
    required List<String> options,
    required bool Function(T record, String tag) resolve,
  }) {
    if (tagOptions.containsKey(name)) {
      final current = tagOptions[name]!;
      final selected = List<String>.from(current.selected)
        ..removeWhere((element) => !options.contains(element));
      tagOptions[name] = current.copyWith(
        options: options,
        resolve: resolve,
        selected: selected,
      );
    } else {
      tagOptions.putIfAbsent(
        name,
        () => FilterTagOptions(
          name: name,
          options: options,
          resolve: resolve,
        ),
      );
    }
  }

  /// remove existing filter tag options
  @protected
  void removeTagOptions(String name) {
    tagOptions.remove(name);
  }

  /// original result reference
  FutureOr<List<T>> _snapshot = Future.value([]);

  /// value to test for [searchPattern]
  @protected
  String forSearch(T record);

  /// search text hint regarding [forSearch]
  String get forSearchHint;

  /// on apply filter
  @protected
  void onApplyFilter(List<T> filtered);

  /// {@macro filter_search_text}
  RegExp get searchPattern => filterSearchText.isNotEmpty
      ? RegExp(
          filterSearchText,
          dotAll: false,
          caseSensitive: false,
        )
      : RegExp('.*', dotAll: true);

  /// filtered result visible vs total
  String toStringFilteredCount({
    String format = 'Displaying {count} of {total} records',
    String emptyListText = '',
  }) {
    return _totalRecords == 0
        ? emptyListText
        : format
            .replaceAll('{count}', '$_visibleRecords')
            .replaceAll('{total}', '$_totalRecords');
  }

  /// returns a method to run combined active tag test
  @protected
  bool Function(T record) testActiveTags() {
    final activeTags = tagOptions.values
        .where((element) => element.selected.isNotEmpty)
        .map((e) => e.test);
    return activeTags.isEmpty
        ? (T record) => true
        : (T record) =>
            activeTags.fold(true, (value, test) => value && test(record));
  }

  /// filtered output
  Stream<T> _filtered() async* {
    final pattern = searchPattern;
    final activeTags = testActiveTags();
    _totalRecords = 0;
    _visibleRecords = 0;
    for (var record in await _snapshot) {
      _totalRecords++;
      if (activeTags(record) && pattern.hasMatch(forSearch(record))) {
        _visibleRecords++;
        yield record;
      }
    }
  }

  /// filtered sorted results
  @protected
  Future<List<T>> filteredSorted() async {
    final result = await _filtered().toList();
    if (filterSortOptions.containsKey(filterSortBy)) {
      result.sort((a, b) => sortDirection == FilterSort.ascending
          ? filterSortOptions[filterSortBy]!(a, b)
          : filterSortOptions[filterSortBy]!(b, a));
    }
    return result;
  }

  /// update filter settings and call [onApplyFilter]
  @protected
  Future<void> applyFilter(
    FutureOr<List<T>> snapshot, {
    String? searchText,
    String? Function()? sortBy,
    FilterSort? sortDirection,
    List<String>? activeTags,
  }) async {
    _snapshot = snapshot;
    this.filterSearchText = searchText ?? this.filterSearchText;
    this.filterSortBy = sortBy != null ? sortBy() : this.filterSortBy;
    this.sortDirection = sortDirection ?? this.sortDirection;
    this.filterActiveTags = activeTags ?? this.filterActiveTags;
    onApplyFilter(await filteredSorted());
  }

  /// change search text, calls [onApplyFilter] when notify is true.
  void setFilterSearchText(String value, {bool notify = false}) {
    if (notify) {
      applyFilter(_snapshot, searchText: value);
    } else {
      filterSearchText = value;
    }
  }

  /// update filter sort, calls [onApplyFilter] when notify is true.
  void setFilterSort(String? value, {bool notify = false}) {
    if (notify) {
      applyFilter(_snapshot, sortBy: () => value);
    } else {
      filterSortBy = value;
    }
  }

  /// update sort direction, calls [onApplyFilter] when notify is true.
  void setFilterSortDirection(FilterSort value, {bool notify = false}) {
    if (notify) {
      applyFilter(_snapshot, sortDirection: value);
    } else {
      sortDirection = value;
    }
  }

  /// update selected tag, calls [onApplyFilter] when notify is true.
  void setSelectedTag({
    required String name,
    required List<String> value,
    bool notify = false,
  }) {
    tagOptions[name] = tagOptions[name]!.copyWith(selected: value);
    if (notify) {
      applyFilter(_snapshot);
    }
  }
}
