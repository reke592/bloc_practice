import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

extension ShimmerEffect on Widget {
  Widget addShimmer(bool value) {
    if (value) {
      return Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Colors.grey.shade100,
        child: Container(
          color: Colors.grey.withAlpha(50),
          child: this,
        ),
      );
    } else {
      return this;
    }
  }
}
