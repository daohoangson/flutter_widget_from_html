import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  testWidgets('renders IMG tag', (WidgetTester tester) async {
    final sizingConstraints = 'height≥0.0,height=auto,width≥0.0,width=auto';
    final src = 'http://domain.com/image.png';
    final html = '<img src="$src" />';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals('[CssSizing:$sizingConstraints,child='
          '[CachedNetworkImage:imageUrl=$src]'
          ']'),
    );
  });
}
