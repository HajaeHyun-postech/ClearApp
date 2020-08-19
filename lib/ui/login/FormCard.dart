import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'login_auth.dart';

class FormCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginAuth = Provider.of<LoginAuth>(context);

    return new Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 1),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 15.0),
                blurRadius: 15.0),
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, -10.0),
                blurRadius: 10.0),
          ]),
      child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: FormBuilder(
            key: loginAuth.fbKey,
            initialValue: {
              'povisId': 'yshajae',
              'studentId': '20180673',
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Login",
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(60),
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                        letterSpacing: .6)),
                FormBuilderTextField(
                  attribute: "povisId",
                  decoration: InputDecoration(
                      labelText: "Povis Id",
                      labelStyle: TextStyle(
                        fontSize: ScreenUtil().setSp(50),
                        fontFamily: "WorkSans",
                      )),
                  validators: [
                    FormBuilderValidators.required(),
                  ],
                  valueTransformer: (value) =>
                      value.replaceAll("\t", "").replaceAll(" ", ""),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(30),
                ),
                FormBuilderTextField(
                  valueTransformer: (value) => int.parse(value),
                  attribute: "studentId",
                  decoration: InputDecoration(
                      labelText: "Student Id",
                      labelStyle: TextStyle(
                        fontSize: ScreenUtil().setSp(50),
                        fontFamily: "WorkSans",
                      )),
                  validators: [
                    FormBuilderValidators.pattern(r'^\d{8}',
                        errorText: 'Invalid student Id'),
                  ],
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(70),
                ),
              ],
            ),
          )),
    );
  }
}
