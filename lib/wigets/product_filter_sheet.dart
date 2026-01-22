import 'package:flutter/material.dart';
import '../controllers/product_controller.dart';

class ProductFilterSheet extends StatelessWidget {
  final ProductController controller;

  const ProductFilterSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Category',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              return Column(
                children: [
                  DropdownButton<String>(
                    value: controller.selectedCategory,
                    isExpanded: true,
                    items: controller.categories.map((cat) {
                      return DropdownMenuItem(value: cat, child: Text(cat));
                    }).toList(),
                    onChanged: (val) {
                      controller.setFilters(category: val);
                      Navigator.pop(
                        context,
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
