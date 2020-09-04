import 'package:clearApp/store/game/game_store.dart';
import 'package:clearApp/ui/game_menu/game_theme.dart';
import 'package:clearApp/vo/user/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameHomeWithProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<GameStore>(
      create: (_) => GameStore(),
      child: GameHome(user: ModalRoute.of(context).settings.arguments),
    );
  }
}

class GameHome extends StatefulWidget {
  final User user;

  const GameHome({Key key, this.user}) : super(key: key);

  @override
  GameHomeState createState() => GameHomeState();
}

class GameHomeState extends State<GameHome> {
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
