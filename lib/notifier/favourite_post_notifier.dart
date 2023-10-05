import 'package:flutter/material.dart';
import 'package:flutter_blog/model/blog_post.dart';
import 'package:hive/hive.dart';

class FavoriteNotifier extends ChangeNotifier {
  final box = Hive.box<BlogPost>('favblogBox');
  void addBlogPost(BlogPost blogPost) {
    box.add(blogPost.copy());
    notifyListeners();
  }

  void removeBlogPost(BlogPost blogPost) {
    BlogPost p = Hive.box<BlogPost>('favblogBox')
        .values
        .toList()
        .where((element) => element.id == blogPost.id)
        .toList()[0];
    box.delete(p.key);
    notifyListeners();
  }
}
