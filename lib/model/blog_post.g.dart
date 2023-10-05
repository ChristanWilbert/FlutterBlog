// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_post.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BlogPostAdapter extends TypeAdapter<BlogPost> {
  @override
  final int typeId = 0;

  @override
  BlogPost read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BlogPost(
      id: fields[0] as String?,
      imageUrl: fields[1] as String?,
      title: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BlogPost obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imageUrl)
      ..writeByte(2)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlogPostAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
