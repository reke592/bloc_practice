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
  final String Function(T record) resolve;
  final Set<String> options;
  final Set<String> selected;

  /// test record for matched tag
  bool test(T record) => selected.contains(resolve(record));

  /// {@macro filter_tag_options}
  FilterTagOptions({
    required this.name,
    required this.options,
    required this.resolve,
    this.selected = const {},
  });

  FilterTagOptions<T> copyWith({
    String? name,
    String Function(T record)? resolve,
    Set<String>? options,
    Set<String>? selected,
  }) =>
      FilterTagOptions(
        name: name ?? this.name,
        options: options ?? this.options,
        resolve: resolve ?? this.resolve,
        selected: selected ?? this.selected,
      );

  FilterTagOptions<T> withSelected(Set<String> value) =>
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
    required Set<String> options,
    required String Function(T record) resolve,
  }) {
    if (tagOptions.containsKey(name)) {
      final current = tagOptions[name]!;
      final selected = Set<String>.from(current.selected)
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
  @protected
  FutureOr<List<T>> get filterReference;

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
    for (var record in await filterReference) {
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
  Future<void> applyFilter({
    String? searchText,
    String? Function()? sortBy,
    FilterSort? sortDirection,
  }) async {
    this.filterSearchText = searchText ?? this.filterSearchText;
    this.filterSortBy = sortBy != null ? sortBy() : this.filterSortBy;
    this.sortDirection = sortDirection ?? this.sortDirection;
    onApplyFilter(await filteredSorted());
  }

  /// change search text, calls [onApplyFilter] when notify is true.
  void setFilterSearchText(String value, {bool notify = false}) {
    if (notify) {
      applyFilter(searchText: value);
    } else {
      filterSearchText = value;
    }
  }

  /// update filter sort, calls [onApplyFilter] when notify is true.
  void setFilterSort(String? value, {bool notify = false}) {
    if (notify) {
      applyFilter(sortBy: () => value);
    } else {
      filterSortBy = value;
    }
  }

  /// update sort direction, calls [onApplyFilter] when notify is true.
  void setFilterSortDirection(FilterSort value, {bool notify = false}) {
    if (notify) {
      applyFilter(sortDirection: value);
    } else {
      sortDirection = value;
    }
  }

  /// update selected tag, calls [onApplyFilter] when notify is true.
  @Deprecated('use setSelectedFilter')
  void setSelectedTag({
    required String name,
    required Set<String> value,
    bool notify = false,
  }) {
    tagOptions[name] = tagOptions[name]!.copyWith(selected: value);
    if (notify) {
      applyFilter();
    }
  }

  /// update selected tag, calls [onApplyFilter] when notify is true.
  void setSelectedFilter({
    required String name,
    required String value,
    required bool selected,
    bool notify = false,
  }) {
    final tags = Set<String>.from(tagOptions[name]!.selected);
    if (selected) {
      tags.add(value);
    } else {
      tags.remove(value);
    }
    tagOptions[name] = tagOptions[name]!.copyWith(selected: tags);
    if (notify) {
      applyFilter();
    }
  }

  bool isSelectedTag(String name, String value) =>
      tagOptions[name]?.selected.contains(value) ?? false;
}
