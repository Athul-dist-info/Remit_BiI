import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:remit_bi/model/piechart_grouping_model.dart';

class CustomPieChart extends StatefulWidget {
  final List<PieChartDataModel> chartData;
  final List<Map<String, Color>> serviceColors;
  final String valueLabel;
  final Duration animationDuration;
  final Curve animationCurve;
  final String Function(double)? valueFormatter;
  final double chartHeight;
  final bool useWideLayout;

  const CustomPieChart({
    super.key,
    required this.chartData,
    required this.serviceColors,
    this.valueLabel = '',
    this.animationDuration = const Duration(milliseconds: 2000),
    this.animationCurve = Curves.easeOutCubic,
    this.valueFormatter,
    this.chartHeight = 300,
    this.useWideLayout = false,
  });

  @override
  State<CustomPieChart> createState() => _CustomPieChartState();
}

class _CustomPieChartState extends State<CustomPieChart>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _fadeController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;

  int touchedIndex = -1;
  bool _isAnimating = true;
  Map<String, double> categoryTotals = {};
  List<double> cumulativeAngles = [];

  @override
  void initState() {
    super.initState();
    categoryTotals = _calculateCategoryTotals();
    cumulativeAngles = _calculateCumulativeAngles();
    _setupAnimation();
  }

  void _setupAnimation() {
    _rotationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: Duration(
        milliseconds: widget.animationDuration.inMilliseconds ~/ 2,
      ),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _rotationController,
        curve: widget.animationCurve,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _rotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isAnimating = false;
        });
        // Start fade animation for legend
        _fadeController.forward();
      }
    });

    // Start animation
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _rotationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  List<double> _calculateCumulativeAngles() {
    final total = categoryTotals.values.reduce((a, b) => a + b);
    List<double> angles = [];
    double cumulative = 0.0;

    for (var value in categoryTotals.values) {
      cumulative += (value / total) * 360;
      angles.add(cumulative);
    }

    return angles;
  }

  String _formatValue(double value) {
    if (widget.valueFormatter != null) {
      return widget.valueFormatter!(value);
    }

    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)}K';
    }
    return value.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // loading indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isAnimating) ...[
              Icon(Icons.animation, size: 16, color: Colors.blue),
              SizedBox(width: 4),
              Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),

        if (_isAnimating) const SizedBox(height: 16),

        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 500;

            if (isWide || widget.useWideLayout) {
              // Wide layout: pie chart and legend side by side
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: constraints.maxWidth * 0.6,
                      height: widget.chartHeight,
                      child: _buildAnimatedPieChart(
                        BoxConstraints.loose(
                          Size(constraints.maxWidth * 0.6, widget.chartHeight),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: _buildAnimatedLegend()),
                  ],
                ),
              );
            } else {
              // Narrow layout: pie chart on top, legend below
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: widget.chartHeight,
                    child: _buildAnimatedPieChart(
                      BoxConstraints.loose(
                        Size(constraints.maxWidth, widget.chartHeight),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildAnimatedLegend(),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildAnimatedPieChart(BoxConstraints constraints) {
    final availableSize = constraints.biggest.shortestSide;
    final centerSpaceRadius = (availableSize * 0.15).clamp(30.0, 60.0);
    final baseRadius = (availableSize * 0.25).clamp(50.0, 80.0);

    return AspectRatio(
      aspectRatio: 1,
      child: AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (context, child) {
          return Stack(
            children: [
              // Background circle
              if (_isAnimating)
                Center(
                  child: Container(
                    width: (baseRadius + centerSpaceRadius) * 2,
                    height: (baseRadius + centerSpaceRadius) * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                ),

              // Animated pie chart
              PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    enabled: !_isAnimating, // Disable touch during animation
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      if (!_isAnimating) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex =
                              pieTouchResponse
                                  .touchedSection!
                                  .touchedSectionIndex;
                        });
                      }
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: _isAnimating ? 0 : 1.8,
                  centerSpaceRadius: centerSpaceRadius,
                  startDegreeOffset: -90,
                  sections: _buildAnimatedPieChartSections(baseRadius),
                ),
              ),

              // Center loading indicator during animation
              if (_isAnimating)
                Center(
                  child: Container(
                    width: centerSpaceRadius * 2,
                    height: centerSpaceRadius * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '${(_rotationAnimation.value * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  List<PieChartSectionData> _buildAnimatedPieChartSections(double baseRadius) {
    final total = categoryTotals.values.reduce((a, b) => a + b);
    final currentAngle = _rotationAnimation.value * 360;

    List<PieChartSectionData> sections = [];
    double startAngle = 0;

    categoryTotals.entries.toList().asMap().forEach((index, entry) {
      final segmentAngle = (entry.value / total) * 360;
      final endAngle = startAngle + segmentAngle;

      double visibleValue = 0;

      if (currentAngle > startAngle) {
        if (currentAngle >= endAngle) {
          visibleValue = entry.value;
        } else {
          final visibleAngle = currentAngle - startAngle;
          visibleValue = (visibleAngle / segmentAngle) * entry.value;
        }
      }

      if (visibleValue > 0) {
        final isTouch = index == touchedIndex && !_isAnimating;
        final percentage = (entry.value / total * 100);
        final color = _getColorForCategory(entry.key);

        sections.add(
          PieChartSectionData(
            color: color,
            value: visibleValue,
            title: '',
            radius: isTouch ? baseRadius + 10 : baseRadius,
            titleStyle: TextStyle(
              fontSize: isTouch ? 14 : 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            badgeWidget:
                isTouch && !_isAnimating
                    ? Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            entry.key,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${percentage.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            '${_formatValue(entry.value)} ${widget.valueLabel}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    )
                    : null,
            badgePositionPercentageOffset: 1.3,
          ),
        );
      }

      startAngle = endAngle;
    });

    return sections;
  }

  Widget _buildAnimatedLegend() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return AnimatedOpacity(
          opacity: _isAnimating ? _fadeAnimation.value * 0.3 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: Wrap(
            spacing: 16.0,
            runSpacing: 12.0,
            alignment: WrapAlignment.start,
            children:
                categoryTotals.entries.toList().asMap().entries.map((mapEntry) {
                  final index = mapEntry.key;
                  final entry = mapEntry.value;
                  final color = _getColorForCategory(entry.key);

                  return AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    constraints: BoxConstraints(minWidth: 100, maxWidth: 150),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            width: 12,
                            height: 12,
                            margin: EdgeInsets.only(top: 2),
                            decoration: BoxDecoration(
                              color:
                                  color?.withOpacity(
                                    _isAnimating ? 0.5 : 1.0,
                                  ) ??
                                  Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  entry.key,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        _isAnimating
                                            ? Colors.black.withOpacity(0.5)
                                            : Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${_formatValue(entry.value)} ${widget.valueLabel}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color:
                                        _isAnimating
                                            ? Colors.grey[600]?.withOpacity(0.5)
                                            : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),
        );
      },
    );
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

  Map<String, double> _calculateCategoryTotals() {
    final Map<String, double> categoryTotals = {};

    for (final item in widget.chartData) {
      categoryTotals[item.categoryKey] =
          (categoryTotals[item.categoryKey] ?? 0) + item.valueKey;
    }

    return categoryTotals;
  }
}
