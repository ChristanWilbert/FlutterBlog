import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/notifier/favourite_post_notifier.dart';
import 'package:flutter_blog/widget/blogview.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_blog/model/blog_post.dart';
import 'package:provider/provider.dart';

class Favorite extends StatefulWidget {
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  late Box<BlogPost> box;

  @override
  void initState() {
    super.initState();
    box = Hive.box<BlogPost>('favblogBox');
  }

  @override
  Widget build(BuildContext context) {
    return favorite(box: box);
  }
}

class favorite extends StatelessWidget {
  const favorite({
    super.key,
    required this.box,
  });

  final Box<BlogPost> box;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<BlogPost>('favblogBox').listenable(),
      builder: (context, Box<BlogPost> box, _) {
        if (box.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.heart_broken,
                ),
                Text("No favorites")
              ],
            ),
          );
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
                        (Hive.box<BlogPost>('favblogBox')
                                .values
                                .toList()
                                .contains(post))
                            ? Icons.favorite_outlined
                            : Icons.favorite_border,
                        color: const Color.fromARGB(255, 176, 69, 61),
                      ),
                    ),
                    onTap: () {
                      if (Hive.box<BlogPost>('favblogBox')
                          .values
                          .toList()
                          .contains(post)) {
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
