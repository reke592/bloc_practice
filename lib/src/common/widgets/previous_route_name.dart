import 'package:bloc_practice/src/common/observers/previous_route_observer.dart';
import 'package:flutter/material.dart';

class PreviousRouteName extends StatelessWidget {
  final TextStyle? textStyle;
  const PreviousRouteName({
    super.key,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final name = PreviousRouteObserver.value?.settings.name;
    return name != null
        ? Text(
            'Back to $name',
            style: textStyle ?? Theme.of(context).textTheme.bodySmall,
          )
        : Container();
  }
}
