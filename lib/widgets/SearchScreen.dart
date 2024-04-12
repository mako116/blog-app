// import 'package:flutter/material.dart';

// class SearchScreen extends StatefulWidget {
//   final List<String> filteredBlogTitles;

//   const SearchScreen({Key? key, required this.filteredBlogTitles})
//       : super(key: key);

//   @override
//   _SearchResultScreenState createState() => _SearchResultScreenState();
// }

// class _SearchResultScreenState extends State<SearchScreen> {
//   List<bool> isBookmarked = [];

//   @override
//   void initState() {
//     super.initState();
//     // Initialize all list items as not bookmarked
//     isBookmarked = List<bool>.filled(widget.filteredBlogTitles.length, false);
//   }

//   void toggleBookmark(int index) {
//     setState(() {
//       isBookmarked[index] = !isBookmarked[index];
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Search Results'),
//       ),
//       body: ListView.builder(
//         itemCount: widget.filteredBlogTitles.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(widget.filteredBlogTitles[index]),
//             trailing: IconButton(
//               icon: Icon(
//                 isBookmarked[index] ? Icons.bookmark : Icons.bookmark_border,
//                 color: isBookmarked[index] ? Colors.blue : null,
//               ),
//               onPressed: () {
//                 toggleBookmark(index);
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
