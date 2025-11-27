import 'package:flutter/material.dart';
import '../models/book.dart';
import 'book_card.dart';

class BookGrid extends StatelessWidget {
  final List<Book> books;
  final Function(Book) onTapBook;

  final int crossAxisCount;
  final double childAspectRatio;

  const BookGrid({
    super.key,
    required this.books,
    required this.onTapBook,
    required this.crossAxisCount,
    this.childAspectRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      clipBehavior: Clip.none, 
      itemCount: books.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 32,
        mainAxisSpacing: 40,
      ),
      itemBuilder: (context, index) {
        final book = books[index];

        return Align(
          alignment: Alignment.bottomCenter,
          child: Transform.translate(
            offset: const Offset(0, -10),
            child: BookCard(
              book: book,
              onTap: () => onTapBook(book),
            ),
          ),
        );
      },
    );
  }
}
