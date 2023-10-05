import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/model/blog_post.dart';

class BlogView extends StatelessWidget {
  const BlogView({super.key, required this.post});
  final BlogPost post;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Card(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 40),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        post.title!,
                        softWrap: true,
                        maxLines: 5,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CachedNetworkImage(
                  width: MediaQuery.of(context).size.width * .95,
                  imageUrl: post.imageUrl!,
                  progressIndicatorBuilder: (context, url, progress) {
                    return Center(
                      child: CircularProgressIndicator(
                        value: progress.downloaded != null
                            ? progress.downloaded / (progress.totalSize ?? 1)
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
