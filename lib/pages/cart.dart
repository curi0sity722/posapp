import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posapp/api/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}

// Cart provider to manage the state of the cart
final cartProvider = StateNotifierProvider<CartNotifier, Map<int, CartItem>>(
  (ref) => CartNotifier(),
);

class CartNotifier extends StateNotifier<Map<int, CartItem>> {
  CartNotifier() : super({});

  void addToCart(Product product) {
    if (state.containsKey(product.id)) {
      state = {
        ...state,
        product.id: CartItem(
          product: product,
          quantity: state[product.id]!.quantity + 1,
        ),
      };
    } else {
      state = {
        ...state,
        product.id: CartItem(product: product, quantity: 1),
      };
    }
  }

  void reduceQuantity(int productId) {
    if (state.containsKey(productId)) {
      final currentQuantity = state[productId]!.quantity;

      if (currentQuantity > 1) {
        state = {
          ...state,
          productId: CartItem(
            product: state[productId]!.product,
            quantity: currentQuantity - 1,
          ),
        };
      } else {
        // Remove item from cart if quantity reaches 0
        removeFromCart(productId);
      }
    }
  }

  void removeFromCart(int productId) {
    final updatedCart = {...state};
    updatedCart.remove(productId);
    state = updatedCart;
  }
}


class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    // Calculate the total cost of items in the cart
    double totalCost = cart.values.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: cart.isEmpty
                ? const Center(
                    child: Text('Your cart is empty!'),
                  )
                : ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final cartItem = cart.values.elementAt(index);

                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Image.network(cartItem.product.thumbnail),
                          title: Text(cartItem.product.title),
                          subtitle: Text(
                              'Price: \$${cartItem.product.price}\nQuantity: ${cartItem.quantity}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  ref
                                      .read(cartProvider.notifier)
                                      .reduceQuantity(cartItem.product.id);
                                },
                              ),
                              Text(cartItem.quantity.toString()),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  ref
                                      .read(cartProvider.notifier)
                                      .addToCart(cartItem.product);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey.shade200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${totalCost.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
