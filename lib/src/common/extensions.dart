import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

extension ShimmerEffect on Widget {
  Widget addShimmer(bool value) {
    if (value) {
      return Shimmer.fromColors(
        baseColor: Colors.transparent,
        highlightColor: Colors.grey.withOpacity(0.5),
        child: AbsorbPointer(
          absorbing: true,
          child: this,
        ),
      );
    } else {
      return this;
    }
  }
}
