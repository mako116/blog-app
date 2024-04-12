// widgets/blog_post_item.dart

import 'package:blogs/models/blog_post.dart';
import 'package:blogs/screens/blog_detail_screen.dart';
import 'package:flutter/material.dart';

class BlogPostItem extends StatelessWidget {
  final BlogPost blogPost;

  const BlogPostItem({required this.blogPost});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(blogPost.title),
      subtitle: Text(blogPost.subTitle),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlogDetailScreen(blogPost: blogPost),
          ),
        );
      },
    );
  }
}
