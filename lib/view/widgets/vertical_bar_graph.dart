import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class VerticalBarGraph extends StatefulWidget {
  final List<BarChartDataModel> chartData;
  final double chartHeight;
  final Duration animationDuration;
  final Curve animationCurve;
  final String Function(double) valueFormatter;
  final String xAxisLabel;
  final String yAxisLabel;
  final Color barColor;
  final double barWidth;
  final bool showGridLines;
  final bool showTooltips;

  const VerticalBarGraph({
    super.key,
    required this.chartData,
    required this.valueFormatter,
    required this.xAxisLabel,
    required this.yAxisLabel,
    this.chartHeight = 380,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.animationCurve = Curves.easeOutCubic,
    this.barColor = Colors.blue,
    this.barWidth = 40,
    this.showGridLines = true,
    this.showTooltips = true,
  });

  @override
  State<VerticalBarGraph> createState() => _VerticalBarGraphState();
}

class _VerticalBarGraphState extends State<VerticalBarGraph>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;
  bool _isAnimating = true;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _heightAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve,
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isAnimating = false;
        });
      }
    });

    // Start animation
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<BarChartGroupData> _createBarGroups(double animationValue) {
    List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < widget.chartData.length; i++) {
      final data = widget.chartData[i];
      final animatedValue = data.value * animationValue;

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              fromY: 0,
              toY: animatedValue,
              color: widget.barColor,
              width: widget.barWidth,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
              gradient: LinearGradient(
                colors: [widget.barColor.withOpacity(0.8), widget.barColor],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ],
        ),
      );
    }

    return barGroups;
  }

  double _getMaxY() {
    if (widget.chartData.isEmpty) return 100;

    double maxValue = widget.chartData
        .map((data) => data.value)
        .reduce((a, b) => math.max(a, b));

    // Add 15% padding to the top
    double padding = maxValue * 0.15;
    return maxValue + padding;
  }

  double _getInterval() {
    double maxY = _getMaxY();

    if (maxY <= 0) return 1;

    int magnitude = (math.log(maxY) / math.ln10).floor();
    double baseInterval = math.pow(10, magnitude).toDouble();

    if (maxY / baseInterval <= 2) {
      return baseInterval / 2;
    } else if (maxY / baseInterval <= 5) {
      return baseInterval;
    } else {
      return baseInterval * 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxY = _getMaxY();
    final interval = _getInterval();

    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          if (_isAnimating)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.animation, size: 16, color: Colors.blue),
                  SizedBox(width: 4),
                  Text(
                    'Loading chart...',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          // Chart
          SizedBox(
            height: widget.chartHeight,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            widget.yAxisLabel,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          width: math.max(
                            widget.chartData.length * 80.0,
                            MediaQuery.of(context).size.width - 32,
                          ),
                          padding: const EdgeInsets.only(right: 20),
                          child: AnimatedBuilder(
                            animation: _heightAnimation,
                            builder: (context, child) {
                              return BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceEvenly,
                                  maxY: maxY,
                                  groupsSpace: 20,
                                  barTouchData: BarTouchData(
                                    enabled:
                                        widget.showTooltips && !_isAnimating,
                                    touchTooltipData:
                                        widget.showTooltips
                                            ? BarTouchTooltipData(
                                              tooltipPadding:
                                                  const EdgeInsets.all(8),
                                              tooltipMargin: 8,
                                              getTooltipItem: (
                                                group,
                                                groupIndex,
                                                rod,
                                                rodIndex,
                                              ) {
                                                if (groupIndex >=
                                                    widget.chartData.length) {
                                                  return null;
                                                }

                                                final data =
                                                    widget
                                                        .chartData[groupIndex];
                                                String tooltipText =
                                                    '${data.label}\n';
                                                tooltipText += widget
                                                    .valueFormatter(data.value);

                                                return BarTooltipItem(
                                                  tooltipText,
                                                  const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                );
                                              },
                                            )
                                            : null,
                                  ),
                                  titlesData: FlTitlesData(
                                    show: true,
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (
                                          double value,
                                          TitleMeta meta,
                                        ) {
                                          int index = value.toInt();
                                          if (index >= 0 &&
                                              index < widget.chartData.length) {
                                            return AnimatedOpacity(
                                              opacity: _heightAnimation.value,
                                              duration: const Duration(
                                                milliseconds: 300,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 8,
                                                ),
                                                child: SizedBox(
                                                  width: 70,
                                                  child: Text(
                                                    widget
                                                        .chartData[index]
                                                        .label,
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                          return const SizedBox();
                                        },
                                        reservedSize: 60,
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (
                                          double value,
                                          TitleMeta meta,
                                        ) {
                                          return AnimatedOpacity(
                                            opacity: _heightAnimation.value,
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                right: 8,
                                              ),
                                              child: Text(
                                                widget.valueFormatter(value),
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        reservedSize: 45,
                                        interval: interval,
                                      ),
                                    ),
                                    topTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                  ),
                                  borderData: FlBorderData(
                                    show: true,
                                    border: Border(
                                      left: BorderSide(
                                        color: Colors.grey.shade400,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: Colors.grey.shade400,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  gridData: FlGridData(
                                    show: widget.showGridLines,
                                    horizontalInterval: interval,
                                    verticalInterval: 1,
                                    drawHorizontalLine: widget.showGridLines,
                                    drawVerticalLine: false,
                                    getDrawingHorizontalLine: (value) {
                                      return FlLine(
                                        color: Colors.grey.shade300.withOpacity(
                                          _heightAnimation.value,
                                        ),
                                        strokeWidth: 1,
                                        dashArray: [3, 3],
                                      );
                                    },
                                  ),
                                  barGroups: _createBarGroups(
                                    _heightAnimation.value,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _heightAnimation.value,
                    duration: const Duration(milliseconds: 300),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.sizeOf(context).width / 2,
                      ),
                      child: Text(
                        widget.xAxisLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BarChartDataModel {
  final String label;
  final double value;

  BarChartDataModel({required this.label, required this.value});
}





// Usage example:
/*
// Convert your REM5model list to chart data
List<BarChartDataModel> chartData = rem5List.map((model) {
  return model.toBarChartData(
    labelExtractor: (model) => model.nationality ?? 'Unknown',
    valueExtractor: (model) => model.totalFxAmt, // or any other field
  );
}).toList();

// Use the chart widget
VerticalBarGraph(
  chartData: chartData,
  xAxisLabel: 'Nationality',
  yAxisLabel: 'Total FX Amount',
  valueFormatter: ChartFormatters.formatToBillion,
  barColor: Colors.blue,
  chartHeight: 400,
)
*/