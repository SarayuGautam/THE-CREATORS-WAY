import 'dart:io';

import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/use_case/use_case.dart';
import 'package:blog_app/features/blog/domain/entity/blog.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadBlog implements UseCase<Blog, UploadBlogParams> {
  UploadBlog({
    required this.blogRepository,
  });

  final BlogRepository blogRepository;
  @override
  Future<Either<Failure, Blog>> call(UploadBlogParams params) async {
    final res = await blogRepository.uploadBlog(
      image: params.image,
      title: params.title,
      content: params.content,
      posterId: params.posterId,
      topics: params.topics,
    );
    print(res);
    return res;
  }
}

class UploadBlogParams {
  UploadBlogParams({
    required this.posterId,
    required this.title,
    required this.content,
    required this.image,
    required this.topics,
  });

  final String posterId;
  final String title;
  final String content;
  final File image;
  final List<String> topics;
}
