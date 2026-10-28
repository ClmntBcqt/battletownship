import 'package:flutter/material.dart';

class EB10Sign extends StatelessWidget {
  const new({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: .all(color: Colors.grey, width: 1),
        borderRadius: .circular(11),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: .all(color: Colors.white, width: 2),
          borderRadius: .circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.red, width: 8),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
          child: format(DefaultTextStyle.of(context).style),
        ),
      ),
    );
  }

  RichText format(TextStyle textStyle) {
    var parts = text.toUpperCase().split(" ").map((e) => e.split("-").toList());

    var spans =
        parts
            .map(
              (words) => TextSpan(
                children:
                    words
                        .map(
                          (wordWithDash) =>
                              _specialFormat(wordWithDash, textStyle) != null
                              ? _specialFormat(wordWithDash, textStyle)!
                              : TextSpan(
                                  text: wordWithDash,
                                  style: isReducible(wordWithDash)
                                      ? TextStyle(
                                          fontSize: textStyle.fontSize! / 1.4,
                                        )
                                      : null,
                                ),
                        )
                        .expand((e) => [e, TextSpan(text: "-")])
                        .toList()
                      ..removeLast(),
              ),
            )
            .expand(
              (e) => [
                e,
                WidgetSpan(child: SizedBox(width: textStyle.fontSize! * .6)),
              ],
            )
            .toList()
          ..removeLast();

    return RichText(
      textAlign: .center,
      text: TextSpan(
        children: spans,
        style: textStyle.copyWith(
          fontFamily: 'L1',
          letterSpacing: textStyle.fontSize! * 0.2,
        ),
      ),
    );
  }

  static const List<String> _reducibleWords = [
    "DU",
    "DE",
    "A",
    "À",
    "AU",
    "AUX",
    "LE",
    "LA",
    "LES",
    "UN",
    "UNE",
    "DES",
    "ET",
    "SOUS",
  ];
  bool isReducible(String p) => _reducibleWords.contains(p);

  TextSpan? _specialFormat(String word, TextStyle textStyle) {
    if (isReducible(word)) {
      return TextSpan(
        text: word,
        style: TextStyle(fontSize: textStyle.fontSize! / 1.4),
      );
    }

    if (word == "SAINT" || word == "ST") {
      return TextSpan(
        text: "S",
        children: [
          WidgetSpan(
            child: Transform.translate(
              offset: Offset(
                -textStyle.fontSize! * .1,
                -textStyle.fontSize! / 3,
              ),
              child: Text(
                "T",
                style: TextStyle(
                  fontSize: textStyle.fontSize! / 1.6,
                  fontWeight: .w900,
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (word == "SUR") {
      return TextSpan(text: "?"); // ? is char for s/ in L1
    }
    return null;
  }
}
