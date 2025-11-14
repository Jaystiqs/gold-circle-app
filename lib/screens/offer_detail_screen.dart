import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/offer.dart';
import '../providers/offer_provider.dart';
import 'offer_form_screen.dart';

/// Screen displaying detailed information about an offer
class OfferDetailScreen extends StatelessWidget {
  final Offer offer;

  const OfferDetailScreen({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final dateFormat = DateFormat('MMMM dd, yyyy \'at\' hh:mm a');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offer Details'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OfferFormScreen(offer: offer),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image (if available)
            if (offer.imageUrl != null && offer.imageUrl!.isNotEmpty)
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                child: Image.network(
                  offer.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 200,
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Icon(
                  Icons.image_outlined,
                  size: 64,
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    offer.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Price card
                  Card(
                    color: Theme.of(context).primaryColor,
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Price',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            currencyFormat.format(offer.price),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Category
                  _buildInfoSection(
                    'Category',
                    Icons.category,
                    child: Chip(
                      label: Text(offer.category),
                      backgroundColor: Theme.of(context)
                          .primaryColor
                          .withOpacity(0.1),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description
                  _buildInfoSection(
                    'Description',
                    Icons.description,
                    child: Text(
                      offer.description,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tags
                  if (offer.tags.isNotEmpty)
                    _buildInfoSection(
                      'Tags',
                      Icons.label,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: offer.tags.map((tag) {
                          return Chip(
                            label: Text(tag),
                            backgroundColor: Colors.grey[200],
                          );
                        }).toList(),
                      ),
                    ),
                  if (offer.tags.isNotEmpty) const SizedBox(height: 20),

                  // Divider
                  const Divider(height: 40),

                  // Posted by
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          offer.createdBy[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Posted by',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            offer.createdBy,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Posted date
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 20, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        'Posted on ${dateFormat.format(offer.createdAt)}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Contact button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Contact feature coming soon! Reach out to ${offer.createdBy}',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.message),
                      label: const Text('Contact Seller'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, IconData icon, {required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[700]),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
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
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to list
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
