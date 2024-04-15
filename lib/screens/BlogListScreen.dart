import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:blogs/screens/TestimonialSlider.dart';
import 'package:blogs/screens/blog_detail_screen.dart';
import 'package:blogs/screens/create_update_blog_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BlogListScreen extends StatefulWidget {
  @override
  _BlogListScreenState createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  final TextEditingController _searchController = TextEditingController();
  Map<String, bool> bookmarkedBlogs = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TC Founders'),
        actions: [
          Stack(
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: 140, maxHeight: 50),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 0.2,
                        ),
                      ),
                    ),
                    onSubmitted: (value) {
                      _performSearch(context, value);
                    },
                  ),
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _performSearch(context, _searchController.text);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        height: 700, // Set body height to 700px
        child: Query(
          options: QueryOptions(
            document: gql('''
              query fetchAllBlogs {
                allBlogPosts {
                  id
                  title
                  subTitle
                  body
                  dateCreated
                }
              }
            '''),
          ),
          builder: (QueryResult result, {refetch, fetchMore}) {
            if (result.hasException) {
              return Text('Error fetching blogs: ${result.exception}');
            }

            if (result.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            final List? blogs = result.data?['allBlogPosts'];

            if (blogs == null || blogs.isEmpty) {
              return Text('No blogs available');
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    elevation: 4,
                    margin: EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'TRENDING ',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              shadows: [
                                Shadow(
                                  blurRadius: 3,
                                  color: Colors.black.withOpacity(0.5),
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: blogs.length,
                          itemBuilder: (context, index) {
                            final blog = blogs[index];
                            final DateTime? date = blog['dateCreated'] != null
                                ? DateTime.parse(blog['dateCreated'])
                                : null;

                            final bool isBookmarked =
                                bookmarkedBlogs[blog['id']] ?? false;

                            return Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 10,
                                ),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        blog['title'] ?? '',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff4c53a5),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.bookmark,
                                          color: isBookmarked
                                              ? Colors.yellow
                                              : null),
                                      onPressed: () {
                                        // Toggle the bookmark state for the blog entry
                                        setState(() {
                                          bookmarkedBlogs[blog['id']] =
                                              !isBookmarked;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(blog['subTitle'] ?? ''),
                                    Text(
                                      'Created on: ${date?.day}/${date?.year}',
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlogDetailsScreen(
                                        blogId: blog['id'] ?? '',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      height:
                          120), // Add space between blog list and testimonial
                  TestimonialSlider(
                      // Set margin top for testimonial
                      ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdateBlogScreen(
                blog: null,
              ),
            ),
          );
        },
        child: Icon(Icons.create),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Color(0xff4c53a5),
        height: 70,
        items: [
          Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.chat_bubble,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.list,
            size: 30,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  void _performSearch(BuildContext context, String searchQuery) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Searching for: $searchQuery'),
      ),
    );
  }
}
