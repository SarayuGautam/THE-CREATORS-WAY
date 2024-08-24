import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/features/blog/domain/entity/blog.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_details.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  const BlogCard({
    required this.blog,
    required this.color,
    super.key,
  });

  final Blog blog;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final readingTime = calculateReadingTime(blog.content);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          BlogDetailsPage.route(
            blog,
          ),
        );
      },
      child: Container(
        height: 200,
        margin: const EdgeInsets.all(16).copyWith(
          bottom: 4,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: blog.topics
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(5),
                        child: Chip(
                          color: const WidgetStatePropertyAll(
                            AppPallete.backgroundColor,
                          ),
                          label: Text(
                            e,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Text(
              blog.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text('$readingTime min'),
          ],
        ),
      ),
    );
  }
}
