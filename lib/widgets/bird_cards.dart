import 'dart:math';

import 'package:birdz/widgets/bird_card.dart';
import 'package:flutter/material.dart';

List<Alignment> cardsAlign = [
  Alignment(0.0, 0.0),
];

class BirdCards extends StatefulWidget {
  final BuildContext context;
  BirdCards(this.context);

  @override
  _BirdCardsState createState() => _BirdCardsState(
      cardSize: Size(MediaQuery.of(context).size.width * 0.9,
          MediaQuery.of(context).size.height * 0.6));
}

class _BirdCardsState extends State<BirdCards>
    with SingleTickerProviderStateMixin {
  final Size cardSize;
  int cardsCounter = 0;

  List<BirdCard> cards = List();
  AnimationController _controller;

  final Alignment defaultFrontCardAlign = Alignment(0.0, 0.0);
  Alignment frontCardAlign = Alignment(0.0, 0.0);
  double frontCardRotation = 0.0;

  _BirdCardsState({@required this.cardSize});

  @override
  void initState() {
    super.initState();

    // Init cards
    for (cardsCounter = 0; cardsCounter < 2; cardsCounter++) {
      cards.add(BirdCard(assetName: 'bird.jpg'));
    }

    // Init the animation controller
    _controller =
        AnimationController(duration: Duration(milliseconds: 700), vsync: this);
    _controller.addListener(() => setState(() {}));
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) changeCardsOrder();
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    // Add what the user swiped in the last frame to the alignment of the card
    setState(() {
      frontCardAlign = Alignment(
          frontCardAlign.x +
              20 * details.delta.dx / MediaQuery.of(context).size.width,
          frontCardAlign.y +
              8 * details.delta.dy / MediaQuery.of(context).size.height);

      frontCardRotation = frontCardAlign.x;
    });
  }

  void _onPanEnd(_) {
    // If the front card was swiped far enough to count as swiped
    if (frontCardAlign.x > 3.0 || frontCardAlign.x < -3.0) {
      animateCards();
    } else {
      // Return to the initial rotation and alignment
      setState(() {
        frontCardAlign = defaultFrontCardAlign;
        frontCardRotation = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Stack(
      children: <Widget>[
        backCard(),
        frontCard(),
        // Prevent swiping if the cards are animating
        _controller.status != AnimationStatus.forward
            ? SizedBox.expand(
                child: GestureDetector(
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                ),
              )
            : Container(),
      ],
    ));
  }

  Widget backCard() {
    return Align(
      alignment: _controller.status == AnimationStatus.forward
          // ? CardsAnimation.backCardAlignmentAnim(_controller).value
          ? cardsAlign[0]
          : cardsAlign[0],
      child: SizedBox.fromSize(
        size: _controller.status == AnimationStatus.forward
            //? CardsAnimation.backCardSizeAnim(_controller).value
            ? cardSize
            : cardSize,
        child: cards[1],
      ),
    );
  }

  Widget frontCard() {
    return Align(
        alignment: _controller.status == AnimationStatus.forward
            // ? CardsAnimation.frontCardDisappearAlignmentAnim(_controller, frontCardAlign) .value
            ? frontCardAlign
            : frontCardAlign,
        child: Transform.rotate(
          angle: (pi / 180.0) * frontCardRotation,
          child: SizedBox.fromSize(size: cardSize, child: cards[0]),
        ));
  }

  void changeCardsOrder() {
    setState(() {
      cards[0] = cards[1];
      cards[1] = BirdCard(assetName: 'bird.jpg');

      frontCardAlign = defaultFrontCardAlign;
      frontCardRotation = 0.0;
    });
  }

  void animateCards() {
    _controller.stop();
    _controller.value = 0.0;
    _controller.forward();
  }
}

/*
class CardsAnimation {
  final Size cardSize;

  CardsAnimation({@required this.cardSize});

  static Animation<Alignment> backCardAlignmentAnim(
      AnimationController parent) {
    return AlignmentTween(begin: cardsAlign[1], end: cardsAlign[2]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.2, 0.5, curve: Curves.easeIn)));
  }

  static Animation<Size> backCardSizeAnim(AnimationController parent) {
    return SizeTween(begin: cardSize, end: cardSize).animate(CurvedAnimation(
        parent: parent, curve: Interval(0.2, 0.5, curve: Curves.easeIn)));
  }

  static Animation<Alignment> frontCardDisappearAlignmentAnim(
      AnimationController parent, Alignment beginAlign) {
    return AlignmentTween(
            begin: beginAlign,
            end: Alignment(
                beginAlign.x > 0 ? beginAlign.x + 30.0 : beginAlign.x - 30.0,
                0.0) // Has swiped to the left or right?
            )
        .animate(CurvedAnimation(
            parent: parent, curve: Interval(0.0, 0.5, curve: Curves.easeIn)));
  }
}
*/
