part of 'blog_bloc.dart';

@immutable
sealed class BlogState {}

final class BlogInitial extends BlogState {}

final class BlogLoading extends BlogState {}

final class BlogFailure extends BlogState {
  BlogFailure({
    required this.error,
  });

  final String error;
}

final class BlogSuccessUpload extends BlogState {}

final class BlogSuccessGet extends BlogState {
  BlogSuccessGet({
    required this.blogs,
  });

  final List<Blog> blogs;
}
