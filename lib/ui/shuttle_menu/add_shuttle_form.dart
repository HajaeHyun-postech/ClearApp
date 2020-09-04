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
        }
      }));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    shuttleFormStore.dispose();
    super.dispose();
  }

  Row _buildAmountPriceSelection() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: ScreenUtil().setWidth(180)),
          child: Column(
            children: <Widget>[
              Text('Price',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: ScreenUtil().setSp(65),
                      color: ClearAppTheme.grey)),
              SizedBox(height: ScreenUtil().setHeight(30)),
              NumberPicker(
                initialValue: shuttleFormStore.price,
                maxValue: 20000,
                minValue: 10000,
                step: 500,
                onValue: (value) => shuttleFormStore.price = value,
                enablePicker: true,
                valueTextStyle: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: ScreenUtil().setSp(50),
                    color: ClearAppTheme.grey),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(130),
              right: ScreenUtil().setWidth(40)),
          child: Column(
            children: <Widget>[
              Text('Amount',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: ScreenUtil().setSp(65),
                      color: ClearAppTheme.grey)),
              SizedBox(height: ScreenUtil().setHeight(30)),
              NumberPicker(
                  initialValue: shuttleFormStore.amountAdd,
                  maxValue: 100,
                  minValue: 1,
                  step: 1,
                  onValue: (value) => shuttleFormStore.amountAdd = value,
                  enablePicker: true,
                  valueTextStyle: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: ScreenUtil().setSp(50),
                      color: ClearAppTheme.grey))
            ],
          ),
        ),
      ],
    );
  }

  Column _buildRemaining() {
    return Column(
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
              _buildRemaining(),
              SizedBox(height: ScreenUtil().setHeight(90)),
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
