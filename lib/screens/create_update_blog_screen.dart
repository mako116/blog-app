// screens/create_update_blog_screen.dart

import 'package:flutter/material.dart';
import 'package:blogs/models/blog_post.dart';
import 'package:blogs/services/graphql_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String createBlogPostMutation = """
  mutation CreateBlogPost(\$title: String!, \$subTitle: String!, \$body: String!) {
    createBlogPost(title: \$title, subTitle: \$subTitle, body: \$body) {
      id
      title
      subTitle
      body
      dateCreated
    }
  }
""";

const String updateBlogPostMutation = """
  mutation UpdateBlogPost(\$blogId: String!, \$title: String!, \$subTitle: String!, \$body: String!) {
    updateBlogPost(blogId: \$blogId, title: \$title, subTitle: \$subTitle, body: \$body) {
      id
      title
      subTitle
      body
      dateCreated
    }
  }
""";

class CreateUpdateBlogScreen extends StatefulWidget {
  final BlogPost? initialBlogPost;

  const CreateUpdateBlogScreen({Key? key, this.initialBlogPost})
      : super(key: key);

  @override
  _CreateUpdateBlogScreenState createState() => _CreateUpdateBlogScreenState();
}

class _CreateUpdateBlogScreenState extends State<CreateUpdateBlogScreen> {
  late TextEditingController _titleController;
  late TextEditingController _subTitleController;
  late TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.initialBlogPost?.title ?? '');
    _subTitleController =
        TextEditingController(text: widget.initialBlogPost?.subTitle ?? '');
    _bodyController =
        TextEditingController(text: widget.initialBlogPost?.body ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialBlogPost == null
            ? 'Create Blog Post'
            : 'Update Blog Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _subTitleController,
              decoration: InputDecoration(labelText: 'Subtitle'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _bodyController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(labelText: 'Body'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text;
                final subTitle = _subTitleController.text;
                final body = _bodyController.text;

                if (title.isNotEmpty &&
                    subTitle.isNotEmpty &&
                    body.isNotEmpty) {
                  // Create or update blog post
                  final blogPost = BlogPost(
                    id: widget.initialBlogPost?.id ?? '',
                    title: title,
                    subTitle: subTitle,
                    body: body,
                    dateCreated: DateTime.now().toString(), // Adjust as needed
                  );

                  if (widget.initialBlogPost == null) {
                    // Create blog post
                    _createBlogPost(blogPost);
                  } else {
                    // Update blog post
                    _updateBlogPost(blogPost);
                  }
                } else {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill in all fields.'),
                    ),
                  );
                }
              },
              child: Text(widget.initialBlogPost == null ? 'Create' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _createBlogPost(BlogPost blogPost) async {
    try {
      final result = await GraphQLService.client.mutate(MutationOptions(
        document: gql(createBlogPostMutation),
        variables: {
          'title': blogPost.title,
          'subTitle': blogPost.subTitle,
          'body': blogPost.body,
        },
      ));

      if (result.hasException) {
        // Handle mutation error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to create blog post: ${result.exception.toString()}'),
          ),
        );
      } else {
        // Handle success
        Navigator.pop(context, true); // Navigate back and signal success
      }
    } catch (e) {
      // Handle network error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create blog post: $e'),
        ),
      );
    }
  }

  void _updateBlogPost(BlogPost blogPost) async {
    try {
      final result = await GraphQLService.client.mutate(MutationOptions(
        document: gql(updateBlogPostMutation),
        variables: {
          'blogId': blogPost.id,
          'title': blogPost.title,
          'subTitle': blogPost.subTitle,
          'body': blogPost.body,
        },
      ));

      if (result.hasException) {
        // Handle mutation error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to update blog post: ${result.exception.toString()}'),
          ),
        );
      } else {
        // Handle success
        Navigator.pop(context, true); // Navigate back and signal success
      }
    } catch (e) {
      // Handle network error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update blog post: $e'),
        ),
      );
    }
  }
}
