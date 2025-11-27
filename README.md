# 📚 BookVerse  
*A cinematic digital bookshelf built with Flutter.*

BookVerse is a beautifully crafted Flutter application that lets users browse, track, and manage their reading journey. Designed with a cinematic theme, smooth animations, and a dynamic bookshelf UI, it merges aesthetics with functionality. Users can add books, update statuses, write notes, filter categories, and explore their reading stats — all wrapped in a polished experience.

## ✨ Features  

### 📖 **Library View (Cinematic Bookshelf)**
- Beautiful horizontal bookshelf with 3D-style elevation  
- Custom book cards with dynamic shadows  
- Supports uploaded images or URL-based covers  
- Filters: **To Read**, **Reading**, **Finished**

### 📝 **Book Details**
- Smooth animated transition into detailed view  
- Change reading status  
- Add/delete personal notes  
- Delete books with confirmation & success popups  
- Dark mode adaptive gradients

### ➕ **Add Book**
- Add new books using:
  - Uploaded image (FilePicker)
  - Image URL  
- Enter title, author, description  
- Instant success snackbar on add

### 🔍 **Search**
- Search by title or author  
- Selecting a result opens the Book Details screen directly

### 📊 **Reading Stats**
- Total books  
- Books by category  
- Clean tile-based stat layout

### 🌙 **Dark / Light Mode**
- Entire app theme switches dynamically  
- Dark mode uses soft cinematic gradients for comfort

### 📱 **Responsive**
- Adapts to:
  - Mobile  
  - Web  
  - Desktop sizes  
- Grid layout adjusts automatically in Reading List view



## 🎨 Visual Direction  
The visual style was inspired by:
- Soft pastel gradients  
- Cinematic typography (Cinzel Decorative)  
- Cozy bookstore aesthetic
   
This guided choices like:
- Rounded card edges  
- Shelf shadows  
- Elegant color accents  
- Depth and spacing to create “airiness”

## 🛠️ Customization Guide  

### Theme & Colors  
All global theme controls live in `main.dart`:

```dart
theme: ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
),
darkTheme: ThemeData(
  brightness: Brightness.dark,
),
```

## 🛠️ Project Structure
```
lib/
 ├── main.dart
 ├── models/
 │    └── book.dart
 ├── screens/
 │    └── home_screens.dart
 ├── widgets/
 │    ├── book_card.dart
 │    ├── book_detail.dart
 │    ├── add_book.dart
 │    ├── book_grid.dart
 │    └── book_search.dart
 └── utils/
```

## 🧑‍💻 Built With
- Flutter 3.x
- Dart
- Google Fonts
- FilePicker
- Responsive design principles
