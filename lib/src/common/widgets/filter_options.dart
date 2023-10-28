import 'dart:async';

import 'package:bloc_practice/src/common/mixins/filter_data_properties.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';

class FilterOptions<T> extends StatefulWidget {
  final FilterDataProperties<T> provider;

  const FilterOptions({
    super.key,
    required this.provider,
  });

  @override
  State<FilterOptions<T>> createState() => _FilterOptionsState<T>();
}

class _FilterOptionsState<T> extends State<FilterOptions<T>> {
  Timer? _debouncer;
  late final TextEditingController _searchController;

  @override
  void initState() {
    _searchController =
        TextEditingController(text: widget.provider.filterSearchText);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            'Filter current results',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          // Text search
          textSearch(),
          const SizedBox(height: 20),
          // Sort options
          sortOptions(),
          const SizedBox(height: 10),
          // Visibility Tags
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Tags:'),
          ),
          tagsOption(),
        ],
      ),
    );
  }

  Widget textSearch() {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            label: const Text('Search'),
            hintText: widget.provider.forSearchHint,
          ),
          onChanged: (value) {
            _debouncer?.cancel();
            _debouncer = Timer(const Duration(milliseconds: 200), () {
              widget.provider.setFilterSearchText(value, notify: true);
            });
          },
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Tip: combine search results by using '|'.\neg. 'email|chart'",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  Widget sortOptions() {
    return Column(
      children: [
        DropdownMenu(
          initialSelection: widget.provider.filterSortBy ?? '',
          label: const Text('Sort By'),
          dropdownMenuEntries: [
            const DropdownMenuEntry(value: '', label: 'None'),
            for (var option in widget.provider.filterSortOptions.keys)
              DropdownMenuEntry(value: option, label: option)
          ],
          onSelected: (value) {
            widget.provider.setFilterSort(value, notify: true);
          },
        ),
        Builder(
          builder: (context) {
            return Column(
              children: [
                Row(
                  children: [
                    Radio(
                      value:
                          widget.provider.sortDirection == FilterSort.ascending,
                      groupValue: true,
                      onChanged: (value) {
                        widget.provider.setFilterSortDirection(
                          FilterSort.ascending,
                          notify: true,
                        );
                        (context as Element).markNeedsBuild();
                      },
                    ),
                    const Text('Ascending'),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: widget.provider.sortDirection ==
                          FilterSort.descending,
                      groupValue: true,
                      onChanged: (value) {
                        widget.provider.setFilterSortDirection(
                          FilterSort.descending,
                          notify: true,
                        );
                        (context as Element).markNeedsBuild();
                      },
                    ),
                    const Text('Descending'),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget tagsOption() {
    return Expanded(
      child: Builder(builder: (context) {
        final scroll = ScrollController();
        return Scrollbar(
          controller: scroll,
          thumbVisibility: true,
          thickness: 4,
          child: SingleChildScrollView(
            controller: scroll,
            child: Column(
              children: [
                for (var name in widget.provider.tagOptions.keys) ...[
                  const Divider(),
                  Text(name),
                  Builder(
                    builder: (context) {
                      return ChipsChoice.multiple(
                        wrapped: true,
                        alignment: WrapAlignment.center,
                        value: widget.provider.tagOptions[name]!.selected,
                        choiceItems: [
                          for (var option
                              in widget.provider.tagOptions[name]!.options)
                            C2Choice(
                              value: option,
                              label: option,
                            )
                        ],
                        onChanged: (value) {
                          widget.provider.setSelectedTag(
                            name: name,
                            value: value,
                            notify: true,
                          );
                          (context as Element).markNeedsBuild();
                        },
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }
}
