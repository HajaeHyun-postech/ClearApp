import 'package:clearApp/widget/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: camel_case_types
class Toast_generator {
  @deprecated
  static showSuccessToast(BuildContext context, String decs) {
    Future.delayed(Duration(milliseconds: 0), () {
      if (decs != null && decs.isNotEmpty) {
        showToast(
          decs,
          context: context,
          animation: StyledToastAnimation.slideFromBottom,
          reverseAnimation: StyledToastAnimation.fade,
          position: StyledToastPosition.bottom,
          animDuration: Duration(seconds: 1),
          duration: Duration(seconds: 2),
          curve: Curves.elasticOut,
          reverseCurve: Curves.linear,
          backgroundColor: ClearAppTheme.green.withOpacity(0.8),
          textStyle: TextStyle(
            fontSize: ScreenUtil().setSp(45),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            color: Color(0xFFFFFFFF),
          ),
        );
      }
    });

    return SizedBox.shrink();
  }

  @deprecated
  static showInfoToast(BuildContext context, String decs) {
    Future.delayed(Duration(milliseconds: 0), () {
      if (decs != null && decs.isNotEmpty) {
        showToast(
          decs,
          context: context,
          animation: StyledToastAnimation.slideFromBottom,
          reverseAnimation: StyledToastAnimation.fade,
          position: StyledToastPosition.bottom,
          animDuration: Duration(seconds: 1),
          duration: Duration(seconds: 2),
          curve: Curves.elasticOut,
          reverseCurve: Curves.linear,
          backgroundColor:
              Color(0xFFF45C43).withOpacity(0.7), // TODO : fix color fit
          textStyle: TextStyle(
            fontSize: ScreenUtil().setSp(45),
            fontFamily: 'Poppins',
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.w500,
          ),
        );
      }
    });

    return SizedBox.shrink();
  }

  @deprecated
  static showErrorToast(BuildContext context, String decs) {
    Future.delayed(Duration(milliseconds: 0), () {
      if (decs != null && decs.isNotEmpty) {
        showToast(
          decs,
          context: context,
          animation: StyledToastAnimation.slideFromBottom,
          reverseAnimation: StyledToastAnimation.fade,
          position: StyledToastPosition.bottom,
          animDuration: Duration(seconds: 1),
          duration: Duration(seconds: 2),
          curve: Curves.elasticOut,
          reverseCurve: Curves.linear,
          backgroundColor: Color(0xFFF45C43).withOpacity(0.8),
          textStyle: TextStyle(
            fontSize: ScreenUtil().setSp(45),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            color: Color(0xFFFFFFFF),
          ),
        );
      }
    });

    return SizedBox.shrink();
  }

  static void errorToast(BuildContext context, String decs) {
    if (decs != null && decs.isNotEmpty) {
      showToast(
        decs,
        context: context,
        animation: StyledToastAnimation.slideFromBottom,
        reverseAnimation: StyledToastAnimation.fade,
        position: StyledToastPosition.bottom,
        animDuration: Duration(seconds: 1),
        duration: Duration(seconds: 2),
        curve: Curves.elasticOut,
        reverseCurve: Curves.linear,
        backgroundColor: Color(0xFFF45C43).withOpacity(0.8),
        textStyle: TextStyle(
          fontSize: ScreenUtil().setSp(45),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          color: Color(0xFFFFFFFF),
        ),
      );
    }
  }

  static void successToast(BuildContext context, String decs) {
    if (decs != null && decs.isNotEmpty) {
      showToast(
        decs,
        context: context,
        animation: StyledToastAnimation.slideFromBottom,
        reverseAnimation: StyledToastAnimation.fade,
        position: StyledToastPosition.bottom,
        animDuration: Duration(seconds: 1),
        duration: Duration(seconds: 2),
        curve: Curves.elasticOut,
        reverseCurve: Curves.linear,
        backgroundColor: ClearAppTheme.green.withOpacity(0.8),
        textStyle: TextStyle(
          fontSize: ScreenUtil().setSp(45),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          color: Color(0xFFFFFFFF),
        ),
      );
    }
  }

  static void infoToast(BuildContext context, String decs) {
    if (decs != null && decs.isNotEmpty) {
      showToast(
        decs,
        context: context,
        animation: StyledToastAnimation.slideFromBottom,
        reverseAnimation: StyledToastAnimation.fade,
        position: StyledToastPosition.bottom,
        animDuration: Duration(seconds: 1),
        duration: Duration(seconds: 2),
        curve: Curves.elasticOut,
        reverseCurve: Curves.linear,
        backgroundColor:
            Color(0xFFF45C43).withOpacity(0.7), // TODO : fix color fit
        textStyle: TextStyle(
          fontSize: ScreenUtil().setSp(45),
          fontFamily: 'Poppins',
          color: Color(0xFFFFFFFF),
          fontWeight: FontWeight.w500,
        ),
      );
    }
  }
}
