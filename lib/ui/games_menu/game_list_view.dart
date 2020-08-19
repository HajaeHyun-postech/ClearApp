import 'package:flutter/material.dart';

import './data_manage/game_data.dart';
import 'game_expansion_card.dart';

class GameListView extends StatelessWidget {
  const GameListView({
    Key key,
    this.gameData,
    this.animationController,
    this.animation,
  }) : super(key: key);

  final GameData gameData;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 8, bottom: 16),
              child: GameExpansionCard(
                initiallyExpanded: false,
                gameData: gameData,
              ),
            ),
          ),
        );
      },
    );
  }
}
