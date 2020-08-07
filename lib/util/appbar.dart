import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_theme.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: ClearAppTheme.buildLightTheme().backgroundColor,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                offset: const Offset(0, 2),
                blurRadius: 8.0),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top, left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                width: AppBar().preferredSize.height + 40,
                height: AppBar().preferredSize.height,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(32.0),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_back),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Clear App',
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'Poppins',
                      color: ClearAppTheme.darkText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Container(
                width: AppBar().preferredSize.height + 40,
                height: AppBar().preferredSize.height,
              ),
            ],
          ),
        ));
  }
}
