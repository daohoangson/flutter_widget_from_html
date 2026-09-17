// CSS Counter Styles Level 3 algorithm engine and predefined style registry.
// https://www.w3.org/TR/css-counter-styles-3/

enum _System { alphabetic, numeric, additive, cyclic }

/// Implements the counter representation algorithm for a single counter style.
class CssCounterStyle {
  final _System _system;
  final List<String> _symbols;
  final List<(int, String)> _additiveSymbols;
  final String suffix;
  final (int, int)? _range; // null = auto
  final (int, String)? _pad; // (minLength, padChar)

  const CssCounterStyle._alphabetic({
    required List<String> symbols,
    this.suffix = '.',
    (int, int)? range,
  })  : _system = _System.alphabetic,
        _symbols = symbols,
        _additiveSymbols = const [],
        _range = range,
        _pad = null;

  const CssCounterStyle._numeric({
    required List<String> symbols,
    this.suffix = '.',
    (int, int)? range,
    (int, String)? pad,
  })  : _system = _System.numeric,
        _symbols = symbols,
        _additiveSymbols = const [],
        _range = range,
        _pad = pad;

  const CssCounterStyle._additive({
    required List<(int, String)> additiveSymbols,
    this.suffix = '.',
    (int, int)? range,
  })  : _system = _System.additive,
        _symbols = const [],
        _additiveSymbols = additiveSymbols,
        _range = range,
        _pad = null;

  const CssCounterStyle._cyclic({
    required List<String> symbols,
  })  : suffix = '',
        _system = _System.cyclic,
        _symbols = symbols,
        _additiveSymbols = const [],
        _range = null,
        _pad = null;

  /// Returns the [CssCounterStyle] for the given [type].
  /// Supports predefined styles and CSS string literals (e.g., '"★"' or "'👉'").
  static CssCounterStyle? lookup(String type) {
    // is it a predefined style?
    final predefined = _styles[type];
    if (predefined != null) {
      return predefined;
    }

    // is it an empty string literal?
    if (type.isEmpty) {
      return null;
    }

    // is it explicitly quoted?
    final isExplicitlyQuoted = type.length >= 2 &&
        ((type.startsWith('"') && type.endsWith('"')) ||
            (type.startsWith("'") && type.endsWith("'")));

    // is it a stripped string literal? (symbols, spaces, emojis)
    final isSymbolOrTextWithSpaces = !RegExp(r'^[a-zA-Z\-]+$').hasMatch(type);

    if (isExplicitlyQuoted || isSymbolOrTextWithSpaces) {
      // strip the quotes if they survived the html parser
      final literal =
          isExplicitlyQuoted ? type.substring(1, type.length - 1) : type;

      // return a dynamic cyclic style for the literal
      return CssCounterStyle._cyclic(symbols: [literal]);
    }

    // unknown style
    return null;
  }

  /// Returns the formatted marker string for counter value [n],
  /// or null if [n] is outside this style's range or unrepresentable.
  String? format(int n) {
    if (!_inRange(n)) {
      return null;
    }
    final rep = _represent(n);
    if (rep == null) {
      return null;
    }

    var result = rep;
    final padSpec = _pad;
    if (padSpec != null) {
      while (result.length < padSpec.$1) {
        result = padSpec.$2 + result;
      }
    }
    return '$result$suffix';
  }

  bool _inRange(int n) {
    final r = _range;
    if (r != null) {
      return n >= r.$1 && n <= r.$2;
    }
    return switch (_system) {
      _System.numeric => true,
      _System.alphabetic => n >= 1,
      _System.additive => n >= 0,
      _System.cyclic => true,
    };
  }

  String? _represent(int n) => switch (_system) {
        _System.alphabetic => _representAlphabetic(n),
        _System.numeric => _representNumeric(n),
        _System.additive => _representAdditive(n),
        _System.cyclic => _representCyclic(n),
      };

  String? _representAlphabetic(int n) {
    if (n < 1) {
      return null;
    }
    final len = _symbols.length;
    if (len < 2) {
      return null;
    }
    var num = n;
    final chars = <String>[];
    while (num > 0) {
      num -= 1;
      chars.add(_symbols[num % len]);
      num = num ~/ len;
    }
    return chars.reversed.join();
  }

  String? _representNumeric(int n) {
    final len = _symbols.length;
    if (len < 2) {
      return null;
    }
    if (n == 0) {
      return _symbols[0];
    }
    final isNeg = n < 0;
    var num = n.abs();
    final chars = <String>[];
    while (num > 0) {
      chars.add(_symbols[num % len]);
      num = num ~/ len;
    }
    final result = chars.reversed.join();
    return isNeg ? '-$result' : result;
  }

  String? _representAdditive(int n) {
    if (n < 0) {
      return null;
    }
    if (n == 0) {
      for (final (w, s) in _additiveSymbols) {
        if (w == 0) {
          return s;
        }
      }
      return null;
    }
    var remaining = n;
    final buf = StringBuffer();
    for (final (weight, sym) in _additiveSymbols) {
      if (weight == 0) {
        break;
      }
      while (remaining >= weight) {
        buf.write(sym);
        remaining -= weight;
      }
      if (remaining == 0) {
        break;
      }
    }
    return remaining == 0 ? buf.toString() : null;
  }

  String? _representCyclic(int n) {
    if (_symbols.isEmpty) {
      return null;
    }
    final index = (n - 1) % _symbols.length;
    final positiveIndex = index < 0 ? index + _symbols.length : index;
    return _symbols[positiveIndex];
  }
}

// --- Predefined counter style instances --------------------------------------

const _decimal = CssCounterStyle._numeric(
  symbols: ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
);

const _decimalLeadingZero = CssCounterStyle._numeric(
  symbols: ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
  pad: (2, '0'),
);

const _binary = CssCounterStyle._numeric(
  symbols: ['0', '1'],
);

const _octal = CssCounterStyle._numeric(
  symbols: ['0', '1', '2', '3', '4', '5', '6', '7'],
);

const _lowerHexadecimal = CssCounterStyle._numeric(
  symbols: [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'a',
    'b',
    'c',
    'd',
    'e',
    'f'
  ],
);

const _upperHexadecimal = CssCounterStyle._numeric(
  symbols: [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F'
  ],
);

const _arabicIndic = CssCounterStyle._numeric(
  symbols: ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'],
);

const _armenian = CssCounterStyle._additive(
  range: (1, 9999),
  additiveSymbols: [
    (9000, 'ք'),
    (8000, 'փ'),
    (7000, 'ւ'),
    (6000, 'ց'),
    (5000, 'ր'),
    (4000, 'տ'),
    (3000, 'վ'),
    (2000, 'ս'),
    (1000, 'ռ'),
    (900, 'ջ'),
    (800, 'պ'),
    (700, 'չ'),
    (600, 'ո'),
    (500, 'շ'),
    (400, 'ն'),
    (300, 'յ'),
    (200, 'մ'),
    (100, 'ճ'),
    (90, 'ղ'),
    (80, 'ձ'),
    (70, 'հ'),
    (60, 'կ'),
    (50, 'ծ'),
    (40, 'խ'),
    (30, 'լ'),
    (20, 'ի'),
    (10, 'ժ'),
    (9, 'թ'),
    (8, 'ը'),
    (7, 'է'),
    (6, 'զ'),
    (5, 'ե'),
    (4, 'դ'),
    (3, 'գ'),
    (2, 'բ'),
    (1, 'ա'),
  ],
);

const _bengali = CssCounterStyle._numeric(
  symbols: ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'],
);

const _cambodian = CssCounterStyle._numeric(
  symbols: ['០', '១', '២', '៣', '៤', '៥', '៦', '៧', '៨', '៩'],
);

const _cjkDecimal = CssCounterStyle._numeric(
  symbols: ['〇', '一', '二', '三', '四', '五', '六', '七', '八', '九'],
  suffix: '、',
);

const _cjkEarthlyBranch = CssCounterStyle._alphabetic(
  symbols: ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'],
  suffix: '、',
);

const _cjkHeavenlyStem = CssCounterStyle._alphabetic(
  symbols: ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'],
  suffix: '、',
);

const _cjkIdeographic = CssCounterStyle._additive(
  range: (-9999, 9999),
  suffix: '、',
  additiveSymbols: [
    (9000, '九千'),
    (8000, '八千'),
    (7000, '七千'),
    (6000, '六千'),
    (5000, '五千'),
    (4000, '四千'),
    (3000, '三千'),
    (2000, '二千'),
    (1000, '一千'),
    (900, '九百'),
    (800, '八百'),
    (700, '七百'),
    (600, '六百'),
    (500, '五百'),
    (400, '四百'),
    (300, '三百'),
    (200, '二百'),
    (100, '一百'),
    (90, '九十'),
    (80, '八十'),
    (70, '七十'),
    (60, '六十'),
    (50, '五十'),
    (40, '四十'),
    (30, '三十'),
    (20, '二十'),
    (10, '一十'),
    (9, '九'),
    (8, '八'),
    (7, '七'),
    (6, '六'),
    (5, '五'),
    (4, '四'),
    (3, '三'),
    (2, '二'),
    (1, '一'),
    (0, '零'),
  ],
);

const _japaneseFormal = CssCounterStyle._additive(
  range: (-9999, 9999),
  suffix: '、',
  additiveSymbols: [
    (9000, '九阡'),
    (8000, '八阡'),
    (7000, '七阡'),
    (6000, '六阡'),
    (5000, '伍阡'),
    (4000, '四阡'),
    (3000, '参阡'),
    (2000, '弐阡'),
    (1000, '壱阡'),
    (900, '九百'),
    (800, '八百'),
    (700, '七百'),
    (600, '六百'),
    (500, '伍百'),
    (400, '四百'),
    (300, '参百'),
    (200, '弐百'),
    (100, '壱百'),
    (90, '九拾'),
    (80, '八拾'),
    (70, '七拾'),
    (60, '六拾'),
    (50, '伍拾'),
    (40, '四拾'),
    (30, '参拾'),
    (20, '弐拾'),
    (10, '壱拾'),
    (9, '九'),
    (8, '八'),
    (7, '七'),
    (6, '六'),
    (5, '伍'),
    (4, '四'),
    (3, '参'),
    (2, '弐'),
    (1, '壱'),
    (0, '零'),
  ],
);

const _simpChineseFormal = CssCounterStyle._additive(
  range: (-9999, 9999),
  suffix: '、',
  additiveSymbols: [
    (9000, '玖仟'),
    (8000, '捌仟'),
    (7000, '柒仟'),
    (6000, '陆仟'),
    (5000, '伍仟'),
    (4000, '肆仟'),
    (3000, '叁仟'),
    (2000, '贰仟'),
    (1000, '壹仟'),
    (900, '玖佰'),
    (800, '捌佰'),
    (700, '柒佰'),
    (600, '陆佰'),
    (500, '伍佰'),
    (400, '肆佰'),
    (300, '叁佰'),
    (200, '贰佰'),
    (100, '壹佰'),
    (90, '玖拾'),
    (80, '捌拾'),
    (70, '柒拾'),
    (60, '陆拾'),
    (50, '伍拾'),
    (40, '肆拾'),
    (30, '叁拾'),
    (20, '贰拾'),
    (10, '壹拾'),
    (9, '玖'),
    (8, '捌'),
    (7, '柒'),
    (6, '陆'),
    (5, '伍'),
    (4, '肆'),
    (3, '叁'),
    (2, '贰'),
    (1, '壹'),
    (0, '零'),
  ],
);

const _tradChineseFormal = CssCounterStyle._additive(
  range: (-9999, 9999),
  suffix: '、',
  additiveSymbols: [
    (9000, '玖仟'),
    (8000, '捌仟'),
    (7000, '柒仟'),
    (6000, '陸仟'),
    (5000, '伍仟'),
    (4000, '肆仟'),
    (3000, '參仟'),
    (2000, '貳仟'),
    (1000, '壹仟'),
    (900, '玖佰'),
    (800, '捌佰'),
    (700, '柒佰'),
    (600, '陸佰'),
    (500, '伍佰'),
    (400, '肆佰'),
    (300, '參佰'),
    (200, '貳佰'),
    (100, '壹佰'),
    (90, '玖拾'),
    (80, '捌拾'),
    (70, '柒拾'),
    (60, '陸拾'),
    (50, '伍拾'),
    (40, '肆拾'),
    (30, '參拾'),
    (20, '貳拾'),
    (10, '壹拾'),
    (9, '玖'),
    (8, '捌'),
    (7, '柒'),
    (6, '陸'),
    (5, '伍'),
    (4, '肆'),
    (3, '參'),
    (2, '貳'),
    (1, '壹'),
    (0, '零'),
  ],
);

const _koreanHangulFormal = CssCounterStyle._additive(
  range: (-9999, 9999),
  suffix: ', ',
  additiveSymbols: [
    (9000, '구천'),
    (8000, '팔천'),
    (7000, '칠천'),
    (6000, '육천'),
    (5000, '오천'),
    (4000, '사천'),
    (3000, '삼천'),
    (2000, '이천'),
    (1000, '일천'),
    (900, '구백'),
    (800, '팔백'),
    (700, '칠백'),
    (600, '육백'),
    (500, '오백'),
    (400, '사백'),
    (300, '삼백'),
    (200, '이백'),
    (100, '일백'),
    (90, '구십'),
    (80, '팔십'),
    (70, '칠십'),
    (60, '육십'),
    (50, '오십'),
    (40, '사십'),
    (30, '삼십'),
    (20, '이십'),
    (10, '일십'),
    (9, '구'),
    (8, '팔'),
    (7, '칠'),
    (6, '육'),
    (5, '오'),
    (4, '사'),
    (3, '삼'),
    (2, '이'),
    (1, '일'),
    (0, '영'),
  ],
);

const _koreanHanjaFormal = CssCounterStyle._additive(
  range: (-9999, 9999),
  suffix: ', ',
  additiveSymbols: [
    (9000, '九仟'),
    (8000, '八仟'),
    (7000, '七仟'),
    (6000, '六仟'),
    (5000, '五仟'),
    (4000, '四仟'),
    (3000, '參仟'),
    (2000, '貳仟'),
    (1000, '壹仟'),
    (900, '九百'),
    (800, '八百'),
    (700, '七百'),
    (600, '六百'),
    (500, '五百'),
    (400, '四百'),
    (300, '參百'),
    (200, '貳百'),
    (100, '壹百'),
    (90, '九拾'),
    (80, '八拾'),
    (70, '七拾'),
    (60, '六拾'),
    (50, '五拾'),
    (40, '四拾'),
    (30, '參拾'),
    (20, '貳拾'),
    (10, '壹拾'),
    (9, '九'),
    (8, '八'),
    (7, '七'),
    (6, '六'),
    (5, '五'),
    (4, '四'),
    (3, '參'),
    (2, '貳'),
    (1, '壹'),
    (0, '零'),
  ],
);

const _koreanHanjaInformal = CssCounterStyle._additive(
  range: (-9999, 9999),
  suffix: ', ',
  additiveSymbols: [
    (9000, '九千'),
    (8000, '八千'),
    (7000, '七千'),
    (6000, '六千'),
    (5000, '五千'),
    (4000, '四千'),
    (3000, '三千'),
    (2000, '二千'),
    (1000, '一千'),
    (900, '九百'),
    (800, '八百'),
    (700, '七百'),
    (600, '六百'),
    (500, '五百'),
    (400, '四百'),
    (300, '三百'),
    (200, '二百'),
    (100, '一百'),
    (90, '九十'),
    (80, '八十'),
    (70, '七十'),
    (60, '六十'),
    (50, '五十'),
    (40, '四十'),
    (30, '三十'),
    (20, '二十'),
    (10, '一十'),
    (9, '九'),
    (8, '八'),
    (7, '七'),
    (6, '六'),
    (5, '五'),
    (4, '四'),
    (3, '三'),
    (2, '二'),
    (1, '一'),
    (0, '零'),
  ],
);

const _devanagari = CssCounterStyle._numeric(
  symbols: ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'],
);

const _georgian = CssCounterStyle._additive(
  range: (1, 19999),
  additiveSymbols: [
    (10000, 'ჵ'),
    (9000, 'ჰ'),
    (8000, 'ჯ'),
    (7000, 'ხ'),
    (6000, 'ჭ'),
    (5000, 'წ'),
    (4000, 'ძ'),
    (3000, 'ც'),
    (2000, 'ჩ'),
    (1000, 'შ'),
    (900, 'ყ'),
    (800, 'ღ'),
    (700, 'ქ'),
    (600, 'ფ'),
    (500, 'უ'),
    (400, 'ტ'),
    (300, 'ს'),
    (200, 'რ'),
    (100, 'ჟ'),
    (90, 'ჳ'),
    (80, 'პ'),
    (70, 'ო'),
    (60, 'ჲ'),
    (50, 'ნ'),
    (40, 'մ'),
    (30, 'լ'),
    (20, 'ი'),
    (10, 'ժ'),
    (9, 'თ'),
    (8, 'ჱ'),
    (7, 'զ'),
    (6, 'ვ'),
    (5, 'ե'),
    (4, 'դ'),
    (3, 'გ'),
    (2, 'բ'),
    (1, 'ա'),
  ],
);

const _gujarati = CssCounterStyle._numeric(
  symbols: ['૦', '૧', '૨', '૩', '૪', '૫', '૬', '૭', '૮', '૯'],
);

const _gurmukhi = CssCounterStyle._numeric(
  symbols: ['੦', '੧', '੨', '੩', '੪', '੫', '੬', '੭', '੮', '੯'],
);

const _hangul = CssCounterStyle._alphabetic(
  symbols: [
    '가',
    '나',
    '다',
    '라',
    '마',
    '바',
    '사',
    '아',
    '자',
    '차',
    '카',
    '타',
    '파',
    '하'
  ],
);

const _hangulConsonant = CssCounterStyle._alphabetic(
  symbols: [
    'ㄱ',
    'ㄴ',
    'ㄷ',
    'ㄹ',
    'ㅁ',
    'ㅂ',
    'ㅅ',
    'ㅇ',
    'ㅈ',
    'ㅊ',
    'ㅋ',
    'ㅌ',
    'ㅍ',
    'ㅎ'
  ],
);

const _hebrew = CssCounterStyle._additive(
  range: (1, 1099),
  additiveSymbols: [
    (400, 'ת'),
    (300, 'ש'),
    (200, 'ר'),
    (100, 'ק'),
    (90, 'צ'),
    (80, 'פ'),
    (70, 'ע'),
    (60, 'ס'),
    (50, 'נ'),
    (40, 'מ'),
    (30, 'ל'),
    (20, 'כ'),
    (10, 'י'),
    (9, 'ט'),
    (8, 'ח'),
    (7, 'ז'),
    (6, 'ו'),
    (5, 'ה'),
    (4, 'ד'),
    (3, 'ג'),
    (2, 'ב'),
    (1, 'א'),
  ],
);

const _hiragana = CssCounterStyle._alphabetic(
  symbols: [
    'あ',
    'い',
    'う',
    'え',
    'お',
    'か',
    'き',
    'く',
    'け',
    'こ',
    'さ',
    'し',
    'す',
    'せ',
    'そ',
    'た',
    'ち',
    'つ',
    'て',
    'と',
    'な',
    'に',
    'ぬ',
    'ね',
    'の',
    'は',
    'ひ',
    'ふ',
    'へ',
    'ほ',
    'ま',
    'み',
    'む',
    'め',
    'も',
    'や',
    'ゆ',
    'よ',
    'ら',
    'り',
    'る',
    'れ',
    'ろ',
    'わ',
    'ゐ',
    'ゑ',
    'を',
    'ん',
  ],
  suffix: '、',
);

const _hiraganaIroha = CssCounterStyle._alphabetic(
  symbols: [
    'い',
    'ろ',
    'は',
    'に',
    'ほ',
    'へ',
    'と',
    'ち',
    'り',
    'ぬ',
    'る',
    'を',
    'わ',
    'か',
    'よ',
    'た',
    'れ',
    'そ',
    'つ',
    'ね',
    'な',
    'ら',
    'む',
    'う',
    'ゐ',
    'の',
    'お',
    'く',
    'や',
    'ま',
    'け',
    'ふ',
    'こ',
    'え',
    'て',
    'あ',
    'さ',
    'き',
    'ゆ',
    'め',
    'み',
    'し',
    'ゑ',
    'ひ',
    'も',
    'せ',
    'す',
  ],
  suffix: '、',
);

const _kannada = CssCounterStyle._numeric(
  symbols: ['೦', '೧', '೨', '೩', '೪', '೫', '೬', '೭', '೮', '೯'],
);

const _katakana = CssCounterStyle._alphabetic(
  symbols: [
    'ア',
    'イ',
    'ウ',
    'エ',
    'オ',
    'カ',
    'キ',
    'ク',
    'ケ',
    'コ',
    'サ',
    'シ',
    'ス',
    'セ',
    'ソ',
    'タ',
    'チ',
    'ツ',
    'テ',
    'ト',
    'ナ',
    'ニ',
    'ヌ',
    'ネ',
    'ノ',
    'ハ',
    'ヒ',
    'フ',
    'ヘ',
    'ホ',
    'マ',
    'ミ',
    'ム',
    'メ',
    'モ',
    'ヤ',
    'ユ',
    'ヨ',
    'ラ',
    'リ',
    'ル',
    'レ',
    'ロ',
    'ワ',
    'ヰ',
    'ヱ',
    'ヲ',
    'ン',
  ],
  suffix: '、',
);

const _katakanaIroha = CssCounterStyle._alphabetic(
  symbols: [
    'イ',
    'ロ',
    'ハ',
    'ニ',
    'ホ',
    'ヘ',
    'ト',
    'チ',
    'リ',
    'ヌ',
    'ル',
    'ヲ',
    'ワ',
    'カ',
    'ヨ',
    'タ',
    'レ',
    'ソ',
    'ツ',
    'ネ',
    'ナ',
    'ラ',
    'ム',
    'ウ',
    'ヰ',
    'ノ',
    'オ',
    'ク',
    'ヤ',
    'マ',
    'ケ',
    'フ',
    'コ',
    'エ',
    'テ',
    'ア',
    'サ',
    'キ',
    'ユ',
    'メ',
    'ミ',
    'シ',
    'ヱ',
    'ヒ',
    'モ',
    'セ',
    'ス',
  ],
  suffix: '、',
);

const _lao = CssCounterStyle._numeric(
  symbols: ['໐', '໑', '໒', '໓', '໔', '໕', '໖', '໗', '໘', '໙'],
);

const _lowerAlpha = CssCounterStyle._alphabetic(
  symbols: [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z',
  ],
);

const _lowerGreek = CssCounterStyle._alphabetic(
  symbols: [
    'α',
    'β',
    'γ',
    'δ',
    'ε',
    'ζ',
    'η',
    'θ',
    'ι',
    'κ',
    'λ',
    'μ',
    'ν',
    'ξ',
    'ο',
    'π',
    'ρ',
    'σ',
    'τ',
    'υ',
    'φ',
    'χ',
    'ψ',
    'ω',
  ],
);

const _lowerRoman = CssCounterStyle._additive(
  range: (1, 3999),
  additiveSymbols: [
    (1000, 'm'),
    (900, 'cm'),
    (500, 'd'),
    (400, 'cd'),
    (100, 'c'),
    (90, 'xc'),
    (50, 'l'),
    (40, 'xl'),
    (10, 'x'),
    (9, 'ix'),
    (5, 'v'),
    (4, 'iv'),
    (1, 'i'),
  ],
);

const _malayalam = CssCounterStyle._numeric(
  symbols: ['൦', '൧', '൨', '൩', '൪', '൫', '൬', '൭', '൮', '൯'],
);

const _mongolian = CssCounterStyle._numeric(
  symbols: ['᠐', '᠑', '᠒', '᠓', '᠔', '᠕', '᠖', '᠗', '᠘', '᠙'],
);

const _myanmar = CssCounterStyle._numeric(
  symbols: ['၀', '၁', '၂', '၃', '၄', '၅', '၆', '၇', '၈', '၉'],
);

const _oriya = CssCounterStyle._numeric(
  symbols: ['୦', '୧', '୨', '୩', '୪', '୫', '୬', '୭', '୮', '୯'],
);

const _persian = CssCounterStyle._numeric(
  symbols: ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'],
);

const _tamil = CssCounterStyle._numeric(
  symbols: ['௦', '௧', '௨', '௩', '௪', '௫', '௬', '௭', '௮', '௯'],
);

const _telugu = CssCounterStyle._numeric(
  symbols: ['౦', '౧', '౨', '౩', '౪', '౫', '౬', '౭', '౮', '౯'],
);

const _thai = CssCounterStyle._numeric(
  symbols: ['๐', '๑', '๒', '๓', '๔', '๕', '๖', '๗', '๘', '๙'],
);

const _tibetan = CssCounterStyle._numeric(
  symbols: ['༠', '၁', '༢', '༣', '༤', '၅', '၆', '၇', '༨', '၉'],
);

const _urdu = CssCounterStyle._numeric(
  symbols: ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'],
);

const _upperAlpha = CssCounterStyle._alphabetic(
  symbols: [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ],
);

const _upperRoman = CssCounterStyle._additive(
  range: (1, 3999),
  additiveSymbols: [
    (1000, 'M'),
    (900, 'CM'),
    (500, 'D'),
    (400, 'CD'),
    (100, 'C'),
    (90, 'XC'),
    (50, 'L'),
    (40, 'XL'),
    (10, 'X'),
    (9, 'IX'),
    (5, 'V'),
    (4, 'IV'),
    (1, 'I'),
  ],
);

const _styles = {
  'decimal': _decimal,
  'decimal-leading-zero': _decimalLeadingZero,
  'binary': _binary,
  'octal': _octal,
  'lower-hexadecimal': _lowerHexadecimal,
  'upper-hexadecimal': _upperHexadecimal,
  'arabic-indic': _arabicIndic,
  'armenian': _armenian,
  'bengali': _bengali,
  'cambodian': _cambodian,
  'khmer': _cambodian,
  'cjk-decimal': _cjkDecimal,
  'cjk-earthly-branch': _cjkEarthlyBranch,
  'cjk-heavenly-stem': _cjkHeavenlyStem,
  'cjk-ideographic': _cjkIdeographic,
  'simp-chinese-informal': _cjkIdeographic,
  'trad-chinese-informal': _cjkIdeographic,
  'japanese-informal': _cjkIdeographic,
  'simp-chinese-formal': _simpChineseFormal,
  'trad-chinese-formal': _tradChineseFormal,
  'japanese-formal': _japaneseFormal,
  'korean-hangul-formal': _koreanHangulFormal,
  'korean-hanja-formal': _koreanHanjaFormal,
  'korean-hanja-informal': _koreanHanjaInformal,
  'devanagari': _devanagari,
  'georgian': _georgian,
  'gujarati': _gujarati,
  'gurmukhi': _gurmukhi,
  'hangul': _hangul,
  'hangul-consonant': _hangulConsonant,
  'hebrew': _hebrew,
  'hiragana': _hiragana,
  'hiragana-iroha': _hiraganaIroha,
  'kannada': _kannada,
  'katakana': _katakana,
  'katakana-iroha': _katakanaIroha,
  'lao': _lao,
  'lower-alpha': _lowerAlpha,
  'lower-armenian': _armenian,
  'lower-greek': _lowerGreek,
  'lower-latin': _lowerAlpha,
  'lower-roman': _lowerRoman,
  'malayalam': _malayalam,
  'mongolian': _mongolian,
  'myanmar': _myanmar,
  'oriya': _oriya,
  'persian': _persian,
  'tamil': _tamil,
  'telugu': _telugu,
  'thai': _thai,
  'tibetan': _tibetan,
  'upper-alpha': _upperAlpha,
  'upper-armenian': _armenian,
  'upper-latin': _upperAlpha,
  'upper-roman': _upperRoman,
  'urdu': _urdu,
};
