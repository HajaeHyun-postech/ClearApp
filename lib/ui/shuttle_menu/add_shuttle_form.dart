import 'package:clearApp/store/shuttle/shuttle_form_store.dart';
import 'package:clearApp/ui/shuttle_menu/form_button.dart';
import 'package:clearApp/widget/app_theme.dart';
import 'package:clearApp/widget/number_picker.dart';
import 'package:clearApp/widget/toast_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:mobx/mobx.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';

class AddShuttleForm extends StatefulWidget {
  const AddShuttleForm({Key key}) : super(key: key);

  @override
  _AddShuttleFormState createState() => _AddShuttleFormState();
}

class _AddShuttleFormState extends State<AddShuttleForm>
    with TickerProviderStateMixin {
  ScrollController _scrollController;
  ShuttleFormStore shuttleFormStore;

  @override
  void initState() {
    super.initState();

    /*Animation Settings*/
    _scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    shuttleFormStore = Provider.of<ShuttleFormStore>(context);

    shuttleFormStore.disposers
      ..add(reaction((_) => shuttleFormStore.successStore.success, (success) {
        if (success) {
          shuttleFormStore.getRemaining();
          ToastGenerator.successToast(
              context, shuttleFormStore.successStore.successMessage);
        }
      }))
      ..add(reaction((_) => shuttleFormStore.errorStore.error, (error) {
        if (error) {
          ToastGenerator.errorToast(
              context, shuttleFormStore.errorStore.errorMessage);
        }
      }));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    shuttleFormStore.dispose();
    super.dispose();
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

  Row _buildAmountPriceSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
                child: Text('Remaining',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: ScreenUtil().setSp(50),
                        color: ClearAppTheme.grey))),
            SizedBox(height: ScreenUtil().setHeight(40)),
            Container(child: Observer(
              builder: (_) {
                return shuttleFormStore.loading
                    ? JumpingText('...',
                        style: TextStyle(fontSize: ScreenUtil().setSp(100)))
                    : Text('${shuttleFormStore.remaining}',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: ScreenUtil().setSp(95),
                            color: ClearAppTheme.grey));
              },
            )),
          ],
        ),
        Column(
          children: <Widget>[
            Text('Price',
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: ScreenUtil().setSp(50),
                    color: ClearAppTheme.grey)),
            SizedBox(height: ScreenUtil().setHeight(20)),
            NumberPicker(
              initialValue: shuttleFormStore.price,
              maxValue: 20000,
              minValue: 10000,
              step: 500,
              onValue: (value) => shuttleFormStore.price = value,
              valueTextStyle: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: ScreenUtil().setSp(45),
                  color: ClearAppTheme.grey),
            ),
            SizedBox(height: ScreenUtil().setHeight(70)),
            Text('Amount',
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: ScreenUtil().setSp(50),
                    color: ClearAppTheme.grey)),
            SizedBox(height: ScreenUtil().setHeight(20)),
            NumberPicker(
                initialValue: shuttleFormStore.amountAdd,
                maxValue: 100,
                minValue: 1,
                step: 1,
                onValue: (value) => shuttleFormStore.amountAdd = value,
                enablePicker: true,
                valueTextStyle: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: ScreenUtil().setSp(45),
                    color: ClearAppTheme.grey))
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
              _buildAmountPriceSelection(),
              SizedBox(height: ScreenUtil().setHeight(90)),
              FormButton(
                onTap: () => shuttleFormStore.addShuttle(),
                content: 'ADD',
              )
            ],
          ),
        ),
      ],
    );
  }
}
