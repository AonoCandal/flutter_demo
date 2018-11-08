library flutter_calendar_dooboo;

/// A Calculator.
import 'package:flutter/material.dart';

typedef CalendarScrollListener(DateTime currentDate);

class CalendarCarousel extends StatefulWidget {
  final TextStyle defaultHeaderTextStyle = TextStyle(
    fontSize: 18.0,
    color: Colors.blue,
  );
  final TextStyle defaultPrevDaysTextStyle = TextStyle(
    color: Colors.grey,
    fontSize: 17.0,
  );
  final TextStyle defaultNextDaysTextStyle = TextStyle(
    color: Colors.grey,
    fontSize: 17.0,
  );
  final TextStyle defaultPrevMonthTextStyle = TextStyle(
    color: Colors.grey,
    fontSize: 15.0,
  );
  final TextStyle defaultNextMonthTextStyle = TextStyle(
    color: Colors.grey,
    fontSize: 15.0,
  );
  final TextStyle defaultDaysTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 17.0,
  );
  final TextStyle defaultTodayTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 17.0,
  );
  final TextStyle defaultSelectedDayTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 17.0,
  );
  final TextStyle defaultWeekdayTextStyle = TextStyle(
    color: Colors.deepOrange,
    fontSize: 14.0,
  );
  final Widget defaultMarkedDateWidget = Column(
    children: <Widget>[
      Expanded(child: Container()),
      Container(
        color: Color(0xffBCD3F2),
        height: 17.0,
        alignment: Alignment.center,
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 16.0,
        ),
      ),
    ],
  );

  final Widget noMarkedDateWidget = Column(
    children: <Widget>[
      Expanded(child: Container()),
      Container(
        color: Color(0xfff3f3f3),
        height: 17.0,
      ),
    ],
  );

  final Widget markedErrorDateWidget = Column(
    children: <Widget>[
      Expanded(child: Container()),
      Container(
        color: Color(0xffE60113),
        height: 17.0,
        alignment: Alignment.center,
        child: Text(
          '缺勤',
          style: TextStyle(color: Colors.white, fontSize: 12.0),
        ),
      ),
    ],
  );

  final List<String> weekDays;
  final double viewportFraction;
  final TextStyle prevDaysTextStyle;
  final TextStyle daysTextStyle;
  final TextStyle nextDaysTextStyle;
  final TextStyle prevMonthTextStyle;
  final TextStyle nextMonthTextStyle;
  final TextStyle highLightTextStyle;
  final Color prevMonthDayBorderColor;
  final Color thisMonthDayBorderColor;
  final Color nextMonthDayBorderColor;
  final double dayPadding;
  final double height;
  final double width;
  final TextStyle todayTextStyle;
  final Color dayButtonColor;
  final Color todayBorderColor;
  final Color todayButtonColor;
  final DateTime selectedDateTime;
  final TextStyle selectedDayTextStyle;
  final Color selectedDayButtonColor;
  final Color selectedDayBorderColor;
  final bool daysHaveCircularBorder;
  final Function(DateTime) onDayPressed;
  final TextStyle weekdayTextStyle;
  final TextStyle weekEndDayTextStyle;
  final Color iconColor;
  final TextStyle headerTextStyle;
  final Widget headerText;
  final TextStyle weekendTextStyle;
  final TextStyle weekendHeaderTextStyle;
  final List<DateTime> markedDates;
  final List<DateTime> markedLightDates;
  final Color markedDateColor;
  final Widget markedDateWidget;
  final EdgeInsets headerPadding;
  final EdgeInsets headerMargin;
  final EdgeInsets weekdayMargin;
  final Color headerBgColor;
  final double childAspectRatio;
  final EdgeInsets weekDayMargin;
  final CalendarScrollListener listener;

  CalendarCarousel({
    this.weekDays = const ['日', '一', '二', '三', '四', '五', '六'],
    this.viewportFraction = 1.0,
    this.prevDaysTextStyle,
    this.daysTextStyle,
    this.nextDaysTextStyle,
    this.prevMonthTextStyle,
    this.nextMonthTextStyle,
    this.highLightTextStyle,
    this.prevMonthDayBorderColor = Colors.transparent,
    this.thisMonthDayBorderColor = Colors.transparent,
    this.nextMonthDayBorderColor = Colors.transparent,
    this.dayPadding = 2.0,
    this.height = double.infinity,
    this.width = double.infinity,
    this.todayTextStyle,
    this.dayButtonColor = Colors.transparent,
    this.todayBorderColor = Colors.transparent,
    this.todayButtonColor = Colors.transparent,
    this.selectedDateTime,
    this.selectedDayTextStyle,
    this.selectedDayBorderColor = Colors.transparent,
    this.selectedDayButtonColor = Colors.transparent,
    this.daysHaveCircularBorder,
    this.onDayPressed,
    this.weekdayTextStyle,
    this.weekEndDayTextStyle,
    this.iconColor = Colors.blueAccent,
    this.headerTextStyle,
    this.headerText,
    this.weekendTextStyle,
    this.weekendHeaderTextStyle,
    this.markedDates,
    this.markedLightDates,
    @deprecated this.markedDateColor,
    this.markedDateWidget,
    this.headerPadding = const EdgeInsets.symmetric(vertical: 16.0),
    this.headerMargin = const EdgeInsets.symmetric(vertical: 0.0),
    this.weekdayMargin = const EdgeInsets.symmetric(vertical: 16.0),
    this.headerBgColor = Colors.transparent,
    this.childAspectRatio = 1.0,
    this.weekDayMargin = const EdgeInsets.only(bottom: 4.0),
    this.listener,
  });

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<CalendarCarousel> {
  PageController _controller;
  List<DateTime> _dates = List(3);
  int _startWeekday = 0;
  int _endWeekday = 0;

  @override
  initState() {
    super.initState();

    /// setup pageController
    _controller = PageController(
      initialPage: 1,
      keepPage: true,
      viewportFraction: widget.viewportFraction,

      /// width percentage
    );
    this._setDate();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: <Widget>[
          Container(
            color: widget.headerBgColor,
            padding: widget.headerPadding,
            margin: widget.headerMargin,
            child: DefaultTextStyle(
              style: widget.headerTextStyle != null
                  ? widget.headerTextStyle
                  : widget.defaultHeaderTextStyle,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                      onPressed: () => _setDate(page: 0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.keyboard_arrow_left,
                            color: widget.iconColor,
                          ),
                          Text(
                            '${this._dates[0].month}月',
                            style: widget.prevMonthTextStyle != null
                                ? widget.prevMonthTextStyle
                                : widget.defaultPrevMonthTextStyle,
                          ),
                        ],
                      )),
                  Container(
                    child: widget.headerText != null
                        ? widget.headerText
                        : Text(
                            '${this._dates[1].year}年${this._dates[1].month}月',
                          ),
                  ),
                  FlatButton(
                      onPressed: () => _setDate(page: 2),
                      child: Row(
                        children: <Widget>[
                          Text(
                            '${this._dates[2].month}月',
                            style: widget.nextMonthTextStyle != null
                                ? widget.nextMonthTextStyle
                                : widget.defaultNextMonthTextStyle,
                          ),
                          Icon(
                            Icons.keyboard_arrow_right,
                            color: widget.iconColor,
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
          widget.weekDays == null
              ? Container()
              : Container(
                  margin: widget.weekdayMargin,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: this._renderWeekDays(),
                  ),
                ),
          Expanded(
            child: PageView.builder(
              itemCount: 3,
              onPageChanged: (value) {
                this._setDate(page: value);
              },
              controller: _controller,
              itemBuilder: (context, index) {
                return builder(index);
              },
              pageSnapping: true,
            ),
          ),
        ],
      ),
    );
  }

  builder(int slideIndex) {
    double screenWidth = MediaQuery.of(context).size.width;
    int totalItemCount = DateTime(
          this._dates[slideIndex].year,
          this._dates[slideIndex].month + 1,
          0,
        ).day +
        this._startWeekday +
        (7 - this._endWeekday);
    int year = this._dates[slideIndex].year;
    int month = this._dates[slideIndex].month;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double value = 1.0;
        if (_controller.position.haveDimensions) {
          value = _controller.page - slideIndex;
          value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);
        }

        return Center(
          child: SizedBox(
            height: Curves.easeOut.transform(value) * widget.height,
            width: Curves.easeOut.transform(value) * screenWidth,
            child: child,
          ),
        );
      },
      child: Stack(
        children: <Widget>[
          Positioned(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: GridView.count(
                crossAxisCount: 7,
                childAspectRatio: widget.childAspectRatio,
                padding: EdgeInsets.zero,
                children: List.generate(totalItemCount,

                    /// last day of month + weekday
                    (index) {
                  bool isToday =
                      DateTime.now().day == index + 1 - this._startWeekday &&
                          DateTime.now().month == month &&
                          DateTime.now().year == year;
                  bool isSelectedDay = widget.selectedDateTime != null &&
                      widget.selectedDateTime.year == year &&
                      widget.selectedDateTime.month == month &&
                      widget.selectedDateTime.day ==
                          index + 1 - this._startWeekday;
                  bool isPrevMonthDay = index < this._startWeekday;
                  bool isNextMonthDay = index >=
                      (DateTime(year, month + 1, 0).day) + this._startWeekday;
                  bool isThisMonthDay = !isPrevMonthDay && !isNextMonthDay;

                  DateTime now = DateTime(year, month, 1);
                  TextStyle textStyle;
                  TextStyle defaultTextStyle;
                  if (isPrevMonthDay) {
                    now = now
                        .subtract(Duration(days: this._startWeekday - index));
                    textStyle = widget.prevDaysTextStyle;
                    defaultTextStyle = widget.defaultPrevDaysTextStyle;
                  } else if (isThisMonthDay) {
                    now = DateTime(year, month, index + 1 - this._startWeekday);
                    textStyle = isSelectedDay
                        ? widget.selectedDayTextStyle
                        : isToday
                            ? widget.todayTextStyle
                            : widget.daysTextStyle;
                    defaultTextStyle = isSelectedDay
                        ? widget.defaultSelectedDayTextStyle
                        : isToday
                            ? widget.defaultTodayTextStyle
                            : widget.defaultDaysTextStyle;
                  } else {
                    now = DateTime(year, month, index + 1 - this._startWeekday);
                    textStyle = widget.nextDaysTextStyle;
                    defaultTextStyle = widget.defaultNextDaysTextStyle;
                  }
                  bool isHighLightDay = isHighLightDate(now);
                  return Container(
                    margin: EdgeInsets.all(widget.dayPadding),
                    child: Stack(
                      children: <Widget>[
                        _renderMarked(now),
                        Container(
                          height: double.infinity,
                          width: double.infinity,
                          child: FlatButton(
                            color:
                                isSelectedDay && widget.todayBorderColor != null
                                    ? widget.selectedDayBorderColor
                                    : isToday && widget.todayBorderColor != null
                                        ? widget.todayButtonColor
                                        : widget.dayButtonColor,
                            onPressed: () => widget.onDayPressed(DateTime(
                                year, month, index + 1 - this._startWeekday)),
                            padding: EdgeInsets.all(widget.dayPadding),
                            shape: widget.daysHaveCircularBorder == null
                                ? RoundedRectangleBorder()
                                : widget.daysHaveCircularBorder
                                    ? CircleBorder(
                                        side: BorderSide(
                                          color: isPrevMonthDay
                                              ? widget.prevMonthDayBorderColor
                                              : isNextMonthDay
                                                  ? widget
                                                      .nextMonthDayBorderColor
                                                  : isToday &&
                                                          widget.todayBorderColor !=
                                                              null
                                                      ? widget.todayBorderColor
                                                      : widget
                                                          .thisMonthDayBorderColor,
                                        ),
                                      )
                                    : RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: isPrevMonthDay
                                              ? widget.prevMonthDayBorderColor
                                              : isNextMonthDay
                                                  ? widget
                                                      .nextMonthDayBorderColor
                                                  : isToday &&
                                                          widget.todayBorderColor !=
                                                              null
                                                      ? widget.todayBorderColor
                                                      : widget
                                                          .thisMonthDayBorderColor,
                                        ),
                                      ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Center(
                                    child: DefaultTextStyle(
                                      style:
                                          (index % 7 == 0 || index % 7 == 6) &&
                                                  !isSelectedDay &&
                                                  !isToday
                                              ? defaultTextStyle
                                              : isToday
                                                  ? widget.defaultTodayTextStyle
                                                  : defaultTextStyle,
                                      child: Text(
                                        '${now.day}',
                                        style: getDayStyle(
                                            isHighLightDay,
                                            index,
                                            isSelectedDay,
                                            isToday,
                                            isThisMonthDay,
                                            textStyle),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 20.0,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle getDayStyle(bool isHighLightDay, int index, bool isSelectedDay,
      bool isToday, bool isThisMonth, TextStyle textStyle) {
    return isHighLightDay && widget.highLightTextStyle != null && isThisMonth
        ? widget.highLightTextStyle
        : (index % 7 == 0 || index % 7 == 6) &&
                !isSelectedDay &&
                !isToday &&
                widget.weekendTextStyle != null
            ? widget.weekendTextStyle
            : isToday ? widget.todayTextStyle : textStyle;
  }

  void _setDate({
    int page,
  }) {
    if (page == null) {
      /// setup dates
      DateTime date0 =
          DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
      DateTime date1 = DateTime(DateTime.now().year, DateTime.now().month, 1);
      DateTime date2 =
          DateTime(DateTime.now().year, DateTime.now().month + 1, 1);

      this.setState(() {
        /// setup current day
        _startWeekday = date1.weekday;
        _endWeekday = date2.weekday;
        this._dates = [
          date0,
          date1,
          date2,
        ];
      });
    } else if (page == 1) {
      return;
    } else {
      print('page: $page');
      List<DateTime> dates = this._dates;
      print('dateLength: ${dates.length}');
      if (page == 0) {
        dates[2] = DateTime(dates[0].year, dates[0].month + 1, 1);
        dates[1] = DateTime(dates[0].year, dates[0].month, 1);
        dates[0] = DateTime(dates[0].year, dates[0].month - 1, 1);
        page = page + 1;
      } else if (page == 2) {
        dates[0] = DateTime(dates[2].year, dates[2].month - 1, 1);
        dates[1] = DateTime(dates[2].year, dates[2].month, 1);
        dates[2] = DateTime(dates[2].year, dates[2].month + 1, 1);
        page = page - 1;
      }

      this.setState(() {
        _startWeekday = dates[page].weekday;
        _endWeekday = dates[page + 1].weekday;
        this._dates = dates;
      });

      print('dates');
      print(this._dates);

      _controller.animateToPage(page,
          duration: Duration(milliseconds: 1), curve: Threshold(0.0));
      if (widget.listener != null) {
        widget.listener(_dates[1]);
      }
    }
    print('startWeekDay: $_startWeekday');
    print('endWeekDay: $_endWeekday');
  }

  List<Widget> _renderWeekDays() {
    List<Widget> list = [];
    for (var weekDay in widget.weekDays) {
      list.add(
        Expanded(
            child: Container(
          margin: widget.weekDayMargin,
          child: Center(
            child: DefaultTextStyle(
              style: widget.defaultWeekdayTextStyle,
              child: Text(
                weekDay,
                style: (widget.weekDays.indexOf(weekDay) == 0 ||
                            widget.weekDays.indexOf(weekDay) ==
                                widget.weekDays.length - 1) &&
                        widget.weekEndDayTextStyle != null
                    ? widget.weekEndDayTextStyle
                    : widget.weekdayTextStyle,
              ),
            ),
          ),
        )),
      );
    }
    return list;
  }

  Widget _renderMarked(DateTime now) {
    if (now.month == _dates[1].month) {
      if (widget.markedDates != null && widget.markedDates.length > 0) {
        List<DateTime> markedDates = widget.markedDates.map((date) {
          return DateTime(date.year, date.month, date.day);
        }).toList();
        if (markedDates.contains(now)) {
          return widget.markedDateWidget != null
              ? widget.markedDateWidget
              : widget.defaultMarkedDateWidget;
        }
      }
      if (isHighLightDate(now)) {
        return widget.markedDateWidget != null
            ? widget.markedDateWidget
            : widget.markedErrorDateWidget;
      }
    }
    return widget.noMarkedDateWidget;
  }

  bool isHighLightDate(DateTime date) {
    if (widget.markedLightDates != null && widget.markedLightDates.length > 0) {
      List<DateTime> markedDates = widget.markedLightDates.map((date) {
        return DateTime(date.year, date.month, date.day);
      }).toList();
      return markedDates.contains(date);
    }
    return false;
  }
}
