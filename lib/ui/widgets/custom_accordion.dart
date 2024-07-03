import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_rent/data_layer/models/smart_model.dart';
import 'package:smart_rent/ui/themes/app_theme.dart';

class DateTimeAccordion extends StatefulWidget {
  const DateTimeAccordion(
      {super.key,
      required this.name,
      required this.dateController,
      required this.timeController});

  final String name;
  final TextEditingController dateController;
  final TextEditingController timeController;

  @override
  State<DateTimeAccordion> createState() => _DateTimeAccordionState();
}

class _DateTimeAccordionState extends State<DateTimeAccordion> {
  bool isDate = true;
  bool isTime = true;

  late bool _showContent;

  late double _height = 200;

  DateTime now = DateTime.now();

  String selectedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String selectedTime = DateFormat('h:mm a').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.whiteColor,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(children: [
        _buildTimeField(selectedDate, selectedTime),
        // Show or hide the content based on the state
        _showContent
            ? Container(
                height: _height,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: (isDate)
                    ? CalendarDatePicker(
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 99),
                        onDateChanged: (DateTime newDate) {
                          setState(() {
                            selectedDate =
                                DateFormat('dd/MM/yyyy').format(newDate);
                            widget.dateController.text = selectedDate;

                            _showContent = false;
                          });
                        },
                      )
                    : (isTime)
                        ? CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.time,
                            initialDateTime: DateTime.now(),
                            onDateTimeChanged: (DateTime newTime) {
                              setState(() {
                                selectedTime =
                                    DateFormat('h:mm a').format(newTime);
                                widget.timeController.text = selectedTime;
                              });
                            },
                          )
                        : CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.time,
                            initialDateTime: DateTime.now(),
                            onDateTimeChanged: (DateTime newTime) {
                              setState(() {
                                selectedTime =
                                    DateFormat('h:mm a').format(newTime);
                              });
                            },
                          ),
              )
            : Container()
      ]),
    );
  }

  _buildTimeField(String date, String time) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppTheme.whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.name),
              Row(
                children: [
                  SizedBox(
                    height: 40,
                    child: FilledButton(
                      onPressed: () {
                        setState(() {
                          isDate = true;

                          if (_showContent && isTime) {
                            isTime = false;
                            _height = 280;
                            _showContent = true;
                            return;
                          }

                          isTime = false;
                          _height = 280;
                          _showContent = !_showContent;
                        });
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => AppTheme.appBgColor)),
                      child: Text(
                        date,
                        style: const TextStyle(color: AppTheme.darker),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 40,
                    child: FilledButton(
                      onPressed: () {
                        setState(() {
                          isTime = true;

                          if (_showContent && isDate) {
                            isDate = false;
                            _showContent = true;
                            _height = 200;
                            return;
                          }

                          isDate = false;
                          _height = 200;
                          _showContent = !_showContent;
                        });
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => AppTheme.appBgColor)),
                      child: Text(
                        time,
                        style: const TextStyle(color: AppTheme.darker),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    widget.dateController.text.isNotEmpty
        ? selectedDate = widget.dateController.text
        : widget.dateController.text = selectedDate;
    widget.timeController.text.isNotEmpty
        ? selectedTime = widget.timeController.text
        : widget.timeController.text = selectedTime;
    _showContent = false;
  }
}

class DoubleDateTimeAccordion extends StatefulWidget {
  const DoubleDateTimeAccordion(
      {super.key,
      required this.startName,
      required this.endName,
      required this.startDateController,
      required this.startTimeController,
      required this.endDateController,
      required this.endTimeController});

  final String startName;
  final String endName;
  final TextEditingController startDateController;
  final TextEditingController startTimeController;
  final TextEditingController endDateController;
  final TextEditingController endTimeController;

  @override
  State<DoubleDateTimeAccordion> createState() =>
      _DoubleDateTimeAccordionState();
}

class _DoubleDateTimeAccordionState extends State<DoubleDateTimeAccordion> {
  bool isStartDate = false;
  bool isStartTime = false;
  bool isEndDate = false;
  bool isEndTime = false;

  late bool _showStartContent;
  late bool _showEndContent;

  late double _height = 200;

  DateTime now = DateTime.now();

  String startSelectedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String startSelectedTime = DateFormat('h:mm a').format(DateTime.now());
  String endSelectedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String endSelectedTime =
      DateFormat('h:mm a').format(DateTime.now().add(const Duration(hours: 1)));

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppTheme.whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Card(
            color: AppTheme.whiteColor,
            elevation: 0,
            child: Column(children: [
              _buildStartTimeField(startSelectedDate, startSelectedTime),
              // Show or hide the content based on the state
              _showStartContent
                  ? Container(
                      height: _height,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      child: (isStartDate)
                          ? CalendarDatePicker(
                              initialDate: DateFormat('dd/MM/yyyy')
                                  .parse(startSelectedDate),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(DateTime.now().year + 99),
                              onDateChanged: (DateTime newDate) {
                                setState(() {
                                  if (isStartDate) {
                                    startSelectedDate = DateFormat('dd/MM/yyyy')
                                        .format(newDate);

                                    widget.startDateController.text =
                                        startSelectedDate;

                                    endSelectedDate = startSelectedDate;

                                    widget.endDateController.text =
                                        startSelectedDate;

                                    _showStartContent = false;
                                  } else if (isEndDate) {
                                    endSelectedDate = DateFormat('dd/MM/yyyy')
                                        .format(newDate);

                                    widget.endDateController.text =
                                        endSelectedDate;

                                    _showStartContent = false;
                                  }
                                });
                              },
                            )
                          : CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.time,
                              initialDateTime:
                                  DateFormat('h:mm a').parse(startSelectedTime),
                              onDateTimeChanged: (DateTime newTime) {
                                setState(() {
                                  if (isStartTime) {
                                    startSelectedTime =
                                        DateFormat('h:mm a').format(newTime);

                                    endSelectedTime = DateFormat('h:mm a')
                                        .format(newTime
                                            .add(const Duration(hours: 1)));

                                    widget.startTimeController.text =
                                        startSelectedTime;
                                    widget.endTimeController.text =
                                        endSelectedTime;
                                  } else if (isEndTime) {
                                    endSelectedTime =
                                        DateFormat('h:mm a').format(newTime);

                                    widget.endTimeController.text =
                                        endSelectedTime;
                                  }
                                });
                              },
                            ))
                  : Container()
            ]),
          ),
          const Divider(indent: 5, endIndent: 5, height: 0),
          Card(
            color: AppTheme.whiteColor,
            elevation: 0,
            child: Column(children: [
              _buildEndTimeField(endSelectedDate, endSelectedTime),
              // Show or hide the content based on the state
              _showEndContent
                  ? Container(
                      height: _height,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      child: (isEndDate)
                          ? CalendarDatePicker(
                              initialDate: DateFormat('dd/MM/yyyy')
                                  .parse(endSelectedDate),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(DateTime.now().year + 99),
                              onDateChanged: (DateTime newDate) {
                                setState(() {
                                  if (isEndDate) {
                                    endSelectedDate = DateFormat('dd/MM/yyyy')
                                        .format(newDate);

                                    widget.endDateController.text =
                                        endSelectedDate;

                                    _showEndContent = false;
                                  }
                                });
                              },
                            )
                          : CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.time,
                              initialDateTime:
                                  DateFormat('h:mm a').parse(endSelectedTime),
                              onDateTimeChanged: (DateTime newTime) {
                                setState(() {
                                  if (isEndTime) {
                                    endSelectedTime =
                                        DateFormat('h:mm a').format(newTime);
                                    widget.endTimeController.text =
                                        endSelectedTime;
                                  }
                                });
                              },
                            ))
                  : Container()
            ]),
          ),
        ],
      ),
    );
  }

  _buildStartTimeField(String startDate, String startTime) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppTheme.whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.startName),
              Row(
                children: [
                  SizedBox(
                    height: 40,
                    child: FilledButton(
                      onPressed: () {
                        setState(() {
                          isStartDate = true;
                          _showEndContent = false;

                          if (_showStartContent && isStartTime) {
                            isStartTime = false;
                            _height = 280;
                            _showStartContent = true;
                            return;
                          }

                          isStartTime = false;
                          _height = 280;
                          _showStartContent = !_showStartContent;
                        });
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => AppTheme.appBgColor)),
                      child: Text(
                        startDate,
                        style: const TextStyle(color: AppTheme.darker),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 40,
                    child: FilledButton(
                      onPressed: () {
                        setState(() {
                          isStartTime = true;
                          _showEndContent = false;

                          if (_showStartContent && isStartDate) {
                            isStartDate = false;
                            _showStartContent = true;
                            _height = 200;
                            return;
                          }

                          isStartDate = false;
                          _height = 200;
                          _showStartContent = !_showStartContent;
                        });
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => AppTheme.appBgColor)),
                      child: Text(
                        startTime,
                        style: const TextStyle(color: AppTheme.darker),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  _buildEndTimeField(String endDate, String endTime) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppTheme.whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.endName),
              Row(
                children: [
                  SizedBox(
                    height: 40,
                    child: FilledButton(
                      onPressed: () {
                        setState(() {
                          isEndDate = true;
                          _showStartContent = false;

                          if (_showEndContent && isEndTime) {
                            isEndTime = false;
                            _height = 280;
                            _showEndContent = true;
                            return;
                          }

                          isEndTime = false;
                          _height = 280;
                          _showEndContent = !_showEndContent;
                        });
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => AppTheme.appBgColor)),
                      child: Text(
                        endDate,
                        style: const TextStyle(color: AppTheme.darker),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 40,
                    child: FilledButton(
                      onPressed: () {
                        setState(() {
                          isEndTime = true;
                          _showStartContent = false;

                          if (_showEndContent && isEndDate) {
                            isEndDate = false;
                            _showEndContent = true;
                            _height = 200;
                            return;
                          }

                          isEndDate = false;
                          _height = 200;
                          _showEndContent = !_showEndContent;
                        });
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => AppTheme.appBgColor)),
                      child: Text(
                        endTime,
                        style: const TextStyle(color: AppTheme.darker),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    widget.startDateController.text.isNotEmpty
        ? startSelectedDate = widget.startDateController.text
        : widget.startDateController.text = startSelectedDate;
    widget.startTimeController.text.isNotEmpty
        ? startSelectedTime = widget.startTimeController.text
        : widget.startTimeController.text = startSelectedTime;
    widget.endDateController.text.isNotEmpty
        ? endSelectedDate = widget.endDateController.text
        : widget.endDateController.text = endSelectedDate;
    widget.endTimeController.text.isNotEmpty
        ? endSelectedTime = widget.endTimeController.text
        : widget.endTimeController.text = endSelectedTime;
    _showStartContent = false;
    _showEndContent = false;
  }
}

class EngagementDateTimeAccordion extends StatefulWidget {
  const EngagementDateTimeAccordion(
      {super.key,
      required this.dateController,
      required this.startTimeController,
      required this.endTimeController});

  final TextEditingController dateController;
  final TextEditingController startTimeController;
  final TextEditingController endTimeController;

  @override
  State<EngagementDateTimeAccordion> createState() =>
      _EngagementDateTimeAccordionState();
}

class _EngagementDateTimeAccordionState
    extends State<EngagementDateTimeAccordion> {
  bool isDate = true;
  bool isStartTime = true;
  bool isEndTime = true;

  late bool _showContent;

  late double _height = 200;

  DateTime now = DateTime.now();

  String selectedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String selectedStartTime = DateFormat('h:mm a').format(DateTime.now());
  String selectedEndTime =
      DateFormat('h:mm a').format(DateTime.now().add(const Duration(hours: 1)));

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.whiteColor,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(children: [
        _buildTimeField(selectedDate, selectedStartTime, selectedEndTime),
        // Show or hide the content based on the state
        _showContent
            ? Container(
                height: _height,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: (isDate)
                    ? CalendarDatePicker(
                        initialDate:
                            DateFormat('dd/MM/yyyy').parse(selectedDate),
                        firstDate: DateTime(DateTime.now().year - 99),
                        lastDate: DateTime(DateTime.now().year + 99),
                        onDateChanged: (DateTime newDate) {
                          setState(() {
                            selectedDate =
                                DateFormat('dd/MM/yyyy').format(newDate);
                            widget.dateController.text = selectedDate;

                            _showContent = false;
                          });
                        },
                      )
                    : (isStartTime)
                        ? CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.time,
                            initialDateTime:
                                DateFormat('h:mm a').parse(selectedStartTime),
                            onDateTimeChanged: (DateTime newTime) {
                              setState(() {
                                selectedStartTime =
                                    DateFormat('h:mm a').format(newTime);
                                widget.startTimeController.text =
                                    selectedStartTime;
                              });
                            },
                          )
                        : CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.time,
                            initialDateTime:
                                DateFormat('h:mm a').parse(selectedEndTime),
                            onDateTimeChanged: (DateTime newTime) {
                              setState(() {
                                selectedEndTime =
                                    DateFormat('h:mm a').format(newTime);
                                widget.endTimeController.text = selectedEndTime;
                              });
                            },
                          ),
              )
            : Container()
      ]),
    );
  }

  _buildTimeField(String date, String timeStart, String timeEnd) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppTheme.whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 40,
                child: FilledButton(
                  onPressed: () {
                    setState(() {
                      isDate = true;

                      if (_showContent && isStartTime || isEndTime) {
                        isEndTime = false;
                        isStartTime = false;
                        _height = 280;
                        _showContent = true;
                        return;
                      }

                      isEndTime = false;
                      isStartTime = false;
                      _height = 280;
                      _showContent = !_showContent;
                    });
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => AppTheme.appBgColor)),
                  child: Text(
                    date,
                    style: const TextStyle(color: AppTheme.darker),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                child: FilledButton(
                  onPressed: () {
                    setState(() {
                      isStartTime = true;

                      if (_showContent && isDate || isEndTime) {
                        isDate = false;
                        isEndTime = false;
                        _showContent = true;
                        _height = 200;
                        return;
                      }

                      isDate = false;
                      isEndTime = false;
                      _height = 200;
                      _showContent = !_showContent;
                    });
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => AppTheme.appBgColor)),
                  child: Text(
                    timeStart,
                    style: const TextStyle(color: AppTheme.darker),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                child: FilledButton(
                  onPressed: () {
                    setState(() {
                      isEndTime = true;

                      if (_showContent && isStartTime || isDate) {
                        isDate = false;
                        isStartTime = false;
                        _showContent = true;
                        _height = 200;
                        return;
                      }

                      isDate = false;
                      isStartTime = false;
                      _height = 200;
                      _showContent = !_showContent;
                    });
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => AppTheme.appBgColor)),
                  child: Text(
                    timeEnd,
                    style: const TextStyle(color: AppTheme.darker),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    widget.dateController.text.isNotEmpty
        ? selectedDate = widget.dateController.text
        : widget.dateController.text = selectedDate;
    widget.startTimeController.text.isNotEmpty
        ? selectedStartTime = widget.startTimeController.text
        : widget.startTimeController.text = selectedStartTime;
    widget.endTimeController.text.isNotEmpty
        ? selectedEndTime = widget.endTimeController.text
        : widget.endTimeController.text = selectedEndTime;
    _showContent = false;
  }
}

class TaskDateTimeAccordion extends StatefulWidget {
  const TaskDateTimeAccordion(
      {super.key,
      required this.dateController,
      required this.startTimeController,
      required this.endTimeController});

  final TextEditingController dateController;
  final TextEditingController startTimeController;
  final TextEditingController endTimeController;

  @override
  State<TaskDateTimeAccordion> createState() => _TaskDateTimeAccordionState();
}

class _TaskDateTimeAccordionState extends State<TaskDateTimeAccordion> {
  bool isDate = true;
  bool isStartTime = true;
  bool isEndTime = true;

  late bool _showContent;

  late double _height = 200;

  DateTime now = DateTime.now();

  String selectedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String selectedStartTime = DateFormat('h:mm a').format(DateTime.now());
  String selectedEndTime =
      DateFormat('h:mm a').format(DateTime.now().add(const Duration(hours: 1)));

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.whiteColor,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(children: [
        _buildTimeField(selectedDate, selectedStartTime, selectedEndTime),
        // Show or hide the content based on the state
        _showContent
            ? Container(
                height: _height,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: (isDate)
                    ? CalendarDatePicker(
                        initialDate:
                            DateFormat('dd/MM/yyyy').parse(selectedDate),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 99),
                        onDateChanged: (DateTime newDate) {
                          setState(() {
                            selectedDate =
                                DateFormat('dd/MM/yyyy').format(newDate);
                            widget.dateController.text = selectedDate;

                            _showContent = false;
                          });
                        },
                      )
                    : (isStartTime)
                        ? CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.time,
                            initialDateTime:
                                DateFormat('h:mm a').parse(selectedStartTime),
                            onDateTimeChanged: (DateTime newTime) {
                              setState(() {
                                selectedStartTime =
                                    DateFormat('h:mm a').format(newTime);
                                widget.startTimeController.text =
                                    selectedStartTime;
                              });
                            },
                          )
                        : CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.time,
                            initialDateTime:
                                DateFormat('h:mm a').parse(selectedEndTime),
                            onDateTimeChanged: (DateTime newTime) {
                              setState(() {
                                selectedEndTime =
                                    DateFormat('h:mm a').format(newTime);
                                widget.endTimeController.text = selectedEndTime;
                              });
                            },
                          ),
              )
            : Container()
      ]),
    );
  }

  _buildTimeField(String date, String timeStart, String timeEnd) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppTheme.whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 40,
                child: FilledButton(
                  onPressed: () {
                    setState(() {
                      isDate = true;

                      if (_showContent && isStartTime || isEndTime) {
                        isEndTime = false;
                        isStartTime = false;
                        _height = 280;
                        _showContent = true;
                        return;
                      }

                      isEndTime = false;
                      isStartTime = false;
                      _height = 280;
                      _showContent = !_showContent;
                    });
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => AppTheme.appBgColor)),
                  child: Text(
                    date,
                    style: const TextStyle(color: AppTheme.darker),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                child: FilledButton(
                  onPressed: () {
                    setState(() {
                      isStartTime = true;

                      if (_showContent && isDate || isEndTime) {
                        isDate = false;
                        isEndTime = false;
                        _showContent = true;
                        _height = 200;
                        return;
                      }

                      isDate = false;
                      isEndTime = false;
                      _height = 200;
                      _showContent = !_showContent;
                    });
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => AppTheme.appBgColor)),
                  child: Text(
                    timeStart,
                    style: const TextStyle(color: AppTheme.darker),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                child: FilledButton(
                  onPressed: () {
                    setState(() {
                      isEndTime = true;

                      if (_showContent && isStartTime || isDate) {
                        isDate = false;
                        isStartTime = false;
                        _showContent = true;
                        _height = 200;
                        return;
                      }

                      isDate = false;
                      isStartTime = false;
                      _height = 200;
                      _showContent = !_showContent;
                    });
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => AppTheme.appBgColor)),
                  child: Text(
                    timeEnd,
                    style: const TextStyle(color: AppTheme.darker),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    widget.dateController.text.isNotEmpty
        ? selectedDate = widget.dateController.text
        : widget.dateController.text = selectedDate;
    widget.startTimeController.text.isNotEmpty
        ? selectedStartTime = widget.startTimeController.text
        : widget.startTimeController.text = selectedStartTime;
    widget.endTimeController.text.isNotEmpty
        ? selectedEndTime = widget.endTimeController.text
        : widget.endTimeController.text = selectedEndTime;
    _showContent = false;
  }
}

class ActivityDateTimeAccordion extends StatefulWidget {
  const ActivityDateTimeAccordion(
      {super.key,
      required this.dateController,
      required this.startTimeController,
      required this.endTimeController});

  final TextEditingController dateController;
  final TextEditingController startTimeController;
  final TextEditingController endTimeController;

  @override
  State<ActivityDateTimeAccordion> createState() =>
      _ActivityDateTimeAccordionState();
}

class _ActivityDateTimeAccordionState extends State<ActivityDateTimeAccordion> {
  bool isDate = true;
  bool isStartTime = true;
  bool isEndTime = true;

  late bool _showContent;

  late double _height = 200;

  DateTime now = DateTime.now();

  String selectedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String selectedStartTime = DateFormat('h:mm a').format(DateTime.now());
  String selectedEndTime =
      DateFormat('h:mm a').format(DateTime.now().add(const Duration(hours: 1)));

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.whiteColor,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(children: [
        _buildTimeField(selectedDate, selectedStartTime, selectedEndTime),
        // Show or hide the content based on the state
        _showContent
            ? Container(
                height: _height,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: (isDate)
                    ? CalendarDatePicker(
                        initialDate:
                            DateFormat('dd/MM/yyyy').parse(selectedDate),
                        firstDate: DateTime(DateTime.now().year - 99),
                        lastDate: DateTime.now(),
                        onDateChanged: (DateTime newDate) {
                          setState(() {
                            selectedDate =
                                DateFormat('dd/MM/yyyy').format(newDate);
                            widget.dateController.text = selectedDate;

                            _showContent = false;
                          });
                        },
                      )
                    : (isStartTime)
                        ? CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.time,
                            initialDateTime:
                                DateFormat('h:mm a').parse(selectedStartTime),
                            onDateTimeChanged: (DateTime newTime) {
                              setState(() {
                                selectedStartTime =
                                    DateFormat('h:mm a').format(newTime);
                                widget.startTimeController.text =
                                    selectedStartTime;
                              });
                            },
                          )
                        : CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.time,
                            initialDateTime:
                                DateFormat('h:mm a').parse(selectedEndTime),
                            onDateTimeChanged: (DateTime newTime) {
                              setState(() {
                                selectedEndTime =
                                    DateFormat('h:mm a').format(newTime);
                                widget.endTimeController.text = selectedEndTime;
                              });
                            },
                          ),
              )
            : Container()
      ]),
    );
  }

  _buildTimeField(String date, String timeStart, String timeEnd) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppTheme.whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 40,
                child: FilledButton(
                  onPressed: () {
                    setState(() {
                      isDate = true;

                      if (_showContent && isStartTime || isEndTime) {
                        isEndTime = false;
                        isStartTime = false;
                        _height = 280;
                        _showContent = true;
                        return;
                      }

                      isEndTime = false;
                      isStartTime = false;
                      _height = 280;
                      _showContent = !_showContent;
                    });
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => AppTheme.appBgColor)),
                  child: Text(
                    date,
                    style: const TextStyle(color: AppTheme.darker),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                child: FilledButton(
                  onPressed: () {
                    setState(() {
                      isStartTime = true;

                      if (_showContent && isDate || isEndTime) {
                        isDate = false;
                        isEndTime = false;
                        _showContent = true;
                        _height = 200;
                        return;
                      }

                      isDate = false;
                      isEndTime = false;
                      _height = 200;
                      _showContent = !_showContent;
                    });
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => AppTheme.appBgColor)),
                  child: Text(
                    timeStart,
                    style: const TextStyle(color: AppTheme.darker),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                child: FilledButton(
                  onPressed: () {
                    setState(() {
                      isEndTime = true;

                      if (_showContent && isStartTime || isDate) {
                        isDate = false;
                        isStartTime = false;
                        _showContent = true;
                        _height = 200;
                        return;
                      }

                      isDate = false;
                      isStartTime = false;
                      _height = 200;
                      _showContent = !_showContent;
                    });
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => AppTheme.appBgColor)),
                  child: Text(
                    timeEnd,
                    style: const TextStyle(color: AppTheme.darker),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    widget.dateController.text.isNotEmpty
        ? selectedDate = widget.dateController.text
        : widget.dateController.text = selectedDate;
    widget.startTimeController.text.isNotEmpty
        ? selectedStartTime = widget.startTimeController.text
        : widget.startTimeController.text = selectedStartTime;
    widget.endTimeController.text.isNotEmpty
        ? selectedEndTime = widget.endTimeController.text
        : widget.endTimeController.text = selectedEndTime;
    _showContent = false;
  }
}

class DateAccordion extends StatefulWidget {
  const DateAccordion({
    super.key,
    required this.dateController,
    required this.title,
    this.onChanged,
  });

  final TextEditingController dateController;
  final String title;
  final Function()? onChanged;

  @override
  State<DateAccordion> createState() => _DateAccordionState();
}

class _DateAccordionState extends State<DateAccordion> {
  late bool _showContent;

  late final double _height = 280;

  DateTime now = DateTime.now();

  String selectedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    selectedDate = widget.dateController.text;

    return Card(
      color: AppTheme.whiteColor,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(children: [
        _buildDateField(selectedDate),
        _showContent
            ? Container(
                height: _height,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: CalendarDatePicker(
                  initialDate: DateFormat('dd/MM/yyyy').parse(selectedDate),
                  firstDate: DateTime(DateTime.now().year - 99),
                  lastDate: DateTime(DateTime.now().year + 99),
                  onDateChanged: (DateTime newDate) {
                    setState(() {
                      selectedDate = DateFormat('dd/MM/yyyy').format(newDate);

                      widget.dateController.text = selectedDate;

                      _showContent = false;
                      if (widget.onChanged != null) widget.onChanged!.call();
                    });
                  },
                ),
              )
            : Container()
      ]),
    );
  }

  _buildDateField(String date) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showContent = !_showContent;
        });
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.fromLTRB(15, 5, 8, 5),
        decoration: BoxDecoration(
          color: AppTheme.whiteColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title),
            Text(date),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    widget.dateController.text.isNotEmpty
        ? selectedDate = widget.dateController.text
        : widget.dateController.text = selectedDate;

    _showContent = false;
  }
}

class DOBAccordion extends StatefulWidget {
  const DOBAccordion({super.key, required this.dateController, this.hint});

  final TextEditingController dateController;
  final String? hint;

  @override
  State<DOBAccordion> createState() => _DOBAccordionState();
}

class _DOBAccordionState extends State<DOBAccordion> {
  late bool _showContent;

  late final double _height = 280;

  DateTime now = DateTime.now();

  String? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.whiteColor,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(children: [
        _buildDateField(selectedDate ?? widget.hint!),
        _showContent
            ? Container(
                height: _height,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: CalendarDatePicker(
                  initialDate: (selectedDate == null)
                      ? DateTime.now()
                      : DateFormat('dd/MM/yyyy').parse(selectedDate!),
                  firstDate: DateTime(DateTime.now().year - 99),
                  lastDate: DateTime(DateTime.now().year + 99),
                  onDateChanged: (DateTime newDate) {
                    setState(() {
                      selectedDate = DateFormat('dd/MM/yyyy').format(newDate);

                      widget.dateController.text = selectedDate!;

                      _showContent = false;
                    });
                  },
                ),
              )
            : Container()
      ]),
    );
  }

  _buildDateField(String date) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showContent = !_showContent;
        });
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.fromLTRB(15, 5, 8, 5),
        decoration: BoxDecoration(
          color: AppTheme.whiteColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(date),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  _showContent ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  size: 25,
                  color: Colors.black45,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _showContent = false;

    widget.dateController.text.isNotEmpty
        ? selectedDate = widget.dateController.text
        : "";
  }
}

class InvoiceDateTimeAccordion extends StatefulWidget {
  const InvoiceDateTimeAccordion({
    super.key,
    required this.startName,
    required this.endName,
    required this.startDateController,
    required this.endDateController,
  });

  final String startName;
  final String endName;
  final TextEditingController startDateController;
  final TextEditingController endDateController;

  @override
  State<InvoiceDateTimeAccordion> createState() =>
      _InvoiceDateTimeAccordionState();
}

class _InvoiceDateTimeAccordionState extends State<InvoiceDateTimeAccordion> {
  bool isStartDate = false;
  bool isEndDate = false;

  late bool _showStartContent;
  late bool _showEndContent;

  late double _height = 200;

  DateTime now = DateTime.now();

  String selectedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String selectedDueDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppTheme.whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Card(
            color: AppTheme.whiteColor,
            elevation: 0,
            child: Column(children: [
              _buildStartTimeField(selectedDate, selectedDueDate),
              // Show or hide the content based on the state
              _showStartContent
                  ? Container(
                      height: _height,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      child: CalendarDatePicker(
                        initialDate:
                            DateFormat('dd/MM/yyyy').parse(selectedDate),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 99),
                        onDateChanged: (DateTime newDate) {
                          setState(() {
                            selectedDate =
                                DateFormat('dd/MM/yyyy').format(newDate);

                            widget.startDateController.text = selectedDate;

                            selectedDueDate = selectedDate;

                            widget.endDateController.text = selectedDate;

                            _showStartContent = false;
                            _showEndContent = false;
                          });
                        },
                      ))
                  : (_showEndContent)
                      ? Container(
                          height: _height,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          child: CalendarDatePicker(
                            initialDate:
                                DateFormat('dd/MM/yyyy').parse(selectedDate),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 99),
                            onDateChanged: (DateTime newDate) {
                              setState(() {
                                selectedDueDate =
                                    DateFormat('dd/MM/yyyy').format(newDate);

                                widget.endDateController.text = selectedDueDate;

                                _showStartContent = false;
                                _showEndContent = false;
                              });
                            },
                          ),
                        )
                      : Container(),
            ]),
          ),
        ],
      ),
    );
  }

  _buildStartTimeField(String startDate, String endDate) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppTheme.whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(widget.startName),
              Row(
                children: [
                  SizedBox(
                    height: 40,
                    child: FilledButton(
                      onPressed: () {
                        setState(() {
                          isStartDate = true;
                          _showEndContent = false;
                          isEndDate = false;

                          if (_showStartContent) {
                            _height = 280;
                            _showStartContent = true;
                            return;
                          }

                          _height = 280;
                          _showStartContent = !_showStartContent;
                        });
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              side: BorderSide(
                                  color: !isStartDate
                                      ? AppTheme.appBgColor
                                      : AppTheme.primary),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => AppTheme.appBgColor)),
                      child: Text(
                        startDate,
                        style: const TextStyle(color: AppTheme.darker),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(widget.endName),
              Row(
                children: [
                  SizedBox(
                    height: 40,
                    child: FilledButton(
                      onPressed: () {
                        setState(() {
                          isEndDate = true;
                          isStartDate = false;
                          _showStartContent = false;

                          if (_showEndContent) {
                            _height = 280;
                            _showEndContent = true;
                            return;
                          }

                          _height = 280;
                          _showEndContent = !_showEndContent;
                        });
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              side: BorderSide(
                                  color: !isEndDate
                                      ? AppTheme.appBgColor
                                      : AppTheme.primary),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => AppTheme.appBgColor)),
                      child: Text(
                        endDate,
                        style: const TextStyle(color: AppTheme.darker),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    widget.startDateController.text.isNotEmpty
        ? selectedDate = widget.startDateController.text
        : widget.startDateController.text = selectedDate;
    widget.endDateController.text.isNotEmpty
        ? selectedDueDate = widget.endDateController.text
        : widget.endDateController.text = selectedDueDate;
    _showStartContent = false;
    _showEndContent = false;
  }
}

class TenantUnitDropdown<T extends SmartUnitModel> extends StatelessWidget {
  const TenantUnitDropdown(
      {super.key,
      required this.hintText,
      required this.menuItems,
      this.onChanged,
      this.defaultValue});

  final String hintText;
  final List<T> menuItems;
  final T? defaultValue;
  final Function(T?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: DropdownButtonFormField2<T>(
            value: defaultValue,
            isExpanded: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              filled: true,
              // fillColor: AppTheme.textBoxColor,
              fillColor: AppTheme.itemBgColor,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            hint: Text(
              hintText,
              style:
                  const TextStyle(color: AppTheme.inActiveColor, fontSize: 15),
            ),
            items: menuItems
                .map((item) => DropdownMenuItem<T>(
                      value: item,
                      child: Text(
                        item.getUnitName(),
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ))
                .toList(),
            validator: (value) {
              if (value == null) {
                return 'Please select a $hintText';
              }
              return null;
            },
            onChanged: onChanged,
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.only(right: 8),
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.black45,
              ),
              iconSize: 24,
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
