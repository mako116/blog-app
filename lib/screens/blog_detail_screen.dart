import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:blogs/screens/create_update_blog_screen.dart';

class BlogDetailsScreen extends StatefulWidget {
  final String blogId;

  const BlogDetailsScreen({super.key, required this.blogId});

  @override
  _BlogDetailsScreenState createState() => _BlogDetailsScreenState();
}

class _BlogDetailsScreenState extends State<BlogDetailsScreen> {
  late String _backgroundImage = 'images/1.jpg';

  @override
  void initState() {
    super.initState();
    _setBackgroundImage(widget.blogId);
  }

  Future<void> _setBackgroundImage(String blogId) async {
    // Placeholder logic to determine background image based on blogId
    String newBackgroundImage = 'images/2.jpg';
    if (blogId == '1') {
      newBackgroundImage = 'images/3.jpg';
    } else if (blogId == '2') {
      newBackgroundImage = 'images/4.jpg';
    }
    setState(() {
      _backgroundImage = newBackgroundImage;
    });
  }

  Future<void> deleteBlogPost(BuildContext context, String blogId) async {
    final GraphQLClient client = GraphQLProvider.of(context).value;

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
        Navigator.pushReplacementNamed(context, '/'); // Push homepage again
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
        flexibleSpace: Container(
          height: 300, // Set height to 300px
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(_backgroundImage),
              fit: BoxFit.cover,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        title: const Text('Blog Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to previous screen
          },
        ),
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
          variables: {'blogId': widget.blogId},
        ),
        builder: (QueryResult result, {refetch, fetchMore}) {
          if (result.hasException) {
            return Text('Error fetching blog details: ${result.exception}');
          }

          if (result.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final blog = result.data?['blogPost'];

          if (blog == null) {
            return const Text('No blog details available');
          }

          // Format date
          final DateTime dateCreated = DateTime.parse(blog['dateCreated']);
          final formattedDate =
              '${dateCreated.day}/${dateCreated.month}/${dateCreated.year}';

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    blog['title'] ?? '',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    blog['subTitle'] ?? '',
                    style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    blog['body'] ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  // Displaying formatted date
                  Text(
                    'Date: $formattedDate',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
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
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.green), // Update button color
                        ),
                        child: const Text(
                          'Update',
                          style: TextStyle(
                              color: Colors.white), // Update button text color
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          deleteBlogPost(context, blog['id']);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.red), // Delete button color
                        ),
                        child: const Text(
                          'Delete',
                          style: TextStyle(
                              color: Colors.white), // Delete button text color
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
