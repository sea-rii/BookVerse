import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/book.dart';

class BookDetailPage extends StatefulWidget {
  final Book book;
  final ValueChanged<ReadingStatus> onStatusChanged;
  final ValueChanged<String> onAddNote;
  final ValueChanged<int> onDeleteNote;
  final VoidCallback onDeleteBook;

  const BookDetailPage({
    super.key,
    required this.book,
    required this.onStatusChanged,
    required this.onAddNote,
    required this.onDeleteNote,
    required this.onDeleteBook,
  });

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  final _noteCtrl = TextEditingController();

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  void _handleStatusChange(ReadingStatus? status) {
    if (status == null) return;
    widget.onStatusChanged(status);
    setState(() {}); 
  }

  void _handleAddNote() {
    final text = _noteCtrl.text.trim();
    if (text.isEmpty) return;

    widget.onAddNote(text);
    _noteCtrl.clear();
    setState(() {});
  }

  void _handleDeleteNote(int index) {
    widget.onDeleteNote(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final book = widget.book;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF14111D), Color(0xFF281F33)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.white,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Text(
                        book.title,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      color: Colors.white,
                      onPressed: () {
                        widget.onDeleteBook();
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Hero(
                tag: book.id,
                child: SizedBox(
                  height: 220,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: book.coverBytes != null
                        ? Image.memory(
                            book.coverBytes as Uint8List,
                            fit: BoxFit.cover,
                          )
                        : (book.coverUrl != null &&
                                book.coverUrl!.trim().isNotEmpty)
                            ? Image.network(
                                book.coverUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.grey[800],
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.book,
                                      color: Colors.white70, size: 32),
                                ),
                              )
                            : Container(
                                color: Colors.grey[800],
                                alignment: Alignment.center,
                                child: const Icon(Icons.book,
                                    color: Colors.white70, size: 32),
                              ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.0),
                        Colors.black.withOpacity(0.85),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'by ${book.author}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[300],
                          ),
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Text(
                              'Status: ',
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey[200]),
                            ),
                            const SizedBox(width: 8),
                            DropdownButton<ReadingStatus>(
                              value: book.status,
                              dropdownColor: const Color(0xFF1E1A2A),
                              underline: const SizedBox(),
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(color: Colors.white),
                              iconEnabledColor: Colors.white,
                              onChanged: _handleStatusChange,
                              items: const [
                                DropdownMenuItem(
                                  value: ReadingStatus.toRead,
                                  child: Text('To Read'),
                                ),
                                DropdownMenuItem(
                                  value: ReadingStatus.reading,
                                  child: Text('Reading'),
                                ),
                                DropdownMenuItem(
                                  value: ReadingStatus.finished,
                                  child: Text('Finished'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        Text(
                          'Description',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          book.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[300],
                          ),
                        ),
                        const SizedBox(height: 24),

                        Text(
                          'Notes',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (book.notes.isEmpty)
                          Text(
                            'No notes yet. Add your thoughts or favorite quotes!',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[400],
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: book.notes.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final note = book.notes[index];
                              return Dismissible(
                                key: ValueKey('note_$index'),
                                direction: DismissDirection.endToStart,
                                onDismissed: (_) => _handleDeleteNote(index),
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.delete,
                                      color: Colors.white),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF231C32),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    note,
                                    style:
                                        theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                        const SizedBox(height: 16),

                        TextField(
                          controller: _noteCtrl,
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.pinkAccent,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Add a note or quote...',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            filled: true,
                            fillColor: const Color(0xFF1D1829),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(999),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.send),
                              color: Colors.pinkAccent,
                              onPressed: _handleAddNote,
                            ),
                          ),
                          onSubmitted: (_) => _handleAddNote(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
