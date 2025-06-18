import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingIndicator extends StatelessWidget {
  final String? message;
  final bool useShimmer;

  const LoadingIndicator({
    super.key,
    this.message,
    this.useShimmer = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        ),
        if (message != null)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              message!,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );

    if (useShimmer) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: content,
      );
    }

    return Center(child: content);
  }
}

class ShimmerLoadingList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  const ShimmerLoadingList({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: itemCount,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: itemHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        },
      ),
    );
  }
}
