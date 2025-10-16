import 'dart:math';
import 'package:flutter/material.dart';
import 'package:remit_bi/core/helper_methods.dart';
import 'package:remit_bi/model/barchart_grouping_model.dart';
import 'package:remit_bi/view/widgets/legend_widget.dart';

class CustomHorizontalBarChart extends StatefulWidget {
  final List<ChartDataModel> chartData;
  final List<String> legendItems;
  final List<Map<String, Color>> serviceColors;
  final String yAxisLabel;
  final String xAxisLabel;
  final bool sortByMonth;
  final bool filterByCategory;
  final Duration animationDuration;
  final Curve animationCurve;

  const CustomHorizontalBarChart({
    super.key,
    required this.chartData,
    required this.serviceColors,
    required this.legendItems,
    this.yAxisLabel = '',
    this.xAxisLabel = '',
    this.sortByMonth = false,
    this.filterByCategory = false,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.animationCurve = Curves.easeOutCubic,
  });

  @override
  State<CustomHorizontalBarChart> createState() =>
      _CustomHorizontalBarChartState();
}

class _CustomHorizontalBarChartState extends State<CustomHorizontalBarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _widthAnimation;
  late double maxValue;
  late List<String> groupingKeys;
  bool _isAnimating = true;

  bool _allowLegendAnimate = true;
  List<String> selectedLegends = [];

  @override
  void initState() {
    super.initState();
    selectedLegends = List.from(widget.legendItems);
    groupingKeys = _getUniqueGroupingKeys();
    maxValue = _getMaxValue();
    _setupAnimation();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _widthAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
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
      // Recalculate max value based on filtered data
      maxValue = _getMaxValue();

      _isAnimating = true;
      _animationController.reset();
      _animationController.forward().then((_) {
        if (mounted) {
          setState(() {
            _isAnimating = false;
          });
        }
      });
    });
  }

  List<String> _getUniqueGroupingKeys() {
    final keys =
        widget.chartData.map((data) => data.groupingKey).toSet().toList();

    if (widget.sortByMonth) {
      keys.sort((a, b) {
        final aParts = a.split(" "); // ["Jan", "2022"]
        final bParts = b.split(" "); // ["Feb", "2022"]

        if (aParts.length < 2 || bParts.length < 2) return b.compareTo(a);

        final aYear = int.tryParse(aParts[1]) ?? 0;
        final bYear = int.tryParse(bParts[1]) ?? 0;

        final aMonth = HelperMethods.monthNameToNumber(aParts[0]);
        final bMonth = HelperMethods.monthNameToNumber(bParts[0]);

        if (aYear != bYear) return bYear.compareTo(aYear);
        return bMonth.compareTo(aMonth);
      });
    } else {
      keys.sort((a, b) => a.compareTo(b));
    }

    return keys;
  }

  double _getMaxValue() {
    if (widget.chartData.isEmpty) return 50;

    final groupedData = groupDataByKey();
    double maxValue = 0;

    for (var groupData in groupedData.values) {
      double groupTotal = 0;
      for (var data in groupData) {
        // Only include data for selected legends
        if (selectedLegends.contains(data.categoryKey)) {
          groupTotal += data.valueKey;
        }
      }
      if (groupTotal > maxValue) {
        maxValue = groupTotal;
      }
    }

    // If no data is selected, return a default value
    if (maxValue == 0) return 50;

    // Round up to a reasonable interval
    if (maxValue <= 10) return 10;
    if (maxValue <= 50) return 50;
    if (maxValue <= 100) return 100;
    if (maxValue <= 500) return 500;
    return (maxValue / 1000).ceil() * 1000;
  }

  Map<String, List<ChartDataModel>> groupDataByKey() {
    Map<String, List<ChartDataModel>> groupedData = {};

    for (var data in widget.chartData) {
      if (!selectedLegends.contains(data.categoryKey)) continue;

      final groupKey = data.groupingKey;

      if (!groupedData.containsKey(groupKey)) {
        groupedData[groupKey] = [];
      }
      groupedData[groupKey]!.add(data);
    }

    return groupedData;
  }

  String _formatValue(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)}K';
    }
    return value.toStringAsFixed(0);
  }

  ChartRange _calculateChartRange() {
    if (widget.chartData.isEmpty) return ChartRange(0, 100);

    double minValue = double.infinity;
    double maxValue = 0;

    final groupedData = groupDataByKey();

    for (var groupData in groupedData.values) {
      double groupTotal = 0;
      for (var data in groupData) {
        groupTotal += data.valueKey;
      }

      if (groupTotal < minValue) minValue = groupTotal;
      if (groupTotal > maxValue) maxValue = groupTotal;
    }

    final paddedMax = maxValue * 1.1;
    return ChartRange(minValue, paddedMax);
  }

  double _calculateGridInterval(double maxValue) {
    if (maxValue <= 0) return 10;

    final magnitude = pow(10, (log(maxValue) / ln10).floor()).toDouble();
    final normalized = maxValue / magnitude;

    if (normalized <= 1) return magnitude * 0.2;
    if (normalized <= 2) return magnitude * 0.5;
    if (normalized <= 5) return magnitude * 1.0;
    if (normalized <= 10) return magnitude * 2.0;
    if (normalized <= 20) return magnitude * 5.0;
    if (normalized <= 50) return magnitude * 10.0;
    if (normalized <= 100) return magnitude * 20.0;
    if (normalized <= 200) return magnitude * 50.0;
    if (normalized <= 500) return magnitude * 100.0;
    return magnitude * 200.0;
  }

  String _formatAxisLabel(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)}K';
    }
    if (value % 1 == 0) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final groupedData = groupDataByKey();
    final availableWidth = MediaQuery.of(context).size.width * 0.6;

    final chartRange = _calculateChartRange();
    final gridInterval = _calculateGridInterval(chartRange.max);
    final displayMax = (chartRange.max / gridInterval).ceil() * gridInterval;
    final gridIntervals = (displayMax / gridInterval).ceil();
    final gridIntervalWidth = availableWidth / gridIntervals;

    final chartHeight = groupingKeys.length * 35.0;

    final hasData = groupedData.isNotEmpty && selectedLegends.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // loading indicator
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
        if (hasData) ...[
          AnimatedBuilder(
            animation: _widthAnimation,
            builder: (context, child) {
              return SizedBox(
                height: chartHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.yAxisLabel.isNotEmpty) ...[
                      Center(
                        child: AnimatedOpacity(
                          opacity: _widthAnimation.value,
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
                      ),
                      const SizedBox(width: 20),
                    ],
                    // Y-axis labels (grouping keys)
                    SizedBox(
                      width: 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children:
                            groupingKeys.map((groupKey) {
                              return SizedBox(
                                height: 30,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: AnimatedOpacity(
                                    opacity: _widthAnimation.value,
                                    duration: const Duration(milliseconds: 300),
                                    child: Text(
                                      groupKey,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.right,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Chart area
                    Expanded(
                      child: Stack(
                        children: [
                          // Grid lines
                          Positioned.fill(
                            child: CustomPaint(
                              painter: AnimatedGridLinePainter(
                                gridIntervalWidth: gridIntervalWidth,
                                gridIntervals: gridIntervals,
                                animationValue: _widthAnimation.value,
                              ),
                            ),
                          ),

                          // Bars
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children:
                                groupingKeys.map((groupKey) {
                                  final groupData = groupedData[groupKey] ?? [];

                                  if (groupData.isEmpty) {
                                    return Container(height: 30);
                                  }

                                  // Calculate category data
                                  final categoryData = <String, double>{};
                                  for (var data in groupData) {
                                    categoryData[data.categoryKey] =
                                        (categoryData[data.categoryKey] ?? 0) +
                                        data.valueKey;
                                  }

                                  final totalCount = categoryData.values.fold(
                                    0.0,
                                    (sum, value) => sum + value,
                                  );
                                  final fullBarWidth =
                                      (totalCount / displayMax) *
                                      availableWidth;
                                  final animatedBarWidth =
                                      fullBarWidth * _widthAnimation.value;

                                  return Container(
                                    height: 30,
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 2.5,
                                    ),
                                    child: Stack(
                                      children: [
                                        // Stacked segments with animation
                                        Row(
                                          children: _buildAnimatedSegments(
                                            categoryData,
                                            animatedBarWidth,
                                          ),
                                        ),

                                        // Tap detector for tooltip (disabled during animation)
                                        if (!_isAnimating)
                                          GestureDetector(
                                            onTap: () {
                                              _showTooltip(
                                                context,
                                                groupKey,
                                                categoryData,
                                                totalCount,
                                              );
                                            },
                                            child: Container(
                                              width: availableWidth,
                                              height: 30,
                                              color: Colors.transparent,
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // X-axis labels
          AnimatedBuilder(
            animation: _widthAnimation,
            builder: (context, child) {
              return Container(
                margin: const EdgeInsets.only(left: 108, top: 10),
                height: 20,
                width: availableWidth,
                child: Stack(
                  children: [
                    for (int i = 0; i <= gridIntervals; i++)
                      Positioned(
                        left: i * gridIntervalWidth - 20,
                        child: SizedBox(
                          width: 40,
                          child: Center(
                            child: AnimatedOpacity(
                              opacity: _widthAnimation.value,
                              duration: const Duration(milliseconds: 300),
                              child: Text(
                                _formatAxisLabel(i * gridInterval),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),

          AnimatedOpacity(
            opacity: _widthAnimation.value,
            duration: const Duration(milliseconds: 300),
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  right: MediaQuery.sizeOf(context).width / 4,
                ),
                child: Text(
                  widget.xAxisLabel,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],

        const SizedBox(height: 40),

        // Legend
        AnimatedOpacity(
          opacity: !_allowLegendAnimate ? 1.0 : _widthAnimation.value,
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
    );
  }

  List<Widget> _buildAnimatedSegments(
    Map<String, double> categoryData,
    double animatedBarWidth,
  ) {
    List<Widget> segments = [];
    double currentWidth = 0;

    // Filter categoryData to only include selected legends
    final filteredCategoryData = Map<String, double>.from(categoryData)
      ..removeWhere((category, value) => !selectedLegends.contains(category));

    // Calculate the TOTAL of ONLY the filtered categories
    final filteredTotalCount = filteredCategoryData.values.fold(
      0.0,
      (sum, value) => sum + value,
    );

    if (filteredTotalCount == 0) return segments;

    for (var entry in filteredCategoryData.entries) {
      final category = entry.key;
      final value = entry.value;

      // Calculate width based on FILTERED total
      final segmentFullWidth = (value / filteredTotalCount) * animatedBarWidth;

      segments.add(
        AnimatedContainer(
          duration: Duration(milliseconds: 50),
          width: segmentFullWidth,
          height: 30,
          color: _getColorForCategory(category),
          child:
              segmentFullWidth > 40
                  ? Center(
                    child: Text(
                      _formatValue(value),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                  : null,
        ),
      );

      currentWidth += segmentFullWidth;
    }

    return segments;
  }

  Color _getColorForCategory(String category) {
    try {
      return widget.serviceColors.firstWhere(
        (element) => element.containsKey(category),
      )[category]!;
    } catch (e) {
      return Colors.blue;
    }
  }

  void _showTooltip(
    BuildContext context,
    String groupKey,
    Map<String, double> categoryData,
    double totalCount,
  ) {
    String tooltipText = '$groupKey - Total: ${_formatValue(totalCount)}\n';
    categoryData.forEach((category, value) {
      tooltipText += '$category: ${_formatValue(value)}\n';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(tooltipText),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.black87,
      ),
    );
  }
}

class AnimatedGridLinePainter extends CustomPainter {
  final double gridIntervalWidth;
  final int gridIntervals;
  final double animationValue;

  AnimatedGridLinePainter({
    required this.gridIntervalWidth,
    required this.gridIntervals,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.grey[300]!.withOpacity(animationValue)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;

    for (int i = 0; i <= gridIntervals; i++) {
      final x = i * gridIntervalWidth;
      const double dashHeight = 4;
      const double dashSpace = 3;
      double startY = 0;

      while (startY < size.height) {
        canvas.drawLine(
          Offset(x, startY),
          Offset(x, startY + dashHeight),
          paint,
        );
        startY += dashHeight + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant AnimatedGridLinePainter oldDelegate) {
    return oldDelegate.gridIntervalWidth != gridIntervalWidth ||
        oldDelegate.gridIntervals != gridIntervals ||
        oldDelegate.animationValue != animationValue;
  }
}

class ChartRange {
  final double min;
  final double max;

  ChartRange(this.min, this.max);
}
