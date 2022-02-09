import 'dart:convert';

import 'package:demo_app/widgets/popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart'
    as enhanced;
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core;

class Golden extends StatelessWidget {
  final String html;
  final String name;
  final Key targetKey;

  const Golden(this.name, this.html, {Key key, this.targetKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseUrl = Uri.parse('https://www.w3schools.com/html/');
    final isSelectable = context.isSelectable;
    final withEnhanced =
        !isSelectable && RegExp(r'^(AUDIO|IFRAME|SVG|VIDEO)$').hasMatch(name);

    final children = <Widget>[
      if (withEnhanced)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(html),
        )
      else
        Text(html),
      const Divider(),
      if (withEnhanced)
        Text(
          'flutter_widget_from_html_core:\n',
          style: Theme.of(context).textTheme.caption,
        ),
      LimitedBox(
        maxHeight: 400,
        child: isSelectable
            ? enhanced.HtmlWidget(
                html,
                baseUrl: baseUrl,
                isSelectable: true,
              )
            : core.HtmlWidget(
                html,
                baseUrl: baseUrl,
              ),
      ),
    ];

    if (withEnhanced) {
      children.addAll(<Widget>[
        const Divider(),
        Text(
          'flutter_widget_from_html:\n',
          style: Theme.of(context).textTheme.caption,
        ),
        LimitedBox(
          maxHeight: 400,
          child: enhanced.HtmlWidget(
            html,
            baseUrl: baseUrl,
            // ignore: deprecated_member_use
            webView: true,
          ),
        ),
      ]);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: const [
          PopupMenu(
            toggleIsSelectable: true,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: RepaintBoundary(
          key: targetKey,
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: children,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GoldensScreen extends StatefulWidget {
  const GoldensScreen({Key key}) : super(key: key);

  @override
  State<GoldensScreen> createState() => _GoldensState();
}

class _GoldensState extends State<GoldensScreen> {
  Future<List<MapEntry<String, String>>> _goldens;

  final _filter = TextEditingController();
  List<MapEntry<String, String>> _filtered;

  @override
  void initState() {
    super.initState();

    _filter.addListener(_onFilter);

    _goldens = rootBundle.loadStructuredData<List<MapEntry<String, String>>>(
        'test/goldens.json', (value) async {
      final map = jsonDecode(value) as Map;
      final typed = <MapEntry<String, String>>[];
      for (final entry in map.entries) {
        final key = entry.key;
        final value = entry.value;
        if (key is String && value is String) {
          typed.add(MapEntry(key, value));
        }
      }

      return typed;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _filter.removeListener(_onFilter);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('GoldensScreen')),
        body: FutureBuilder<List<MapEntry<String, String>>>(
          builder: (context, snapshot) => snapshot.hasData
              ? _onData(_filtered ?? snapshot.data)
              : snapshot.hasError
                  ? _onError(snapshot.error)
                  : _onLoading(),
          future: _goldens,
        ),
      );

  Widget _buildItem(BuildContext context, MapEntry<String, String> golden) =>
      ListTile(
        title: Text(golden.key),
        subtitle: Text(
          golden.value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => Golden(golden.key, golden.value),
          ),
        ),
      );

  Widget _onData(List<MapEntry<String, String>> goldens) => Column(
        children: [
          ListTile(
            title: TextField(
              controller: _filter,
              autocorrect: false,
              decoration: InputDecoration(
                hintText: 'Filter',
                suffixIcon: _filtered != null
                    ? InkWell(
                        onTap: () => _filter.clear(),
                        child: const Icon(Icons.cancel),
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) =>
                  _buildItem(context, goldens[index]),
              itemCount: goldens.length,
            ),
          ),
        ],
      );

  Widget _onError(Object error) => Center(child: Text('$error'));

  Future<void> _onFilter() async {
    final query = _filter.text;
    if (query.isEmpty) {
      setState(() => _filtered = null);
      return;
    }

    final lowerCased = query.toLowerCase();
    final goldens = await _goldens;
    setState(
      () => _filtered = goldens
          .where((golden) => golden.key.toLowerCase().contains(lowerCased))
          .toList(),
    );
  }

  Widget _onLoading() => const Center(child: CircularProgressIndicator());
}
