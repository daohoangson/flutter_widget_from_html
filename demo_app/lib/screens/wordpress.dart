import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class WordpressScreen extends StatelessWidget {
  final sites = {
    'TechCrunch': 'techcrunch.com',
    'The Mozilla Blog': 'blog.mozilla.org',
  };

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('WordPressScreen'),
        ),
        body: ListView(
          children: sites.entries
              .map((e) => ListTile(
                    onTap: () => PostsScreen.pushRoute(context, e.key, e.value),
                    subtitle: Text(e.value),
                    title: Text(e.key),
                  ))
              .toList(growable: false),
        ),
      );
}

class PostsScreen extends StatelessWidget {
  final String domain;
  final String title;

  const PostsScreen(this.domain, {Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext _) => Scaffold(
        appBar: AppBar(title: Text(title ?? domain)),
        body: _PostsList('https://$domain/wp-json/wp/v2/posts?_embed'),
      );

  static void pushRoute(BuildContext context, String title, String domain) =>
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => PostsScreen(domain, title: title)));
}

class _PostScreen extends StatelessWidget {
  final _Post post;

  const _PostScreen(this.post, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: HtmlWidget(post.title),
          actions: [
            IconButton(
              icon: Icon(Icons.open_in_browser),
              onPressed: () => launch(post.link),
            ),
          ],
        ),
        body: Padding(
          child: SingleChildScrollView(
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio:
                      post.featuredMedia.width / post.featuredMedia.height,
                  child: Center(
                    child: Image.network(post.featuredMedia.sourceUrl),
                  ),
                ),
                const SizedBox(height: 8),
                HtmlWidget(post.content),
              ],
            ),
          ),
          padding: const EdgeInsets.all(8),
        ),
      );

  static void pushRoute(BuildContext context, _Post post) =>
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => _PostScreen(post)));
}

class _PostsList extends StatefulWidget {
  final String url;

  const _PostsList(this.url, {Key key}) : super(key: key);

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<_PostsList> {
  Future<List<_Post>> posts;

  @override
  void initState() {
    super.initState();

    posts =
        http.get(widget.url).then((resp) => _parseJson(jsonDecode(resp.body)));
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<_Post>>(
        builder: (context, snapshot) => snapshot.hasData
            ? _build(snapshot.data)
            : snapshot.hasError
                ? Text(snapshot.error.toString())
                : const Center(child: CircularProgressIndicator()),
        future: posts,
      );

  Widget _build(List<_Post> posts) => ListView.builder(
        itemBuilder: (context, index) => _buildItem(posts[index]),
        itemCount: posts.length,
      );

  Widget _buildItem(_Post post) => ListTile(
        leading: Image.network(
          post.featuredMedia.thumbnail,
          fit: BoxFit.cover,
          height: 44,
          width: 44,
        ),
        onTap: () => _PostScreen.pushRoute(context, post),
        subtitle: HtmlWidget(post.excerpt,
            onTapUrl: (_) => _PostScreen.pushRoute(context, post)),
        title: HtmlWidget(post.title),
      );

  List<_Post> _parseJson(json) {
    final posts = <_Post>[];
    if (json is List) {
      for (final postJson in json) {
        if (postJson is! Map) continue;
        final post = _Post.fromJson(postJson);

        if (post == null) continue;
        posts.add(post);
      }
    }
    return posts;
  }
}

@immutable
class _Post {
  final String content;
  final String excerpt;
  final _Media featuredMedia;
  final int id;
  final String link;
  final String title;

  _Post({
    this.content,
    this.excerpt,
    this.featuredMedia,
    this.id,
    this.link,
    this.title,
  });

  factory _Post.fromJson(Map json) => _Post(
        // this is unsafe, do not do this in real app
        content: (json['content'] as Map)['rendered'],
        excerpt: (json['excerpt'] as Map)['rendered'],
        featuredMedia: _Media.fromJson(
            ((json['_embedded'] as Map)['wp:featuredmedia'] as List)[0]),
        id: json['id'],
        link: json['link'],
        title: (json['title'] as Map)['rendered'],
      );
}

@immutable
class _Media {
  final int height;
  final String sourceUrl;
  final String thumbnail;
  final int width;

  _Media({
    this.height,
    this.sourceUrl,
    this.thumbnail,
    this.width,
  });

  factory _Media.fromJson(Map json) => _Media(
        height: (json['media_details'] as Map)['height'],
        sourceUrl: json['source_url'],
        thumbnail: (((json['media_details'] as Map)['sizes']
            as Map)['thumbnail'] as Map)['source_url'],
        width: (json['media_details'] as Map)['width'],
      );
}
