import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:millionaire_game/app/core/extension/integer_extension.dart';

import '../../../core/values/app_colors.dart';

class ChartHelp extends StatefulWidget {
  const ChartHelp({super.key, required this.rightAnswer});

  final int rightAnswer;

  @override
  State<ChartHelp> createState() => _ChartHelpState();
}

class _ChartHelpState extends State<ChartHelp> {
  @override
  Widget build(BuildContext context) {
    final list = getByRightAnswer(widget.rightAnswer);
    return Container(
      padding: EdgeInsets.only(top: 24.h),
      child: AspectRatio(
        aspectRatio: 1.6,
        child: _BarChart(list),
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart(this.list);

  final List<AnswerToPercent> list;

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        backgroundColor: AppColors.colorFF1F2A48,
        maxY: 120,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          // tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: AppColors.colorFFf78f2b,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    String text;
    text = (value.toInt()).intToAnswer();
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  final style = const TextStyle(
    color: AppColors.colorFFf78f2b,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
      show: true,
      border: Border.all(
        color: AppColors.colorFFd1b037,
      ));

  LinearGradient _barsGradient(int i) {
    return LinearGradient(
      colors: i == 0
          ? [
              AppColors.colorFFd1b037,
              AppColors.colorFFf78f2b,
            ]
          : i == 1
              ? [
                  AppColors.colorFF57B9FB,
                  AppColors.colorFF03456e,
                ]
              : i == 2
                  ? [
                      AppColors.colorFF72F672,
                      AppColors.colorFF3CC03C,
                    ]
                  : [
                      AppColors.colorFF9BD7FF,
                      AppColors.colorFF5A8AAA,
                    ],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    );
  }

  List<BarChartGroupData> get barGroups {
    return List.generate(list.length, (index) {
      return BarChartGroupData(
        x: index + 1,
        barRods: [
          BarChartRodData(
            toY: list[index].percent.toDouble(),
            width: 24,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(1), topRight: Radius.circular(1)),
            gradient: _barsGradient(index),
          ),
        ],
        showingTooltipIndicators: [0],
      );
    });
  }
}

List<AnswerToPercent> getByRightAnswer(int rightAnswer) {
  final percentRightAnswer = Random().nextInt(50) + 45;
  final fail1 = Random().nextInt(100 - percentRightAnswer);
  final fail2 = Random().nextInt(100 - percentRightAnswer - fail1);
  final fail3 = 100 - percentRightAnswer - fail1 - fail2;
  switch (rightAnswer) {
    case 1:
      return [
        AnswerToPercent(answer: 'A', percent: percentRightAnswer),
        AnswerToPercent(answer: 'B', percent: fail1),
        AnswerToPercent(answer: 'C', percent: fail2),
        AnswerToPercent(answer: 'D', percent: fail3),
      ];
    case 2:
      return [
        AnswerToPercent(answer: 'A', percent: fail1),
        AnswerToPercent(answer: 'B', percent: percentRightAnswer),
        AnswerToPercent(answer: 'C', percent: fail2),
        AnswerToPercent(answer: 'D', percent: fail3),
      ];
    case 3:
      return [
        AnswerToPercent(answer: 'A', percent: fail2),
        AnswerToPercent(answer: 'B', percent: fail1),
        AnswerToPercent(answer: 'C', percent: percentRightAnswer),
        AnswerToPercent(answer: 'D', percent: fail3),
      ];
    default:
      return [
        AnswerToPercent(answer: 'A', percent: fail3),
        AnswerToPercent(answer: 'B', percent: fail1),
        AnswerToPercent(answer: 'C', percent: fail2),
        AnswerToPercent(answer: 'D', percent: percentRightAnswer),
      ];
  }
}

class AnswerToPercent {
  String answer;
  int percent;
  AnswerToPercent({
    required this.answer,
    required this.percent,
  });
}
