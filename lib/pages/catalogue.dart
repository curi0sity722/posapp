import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posapp/api/fetch_products.dart';
import 'package:posapp/api/product.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(child: Text(title)),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            tooltip: 'Open shopping cart',
            onPressed: () {
              // handle the press
            },
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
                return Card(
                  elevation: 5, // Adds shadow effect
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  product.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  maxLines: 2, // Limits the text to two lines
                                  overflow: TextOverflow
                                      .ellipsis, // Adds '...' when the text exceeds two lines
                                ),
                                Text('Brand: ${product.brand}'),
                                Text('Price: \$${product.price}'),
                                Text('${product.discountPercentage}% off'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Action for button press
                        },
                        style: ElevatedButton.styleFrom(
                          // foregroundColor: Colors.white,
                          backgroundColor: Colors.purple.shade100, // Text color
                          elevation: 1, // Control the elevation (shadow)
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Control boundary (rounded corners)
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12), // Control padding
                          minimumSize:
                              Size(150, 25), // Control the button's size
                        ),
                        child: const Text('Add to Cart +'),
                      )
                    ],
                  ),
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 items per row
                crossAxisSpacing: 10, // Spacing between columns
                mainAxisSpacing: 10, // Spacing between rows
                childAspectRatio:
                    0.7, // Aspect ratio of each item (height vs width)
              ),
            ),
    );
  }
}
