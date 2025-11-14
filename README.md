# Gold Circle App

A Flutter application for posting and managing offers within a gold circle community. Members can create, browse, and manage offers with detailed information including pricing, categories, and tags.

## Features

### Offer Management
- **Create Offers**: Post new offers with comprehensive details
- **Edit Offers**: Update existing offers at any time
- **Delete Offers**: Remove offers with confirmation
- **View Details**: See full offer information on dedicated detail pages

### Offer Form Fields
- Title (required, min 3 characters)
- Description (required, min 10 characters)
- Price (required, numeric validation)
- Category (dropdown selection)
- Created By (your name/business name)
- Image URL (optional)
- Tags (multiple tags support)

### Browse & Search
- **Search**: Find offers by title, description, or tags
- **Filter by Category**: Browse offers by specific categories
- **Categories Available**:
  - Services
  - Products
  - Events
  - Education
  - Health & Wellness
  - Technology
  - Other

### User Interface
- Clean, modern Material Design 3
- Gold-themed color scheme
- Responsive layout
- Pull-to-refresh functionality
- Empty state messages
- Loading indicators
- Success/error notifications

## Project Structure

```
lib/
├── main.dart                          # App entry point and theme configuration
├── models/
│   └── offer.dart                     # Offer data model with JSON serialization
├── providers/
│   └── offer_provider.dart            # State management for offers
├── screens/
│   ├── offer_form_screen.dart         # Create/edit offer form
│   ├── offer_list_screen.dart         # Browse and search offers
│   └── offer_detail_screen.dart       # Detailed offer view
└── widgets/
    └── (reusable widgets as needed)
```

## Dependencies

- **flutter**: Flutter SDK
- **provider**: State management
- **intl**: Date and currency formatting
- **uuid**: Unique ID generation

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (included with Flutter)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd gold-circle-app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Building for Production

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## Usage

### Posting an Offer
1. Tap the "Post Offer" floating action button
2. Fill in the required fields:
   - Enter a descriptive title
   - Provide detailed description
   - Set your price
   - Select appropriate category
   - Add your name/business name
3. Optionally add:
   - Image URL for visual representation
   - Tags for better discoverability
4. Tap "Post Offer" to publish

### Searching Offers
- Use the search bar to find offers by keywords
- Search looks through titles, descriptions, and tags
- Clear search with the X button

### Filtering Offers
- Tap the filter icon in the app bar
- Select a category to view only offers in that category
- Clear filter by tapping the X on the category chip

### Managing Your Offers
- Tap on any offer card to view full details
- Use the menu (three dots) to edit or delete
- Confirmation required before deletion

## State Management

The app uses Provider for state management:
- **OfferProvider**: Manages all offer-related state and operations
- Reactive UI updates when offers change
- Loading states for async operations
- Error handling with user feedback

## Data Model

Each offer contains:
- Unique ID (auto-generated UUID)
- Title
- Description
- Price
- Category
- Created by (user/business name)
- Creation timestamp
- Tags (array of strings)
- Image URL (optional)
- Active status

## Design Decisions

1. **State Management**: Provider was chosen for its simplicity and official Flutter support
2. **Local Storage**: Currently stores offers in memory; can be extended to use persistent storage
3. **Material Design 3**: Modern, accessible UI components
4. **Form Validation**: Client-side validation ensures data quality
5. **Gold Theme**: Custom color scheme reflecting the "Gold Circle" brand

## Future Enhancements

- [ ] Persistent storage (SQLite/Hive)
- [ ] User authentication
- [ ] Image upload functionality
- [ ] Favorites/bookmarking
- [ ] Offer expiration dates
- [ ] Push notifications
- [ ] Messaging between users
- [ ] Payment integration
- [ ] Location-based filtering
- [ ] Social sharing

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
