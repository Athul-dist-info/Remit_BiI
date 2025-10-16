import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:remit_bi/model/barchart_grouping_model.dart';
import 'package:remit_bi/view/widgets/legend_widget.dart';

class StackedVerticalBarGraph extends StatefulWidget {
  final List<ChartDataModel> chartData;
  final List<String> legendItems;
  final List<Map<String, Color>> serviceColors;
  final double chartHeight;
  final Duration animationDuration;
  final Curve animationCurve;
  final String Function(double) valueFormatter;
  final String xAxisLabel;
  final String yAxisLabel;
  final bool filterByCategory;

  const StackedVerticalBarGraph({
    super.key,
    required this.chartData,
    required this.legendItems,
    required this.serviceColors,
    required this.valueFormatter,
    required this.xAxisLabel,
    required this.yAxisLabel,
    this.filterByCategory = false,
    this.chartHeight = 380,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.animationCurve = Curves.easeOutCubic,
  });

  @override
  State<StackedVerticalBarGraph> createState() =>
      _StackedVerticalBarGraphState();
}

class _StackedVerticalBarGraphState extends State<StackedVerticalBarGraph>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;
  bool _isAnimating = true;
  bool _allowLegendAnimate = true;
  List<String> selectedLegends = [];

  @override
  void initState() {
    super.initState();
    selectedLegends = List.from(widget.legendItems);
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

  void _toggleLegend(String legend) {
    _allowLegendAnimate = false;
    setState(() {
      if (selectedLegends.contains(legend)) {
        selectedLegends.remove(legend);
      } else {
        selectedLegends.add(legend);
      }
    });

    // Restart animation
    _isAnimating = true;
    _animationController.reset();
    _animationController.forward().then((_) {
      if (mounted) {
        setState(() {
          _isAnimating = false;
        });
      }
    });
  }

  Map<String, List<Map<String, dynamic>>> _processData() {
    Map<String, List<Map<String, dynamic>>> groupedData = {};

    for (var data in widget.chartData) {
      // Only include data for selected legends
      if (!selectedLegends.contains(data.categoryKey)) continue;
      if (!groupedData.containsKey(data.groupingKey)) {
        groupedData[data.groupingKey] = [];
      }

      groupedData[data.groupingKey]!.add({
        'category': data.categoryKey,
        'value': data.valueKey,
        'color':
            widget.serviceColors.firstWhere(
              (element) => element.containsKey(data.categoryKey),
              orElse: () => {data.categoryKey: Colors.grey},
            )[data.categoryKey],
      });
    }

    return groupedData;
  }

  List<BarChartGroupData> _createBarGroups(double animationValue) {
    final processedData = _processData();
    List<BarChartGroupData> barGroups = [];

    int index = 0;
    processedData.forEach((groupKey, categoryList) {
      // Create stacked segments with animation
      List<BarChartRodStackItem> stackItems = [];
      double currentY = 0;

      for (var categoryData in categoryList) {
        double value = categoryData['value'].toDouble();
        double animatedValue = value * animationValue;

        stackItems.add(
          BarChartRodStackItem(
            currentY,
            currentY + animatedValue,
            categoryData['color'],
          ),
        );
        currentY += animatedValue;
      }

      barGroups.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              fromY: 0,
              toY: currentY,
              color: Colors.transparent,
              width: 40,
              borderRadius: BorderRadius.zero,
              rodStackItems: stackItems,
            ),
          ],
        ),
      );
      index++;
    });

    return barGroups;
  }

  double _getMaxY() {
    final processedData = _processData();
    double maxY = 0;

    processedData.forEach((groupKey, categoryList) {
      double groupTotal = 0;
      for (var categoryData in categoryList) {
        groupTotal += categoryData['value'].toDouble();
      }
      if (groupTotal > maxY) {
        maxY = groupTotal;
      }
    });

    // If no data is selected, return a default value
    if (maxY == 0) return 10;

    double padding = maxY * 0.15;
    return maxY + padding;
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
    final processedData = _processData();
    final groupKeys = processedData.keys.toList();
    final maxY = _getMaxY();
    final interval = _getInterval();

    final hasData = processedData.isNotEmpty && selectedLegends.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          _isAnimating
              ? Padding(
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
              )
              : SizedBox(height: 25),

          if (!hasData && !_isAnimating)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  'No data to display. Select at least one category.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),

          // Chart
          if (hasData) ...[
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
                          AnimatedOpacity(
                            opacity:
                                !_allowLegendAnimate
                                    ? 1.0
                                    : _heightAnimation.value,
                            duration: const Duration(milliseconds: 300),
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: Text(
                                widget.yAxisLabel,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Container(
                            width: math.max(
                              groupKeys.length * 80.0,
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
                                    groupsSpace: 10,
                                    barTouchData: BarTouchData(
                                      enabled: !_isAnimating,
                                      touchTooltipData: BarTouchTooltipData(
                                        tooltipPadding: const EdgeInsets.all(8),
                                        tooltipMargin: 8,
                                        getTooltipItem: (
                                          group,
                                          groupIndex,
                                          rod,
                                          rodIndex,
                                        ) {
                                          if (groupIndex >= groupKeys.length) {
                                            return null;
                                          }

                                          String groupKey =
                                              groupKeys[groupIndex];
                                          final categoryList =
                                              processedData[groupKey]!;

                                          String tooltipText = '$groupKey\n';
                                          double total = 0;

                                          for (var categoryData
                                              in categoryList) {
                                            tooltipText +=
                                                '${categoryData['category']}: ${widget.valueFormatter(categoryData['value'])}\n';
                                            total += categoryData['value'];
                                          }
                                          tooltipText +=
                                              'Total: ${widget.valueFormatter(total)}';

                                          return BarTooltipItem(
                                            tooltipText,
                                            const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          );
                                        },
                                      ),
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
                                                index < groupKeys.length) {
                                              return AnimatedOpacity(
                                                opacity: _heightAnimation.value,
                                                duration: const Duration(
                                                  milliseconds: 300,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        top: 8,
                                                      ),
                                                  child: SizedBox(
                                                    width: 70,
                                                    child: Text(
                                                      groupKeys[index],
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
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
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                      ),
                                      rightTitles: const AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                        ),
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
                                      show: true,
                                      horizontalInterval: interval,
                                      verticalInterval: 1,
                                      drawHorizontalLine: true,
                                      drawVerticalLine: false,
                                      getDrawingHorizontalLine: (value) {
                                        return FlLine(
                                          color: Colors.grey.shade300
                                              .withOpacity(
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
                      opacity:
                          !_allowLegendAnimate ? 1.0 : _heightAnimation.value,
                      duration: const Duration(milliseconds: 300),
                      child: Padding(
                        padding: EdgeInsets.only(
                          // top: 10,
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
          const SizedBox(height: 24),

          // Legend
          AnimatedOpacity(
            opacity: !_allowLegendAnimate ? 1.0 : _heightAnimation.value,
            duration: Duration(
              milliseconds: widget.animationDuration.inMilliseconds ~/ 2,
            ),
            child: LegendWidget(
              legendItems: widget.legendItems,
              serviceColors: widget.serviceColors,
              filterable: widget.filterByCategory,
              selectedLegends: selectedLegends,
              onLegendToggled: _toggleLegend,
            ),
          ),
        ],
      ),
    );
  }
}
