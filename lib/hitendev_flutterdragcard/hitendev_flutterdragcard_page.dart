import 'package:flutter/material.dart';
import '../colors.dart';
import '../entity.dart';
import '../main_card_widget.dart';

class HitendevFlutterdragcardPage extends StatelessWidget {
  const HitendevFlutterdragcardPage({super.key});

  static final List<CardEntity> _sampleCards = [
    CardEntity('https://picsum.photos/200/300?random=1', 'Card 1'),
    CardEntity('https://picsum.photos/200/300?random=2', 'Card 2'),
    CardEntity('https://picsum.photos/200/300?random=3', 'Card 3'),
    CardEntity('https://picsum.photos/200/300?random=4', 'Card 4'),
    CardEntity('https://picsum.photos/200/300?random=5', 'Card 5'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: CardStackWidget(
        cardList: _sampleCards,
      ),
    );
  }
}
