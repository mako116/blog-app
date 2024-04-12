import 'package:blogs/screens/TestimonialSlider.dart';
import 'package:blogs/screens/create_update_blog_screen.dart';
import 'package:blogs/widgets/TestimonialDetails.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class BlogDetailsScreen extends StatelessWidget {
  final String blogId;

  BlogDetailsScreen({required this.blogId});

  Future<void> deleteBlogPost(BuildContext context, String blogId) async {
    final GraphQLClient? client = GraphQLProvider.of(context)?.value;

    if (client == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('GraphQL client is null'),
        ),
      );
      return;
    }

    try {
      final QueryResult result = await client.mutate(
        MutationOptions(
          document: gql('''
            mutation deleteBlogPost(\$blogId: String!) {
              deleteBlog(blogId: \$blogId) {
                success
              }
            }
          '''),
          variables: {'blogId': blogId},
        ),
      );

      if (result.hasException) {
        throw result.exception!;
      }

      final bool success = result.data?['deleteBlog']['success'];

      if (success == true) {
        Navigator.pop(context);
      } else {
        throw Exception('Failed to delete blog post');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting blog post: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog Details'),
      ),
      body: Query(
        options: QueryOptions(
          document: gql('''
            query getBlog(\$blogId: String!) {
              blogPost(blogId: \$blogId) {
                id
                title
                subTitle
                body
                dateCreated
              }
            }
          '''),
          variables: {'blogId': blogId},
        ),
        builder: (QueryResult result, {refetch, fetchMore}) {
          if (result.hasException) {
            return Text('Error fetching blog details: ${result.exception}');
          }

          if (result.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          final blog = result.data?['blogPost'];

          if (blog == null) {
            return Text('No blog details available');
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    blog['title'] ?? '',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    blog['subTitle'] ?? '',
                    style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 16),
                  Text(
                    blog['body'] ?? '',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UpdateBlogScreen(blog: blog),
                            ),
                          );
                        },
                        child: Text('Update'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await deleteBlogPost(context, blog['id']);
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 15)),
                  TestimonialDetails()
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
