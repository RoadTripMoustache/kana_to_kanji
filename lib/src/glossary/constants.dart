import "package:kana_to_kanji/src/core/constants/kana_type.dart";
import "package:kana_to_kanji/src/core/models/resources/kana.dart";

enum GlossaryTab { hiragana, katakana, kanji, vocabulary }

typedef KanaDisabled = ({Kana kana, bool disabled});
typedef KanaMap = Map<KanaTypes, List<KanaDisabled>>;
