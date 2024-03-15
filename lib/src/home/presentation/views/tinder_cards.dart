import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:tdd_education_app/core/extensions/context_extension.dart';
import 'package:tdd_education_app/core/res/media_resources.dart';
import 'package:tdd_education_app/src/home/presentation/views/tinder_card.dart';

class TinderCards extends StatefulWidget {
  const TinderCards({super.key});

  @override
  State<TinderCards> createState() => _TinderCardsState();
}

class _TinderCardsState extends State<TinderCards>
    with SingleTickerProviderStateMixin {
  final CardController cardController = CardController();

  int totalCards = 10;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        // the same size
        width: context.width,
        height: context.width,
        child: TinderSwapCard(
          totalNum: totalCards,
          swipeEdge: 4,
          maxWidth: context.width,
          maxHeight: context.width * .9,
          minWidth: context.width * .71,
          minHeight: context.width * .85,
          allowSwipe: false,
          cardController: cardController,
          swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
            //Get card alignment
            if (align.x < 0) {
              // swipe left
            } else if (align.x > 0) {
              // swipe right
            }
          },
          swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
            // if the card was the last card, add more cards to be swiped
            if (index == totalCards - 1) {
              setState(() {
                totalCards += 10;
              });
            }
          },
          cardBuilder: (context, index) {
            final isFirst = index == 0;
            final colorByIndex =
                index == 1 ? const Color(0xFFDA92FC) : const Color(0xFFDC95FB);
            return Stack(
              children: [
                Positioned(
                  bottom: 110,
                  right: 0,
                  left: 0,
                  child: TinderCard(
                    isFirst: isFirst,
                    color: isFirst ? null : colorByIndex,
                  ),
                ),
                if (isFirst)
                  Positioned(
                    bottom: 130,
                    right: 20,
                    child: Image.asset(
                      MediaRes.microscope,
                      height: 180,
                      width: 149,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
