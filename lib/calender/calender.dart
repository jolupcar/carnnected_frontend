import 'package:mosigg/calender/utils.dart';
import 'package:mosigg/components.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calenderpage extends StatefulWidget {
  final String id;
  const Calenderpage({Key? key, required this.id}) : super(key: key);

  @override
  State<Calenderpage> createState() => _CalenderpageState();
}

class _CalenderpageState extends State<Calenderpage> {
  late String id;
  Future<List>? events;
  List? eventlist;
  late final ValueNotifier<List<Event>> _selectedEvents;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  Future getEvents(String id) async {
    events = eventdata(id);
    eventlist = await events;

    print('eventlist: ' + '$eventlist');
  }

  Future initEvents() async {
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void initState() {
    super.initState();
    id = widget.id;

    getEvents(id);
    initEvents();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: text('일정', 18.0, FontWeight.w500, Colors.black),
      ),
      body: FutureBuilder(
          future: eventdata(id), 
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData == false) {
              return Container(height: 100);
            } else if (snapshot.hasError) {
              return Container(
                height: 100,
              );
            } else {
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                    child: TableCalendar<Event>(
                      headerStyle: HeaderStyle(
                          titleCentered: true,
                          formatButtonVisible: false,
                          headerPadding: EdgeInsets.zero,
                          titleTextStyle: TextStyle(
                              fontFamily: 'NotoSansKR',
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500)),
                      calendarStyle: CalendarStyle(
                        markersAnchor: 1.3,
                        markerSizeScale: 0.18,
                        isTodayHighlighted: true,
                        outsideDaysVisible: true,
                        cellMargin: EdgeInsets.all(0.0),
                        weekendTextStyle: TextStyle(
                            fontFamily: 'NotoSansKR',
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400),
                        holidayTextStyle: TextStyle(
                            fontFamily: 'NotoSansKR',
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400),
                        selectedDecoration: BoxDecoration(
                            color: Color(0xff001a5d),
                            shape: BoxShape.rectangle),
                        todayDecoration: BoxDecoration(
                            color: Color(0xff001a5d),
                            shape: BoxShape.rectangle),
                      ),
                      rangeSelectionMode: _rangeSelectionMode,
                      eventLoader: _getEventsForDay,
                      startingDayOfWeek: StartingDayOfWeek.sunday,
                      onRangeSelected: _onRangeSelected,
                      onDaySelected: _onDaySelected,
                      selectedDayPredicate: (DateTime date) {
                        return isSameDay(_selectedDay, date);
                      },
                      firstDay: DateTime.utc(2022, 01, 01),
                      lastDay: DateTime.utc(2022, 12, 31),
                      focusedDay: _focusedDay,
                      rangeStartDay: _rangeStart,
                      rangeEndDay: _rangeEnd,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: ValueListenableBuilder<List<Event>>(
                      valueListenable: _selectedEvents,
                      builder: (context, value, child) {
                        return ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 4.0,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                      height: 54.0,
                                      width: 52.0,
                                      decoration: BoxDecoration(
                                          color: Color(0xff001a5d)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          text('${value[index].carnumber.substring(0,value[index].carnumber.length-4)}', 14.0, FontWeight.bold,
                                              Colors.white),
                                          text('${value[index].carnumber.substring(value[index].carnumber.length-4,)}', 14.0, FontWeight.bold,
                                              Colors.white),
                                        ],
                                      )),
                                  Container(
                                    height: 54.0,
                                    width: 335,
                                    decoration: BoxDecoration(),
                                    child: ListTile(
                                      onTap: () {
                                        print('${value[index]}');
                                      },
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              text(
                                                  '${value[index]}',
                                                  14.0,
                                                  FontWeight.w500,
                                                  Colors.black),
                                              SizedBox(height: 5.0),
                                              text(
                                                  '${value[index].time}',
                                                  12.0,
                                                  FontWeight.w400,
                                                  Colors.black),
                                            ],
                                          ),
                                          Icon(
                                            Icons.navigate_next,
                                            size: 50,
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              );
            }
          })
    );
  }
}