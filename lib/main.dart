import 'package:flutter/material.dart';
import 'package:flutter_blog/model/blog_post.dart';
import 'package:flutter_blog/myapp.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Import your Hive model

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(BlogPostAdapter());
  await Hive.openBox<BlogPost>('blogBox');
  await Hive.openBox<BlogPost>('favblogBox');

  runApp(MyApp());
}
