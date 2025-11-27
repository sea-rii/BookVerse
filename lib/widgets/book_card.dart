import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/book.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;

  const BookCard({
    super.key,
    required this.book,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardBg = isDark
        ? const LinearGradient(
            colors: [
              Color(0xFF151724),
              Color(0xFF0D0F1A),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
        : const LinearGradient(
            colors: [
              Colors.white,
              Color(0xFFFFFBFF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          );

    final textColor = isDark ? Colors.white : Colors.black87;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: cardBg,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.45 : 0.12),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildCover(context),
            ),

            // TEXT + STATUS
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? Colors.grey[400] : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _buildStatusChip(context, isDark),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCover(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget inner;
    if (book.coverBytes != null) {
      inner = Image.memory(
        book.coverBytes as Uint8List,
        fit: BoxFit.cover,
        width: double.infinity,
      );
    } else if (book.coverUrl != null && book.coverUrl!.isNotEmpty) {
      inner = Image.network(
        book.coverUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => _placeholder(isDark),
      );
    } else {
      inner = _placeholder(isDark);
    }

    return Hero(
      tag: book.id,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: inner,
      ),
    );
  }

  Widget _placeholder(bool isDark) {
    return Container(
      color: isDark ? const Color(0xFF222435) : const Color(0xFFE5E6F0),
      child: Icon(
        Icons.bookmark_added_rounded,
        size: 40,
        color: isDark ? Colors.white70 : Colors.black54,
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, bool isDark) {
    Color bg;
    Color fg;

    switch (book.status) {
      case ReadingStatus.toRead:
        bg = isDark ? const Color(0xFF2349FF) : const Color(0xFFE0ECFF);
        fg = isDark ? Colors.white : const Color(0xFF1C3AA9);
        break;
      case ReadingStatus.reading:
        bg = isDark ? const Color(0xFFFFC857) : const Color(0xFFFFF0C2);
        fg = isDark ? const Color(0xFF3A2500) : const Color(0xFF8A5B00);
        break;
      case ReadingStatus.finished:
        bg = isDark ? const Color(0xFF2BD38A) : const Color(0xFFD9F7E7);
        fg = isDark ? const Color(0xFF00391E) : const Color(0xFF0D6B3B);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _statusLabel(book.status),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  String _statusLabel(ReadingStatus s) {
    switch (s) {
      case ReadingStatus.toRead:
        return 'To Read';
      case ReadingStatus.reading:
        return 'Reading';
      case ReadingStatus.finished:
        return 'Finished';
    }
  }
}
