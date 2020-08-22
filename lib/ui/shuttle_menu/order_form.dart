import 'package:clearApp/routes.dart';
import 'package:clearApp/store/shuttle/shuttle_form_store.dart';
import 'package:clearApp/ui/shuttle_menu/order_button.dart';
import 'package:clearApp/ui/shuttle_menu/usage_select_button.dart';
import 'package:clearApp/widget/app_theme.dart';
import 'package:clearApp/widget/toast_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:mobx/mobx.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';

enum UsageLists {
  Regular_Meeting,
  Personal_Use,
  Training,
  Official_Event,
  Prize
}

class OrderForm extends StatefulWidget {
  final Function onSuccess;

  const OrderForm({Key key, this.onSuccess}) : super(key: key);

  @override
  OrderFormState createState() => OrderFormState();
}

class OrderFormState extends State<OrderForm> with TickerProviderStateMixin {
  ScrollController _scrollController;
  AnimationController _remainingController;
  ShuttleFormStore shuttleFormStore;
  UsageLists _selectedUsage;

  @override
  void initState() {
    super.initState();

    /*Animation Settings*/
    _scrollController = ScrollController();
    _remainingController = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    shuttleFormStore = Provider.of<ShuttleFormStore>(context);

    shuttleFormStore.disposers
      ..add(when((_) => shuttleFormStore.invalidAmount == true, () {
        _remainingController.forward();
        Future.delayed(Duration(milliseconds: 600),
            () => shuttleFormStore.invalidAmount = false);
      }))
      ..add(reaction((_) => shuttleFormStore.amount,
          (_) => shuttleFormStore.getRemaining()))
      ..add(reaction((_) => shuttleFormStore.successStore.success, (_) {
        widget.onSuccess();
        ToastGenerator.successToast(
            context, shuttleFormStore.successStore.successMessage);
        Navigator.of(context).pop();
      }))
      ..add(reaction(
          (_) => shuttleFormStore.errorStore.error,
          (_) => ToastGenerator.errorToast(
              context, shuttleFormStore.errorStore.errorMessage)));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    shuttleFormStore.dispose();
    super.dispose();
  }

  Wrap _buildUsageSelectionRow() {
    return Wrap(
      alignment: WrapAlignment.center,
      runSpacing: 10.0,
      children: <Widget>[
        UsageSelectButton(
          text: 'Personal Use',
          selected: _selectedUsage == UsageLists.Personal_Use,
          onChange: (bool selected) {
            _handleUsageChange(
                selected, 'Personal Use', UsageLists.Personal_Use);
          },
        ),
        SizedBox(width: ScreenUtil().setWidth(35)),
        UsageSelectButton(
          text: 'Regular Meeting',
          selected: _selectedUsage == UsageLists.Regular_Meeting,
          onChange: (bool selected) {
            _handleUsageChange(
                selected, 'Regular Meeting', UsageLists.Regular_Meeting);
          },
        ),
        SizedBox(width: ScreenUtil().setWidth(35)),
        UsageSelectButton(
          text: 'Training',
          selected: _selectedUsage == UsageLists.Training,
          onChange: (bool selected) {
            _handleUsageChange(selected, 'Training', UsageLists.Training);
          },
        ),
        SizedBox(width: ScreenUtil().setWidth(35)),
        UsageSelectButton(
          text: 'Offical Event',
          selected: _selectedUsage == UsageLists.Official_Event,
          onChange: (bool selected) {
            _handleUsageChange(
                selected, 'Offical event', UsageLists.Official_Event);
          },
        ),
        SizedBox(width: ScreenUtil().setWidth(35)),
        UsageSelectButton(
          text: 'Prize',
          selected: _selectedUsage == UsageLists.Prize,
          onChange: (bool selected) {
            _handleUsageChange(selected, 'Prize', UsageLists.Prize);
          },
        )
      ],
    );
  }

  void _handleUsageChange(
      bool selected, String usage, UsageLists selectedUsage) {
    setState(() {
      if (selected) {
        _selectedUsage = selectedUsage;
        shuttleFormStore.setUsageString(usage);
      } else {
        _selectedUsage = null;
        shuttleFormStore.setUsageString('');
      }
    });
  }

  Column _buildAmountSelection(Animation<double> animation) {
    return Column(children: <Widget>[
      AnimatedBuilder(
        animation: animation,
        builder: (buildContext, child) {
          return Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                    left: animation.value + 20.0,
                    right: (20.0 - animation.value) < 0
                        ? 0
                        : 20.0 - animation.value),
                child: Observer(
                  builder: (_) {
                    return Text('Remaining',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: ScreenUtil().setSp(50),
                            color: shuttleFormStore.invalidAmount
                                ? ClearAppTheme.lightRed
                                : ClearAppTheme.grey));
                  },
                ),
              ),
              Container(
                  padding: EdgeInsets.only(
                      top: 15,
                      left: animation.value + 20.0,
                      right: (20.0 - animation.value) < 0
                          ? 0
                          : 20.0 - animation.value),
                  child: Observer(
                    builder: (_) {
                      return shuttleFormStore.loading
                          ? JumpingText('...',
                              style:
                                  TextStyle(fontSize: ScreenUtil().setSp(100)))
                          : Text(shuttleFormStore.remaining.toString(),
                              style: TextStyle(
                                  fontFamily: ClearAppTheme.fontName,
                                  fontSize: ScreenUtil().setSp(100),
                                  color: shuttleFormStore.invalidAmount
                                      ? ClearAppTheme.lightRed
                                      : ClearAppTheme.grey));
                    },
                  )),
            ],
          );
        },
      ),
      SizedBox(height: ScreenUtil().setHeight(48)),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: shuttleFormStore.decrementAmount,
            child: Container(
              decoration: BoxDecoration(
                color: ClearAppTheme.white.withOpacity(0),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Icon(
                  Icons.remove,
                  color: ClearAppTheme.black,
                  size: 24,
                ),
              ),
            ),
          ),
          SizedBox(width: ScreenUtil().setWidth(70)),
          Container(child: Observer(
            builder: (_) {
              return Text(
                shuttleFormStore.amount.toString(),
                style: TextStyle(
                    fontFamily: 'Roboto', fontSize: ScreenUtil().setSp(65)),
              );
            },
          )),
          SizedBox(width: ScreenUtil().setWidth(70)),
          GestureDetector(
            onTap: shuttleFormStore.incrementAmount,
            child: Container(
              decoration: BoxDecoration(
                color: ClearAppTheme.white..withOpacity(0),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Icon(
                  Icons.add,
                  color: ClearAppTheme.black,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 24.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_remainingController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _remainingController.reverse();
            }
          });
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          color: Colors.white,
          child: ListView(
            controller: _scrollController,
            padding: EdgeInsets.all(25.0),
            shrinkWrap: true,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'Select Usage',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: ScreenUtil().setSp(72),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ScreenUtil().setHeight(70)),
              _buildUsageSelectionRow(),
              SizedBox(height: ScreenUtil().setHeight(90)),
              _buildAmountSelection(offsetAnimation),
              SizedBox(height: ScreenUtil().setHeight(90)),
              OrderButton(
                onTap: () => shuttleFormStore.addOrder(),
              )
            ],
          ),
        ),
      ],
    );
  }
}
