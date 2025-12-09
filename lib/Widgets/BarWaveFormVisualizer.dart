import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class BarWaveformVisualizer extends StatelessWidget {
  final RxList<double> waveformData;
  final double height;
  final Color barColor;
  final Color backgroundColor;
  final int maxBars;

  const BarWaveformVisualizer({
    Key? key,
    required this.waveformData,
    this.height = 60,
    this.barColor = Colors.blue,
    this.backgroundColor = Colors.transparent,
    this.maxBars = 30,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: backgroundColor,
      child: Obx(() {
        if (waveformData.isEmpty) {
          return SizedBox.shrink();
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(
            waveformData.length.clamp(0, maxBars),
            (index) {
              final amplitude = waveformData[index];
              final barHeight = amplitude * height;
              
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 2),
                width: 3,
                height: barHeight > 0 ? barHeight : 2,
                decoration: BoxDecoration(
                  color: barColor.withOpacity(0.7 + (amplitude * 0.3)),
                  borderRadius: BorderRadius.circular(1.5),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
