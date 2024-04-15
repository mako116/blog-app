import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UpdateBlogScreen extends StatefulWidget {
  final Map<String, dynamic>? blog;

  UpdateBlogScreen({this.blog});

  @override
  _UpdateBlogScreenState createState() => _UpdateBlogScreenState();
}

class _UpdateBlogScreenState extends State<UpdateBlogScreen> {
  late TextEditingController _titleController;
  late TextEditingController _subTitleController;
  late TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.blog?['title'] ?? '');
    _subTitleController =
        TextEditingController(text: widget.blog?['subTitle'] ?? '');
    _bodyController = TextEditingController(text: widget.blog?['body'] ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subTitleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _updateOrCreateBlogPost(BuildContext context) async {
    final GraphQLClient? client = GraphQLProvider.of(context)?.value;

    if (client == null) {
      return;
    }

    try {
      final MutationOptions mutationOptions = widget.blog != null
          ? MutationOptions(
              document: gql('''
                mutation updateBlogPost(\$blogId: String!, \$title: String!, \$subTitle: String!, \$body: String!) {
                  updateBlog(blogId: \$blogId, title: \$title, subTitle: \$subTitle, body: \$body) {
                    success
                    blogPost {
                      id
                      title
                      subTitle
                      body
                      dateCreated
                    }
                  }
                }
              '''),
              variables: {
                'blogId': widget.blog?['id'],
                'title': _titleController.text,
                'subTitle': _subTitleController.text,
                'body': _bodyController.text,
              },
            )
          : MutationOptions(
              document: gql('''
                mutation createBlogPost(\$title: String!, \$subTitle: String!, \$body: String!) {
                  createBlog(title: \$title, subTitle: \$subTitle, body: \$body) {
                    success
                    blogPost {
                      id
                      title
                      subTitle
                      body
                      dateCreated
                    }
                  }
                }
              '''),
              variables: {
                'title': _titleController.text,
                'subTitle': _subTitleController.text,
                'body': _bodyController.text,
              },
            );

      final QueryResult result = await client.mutate(mutationOptions);

      if (result.hasException) {
        throw result.exception!;
      }

      final bool success = result.data?['updateBlog']?['success'] ??
          result.data?['createBlog']?['success'];

      if (success == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Blog post ${widget.blog != null ? 'updated' : 'created'} successfully'),
          ),
        );
        Navigator.pop(context); // Pop current screen
        Navigator.pushReplacementNamed(context, '/'); // Push homepage again
      } else {
        throw Exception(
            'Failed to ${widget.blog != null ? 'update' : 'create'} blog post');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Error ${widget.blog != null ? 'updating' : 'creating'} blog post: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.blog != null ? 'Update Blog' : 'Create Blog'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextFormField(
              controller: _subTitleController,
              decoration: InputDecoration(labelText: 'Subtitle'),
            ),
            TextFormField(
              controller: _bodyController,
              decoration: InputDecoration(labelText: 'Body'),
              maxLines: null,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _updateOrCreateBlogPost(context);
              },
              child: Text(widget.blog != null ? 'Update' : 'Create'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}
