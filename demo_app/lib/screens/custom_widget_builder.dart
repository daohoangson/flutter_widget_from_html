import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

const kHtml = '''
<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam ac metus urna. Proin mollis dictum faucibus. Sed tellus leo, aliquam nec gravida sit amet, feugiat nec orci. Nulla eget neque bibendum, gravida elit eget, volutpat purus. Nullam convallis eros neque, ac rhoncus felis pretium a. Maecenas et pulvinar risus. Duis consequat ac magna a ornare. Fusce eget ante efficitur, fermentum turpis id, ullamcorper neque. Duis sed tellus tellus.</p>
<div class="carousel">
  <div class="image">
    <img src="https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&fit=crop&w=1600&height=900" />
  </div>
  <div class="image">
    <img src="https://images.unsplash.com/photo-1541781774459-bb2af2f05b55?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&fit=crop&w=1600&height=900" />
  </div>
  <div class="image">
    <img src="https://images.unsplash.com/photo-1494256997604-768d1f608cac?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&fit=crop&w=1600&height=900" />
  </div>
  <div class="image">
    <img src="https://images.unsplash.com/photo-1515002246390-7bf7e8f87b54?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&fit=crop&w=1600&height=900" />
  </div>
  <div class="image">
    <img src="https://images.unsplash.com/photo-1519052537078-e6302a4968d4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&fit=crop&w=1600&height=900" />
  </div>
</div>
<p>Proin in ex sed ipsum ullamcorper laoreet at eget elit. In euismod vehicula orci, luctus fermentum eros egestas at. Proin est tortor, egestas id sodales at, feugiat a lacus. Nulla bibendum sed purus vitae auctor. Maecenas vitae erat velit. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Suspendisse mattis ex eget mauris lobortis, ut tincidunt arcu fringilla. Suspendisse ultrices ex tortor, at lobortis felis elementum at. Nunc laoreet sed dui nec gravida. Proin non ipsum augue.</p>
''';

class CustomWidgetBuilderScreen extends StatelessWidget {
  const CustomWidgetBuilderScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('CustomStylesBuilderScreen'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: HtmlWidget(
              kHtml,
              customWidgetBuilder: (e) {
                if (!e.classes.contains('carousel')) return null;

                final srcs = <String>[];
                for (final child in e.children) {
                  for (final grandChild in child.children) {
                    srcs.add(grandChild.attributes['src']);
                  }
                }

                return CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 500),
                    autoPlayInterval: const Duration(seconds: 2),
                    enlargeCenterPage: true,
                  ),
                  items: srcs.map(_toItem).toList(growable: false),
                );
              },
            ),
          ),
        ),
      );

  static Widget _toItem(String src) => Center(
        child: Image.network(src, fit: BoxFit.cover, width: 1000),
      );
}
