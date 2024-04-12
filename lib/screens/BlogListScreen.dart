// screens/blog_list_screen.dart
import 'package:blogs/services/graphql_service.dart';
import 'package:blogs/widgets/blog_post_item.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:blogs/models/blog_post.dart';
import 'package:flutter/material.dart';

const String fetchAllBlogsQuery = """
  query FetchAllBlogs {
    allBlogs {
      id
      title
      subTitle
      body
      dateCreated
    }
  }
""";

class BlogListScreen extends StatefulWidget {
  @override
  _BlogListScreenState createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  late List<BlogPost> _blogPosts;
  late bool _isLoading;
  late String _errorMessage;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _errorMessage = '';
    _blogPosts = [];
    _fetchBlogPosts();
  }

  Future<void> _fetchBlogPosts() async {
    try {
      final result = await GraphQLService.client.query(QueryOptions(
        document: gql(fetchAllBlogsQuery),
      ));

      if (result.hasException) {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Failed to fetch blog posts: ${result.exception.toString()}';
        });
      } else {
        final List<dynamic>? data = result.data?['allBlogs'];
        if (data != null) {
          setState(() {
            _isLoading = false;
            _blogPosts = data.map((json) => BlogPost.fromJson(json)).toList();
          });
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to fetch blog posts: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog Posts'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _blogPosts.isEmpty
                  ? Center(child: Text('No blog posts available.'))
                  : ListView.builder(
                      itemCount: _blogPosts.length,
                      itemBuilder: (context, index) {
                        final blogPost = _blogPosts[index];
                        return BlogPostItem(blogPost: blogPost);
                      },
                    ),
    );
  }
}
