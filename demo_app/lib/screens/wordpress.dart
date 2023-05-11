import 'dart:async';
import 'dart:convert';

import 'package:demo_app/widgets/popup_menu.dart';
import 'package:demo_app/widgets/selection_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class WordpressScreen extends StatelessWidget {
  static const sites = {
    'TechCrunch': 'techcrunch.com',
    'The Mozilla Blog': 'blog.mozilla.org',
  };

  const WordpressScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('WordPressScreen'),
        ),
        body: ListView(
          children: sites.entries
              .map(
                (e) => ListTile(
                  onTap: () => PostsScreen.pushRoute(context, e.key, e.value),
                  subtitle: Text(e.value),
                  title: Text(e.key),
                ),
              )
              .toList(growable: false),
        ),
      );
}

class PostsScreen extends StatelessWidget {
  final String domain;
  final String? title;

  const PostsScreen(this.domain, {super.key, this.title});

  @override
  Widget build(BuildContext _) => Scaffold(
        appBar: AppBar(title: Text(title ?? domain)),
        body: _PostsList('https://$domain/wp-json/wp/v2/posts?_embed'),
      );

  static void pushRoute(BuildContext context, String title, String domain) =>
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => PostsScreen(domain, title: title)),
      );
}

class _PostScreen extends StatelessWidget {
  final _Post post;

  const _PostScreen(this.post);

  @override
  Widget build(BuildContext context) => SelectionAreaScaffold(
        appBar: AppBar(
          title: HtmlWidget(post.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.open_in_browser),
              onPressed: () => launchUrl(Uri.parse(post.link)),
            ),
            const PopupMenu(
              toggleIsSelectable: true,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (post case _Post(:final featuredMedia)
                    when featuredMedia != null)
                  AspectRatio(
                    aspectRatio: featuredMedia.width / featuredMedia.height,
                    child: Center(
                      child: Image.network(featuredMedia.sourceUrl),
                    ),
                  ),
                const SizedBox(height: 8),
                HtmlWidget(post.content),
              ],
            ),
          ),
        ),
      );

  static void pushRoute(BuildContext context, _Post post) =>
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => _PostScreen(post)));
}

class _PostsList extends StatefulWidget {
  final String url;

  const _PostsList(this.url);

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<_PostsList> {
  late final Future<List<_Post>> posts;

  @override
  void initState() {
    super.initState();

    posts = http
        .get(Uri.parse(widget.url))
        .then((resp) => _parseJson(jsonDecode(resp.body)));
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<_Post>>(
        builder: (context, snapshot) => snapshot.hasData
            ? _build(snapshot.requireData)
            : snapshot.hasError
                ? Text(snapshot.error.toString())
                : const Center(child: CircularProgressIndicator()),
        future: posts,
      );

  Widget _build(List<_Post> posts) => ListView.builder(
        itemBuilder: (context, index) => _buildItem(posts[index]),
        itemCount: posts.length,
      );

  Widget _buildItem(_Post post) {
    final featuredMedia = post.featuredMedia;
    return ListTile(
      leading: featuredMedia != null
          ? Image.network(
              featuredMedia.thumbnail,
              fit: BoxFit.cover,
              height: 44,
              width: 44,
            )
          : const SizedBox(width: 44),
      onTap: () => _PostScreen.pushRoute(context, post),
      subtitle: HtmlWidget(
        post.excerpt,
        onTapUrl: (_) {
          _PostScreen.pushRoute(context, post);
          return true;
        },
      ),
      title: HtmlWidget(post.title),
    );
  }

  List<_Post> _parseJson(json) {
    final posts = <_Post>[];
    if (json is List) {
      for (final postJson in json) {
        if (postJson is Map) {
          final post = _Post.fromJson(postJson);
          if (post != null) {
            posts.add(post);
          }
        }
      }
    }
    return posts;
  }
}

@immutable
class _Post {
  final String content;
  final String excerpt;
  final _Media? featuredMedia;
  final int id;
  final String link;
  final String title;

  const _Post({
    required this.content,
    required this.excerpt,
    this.featuredMedia,
    required this.id,
    required this.link,
    required this.title,
  });

  static _Post? fromJson(Map json) {
    if (json
        case {
          'content': {
            'rendered': final String content,
          },
          'excerpt': {
            'rendered': final String excerpt,
          },
          'id': final int id,
          'link': final String link,
          'title': {
            'rendered': final String title,
          },
          '_embedded': final Map embedded,
        }) {
      _Media? featuredMedia;
      if (embedded case {'wp:featuredmedia': [final Map featuredMediaJson]}) {
        featuredMedia = _Media.fromJson(featuredMediaJson);
      }

      return _Post(
        content: content,
        excerpt: excerpt,
        featuredMedia: featuredMedia,
        id: id,
        link: link,
        title: title,
      );
    }

    return null;
  }
}

@immutable
class _Media {
  final int height;
  final String sourceUrl;
  final String thumbnail;
  final int width;

  const _Media({
    required this.height,
    required this.sourceUrl,
    required this.thumbnail,
    required this.width,
  });

  static _Media? fromJson(Map json) {
    if (json
        case {
          'media_details': {
            'height': final int height,
            'width': final int width,
            'sizes': {
              'thumbnail': {
                'source_url': final String thumbnail,
              },
            },
          },
          'source_url': final String sourceUrl,
        }) {
      return _Media(
        height: height,
        sourceUrl: sourceUrl,
        thumbnail: thumbnail,
        width: width,
      );
    }

    return null;
  }
}
