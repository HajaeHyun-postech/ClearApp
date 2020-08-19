import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

import './data_manage/events.dart';
import './data_manage/game_data.dart';
import '../../util/app_theme.dart';
import '../../widget/appbar.dart';
import '../login/login_info.dart';
import 'data_manage/game_data_subject.dart';
import 'game_list_view.dart';

class GamesHomeScreenWithProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GameDataSubject>(
      create: (context) => GameDataSubject(context),
      child: GamesHomeScreen(),
    );
  }
}

class GamesHomeScreen extends StatefulWidget {
  @override
  _GamesHomeScreenState createState() => _GamesHomeScreenState();
}

class _GamesHomeScreenState extends State<GamesHomeScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    //animation controll
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameDataSubject = Provider.of<GameDataSubject>(context);

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
                    CustomAppBar(),
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
                          child: gameDataSubject.isFeching
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                      Center(
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          margin: EdgeInsets.all(5),
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3.0,
                                            valueColor: AlwaysStoppedAnimation(
                                                ClearAppTheme.darkBlue),
                                          ),
                                        ),
                                      ),
                                    ])
                              : StickyGroupedListView<GameData, bool>(
                                  elements: gameDataSubject.gameDataList,
                                  groupBy: (gameData) => gameData
                                      .participantList
                                      .contains(LoginInfo()),
                                  floatingHeader: true,
                                  groupSeparatorBuilder: (GameData gameData) =>
                                      Container(
                                    height: 50,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: 120,
                                        decoration: BoxDecoration(
                                          color: Colors.blue[300],
                                          border: Border.all(
                                            color: Colors.blue[300],
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '${gameData.participantList.contains(LoginInfo())}',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  indexedItemBuilder:
                                      (context, element, index) {
                                    final int count =
                                        gameDataSubject.gameDataList.length;
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
                                      gameData:
                                          gameDataSubject.gameDataList[index],
                                      animation: animation,
                                      animationController: animationController,
                                    );
                                  },
                                  order: StickyGroupedListOrder.DESC,
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
                            ' ',
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
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 4, bottom: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            ' ',
                            style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 16,
                                color: Colors.grey.withOpacity(0.8)),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            ' ',
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
                )),
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
                        fontSize: 15,
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
    final gameDataProvider = Provider.of<GameDataSubject>(context);

    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      FormBuilder(
        key: _fbKey,
        initialValue: {
          'dateTime': DateTime.now(),
          'gameType': 'Personal',
          'location': '체육관'
        },
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
                FormBuilderTextField(
                  attribute: "location",
                  decoration: InputDecoration(labelText: "Type location"),
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
                gameDataProvider.eventHandle(EVENT.MakeGameEvent,
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
