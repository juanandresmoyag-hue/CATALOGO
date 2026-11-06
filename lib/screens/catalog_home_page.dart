import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/product.dart';
import '../widgets/product_form_dialog.dart';

class CatalogHomePage extends StatefulWidget {
  const CatalogHomePage({super.key});

  @override
  State<CatalogHomePage> createState() => _CatalogHomePageState();
}

class _CatalogHomePageState extends State<CatalogHomePage> {
  final List<Product> _products = [];
  bool _isLoading = true;
  Object? _loadError;
  String _selectedCategory = 'Todos';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final catalogJson = await rootBundle.loadString('assets/products.json');
      final decodedCatalog = jsonDecode(catalogJson);
      if (decodedCatalog is! List) {
        throw const FormatException('El catálogo debe ser una lista.');
      }

      final products = decodedCatalog.map((entry) {
        if (entry is! Map<String, dynamic>) {
          throw const FormatException('Registro de producto inválido.');
        }
        return Product.fromJson(entry);
      }).toList();

      if (!mounted) return;
      setState(() {
        _products.addAll(products);
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loadError = error;
        _isLoading = false;
      });
    }
  }

  List<Product> get _visibleProducts {
    return _products.where((product) {
      final matchesCategory =
          _selectedCategory == 'Todos' || product.category == _selectedCategory;
      final query = _searchQuery.trim().toLowerCase();
      final matchesSearch =
          query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  Future<void> _addProduct() async {
    final product = await showDialog<Product>(
      context: context,
      builder: (_) => const ProductFormDialog(),
    );
    if (product != null && mounted) {
      setState(() => _products.insert(0, product));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Componente agregado al catálogo')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: Text('Cargando catálogo...')));
    }
    if (_loadError != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('No se pudo cargar el catálogo: $_loadError'),
          ),
        ),
      );
    }

    final products = _visibleProducts;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 24,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(
                Icons.memory_rounded,
                color: Colors.white,
                size: 23,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Catálogo SENATI',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                ),
                Text(
                  'TECNOLOGÍA PARA APRENDER',
                  style: TextStyle(
                    fontSize: 9,
                    letterSpacing: 1.15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF75817D),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: width > 620 ? 260 : 52,
            child: width > 620
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: TextField(
                      onChanged: (value) =>
                          setState(() => _searchQuery = value),
                      decoration: const InputDecoration(
                        hintText: 'Buscar componente',
                        prefixIcon: Icon(Icons.search_rounded),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  )
                : IconButton(
                    tooltip: 'Buscar',
                    onPressed: _showSearch,
                    icon: const Icon(Icons.search_rounded),
                  ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 920),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: _CatalogHeading(productCount: _products.length),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 44,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  scrollDirection: Axis.horizontal,
                  children: [
                    'Todos',
                    ...productCategories,
                  ].map(_buildCategoryChip).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                child: Row(
                  children: [
                    Text(
                      _selectedCategory == 'Todos'
                          ? 'Componentes'
                          : _selectedCategory,
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const Spacer(),
                    Text(
                      '${products.length} ${products.length == 1 ? 'producto' : 'productos'}',
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: const Color(0xFF75817D)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: products.isEmpty
                    ? _EmptyCatalog(
                        isSearching: _searchQuery.isNotEmpty,
                        onClear: () {
                          setState(() {
                            _searchQuery = '';
                            _selectedCategory = 'Todos';
                          });
                        },
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                        itemCount: products.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return _ProductCard(
                            product: product,
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/details',
                              arguments: product,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addProduct,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nuevo componente'),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final selected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(category),
        selected: selected,
        showCheckmark: false,
        onSelected: (_) => setState(() => _selectedCategory = category),
        labelStyle: TextStyle(
          color: selected ? Colors.white : const Color(0xFF53615C),
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: Colors.white,
        selectedColor: Theme.of(context).colorScheme.primary,
        side: BorderSide(
          color: selected
              ? Theme.of(context).colorScheme.primary
              : const Color(0xFFE2E9E6),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Future<void> _showSearch() async {
    final query = await showDialog<String>(
      context: context,
      builder: (context) => _SearchDialog(initialValue: _searchQuery),
    );
    if (query != null) {
      setState(() => _searchQuery = query);
    }
  }
}

class _CatalogHeading extends StatelessWidget {
  const _CatalogHeading({required this.productCount});

  final int productCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Inventario tecnológico',
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.5),
        ),
        const SizedBox(height: 6),
        Text(
          'Explora los componentes disponibles en nuestros laboratorios.',
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: const Color(0xFF75817D)),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF4EF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.inventory_2_outlined,
                size: 18,
                color: Color(0xFF176B58),
              ),
              const SizedBox(width: 9),
              Text(
                '$productCount componentes registrados',
                style: const TextStyle(
                  color: Color(0xFF176B58),
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.onTap});

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFE7ECEA)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F5F2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            _categoryIcon(product.category),
            color: const Color(0xFF176B58),
          ),
        ),
        title: Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 7),
          child: Wrap(
            spacing: 9,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _CategoryTag(category: product.category),
              Text(
                _formatPrice(product.price),
                style: const TextStyle(
                  color: Color(0xFF176B58),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Color(0xFF84918C),
        ),
      ),
    );
  }
}

class _CategoryTag extends StatelessWidget {
  const _CategoryTag({required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        category,
        style: const TextStyle(
          color: Color(0xFF53615C),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EmptyCatalog extends StatelessWidget {
  const _EmptyCatalog({required this.isSearching, required this.onClear});

  final bool isSearching;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.inventory_2_outlined,
              size: 42,
              color: Color(0xFF9BA7A2),
            ),
            const SizedBox(height: 12),
            Text(
              isSearching
                  ? 'No encontramos componentes'
                  : 'No hay componentes en esta categoría',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            if (isSearching) ...[
              const SizedBox(height: 10),
              TextButton(
                onPressed: onClear,
                child: const Text('Limpiar filtros'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SearchDialog extends StatefulWidget {
  const _SearchDialog({required this.initialValue});

  final String initialValue;

  @override
  State<_SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<_SearchDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialValue,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Buscar componente'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Nombre o categoría',
          prefixIcon: Icon(Icons.search_rounded),
        ),
        onSubmitted: (value) => Navigator.pop(context, value),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: const Text('Buscar'),
        ),
      ],
    );
  }
}

IconData _categoryIcon(String category) {
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

String _formatPrice(double price) => 'S/. ${price.toStringAsFixed(2)}';
