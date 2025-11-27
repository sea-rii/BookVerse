import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import '../models/book.dart';
import '../widgets/add_book.dart';
import '../widgets/book_detail.dart';
import '../widgets/book_grid.dart';
import '../widgets/book_card.dart';
import '../widgets/book_search.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const HomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _uuid = const Uuid();
  int _selectedIndex = 0;

  final List<Book> _books = [
    Book(
      id: '1',
      title: 'The Nightingale',
      author: 'Kristin Hannah',
      coverUrl:
          'https://covers.openlibrary.org/b/isbn/9780312577223-L.jpg',
      description:
          'In Nazi-occupied France, two very different sisters each fight to survive and resist the German occupation, one through quiet sacrifices at home and the other through dangerous work with the Resistance.',
      status: ReadingStatus.finished,
    ),
    Book(
      id: '2',
      title: 'The Origin',
      author: 'Dan Brown',
      coverUrl:
          'https://covers.openlibrary.org/b/isbn/9780385514231-L.jpg',
      description:
          'Harvard symbologist Robert Langdon races across Spain after a futurist reveals a discovery about the origin and destiny of humanity—then is murdered before he can share it with the world.',
      status: ReadingStatus.reading,
    ),
    Book(
      id: '3',
      title: 'It Ends With Us',
      author: 'Colleen Hoover',
      coverUrl:
          'https://covers.openlibrary.org/b/isbn/9781501110368-L.jpg',
      description:
          'Lily Bloom falls for charismatic neurosurgeon Ryle, but memories of her first love and patterns of abuse force her to confront how hard it is to break the cycle and choose herself.',
      status: ReadingStatus.finished,
    ),
    Book(
      id: '4',
      title: 'Normal People',
      author: 'Sally Rooney',
      coverUrl:
          'https://covers.openlibrary.org/b/isbn/9780571334650-L.jpg',
      description:
          'Marianne and Connell move from small-town Ireland to Trinity College, weaving in and out of each other’s lives as they struggle with class, intimacy, and the ways love can both save and hurt.',
      status: ReadingStatus.toRead,
    ),
    Book(
      id: '5',
      title: 'Ikigai',
      author: 'Francesc Miralles',
      coverUrl:
          'https://covers.openlibrary.org/b/isbn/9781786330895-L.jpg',
      description:
          'A gentle exploration of the Japanese concept of ikigai—your reason for living—combining research and stories from Okinawa to show how purpose, community, and small joys support a long, happy life.',
      status: ReadingStatus.reading,
    ),
    Book(
      id: '6',
      title: 'Think Like a Monk',
      author: 'Jay Shetty',
      coverUrl:
          'https://covers.openlibrary.org/b/isbn/9781982134488-L.jpg',
      description:
          'Drawing on his years as a monk, Jay Shetty shares practical frameworks and exercises to quiet the noise, let go of ego and fear, and build a life rooted in service, meaning, and peace.',
      status: ReadingStatus.reading,
    ),
    Book(
      id: '7',
      title: 'It Starts with Us',
      author: 'Colleen Hoover',
      coverUrl:
          'https://covers.openlibrary.org/b/isbn/9781398518179-L.jpg',
      description:
          'A companion to *It Ends With Us* that picks up with Lily and Atlas as they try to build a healthier future while navigating co-parenting, old wounds, and the lingering impact of past abuse.',
      status: ReadingStatus.reading,
    ),
    Book(
      id: '8',
      title: 'How To Win Friends & Influence People',
      author: 'Dale Carnegie',
      coverUrl:
          'https://covers.openlibrary.org/b/isbn/9780671027032-L.jpg',
      description:
          'A classic self-help book that teaches timeless principles for better relationships—like showing genuine interest in others, listening more than you talk, and framing criticism with empathy.',
      status: ReadingStatus.reading,
    ),
    Book(
      id: '9',
      title: 'Zero To One',
      author: 'Peter Thiel',
      coverUrl:
          'https://covers.openlibrary.org/b/isbn/9780804139298-L.jpg',
      description:
          'Entrepreneur and investor Peter Thiel argues that the most valuable startups create something truly new—going from “zero to one”—and shares contrarian lessons on building and defending those companies.',
      status: ReadingStatus.reading,
    ),
    Book(
      id: '10',
      title: 'The Alchemist',
      author: 'Paulo Coelho',
      coverUrl:
          'https://covers.openlibrary.org/b/isbn/9780061122415-L.jpg',
      description:
          'Shepherd boy Santiago follows a recurring dream from Spain to the Egyptian desert in search of treasure, discovering omens, love, and the idea of a “Personal Legend” along the way.',
      status: ReadingStatus.reading,
    ),
];

  ReadingStatus? _statusFilter;

  // ---------- CRUD / state ----------

  void _createBookFromSheet(
    String title,
    String author,
    String? coverUrl,
    Uint8List? coverBytes,
    String description,
  ) {
    final book = Book(
      id: _uuid.v4(),
      title: title.trim(),
      author: author.trim(),
      coverUrl: coverUrl?.trim() ?? '',
      coverBytes: coverBytes,
      description: description.trim(),
      status: ReadingStatus.toRead,
    );

    setState(() {
      _books.add(book);
    });
  }

  void _updateBookStatus(Book book, ReadingStatus status) {
    setState(() {
      book.status = status;
    });
  }

  void _addNoteToBook(Book book, String note) {
    setState(() {
      book.notes.add(note);
    });
  }

  void _deleteNoteFromBook(Book book, int index) {
    setState(() {
      book.notes.removeAt(index);
    });
  }

  void _deleteBook(Book book) {
    setState(() {
      _books.removeWhere((b) => b.id == book.id);
    });

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Book deleted successfully'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }




  void _openDetails(Book book) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            ),
            child: BookDetailPage(
              book: book,
              onStatusChanged: (s) => _updateBookStatus(book, s),
              onAddNote: (note) => _addNoteToBook(book, note),
              onDeleteNote: (i) => _deleteNoteFromBook(book, i),
              onDeleteBook: () => _deleteBook(book),
            ),
          ),
        ),
      ),
    );
  }

  // ---------- Actions ----------

  void _openAddBookSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => AddBookSheet(
        onSubmit: _createBookFromSheet,
      ),
    );
  }

  void _openSearch() {
    showSearch(
      context: context,
      delegate: BookSearchDelegate(
        books: _books,
        onSelected: _openDetails,
      ),
    );
  }

  void _openFilterSheet() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter by status', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _statusFilter == null,
                  onSelected: (_) {
                    setState(() => _statusFilter = null);
                  },
                ),
                ChoiceChip(
                  label: const Text('To Read'),
                  selected: _statusFilter == ReadingStatus.toRead,
                  onSelected: (_) {
                    setState(() => _statusFilter = ReadingStatus.toRead);
                  },
                ),
                ChoiceChip(
                  label: const Text('Reading'),
                  selected: _statusFilter == ReadingStatus.reading,
                  onSelected: (_) {
                    setState(() => _statusFilter = ReadingStatus.reading);
                  },
                ),
                ChoiceChip(
                  label: const Text('Finished'),
                  selected: _statusFilter == ReadingStatus.finished,
                  onSelected: (_) {
                    setState(() => _statusFilter = ReadingStatus.finished);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Derived lists ----------

  List<Book> get _filteredLibraryBooks {
    return _books.where((book) {
      if (_statusFilter == null) return true;
      return book.status == _statusFilter;
    }).toList();
  }

  List<Book> get _readingListBooks =>
      _books.where((b) => b.status != ReadingStatus.finished).toList();

  int get _totalBooks => _books.length;
  int get _toReadCount =>
      _books.where((b) => b.status == ReadingStatus.toRead).length;
  int get _readingCount =>
      _books.where((b) => b.status == ReadingStatus.reading).length;
  int get _finishedCount =>
      _books.where((b) => b.status == ReadingStatus.finished).length;

  void _onBottomNavTap(int index) {
    setState(() => _selectedIndex = index);
  }

  // ---------- Tabs ----------

  /// Cinematic shelf
  Widget _buildLibraryTab() {
    final theme = Theme.of(context);
    const shelfHeight = 14.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Library',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              TextButton.icon(
                onPressed: _openAddBookSheet,
                icon: const Icon(Icons.add),
                label: const Text('Add book'),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  backgroundColor:
                      theme.colorScheme.primary.withOpacity(0.08),
                  foregroundColor: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Text(
                _statusFilter == null
                    ? 'All books'
                    : _statusFilter == ReadingStatus.toRead
                        ? 'To read'
                        : _statusFilter == ReadingStatus.reading
                            ? 'Reading'
                            : 'Finished',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: _openFilterSheet,
                icon: const Icon(Icons.filter_list),
                tooltip: 'Filter',
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final books = _filteredLibraryBooks;
              // make sure shelf is fully visible
              const shelfBottomPadding = 36.0;

              return Stack(
                children: [
                  Positioned(
                    left: 24,
                    right: 24,
                    bottom: shelfBottomPadding,
                    child: Container(
                      height: shelfHeight,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0C9A5),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFC58E61).withOpacity(0.55),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                    ),
                  ),

                  ListView.separated(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 16,
                      bottom: shelfBottomPadding + shelfHeight + 16,
                    ),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: books.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 24),
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: Transform.translate(
                          offset: const Offset(0, -10), 
                          child: SizedBox(
                            width: 260,
                            child: BookCard(
                              book: book,
                              onTap: () => _openDetails(book),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReadingListTab() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 2;
        if (constraints.maxWidth > 1200) {
          crossAxisCount = 5;
        } else if (constraints.maxWidth > 900) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth > 600) {
          crossAxisCount = 3;
        }

        return BookGrid(
          books: _readingListBooks,
          onTapBook: _openDetails,
          crossAxisCount: crossAxisCount,
          childAspectRatio: 1.45,   
        );
      },
    );
  }



  Widget _buildStatsTab() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Stats', style: theme.textTheme.titleLarge),
          const SizedBox(height: 24),
          _StatTile(label: 'Total books', value: _totalBooks.toString()),
          const SizedBox(height: 12),
          _StatTile(label: 'To Read', value: _toReadCount.toString()),
          const SizedBox(height: 12),
          _StatTile(label: 'Reading', value: _readingCount.toString()),
          const SizedBox(height: 12),
          _StatTile(label: 'Finished', value: _finishedCount.toString()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _buildLibraryTab(),
      _buildReadingListTab(),
      _buildStatsTab(),
    ];

    final accent1 = Theme.of(context).colorScheme.primary;
    final accent2 = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 96,
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleSpacing: 24,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'BookVerse',
              style: GoogleFonts.cinzelDecorative(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.6,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'your cinematic bookshelf',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                    letterSpacing: 1.1,
                  ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(8),
          child: Container(
            height: 3,
            margin: const EdgeInsets.fromLTRB(24, 4, 24, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              gradient: LinearGradient(colors: [accent1, accent2]),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: _openSearch,
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: _openFilterSheet,
            icon: const Icon(Icons.filter_list),
          ),
          IconButton(
            onPressed: widget.onToggleTheme,
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.isDarkMode
                ? const [
                    Color(0xFF050510),
                    Color(0xFF111320),
                  ]
                : const [
                    Color(0xFFFDF5FF),
                    Color(0xFFF7ECFF),
                  ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: tabs[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Reading List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Stats',
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;

  const _StatTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(
            value,
            style: theme.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
