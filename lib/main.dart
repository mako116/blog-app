import 'package:blogs/screens/BlogListScreen.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink('https://uat-api.vmodel.app/graphql/');

    final ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        cache: GraphQLCache(),
        link: httpLink,
      ),
    );

    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: MaterialApp(
          title: 'Blogs',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routes: {
            "/": (context) => const BlogListScreen(),
          },
        ),
      ),
    );
  }
}
