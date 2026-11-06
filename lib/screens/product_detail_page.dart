import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ficha técnica',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 190,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF4EF),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    _iconForCategory(product.category),
                    size: 76,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  product.category.toUpperCase(),
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: const BorderSide(color: Color(0xFFE7ECEA)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.tune_rounded, color: Color(0xFF176B58)),
                            SizedBox(width: 10),
                            Text(
                              'Características del producto',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _DetailRow(label: 'Nombre', value: product.name),
                        const Divider(height: 24),
                        _DetailRow(label: 'Categoría', value: product.category),
                        const Divider(height: 24),
                        _DetailRow(
                          label: 'Precio',
                          value: 'S/. ${product.price.toStringAsFixed(2)}',
                          valueColor: const Color(0xFF176B58),
                        ),
                        const Divider(height: 24),
                        _DetailRow(
                          label: 'Descripción',
                          value: product.description,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF4EF),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF176B58),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Stock disponible en almacén',
                          style: TextStyle(
                            color: Color(0xFF176B58),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.inventory_2_outlined,
                        color: colors.primary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Align(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Volver al catálogo'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF75817D),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? const Color(0xFF26332E),
            fontSize: 15,
            height: 1.45,
            fontWeight: label == 'Precio' ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

IconData _iconForCategory(String category) {
  return switch (category) {
    'Desktop' => Icons.computer_rounded,
    'Laptop' => Icons.laptop_mac_rounded,
    'Otros' => Icons.devices_other_rounded,
    'Impresora' => Icons.print_rounded,
    'Monitor' => Icons.monitor_rounded,
    'Mouse' => Icons.mouse_rounded,
    'Teclado' => Icons.keyboard_rounded,
    _ => Icons.devices_rounded,
  };
}
