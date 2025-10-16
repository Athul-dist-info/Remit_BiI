import 'package:flutter/material.dart';

class DateFilterDropdown extends StatefulWidget {
  final ValueChanged<DateRange> onDateRangeSelected;
  final DateRange? initialDateRange;
  final DateFilterOption? selectedFilter;

  const DateFilterDropdown({
    super.key,
    required this.onDateRangeSelected,
    this.initialDateRange,
    this.selectedFilter,
  });

  @override
  State<DateFilterDropdown> createState() => _DateFilterDropdownState();
}

class _DateFilterDropdownState extends State<DateFilterDropdown> {
  DateFilterOption? _selectedOption;
  DateRange? _customDateRange;
  bool _showCustomDatePicker = false;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selectedFilter;
    _customDateRange = widget.initialDateRange;
    _showCustomDatePicker = _selectedOption == DateFilterOption.custom;
  }

  DateRange _calculateDateRange(DateFilterOption option) {
    final now = DateTime.now();
    switch (option) {
      case DateFilterOption.lastMonth:
        return DateRange(
          startDate: DateTime(now.year, now.month - 1, now.day),
          endDate: now,
        );
      case DateFilterOption.last3Months:
        return DateRange(
          startDate: DateTime(now.year, now.month - 3, now.day),
          endDate: now,
        );
      case DateFilterOption.last6Months:
        return DateRange(
          startDate: DateTime(now.year, now.month - 6, now.day),
          endDate: now,
        );
      case DateFilterOption.last1Year:
        return DateRange(
          startDate: DateTime(now.year - 1, now.month, now.day),
          endDate: now,
        );
      case DateFilterOption.custom:
        return _customDateRange ??
            DateRange(
              startDate: DateTime(now.year - 1, now.month, now.day),
              endDate: now,
            );
    }
  }

  Future<void> _selectStartDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _customDateRange?.startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _customDateRange = DateRange(
          startDate: pickedDate,
          endDate: _customDateRange?.endDate ?? DateTime.now(),
        );
      });
      widget.onDateRangeSelected(_customDateRange!);
    }
  }

  Future<void> _selectEndDate() async {
    final initialDate = _customDateRange?.endDate ?? DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: _customDateRange?.startDate ?? DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _customDateRange = DateRange(
          startDate: _customDateRange?.startDate ?? pickedDate,
          endDate: pickedDate,
        );
      });
      widget.onDateRangeSelected(_customDateRange!);
    }
  }

  void _handleOptionSelected(DateFilterOption? option) {
    if (option == null) return;

    setState(() {
      _selectedOption = option;
      _showCustomDatePicker = option == DateFilterOption.custom;
    });

    if (option != DateFilterOption.custom) {
      final dateRange = _calculateDateRange(option);
      widget.onDateRangeSelected(dateRange);
    } else if (_customDateRange != null) {
      widget.onDateRangeSelected(_customDateRange!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<DateFilterOption>(
                value: _selectedOption,
                decoration: InputDecoration(
                  labelText: 'Date Range',
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 38, 99, 205),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color:
                          _selectedOption != null
                              ? Color.fromARGB(255, 38, 99, 205)
                              : Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 38, 99, 205),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                items:
                    DateFilterOption.values.map((option) {
                      return DropdownMenuItem<DateFilterOption>(
                        value: option,
                        child: Text(option.displayName),
                      );
                    }).toList(),
                onChanged: _handleOptionSelected,
              ),
            ),
            Expanded(child: SizedBox()),
          ],
        ),

        // Custom date picker section
        if (_showCustomDatePicker) ...[
          SizedBox(height: 16),
          Text(
            'Select Date Range:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _selectStartDate,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Color.fromARGB(255, 38, 99, 205)),
                    ),
                  ),
                  child: Text(
                    _customDateRange != null
                        ? 'Start: ${_formatDate(_customDateRange!.startDate)}'
                        : 'Select Start Date',
                    style: TextStyle(color: Color.fromARGB(255, 38, 99, 205)),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: _selectEndDate,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Color.fromARGB(255, 38, 99, 205)),
                    ),
                  ),
                  child: Text(
                    _customDateRange != null
                        ? 'End: ${_formatDate(_customDateRange!.endDate)}'
                        : 'Select End Date',
                    style: TextStyle(color: Color.fromARGB(255, 38, 99, 205)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

enum DateFilterOption {
  lastMonth('Last Month'),
  last3Months('Last 3 Months'),
  last6Months('Last 6 Months'),
  last1Year('1 Year'),
  custom('Custom Date');

  final String displayName;
  const DateFilterOption(this.displayName);
}

class DateRange {
  final DateTime startDate;
  final DateTime endDate;

  DateRange({required this.startDate, required this.endDate});

  @override
  String toString() => '${_formatDate(startDate)} - ${_formatDate(endDate)}';

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
