import 'package:hive/hive.dart';

part 'blog_post.g.dart';

@HiveType(typeId: 0)
class BlogPost extends HiveObject {
  @HiveField(0)
  late String? id;

  @HiveField(1)
  late String? imageUrl;

  @HiveField(2)
  late String? title;

  BlogPost({
    required this.id,
    required this.imageUrl,
    required this.title,
  });
  BlogPost copy() => BlogPost(id: id, imageUrl: imageUrl, title: title);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlogPost && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  bool contains(BlogPost x) {
    for (int i = 0; i < box!.length; i++) {
      if (x.id == box!.keyAt(i)) {
        return true;
      }
    }
    return false;
  }
}
