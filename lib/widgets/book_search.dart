import 'package:flutter/material.dart';
import '../models/book.dart';

class BookSearchDelegate extends SearchDelegate<Book?> {
  final List<Book> books;
  final Function(Book) onSelected;

  BookSearchDelegate({
    required this.books,
    required this.onSelected,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final matches = books.where((b) {
      final q = query.toLowerCase();
      return b.title.toLowerCase().contains(q) ||
          b.author.toLowerCase().contains(q);
    }).toList();

    return _buildList(context, matches);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final matches = books.where((b) {
      final q = query.toLowerCase();
      return b.title.toLowerCase().contains(q) ||
          b.author.toLowerCase().contains(q);
    }).toList();

    return _buildList(context, matches);
  }

  Widget _buildList(BuildContext context, List<Book> results) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (_, index) {
        final book = results[index];

        return ListTile(
          leading: SizedBox(
            width: 40,
            height: 60,
            child: book.coverUrl != null && book.coverUrl!.isNotEmpty
                ? Image.network(book.coverUrl!, fit: BoxFit.cover)
                : const Icon(Icons.book),
          ),
          title: Text(book.title),
          subtitle: Text(book.author),
          onTap: () {
            close(context, book);      
            onSelected(book);          
          },
        );
      },
    );
  }
}
