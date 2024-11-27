import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posapp/api/fetch_products.dart';
import 'package:posapp/api/product.dart';
import 'package:posapp/pages/cart.dart';
import 'package:badges/badges.dart' as badges;

final productProvider = StateNotifierProvider<ProductNotifier, List<Product>>(
  (ref) => ProductNotifier(),
);

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the product provider
    final productList = ref.watch(productProvider);

    // Fetch the products after the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (productList.isEmpty) {
        ref.read(productProvider.notifier).fetchProducts();
      }
    });

    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(child: Text(title)),
        actions: [
          // Badge with the number of distinct items in the cart
          badges.Badge(
            badgeContent: Text(
              '${cart.length}', // Number of distinct items in the cart
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            position: badges.BadgePosition.topEnd(top: 5, end: 5),
            showBadge: cart.isNotEmpty, // Show badge only if the cart is not empty
            badgeStyle: const badges.BadgeStyle(
              badgeColor: Colors.red, // Badge color
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              tooltip: 'Open shopping cart',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartPage()),
                );
              },
            ),
          ),
        ],
      ),
      body: productList.isEmpty
          ? Center(
              child: ElevatedButton(
                onPressed: () {
                  ref.read(productProvider.notifier).fetchProducts();
                },
                child: const Text('Fetch Products'),
              ),
            )
          : GridView.builder(
              itemCount: productList.length,
              itemBuilder: (context, index) {
                final product = productList[index];
                // Watch the cart provider to see if the product is in the cart
                final cartItem = ref.watch(cartProvider)[product.id];

                double discountedPrice = product.price *
                    (1 - product.discountPercentage / 100);  
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          product.thumbnail,
                          fit: BoxFit.fitHeight,
                          height: height * 0.15,
                          width: double.infinity,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text('Brand: ${product.brand}'),
                            Row(
                              children: [
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                SizedBox(width: width * 0.01,),
                                Text(
                                  '\$${discountedPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.green, // Color for discounted price
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      cartItem == null
                          ? ElevatedButton(
                              onPressed: () {
                                // Add the product to the cart
                                ref.read(cartProvider.notifier).addToCart(product);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple.shade100,
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                minimumSize: const Size(150, 25),
                              ),
                              child: const Text('Add to Cart +'),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    ref
                                        .read(cartProvider.notifier)
                                        .reduceQuantity(product.id);
                                  },
                                ),
                                Text(cartItem.quantity.toString()),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    ref
                                        .read(cartProvider.notifier)
                                        .addToCart(product);
                                  },
                                ),
                              ],
                            ),
                    ],
                  ),
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
            ),
    );
  }
}
