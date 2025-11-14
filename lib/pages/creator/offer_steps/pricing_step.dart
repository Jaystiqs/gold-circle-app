import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../utils/app_styles.dart';

class OfferPricingStep extends StatefulWidget {
  final double basePrice;
  final Function(double) onBasePriceChanged;

  const OfferPricingStep({
    super.key,
    required this.basePrice,
    required this.onBasePriceChanged,
  });

  @override
  State<OfferPricingStep> createState() => _OfferPricingStepState();
}

class _OfferPricingStepState extends State<OfferPricingStep> {
  late TextEditingController _basePriceController;

  @override
  void initState() {
    super.initState();
    _basePriceController = TextEditingController(
      text: widget.basePrice > 0 ? widget.basePrice.toStringAsFixed(0) : '',
    );

    _basePriceController.addListener(_onBasePriceChanged);
  }

  @override
  void dispose() {
    _basePriceController.dispose();
    super.dispose();
  }

  void _onBasePriceChanged() {
    final value = double.tryParse(_basePriceController.text) ?? 0;
    widget.onBasePriceChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Set your price',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppStyles.textPrimary,
                height: 1.0,
                letterSpacing: -0.5,
              ), textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Choose a competitive price for your service',
              style: TextStyle(
                fontSize: 18,
                color: AppStyles.textSecondary,
                letterSpacing: -0.3,
              ), textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),

          TextField(
            controller: _basePriceController,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: AppStyles.textPrimary,
            ),
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 20, top: 3, right: 8),
                child: Text(
                  'GHS',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: AppStyles.textSecondary,
                  ),
                ),
              ),
              hintText: '500',
              hintStyle: TextStyle(
                fontSize: 32,
                color: AppStyles.textLight,
                fontWeight: FontWeight.w600,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppStyles.textPrimary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

}