import 'dart:io';

import 'package:blog_app/features/blog/domain/use_case/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  BlogBloc({required this.uploadBlog}) : super(BlogInitial()) {
    on<BlogEvent>((event, emit) {
      emit(BlogLoading());
    });
    on<BlogUpload>(_onBlogUpload);
  }
  final UploadBlog uploadBlog;

  Future<void> _onBlogUpload(
    BlogUpload event,
    Emitter<BlogState> emit,
  ) async {
    print('here');
    final res = await uploadBlog(
      UploadBlogParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics,
      ),
    );
    print(res);
    res.fold(
      (l) => emit(
        BlogFailure(
          error: l.message,
        ),
      ),
      (r) {
        print(r.content);
        emit(
          BlogSuccess(),
        );
      },
    );
  }
}
