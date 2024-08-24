import 'dart:io';

import 'package:blog_app/core/use_case/use_case.dart';
import 'package:blog_app/features/blog/domain/entity/blog.dart';
import 'package:blog_app/features/blog/domain/use_case/get_blogs.dart';
import 'package:blog_app/features/blog/domain/use_case/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  BlogBloc(this._uploadBlog, this._getBlogs) : super(BlogInitial()) {
    on<BlogEvent>((event, emit) {
      emit(BlogLoading());
    });
    on<BlogsGet>(_onGetBlogs);
    on<BlogUpload>(_onBlogUpload);
  }
  final UploadBlog _uploadBlog;
  final GetBlogs _getBlogs;

  Future<void> _onBlogUpload(
    BlogUpload event,
    Emitter<BlogState> emit,
  ) async {
    print('here');
    final res = await _uploadBlog(
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
          BlogSuccessUpload(),
        );
      },
    );
  }

  Future<void> _onGetBlogs(
    BlogsGet event,
    Emitter<BlogState> emit,
  ) async {
    final res = await _getBlogs(
      NoParams(),
    );
    res.fold(
      (l) => emit(
        BlogFailure(
          error: l.message,
        ),
      ),
      (r) {
        emit(
          BlogSuccessGet(
            blogs: r,
          ),
        );
      },
    );
  }
}
