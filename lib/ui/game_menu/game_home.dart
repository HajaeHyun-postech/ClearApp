import 'package:clearApp/store/game/game_store.dart';
import 'package:clearApp/ui/game_menu/game_theme.dart';
import 'package:clearApp/vo/user/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameHome extends StatefulWidget {
  const GameHome({Key key}) : super(key: key);

  @override
  GameHomeState createState() => GameHomeState();
}

class GameHomeState extends State<GameHome> {
  User user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    user = ModalRoute.of(context).settings.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
