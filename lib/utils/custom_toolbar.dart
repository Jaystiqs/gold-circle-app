import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../utils/app_styles.dart';

class CustomToolbar extends StatefulWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final Widget? rightAction;
  final bool showBackButton;
  final bool enableSearch;
  final String? searchHint;
  final ValueChanged<String>? onSearchChanged;
  final TextEditingController? searchController;

  const CustomToolbar({
    Key? key,
    required this.title,
    this.onBackPressed,
    this.rightAction,
    this.showBackButton = true,
    this.enableSearch = false,
    this.searchHint = 'Search...',
    this.onSearchChanged,
    this.searchController,
  }) : super(key: key);

  @override
  State<CustomToolbar> createState() => _CustomToolbarState();
}

class _CustomToolbarState extends State<CustomToolbar> {
  late TextEditingController _searchController;
  bool _isSearchActive = false;

  @override
  void initState() {
    super.initState();
    _searchController = widget.searchController ?? TextEditingController();
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchTextChanged);
    if (widget.searchController == null) {
      _searchController.dispose();
    }
    super.dispose();
  }

  void _onSearchTextChanged() {
    if (widget.onSearchChanged != null) {
      widget.onSearchChanged!(_searchController.text);
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearchActive = !_isSearchActive;
      if (!_isSearchActive) {
        _searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 16.0, 16.0),
      child: Column(
        children: [
          Row(
            children: [
              if (widget.showBackButton) ...[
                GestureDetector(
                  onTap: () {
                    if (widget.onBackPressed != null) {
                      widget.onBackPressed!();
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: AppStyles.textPrimary,
                    size: 24.0,
                  ),
                ),
                const SizedBox(width: 16.0),
              ],
              Expanded(
                child: Text(
                  widget.title,
                  style: AppStyles.h1.copyWith(
                    color: AppStyles.textPrimary,
                    fontWeight: AppStyles.bold,
                    letterSpacing: -1.2,
                  ),
                ),
              ),
              if (widget.enableSearch)
                IconButton(
                  icon: Icon(
                    _isSearchActive
                        ? PhosphorIcons.x()
                        : PhosphorIcons.magnifyingGlass(),
                    color: AppStyles.textPrimary,
                  ),
                  onPressed: _toggleSearch,
                )
              else if (widget.rightAction != null)
                widget.rightAction!,
            ],
          ),
          if (_isSearchActive && widget.enableSearch) ...[
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppStyles.backgroundGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                style: AppStyles.bodyMedium.copyWith(
                  color: AppStyles.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: widget.searchHint,
                  hintStyle: AppStyles.bodyMedium.copyWith(
                    color: AppStyles.textLight,
                  ),
                  prefixIcon: Icon(
                    PhosphorIcons.magnifyingGlass(),
                    color: AppStyles.textLight,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}