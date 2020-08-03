import 'dart:ui';
import 'package:clearApp/util/app_theme.dart';
import 'package:clearApp/util/appbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:logger/logger.dart';
import 'package:numberpicker/numberpicker.dart';
import './data_manage/game_data_handler.dart';
import './data_manage/game_data.dart';
import './data_manage/events.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'game_list_view.dart';

class GamesHomeScreen extends StatefulWidget {
  @override
  _GamesHomeScreenState createState() => _GamesHomeScreenState();
}

class _GamesHomeScreenState extends State<GamesHomeScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;
  List<GameData> gameList = new List();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  Map<String, dynamic> formData = new Map();
  GameDataHandler gameDataHandler;

  bool loadingData;

  void initForm() {
    formData['date'] = DateTime.now();
    formData['time'] = TimeOfDay.now();
    formData['gameType'] = "Personally";
    formData['description'] = '';
    formData['maxCapacity'] = 60;
  }

  @override
  void initState() {
    //Data handling
    registerHandler();
    refreshData();

    //animation controll
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    initForm();
    super.initState();
  }

  void registerHandler() {
    gameDataHandler = new GameDataHandler(context);
    gameDataHandler.registerDataUpdateCallback((list) {
      setState(() {
        loadingData = false;
        gameList = list;
      });
    });
  }

  void refreshData() {
    loadingData = true;
    gameDataHandler.eventHandle(EVENT.RefreshEvent);
  }

  @override
  void dispose() {
    animationController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ClearAppTheme.buildLightTheme(),
      child: Container(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Column(
                  children: <Widget>[
                    CustomAppBar().appBar(context),
                    Expanded(
                      child: NestedScrollView(
                        controller: _scrollController,
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                return Column(
                                  children: <Widget>[
                                    getSearchBarUI(),
                                    getDescriptionUI(),
                                    getTimeDateUI(),
                                  ],
                                );
                              }, childCount: 1),
                            ),
                            SliverPersistentHeader(
                              pinned: true,
                              floating: true,
                              delegate: ContestTabHeader(
                                getFilterBarUI(),
                              ),
                            ),
                          ];
                        },
                        body: Container(
                          color:
                              ClearAppTheme.buildLightTheme().backgroundColor,
                          child: ListView.builder(
                            itemCount: gameList.length,
                            padding: const EdgeInsets.only(top: 8),
                            scrollDirection: Axis.vertical,
                            itemBuilder: !loadingData
                                ? (BuildContext context, int index) {
                                    final int count = gameList.length > 10
                                        ? 10
                                        : gameList.length;
                                    final Animation<double> animation =
                                        Tween<double>(begin: 0.0, end: 1.0)
                                            .animate(CurvedAnimation(
                                                parent: animationController,
                                                curve: Interval(
                                                    (1 / count) * index, 1.0,
                                                    curve:
                                                        Curves.fastOutSlowIn)));
                                    animationController.forward();
                                    return GameListView(
                                      callback: () {},
                                      gameData: gameList[index],
                                      animation: animation,
                                      animationController: animationController,
                                    );
                                  }
                                : (BuildContext context, int index) {
                                    return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Center(
                                            child: Container(
                                              height: 30,
                                              width: 30,
                                              margin: EdgeInsets.all(5),
                                              child: CircularProgressIndicator(
                                                strokeWidth: 3.0,
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                        ClearAppTheme.darkBlue),
                                              ),
                                            ),
                                          ),
                                        ]);
                                  },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getDescriptionUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: ClearAppTheme.buildLightTheme().backgroundColor,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      offset: const Offset(0, 2),
                      blurRadius: 8.0),
                ],
              ),
              child: _buildTodoTextInput(),
            ),
          ),
        ],
      ),
    );
  }

  Widget getTimeDateUI() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      showRoundedDatePicker(
                        context: context,
                        background: Colors.white,
                        theme: ThemeData(
                          primaryColor: ClearAppTheme.darkBlue,
                          accentColor: ClearAppTheme.blue,
                          dialogBackgroundColor: ClearAppTheme.nearlyWhite,
                          textTheme: TextTheme(
                            bodyText1: TextStyle(color: ClearAppTheme.black),
                            caption: TextStyle(color: ClearAppTheme.orange),
                          ),
                          accentTextTheme: TextTheme(
                            bodyText1: TextStyle(color: ClearAppTheme.white),
                          ),
                        ),
                      ).then((newDate) {
                        if (newDate == null) return;

                        setState(() {
                          formData['date'] = newDate;
                        });

                        showRoundedTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                          theme: ThemeData(
                            primaryColor: ClearAppTheme.darkBlue,
                            accentColor: ClearAppTheme.blue,
                            dialogBackgroundColor: ClearAppTheme.nearlyWhite,
                            textTheme: TextTheme(
                              bodyText1: TextStyle(color: ClearAppTheme.black),
                              caption: TextStyle(color: ClearAppTheme.orange),
                            ),
                            accentTextTheme: TextTheme(
                              bodyText1: TextStyle(color: ClearAppTheme.white),
                            ),
                          ),
                        ).then((newTime) {
                          if (newTime == null) return;

                          setState(() {
                            formData['time'] = newTime;
                          });
                        });
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 4, bottom: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Choose date',
                            style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 16,
                                color: Colors.grey.withOpacity(0.8)),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            '${DateFormat("MM/dd").format(formData['date'])} , ${formData['time'].format(context)}',
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              width: 1,
              height: 42,
              color: Colors.grey.withOpacity(0.8),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      showDialog<int>(
                          context: context,
                          builder: (BuildContext context) {
                            return new NumberPickerDialog.integer(
                              minValue: 1,
                              maxValue: 100,
                              initialIntegerValue: formData['maxCapacity'],
                            );
                          }).then((newCapacity) {
                        if (newCapacity == null) return;
                        setState(() {
                          formData['maxCapacity'] = newCapacity;
                        });
                        Logger().i(
                            'max capacity changed : ${formData['maxCapacity']}');
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 4, bottom: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Max Capacity',
                            style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 16,
                                color: Colors.grey.withOpacity(0.8)),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            '${formData['maxCapacity']}',
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: ClearAppTheme.buildLightTheme().backgroundColor,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: DropdownSearch<String>(
                  mode: Mode.MENU,
                  showSelectedItem: true,
                  items: [
                    "Regular Meeting",
                    "Training",
                    'Personally',
                    'Event',
                    'etc'
                  ],
                  hint: "country in menu mode",
                  label: "Selecte game type",
                  onChanged: (String item) {
                    formData['gameType'] = item;
                    Logger().i('gameType changed : ${formData['gameType']}');
                  },
                  selectedItem: formData['gameType'],
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF5B86E5).withOpacity(0.8),
              borderRadius: const BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: const Offset(0, 2),
                    blurRadius: 8.0),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  GameData newGame = new GameData(formData);
                  gameDataHandler.eventHandle(EVENT.MakeGameEvent,
                      newGame: newGame);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(FontAwesomeIcons.plus,
                      size: 20,
                      color: ClearAppTheme.buildLightTheme().backgroundColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getFilterBarUI() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              color: ClearAppTheme.buildLightTheme().backgroundColor,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset: const Offset(0, -2),
                    blurRadius: 8.0),
              ],
            ),
          ),
        ),
        Container(
          color: ClearAppTheme.buildLightTheme().backgroundColor,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '5 games found',
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () => showMaterialModalBottomSheet(
                        expand: false,
                        context: context,
                        builder: (context, scrollController) => Material(
                                child: Theme(
                              data: ClearAppTheme.buildLightTheme(),
                              child: SafeArea(
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 30, right: 30, bottom: 20),
                                      child: createForm())),
                            ))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.add,
                            color: ClearAppTheme.deactivatedText),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Divider(
            height: 1,
          ),
        )
      ],
    );
  }

  Widget createForm() {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      FormBuilder(
        key: _fbKey,
        initialValue: {'dateTime': DateTime.now(), 'gameType': 'Personal'},
        autovalidate: true,
        child: Column(
          children: <Widget>[
            Text('Create Game',
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 20,
                    fontWeight: FontWeight.w600)),
            SizedBox(
              height: 10,
            ),
            Column(
              children: <Widget>[
                FormBuilderDropdown(
                  attribute: "gameType",
                  decoration: InputDecoration(labelText: "Game Type"),
                  hint: Text('Select type'),
                  validators: [FormBuilderValidators.required()],
                  items: [
                    'Regular Meeting',
                    'Training',
                    'Personal',
                    'Event',
                    'etc'
                  ]
                      .map((type) =>
                          DropdownMenuItem(value: type, child: Text("$type")))
                      .toList(),
                ),
                FormBuilderTextField(
                  attribute: "description",
                  decoration:
                      InputDecoration(labelText: "Type game description"),
                ),
                FormBuilderDateTimePicker(
                  attribute: "dateTime",
                  inputType: InputType.both,
                  format: DateFormat("yyyy/MM/dd  HH:mm"),
                  decoration: InputDecoration(labelText: "Date time"),
                ),
                FormBuilderSlider(
                  attribute: "maxCapacity",
                  validators: [FormBuilderValidators.min(1)],
                  min: 0,
                  max: 100,
                  initialValue: 60,
                  divisions: 20,
                  decoration: InputDecoration(labelText: "Max Capacity"),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            )
          ],
        ),
      ),
      Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          gradient: LinearGradient(
            colors: <Color>[
              Color(0xFF36D1DC),
              Color(0xFF5B86E5),
            ],
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (_fbKey.currentState.saveAndValidate()) {
                Logger().i('Create Game button clicked');
                GameData newGame = new GameData(_fbKey.currentState.value);
                gameDataHandler.eventHandle(EVENT.MakeGameEvent,
                    newGame: newGame);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                !false
                    ? Icon(
                        Icons.add,
                        color: Colors.white,
                      )
                    : new CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            ClearAppTheme.white),
                      ),
              ],
            ),
          ),
        ),
      )
    ]);
  }

  Widget _buildTodoTextInput() {
    return TextFormField(
      controller: _textController,
      decoration: InputDecoration(
        labelText: 'Game description',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 2, color: ClearAppTheme.purpleBlue),
        ),
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.all(Radius.circular(4)),
          borderSide: new BorderSide(),
        ),
      ),
      onFieldSubmitted: (String text) {
        formData['description'] = text;
        Logger().i('description saved : ${formData['description']}');
      },
    );
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader(
    this.searchUI,
  );
  final Widget searchUI;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return searchUI;
  }

  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
