import 'package:blog_app/features/blog/data/model/blog_model.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDataSource {
  void uploadLocalBlogs({required List<BlogModel> blogs});

  List<BlogModel> loadBlogs();
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  BlogLocalDataSourceImpl({
    required this.box,
  });

  final Box box;

  @override
  List<BlogModel> loadBlogs() {
    final blogs = <BlogModel>[];

    box.read(() {
      for (var i = 0; i < box.length; i++) {
        final blog =
            BlogModel.fromJson(box.get(i.toString()) as Map<String, dynamic>);
        blogs.add(blog);
      }
    });

    return blogs;
  }

  @override
  void uploadLocalBlogs({required List<BlogModel> blogs}) {
    box
      ..clear()
      ..write(() {
        for (var i = 0; i < blogs.length; i++) {
          box.put(i.toString(), blogs[i].toJson());
        }
      });
  }
}
