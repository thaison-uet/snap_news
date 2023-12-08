import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:news_app/src/core/core.dart';

class LoadingView extends StatelessWidget {
  bool isVisible;

  LoadingView({Key? key, required this.isVisible}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Container(
          color: colorPrimaryOpacity20,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: Container(
            width: 52,
            height: 52,
            color: transparent,
            child: const LoadingIndicator(
                indicatorType: Indicator.ballTrianglePath,

                /// Required, The loading type of the widget
                colors: [colorPrimary],

                /// Optional, The color collections
                strokeWidth: 2,

                /// Optional, The stroke of the line, only applicable to widget which contains line
                backgroundColor: transparent,

                /// Optional, Background of the widget
                pathBackgroundColor: transparent

                /// Optional, the stroke backgroundColor
                ),
          )),
    );
  }
}
