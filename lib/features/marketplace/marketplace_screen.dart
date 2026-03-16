import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  _MarketplaceScreenState createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final List<Map<String, dynamic>> _products = [
    {
      'id': 'prod_001',
      'name': 'Shampoing Hydratant Premium',
      'price': 29.99,
      'category': 'Soin',
      'rating': 4.5,
      'image': 'https://picsum.photos/seed/shampoo/300/300'
    },
    {
      'id': 'prod_002',
      'name': 'Masque Nourrissant Cheveux',
      'price': 39.99,
      'category': 'Soin',
      'rating': 4.8,
      'image': 'https://picsum.photos/seed/mask/300/300'
    },
    {
      'id': 'prod_003',
      'name': 'Huile d\'Argan Pure',
      'price': 24.99,
      'category': 'Soin',
      'rating': 4.7,
      'image': 'https://picsum.photos/seed/argan/300/300'
    },
    {
      'id': 'prod_004',
      'name': 'Brosse Démêlante Pro',
      'price': 19.99,
      'category': 'Accessoire',
      'rating': 4.3,
      'image': 'https://picsum.photos/seed/brush/300/300'
    },
    {
      'id': 'prod_005',
      'name': 'Spray Thermoprotecteur',
      'price': 17.99,
      'category': 'Style',
      'rating': 4.4,
      'image': 'https://picsum.photos/seed/spray/300/300'
    },
    {
      'id': 'prod_006',
      'name': 'Gel Coiffant Fort',
      'price': 12.99,
      'category': 'Style',
      'rating': 4.2,
      'image': 'https://picsum.photos/seed/gel/300/300'
    },
    {
      'id': 'prod_007',
      'name': 'Sèche-cheveux Ionique',
      'price': 79.99,
      'category': 'Accessoire',
      'rating': 4.9,
      'image': 'https://picsum.photos/seed/dryer/300/300'
    },
    {
      'id': 'prod_008',
      'name': 'Après-shampoing Réparateur',
      'price': 22.99,
      'category': 'Soin',
      'rating': 4.6,
      'image': 'https://picsum.photos/seed/conditioner/300/300'
    },
  ];

  final List<String> _categories = ['Tous', 'Soin', 'Style', 'Accessoire'];
  String _selectedCategory = 'Tous';
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _filteredProducts = _products;
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _products.where((p) {
        final matchesQuery =
            (p['name'] as String).toLowerCase().contains(query);
        final matchesCategory = _selectedCategory == 'Tous' ||
            p['category'] == _selectedCategory;
        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  void _setCategory(String cat) {
    setState(() => _selectedCategory = cat);
    _filterProducts();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F5),
      appBar: AppBar(
        title: const Text('Boutique'),
        backgroundColor: const Color(0xFF204854),
        foregroundColor: Colors.white,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => _openCart(context),
              ),
              if (cart.itemCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFDB05E),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${cart.itemCount}',
                      style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Rechercher un produit...',
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((cat) {
                      final isSelected = _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(cat),
                          selected: isSelected,
                          onSelected: (_) => _setCategory(cat),
                          selectedColor: const Color(0xFF204854),
                          checkmarkColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredProducts.isEmpty
                ? const Center(child: Text('Aucun produit trouvé'))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      return _buildProductCard(
                          context, _filteredProducts[index], cart);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context,
      Map<String, dynamic> product, CartProvider cart) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(14)),
              child: Image.network(
                product['image'] as String,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image, size: 50),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'] as String,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.star,
                        size: 13, color: Colors.amber.shade600),
                    const SizedBox(width: 2),
                    Text(
                      '${product['rating']}',
                      style: const TextStyle(
                          fontSize: 11, color: Colors.black54),
                    ),
                    const Spacer(),
                    Text(
                      '${(product['price'] as double).toStringAsFixed(2)} €',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade700),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      cart.addItem(
                        product['id'] as String,
                        product['name'] as String,
                        product['price'] as double,
                        product['image'] as String,
                      );
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                        content:
                            Text('${product['name']} ajouté au panier'),
                        duration: const Duration(seconds: 1),
                        backgroundColor: Colors.green,
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF204854),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Ajouter',
                        style: TextStyle(
                            fontSize: 12, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openCart(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _CartSheet(),
    );
  }
}

class _CartSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.3,
      expand: false,
      builder: (_, controller) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Mon panier',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const Spacer(),
                if (cart.items.isNotEmpty)
                  TextButton(
                    onPressed: cart.clear,
                    child: const Text('Vider',
                        style: TextStyle(color: Colors.red)),
                  ),
              ],
            ),
            const Divider(),
            Expanded(
              child: cart.items.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_cart_outlined,
                              size: 64, color: Colors.black26),
                          SizedBox(height: 12),
                          Text('Votre panier est vide',
                              style: TextStyle(color: Colors.black45)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: controller,
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        final item = cart.items[index];
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(item.imageUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.grey.shade200,
                                    child: const Icon(Icons.image))),
                          ),
                          title: Text(item.name,
                              style: const TextStyle(fontSize: 13)),
                          subtitle: Text(
                              '${item.price.toStringAsFixed(2)} €',
                              style: TextStyle(
                                  color: Colors.purple.shade700,
                                  fontWeight: FontWeight.bold)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline,
                                    size: 20),
                                onPressed: () =>
                                    cart.decreaseQuantity(item.id),
                              ),
                              Text('${item.quantity}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline,
                                    size: 20),
                                onPressed: () =>
                                    cart.increaseQuantity(item.id),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            if (cart.items.isNotEmpty) ...[
              const Divider(),
              Row(
                children: [
                  const Text('Total :',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text(
                    '${cart.totalAmount.toStringAsFixed(2)} €',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade700),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF204854),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    cart.clear();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Commande passée avec succès !'),
                          backgroundColor: Colors.green),
                    );
                  },
                  child: const Text('Passer la commande',
                      style:
                          TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}

