import 'package:clearApp/store/racket/racket_store.dart';
import 'package:clearApp/widget/app_theme.dart';
import 'package:clearApp/widget/appbar.dart';
import 'package:clearApp/widget/toast_generator.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'racket_cardlist.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'custom_filter.dart';
import 'package:selection_menu/selection_menu.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class RacketMenuHomeScreenWithProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<RacketStore>(
      create: (_) => RacketStore(),
      child: RacketMenuHomeScreen(),
    );
  }
}

class RacketMenuHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        CustomAppBar(),
        RacketScrollView(),
      ],
    ));
  }
}

class RacketScrollView extends StatefulWidget {
  RacketScrollView({Key key}) : super(key: key);
  @override
  _RacketScrollView createState() => _RacketScrollView();
}

class _RacketScrollView extends State<RacketScrollView> {
  final ScrollController _scrollController = ScrollController();
  SelectionMenuController selectionMenuController;
  RacketStore racketStore;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      //print('offset = ${_scrollController.offset}');
    });
    selectionMenuController = SelectionMenuController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    racketStore = Provider.of<RacketStore>(context);

    racketStore.disposers
      ..add(autorun((_) {
        if (racketStore.success) {
          racketStore.getRackets();
          ToastGenerator.successToast(
              context, racketStore.successStore.successMessage);
        } else {
          ToastGenerator.errorToast(
              context, racketStore.errorStore.errorMessage);
        }
      }));

    ///racketStore.rackets 에 라켓 정보가 들어있음
    ///위 코드는 check out/ in 이 성공 / 실패 할때마다 토스트를 띄우고, refresh 하는 코드.
    ///shuttle_menu/order_form 을 참고하면 됨.
    ///프로바이더 패턴으로 racketStore을 얻어서, store 의 action 함수를 실행하면 됨.
    ///toast message는 위 코드에서 알아서 띄우므로, UI 쪽에서 코드를 집어넣을 필요 없음.
  }

  @override
  void dispose() {
    racketStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: ClearAppTheme.buildLightTheme().backgroundColor,
        child: Observer(builder: (_) {
          return CustomScrollView(
            scrollDirection: Axis.vertical,
            controller: _scrollController,
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Row(children: <Widget>[
                    SizedBox(width: ScreenUtil().setWidth(70)),
                    CustomFilter(),
                  ]),
                  childCount: 1,
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        RacketCardList(racketStore.rackets[index]),
                    childCount: racketStore.rackets.length,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
