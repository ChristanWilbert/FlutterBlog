import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/notifier/favourite_post_notifier.dart';
import 'package:flutter_blog/widget/blogview.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_blog/model/blog_post.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Box<BlogPost> blogBox;

  @override
  void initState() {
    super.initState();
    blogBox = Hive.box<BlogPost>('blogBox');
    fetchData();
  }

  Future<void> fetchData() async {
    const String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
    const String adminSecret =
        '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'x-hasura-admin-secret': adminSecret,
      });

      if (response.statusCode == 200) {
        // Request successful, handle the response data here

        Iterable list = json.decode(response.body)['blogs'];
        List<BlogPost> posts = list
            .map((model) => BlogPost(
                id: model['id'],
                imageUrl: model['image_url'],
                title: model['title']))
            .toList();

        await blogBox.clear();
        blogBox.addAll(posts);
      } else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Something went wrong"),
            content: const Text("We are working on it...."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  child: const Text("Okay"),
                ),
              ),
            ],
          ),
        );
        // Request failed
      }
    } catch (e) {
      // Handle any errors that occurred during the request
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("No Network"),
          content: const Text("View offline?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                child: const Text("okay"),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return home(
      blogBox: blogBox,
    );
  }
}

class home extends StatelessWidget {
  const home({
    super.key,
    required this.blogBox,
  });

  final Box<BlogPost> blogBox;

  @override
  Widget build(BuildContext context) {
    List<BlogPost> favlist =
        context.watch<FavoriteNotifier>().box.values.toList();
    return ValueListenableBuilder(
      valueListenable: blogBox.listenable(),
      builder: (context, Box<BlogPost> box, _) {
        if (box.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: box.length,
          itemBuilder: (context, index) {
            BlogPost post = box.getAt(index)!;
            return GestureDetector(
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    color: const Color.fromARGB(255, 63, 65, 65),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            imageUrl: post.imageUrl!,
                            progressIndicatorBuilder: (context, url, progress) {
                              return Center(
                                child: CircularProgressIndicator(
                                  value: progress.downloaded != null
                                      ? progress.downloaded /
                                          (progress.totalSize ?? 1)
                                      : null,
                                ),
                              );
                            },
                            errorWidget: (context, url, error) => const Icon(
                              Icons.signal_wifi_bad_outlined,
                              color: Colors.blueGrey,
                            ),
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              post.title!,
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 30.0, top: 20),
                      child: Icon(
                        (favlist.contains(post))
                            ? Icons.favorite_outlined
                            : Icons.favorite_border,
                        color: const Color.fromARGB(255, 176, 69, 61),
                      ),
                    ),
                    onTap: () {
                      if (favlist.contains(post)) {
                        context.read<FavoriteNotifier>().removeBlogPost(post);
                      } else {
                        context.read<FavoriteNotifier>().addBlogPost(post);
                      }
                    },
                  )
                ],
              ),
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return BlogView(post: post);
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
