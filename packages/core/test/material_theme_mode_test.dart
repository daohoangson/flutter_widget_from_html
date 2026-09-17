import 'package:flutter/cupertino.dart' as flutter_cupertino;
import 'package:flutter/material.dart' as flutter_material;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:material_ui/material_ui.dart' as material_ui;

const _flutterColor = Color(0xFF123456);
const _materialUiColor = Color(0xFFABCDEF);
const _html = '<a href="https://example.com">Link</a>';

void main() {
  testWidgets('auto uses an in-framework MaterialApp', (tester) async {
    await tester.pumpWidget(_flutterApp(const HtmlWidget(_html)));
    expect(_linkColor(tester), _flutterColor);
  });

  testWidgets('auto uses a material_ui MaterialApp', (tester) async {
    await tester.pumpWidget(_materialUiApp(const HtmlWidget(_html)));
    expect(_linkColor(tester), _materialUiColor);
  });

  testWidgets('auto chooses nearest theme in mixed trees', (tester) async {
    await tester.pumpWidget(
      _flutterApp(
        material_ui.Theme(
          data: _materialUiTheme,
          child: const HtmlWidget(_html),
        ),
      ),
    );
    expect(_linkColor(tester), _materialUiColor);

    await tester.pumpWidget(
      _materialUiApp(
        flutter_material.Theme(
          data: _flutterTheme,
          child: const HtmlWidget(_html),
        ),
      ),
    );
    expect(_linkColor(tester), _flutterColor);
  });

  testWidgets('explicit modes ignore the nearer other theme', (tester) async {
    await tester.pumpWidget(
      _flutterApp(
        material_ui.Theme(
          data: _materialUiTheme,
          child: const HtmlWidget(
            _html,
            materialThemeMode: MaterialThemeMode.flutter,
          ),
        ),
      ),
    );
    expect(_linkColor(tester), _flutterColor);

    await tester.pumpWidget(
      _materialUiApp(
        flutter_material.Theme(
          data: _flutterTheme,
          child: const HtmlWidget(
            _html,
            materialThemeMode: MaterialThemeMode.materialUi,
          ),
        ),
      ),
    );
    expect(_linkColor(tester), _materialUiColor);
  });

  testWidgets('theme and mode updates refresh cached HTML', (tester) async {
    final key = GlobalKey<_MutableAppState>();
    await tester.pumpWidget(_MutableApp(key: key));
    expect(_linkColor(tester), _materialUiColor);

    key.currentState!.setMaterialUiColor(const Color(0xFF00AA00));
    await tester.pump();
    expect(_linkColor(tester), const Color(0xFF00AA00));

    key.currentState!.setMode(MaterialThemeMode.flutter);
    await tester.pump();
    expect(_linkColor(tester), _flutterColor);
  });

  testWidgets('no theme and Cupertino-only trees use Flutter fallback', (
    tester,
  ) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: HtmlWidget(_html),
      ),
    );
    expect(
      _linkColor(tester),
      flutter_material.ThemeData.fallback().colorScheme.primary,
    );

    await tester.pumpWidget(
      const flutter_cupertino.CupertinoApp(home: HtmlWidget(_html)),
    );
    // The Material source falls back to Flutter, while Cupertino's inherited
    // default text color keeps its existing CSS precedence.
    expect(_linkColor(tester), flutter_cupertino.CupertinoColors.activeBlue);
  });

  testWidgets('CSS and custom styles override theme color', (tester) async {
    await tester.pumpWidget(
      _materialUiApp(
        HtmlWidget(
          '<a href="/" style="color: red">Inline</a>'
          '<a href="/">Custom</a>',
          customStylesBuilder: (element) =>
              element.text == 'Custom' ? {'color': '#00ff00'} : null,
        ),
      ),
    );
    expect(_spanColor(tester, 'Inline'), const Color(0xFFFF0000));
    expect(_spanColor(tester, 'Custom'), const Color(0xFF00FF00));
  });

  testWidgets('tooltips use the selected Material library', (tester) async {
    const html = '<img src="bad://image" title="Details">';
    await tester.pumpWidget(
      _materialUiApp(
        const HtmlWidget(html, materialThemeMode: MaterialThemeMode.materialUi),
      ),
    );
    expect(find.byType(material_ui.Tooltip), findsOneWidget);
    expect(find.byType(flutter_material.Tooltip), findsNothing);

    await tester.pumpWidget(
      _materialUiApp(
        const HtmlWidget(html, materialThemeMode: MaterialThemeMode.flutter),
      ),
    );
    expect(find.byType(flutter_material.Tooltip), findsOneWidget);
    expect(find.byType(material_ui.Tooltip), findsNothing);
  });

  testWidgets('loading indicators use the selected Material library',
      (tester) async {
    await tester.pumpWidget(
      _materialUiApp(
        Builder(
          builder: (context) => buildMaterialProgressIndicator(
            context,
            mode: MaterialThemeMode.materialUi,
          ),
        ),
      ),
    );
    expect(find.byType(material_ui.CircularProgressIndicator), findsOneWidget);
    expect(
      find.byType(flutter_material.CircularProgressIndicator),
      findsNothing,
    );

    await tester.pumpWidget(
      _materialUiApp(
        Builder(
          builder: (context) => buildMaterialProgressIndicator(
            context,
            mode: MaterialThemeMode.flutter,
          ),
        ),
      ),
    );
    expect(
      find.byType(flutter_material.CircularProgressIndicator),
      findsOneWidget,
    );
    expect(find.byType(material_ui.CircularProgressIndicator), findsNothing);
  });
}

flutter_material.ThemeData get _flutterTheme =>
    flutter_material.ThemeData().copyWith(
      colorScheme: flutter_material.ThemeData().colorScheme.copyWith(
            primary: _flutterColor,
          ),
    );

material_ui.ThemeData get _materialUiTheme => material_ui.ThemeData().copyWith(
      colorScheme: material_ui.ThemeData().colorScheme.copyWith(
            primary: _materialUiColor,
          ),
    );

Widget _flutterApp(Widget child) => flutter_material.MaterialApp(
      theme: _flutterTheme,
      home: flutter_material.Scaffold(body: child),
    );

Widget _materialUiApp(Widget child) => material_ui.MaterialApp(
      theme: _materialUiTheme,
      home: material_ui.Scaffold(body: child),
    );

Color? _linkColor(WidgetTester tester) => _spanColor(tester, 'Link');

Color? _spanColor(WidgetTester tester, String text) {
  Color? result;
  bool visit(InlineSpan span) {
    if (span is TextSpan) {
      if (span.text == text) {
        result = span.style?.color;
        return false;
      }
      for (final child in span.children ?? const <InlineSpan>[]) {
        if (!visit(child)) {
          return false;
        }
      }
    }
    return true;
  }

  for (final richText in tester.widgetList<RichText>(find.byType(RichText))) {
    if (!visit(richText.text)) {
      break;
    }
  }
  return result;
}

class _MutableApp extends StatefulWidget {
  const _MutableApp({super.key});

  @override
  State<_MutableApp> createState() => _MutableAppState();
}

class _MutableAppState extends State<_MutableApp> {
  Color materialUiColor = _materialUiColor;
  MaterialThemeMode mode = MaterialThemeMode.auto;

  void setMaterialUiColor(Color color) =>
      setState(() => materialUiColor = color);

  void setMode(MaterialThemeMode value) => setState(() => mode = value);

  @override
  Widget build(BuildContext context) => flutter_material.MaterialApp(
        theme: _flutterTheme,
        home: material_ui.Theme(
          data: _materialUiTheme.copyWith(
            colorScheme: _materialUiTheme.colorScheme.copyWith(
              primary: materialUiColor,
            ),
          ),
          child: HtmlWidget(_html, materialThemeMode: mode),
        ),
      );
}
