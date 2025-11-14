import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/offer.dart';
import '../providers/offer_provider.dart';
import 'offer_form_screen.dart';
import 'offer_detail_screen.dart';

/// Screen displaying a list of all offers
class OfferListScreen extends StatefulWidget {
  const OfferListScreen({super.key});

  @override
  State<OfferListScreen> createState() => _OfferListScreenState();
}

class _OfferListScreenState extends State<OfferListScreen> {
  String? _selectedCategory;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToOfferForm([Offer? offer]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OfferFormScreen(offer: offer),
      ),
    );
  }

  void _navigateToOfferDetail(Offer offer) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OfferDetailScreen(offer: offer),
      ),
    );
  }

  List<Offer> _getFilteredOffers(List<Offer> allOffers) {
    List<Offer> filtered = allOffers;

    // Filter by category
    if (_selectedCategory != null && _selectedCategory != 'All') {
      filtered = filtered
          .where((offer) => offer.category == _selectedCategory)
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((offer) {
        return offer.title.toLowerCase().contains(query) ||
            offer.description.toLowerCase().contains(query) ||
            offer.tags.any((tag) => tag.toLowerCase().contains(query));
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gold Circle Offers'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search offers...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Category filter chip
          if (_selectedCategory != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  label: Text('Category: $_selectedCategory'),
                  onDeleted: () {
                    setState(() {
                      _selectedCategory = null;
                    });
                  },
                ),
              ),
            ),

          // Offers list
          Expanded(
            child: Consumer<OfferProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.offers.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final filteredOffers = _getFilteredOffers(provider.offers);

                if (filteredOffers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          provider.offers.isEmpty
                              ? 'No offers yet'
                              : 'No offers match your search',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          provider.offers.isEmpty
                              ? 'Be the first to post an offer!'
                              : 'Try adjusting your filters',
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    // Simulate refresh
                    await Future.delayed(const Duration(milliseconds: 500));
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredOffers.length,
                    itemBuilder: (context, index) {
                      final offer = filteredOffers[index];
                      return OfferCard(
                        offer: offer,
                        onTap: () => _navigateToOfferDetail(offer),
                        onEdit: () => _navigateToOfferForm(offer),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToOfferForm(),
        icon: const Icon(Icons.add),
        label: const Text('Post Offer'),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCategoryOption('All'),
            ...OfferProvider.categories.map(_buildCategoryOption),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryOption(String category) {
    return RadioListTile<String>(
      title: Text(category),
      value: category,
      groupValue: _selectedCategory ?? 'All',
      onChanged: (value) {
        setState(() {
          _selectedCategory = value == 'All' ? null : value;
        });
        Navigator.pop(context);
      },
    );
  }
}

/// Card widget for displaying an offer in the list
class OfferCard extends StatelessWidget {
  final Offer offer;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const OfferCard({
    super.key,
    required this.offer,
    required this.onTap,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and menu
              Row(
                children: [
                  Expanded(
                    child: Text(
                      offer.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: const Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: const Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit();
                      } else if (value == 'delete') {
                        _showDeleteDialog(context);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                offer.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),

              // Price and category
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      currencyFormat.format(offer.price),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(
                      offer.category,
                      style: const TextStyle(fontSize: 12),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Tags
              if (offer.tags.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: offer.tags.take(3).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[700],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 8),

              // Footer with created by and date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        offer.createdBy,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    dateFormat.format(offer.createdAt),
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Offer'),
        content: const Text(
          'Are you sure you want to delete this offer? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<OfferProvider>(context, listen: false)
                  .deleteOffer(offer.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Offer deleted successfully'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
