import 'package:bloc_practice/src/common/mixins/filter_data_properties.dart';
import 'package:flutter/material.dart';

class FilteredResultsLabel extends StatelessWidget {
  final FilterDataProperties provider;
  final TextStyle? style;

  const FilteredResultsLabel({
    super.key,
    required this.provider,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      provider.toStringFilteredCount(),
      style: style ?? Theme.of(context).textTheme.bodySmall,
    );
  }
}
