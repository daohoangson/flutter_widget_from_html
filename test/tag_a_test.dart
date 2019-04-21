import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  testWidgets('renders stylings and on tap', (WidgetTester tester) async {
    final html = 'This is a <a href="http://domain.com/href">hyperlink</a>.';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[Padding:(5,10,5,10),child=' +
            '[RichText:(:This is a (#FF0000FF+u+onTap:hyperlink)(:.))]]'));
  });

  testWidgets('renders inner text', (WidgetTester tester) async {
    final html = '<a href="http://domain.com/href">Text</a>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[Padding:(5,10,5,10),child=' +
            '[RichText:(#FF0000FF+u+onTap:Text)]]'));
  });

  testWidgets('renders inline stylings', (WidgetTester tester) async {
    final html = 'This is a <a href="http://domain.com/href" ' +
        'style="color: #f00">hyperlink</a>.';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[Padding:(5,10,5,10),child=' +
            '[RichText:(:This is a (#FFFF0000+u+onTap:hyperlink)(:.))]]'));
  });

  testWidgets('renders inner stylings', (WidgetTester tester) async {
    final html = 'This is a <a href="http://domain.com/href">' +
        '<b><i>hyperlink</i></b>.</a>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[Padding:(5,10,5,10),child=' +
            '[RichText:(:This is a (#FF0000FF+u+onTap:(#FF0000FF+u+i+b+onTap:hyperlink)' +
            '(#FF0000FF+u+onTap:.)))]]'));
  });

  testWidgets('renders IMG tag inside', (WidgetTester tester) async {
    final html = '<a href="http://domain.com/href">' +
        '<img src="http://domain.com/image.png" /></a>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[GestureDetector:child=[Stack:children=' +
            '[Padding:(5,0,5,0),child=[CachedNetworkImage:http://domain.com/image.png]],' +
            '[Positioned:child=[Padding:(10,10,10,10),child=[Icon:]]]]]'));
  });
}
