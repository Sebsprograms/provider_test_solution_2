import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Represenst a Cart Item. Has <int>`id`, <String>`name`, <int>`quantity`
class CartItem {
  int id;
  String name;
  int quantity;

  CartItem(this.id, this.name, this.quantity);
}

/// Manages a cart. Implements ChangeNotifier
class CartState with ChangeNotifier {
  List<CartItem> _products = [];

  CartState();

  /// The number of individual items in the cart. That is, all cart items' quantities.
  // int get totalCartItems => 0; // return actual cart volume.
  int get totalCartItems {
    int count = 0;
    // loop over _products array & add quantity prop to count.
    _products.map((product) => {count += product.quantity});
    return count;
  }

  /// The list of CartItems in the cart
  List<CartItem> get products => _products;

  /// Clears the cart. Notifies any consumers. <<<  *** Notify consumers incomplete. ??? asuming thats change notifier
  void clearCart() {
    _products = [];
  }

  /// Adds a new CartItem to the cart. Notifies any consumers.
  void addToCart({required CartItem item}) {
    // praying this is spread syntax
    _products = [..._products, item];
  }

  /// Updates the quantity of the Cart item with this id. Notifies any consumers.
  void updateQuantity({required int id, required int newQty}) {
    _products.map((cartItem) => {
          if (cartItem.id == id) {cartItem.quantity = newQty}
        });
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartState(),
      child: MyCartApp(),
    ),
  );
}

class MyCartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Column(
            children: [
              ListOfCartItems(),
              CartSummary(),
              CartControls(),
            ],
          ),
        ),
      ),
    );
  }
}

// 2x incomplete (provider)
class CartControls extends StatelessWidget {
  /// Handler for Add Item pressed
  void _addItemPressed(BuildContext context) {
    /// mostly unique cartItemId.
    /// don't change this; not important for this test
    int nextCartItemId = Random().nextInt(10000);
    String nextCartItemName = 'A cart item';
    int nextCartItemQuantity = 1;

    // Actually use the CartItem constructor to assign id, name and quantity
    CartItem item =
        CartItem(nextCartItemId, nextCartItemName, nextCartItemQuantity);

    // TODO: Get the cart current state through Provider. Add this cart item to cart.
  }

  /// TODO: Handle clear cart pressed. Should clear the cart
  // assuming i need to "provide" a reference to clearCart method in CartState
  void _clearCartPressed(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    final Widget addCartItemWidget = TextButton(
      child: Text('Add Item'),
      onPressed: () {
        _addItemPressed(context);
      },
    );

    final Widget clearCartWidget = TextButton(
      child: Text('Clear Cart'),
      onPressed: () {
        _clearCartPressed(context);
      },
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        addCartItemWidget,
        clearCartWidget,
      ],
    );
  }
}

// incomplete x 3 --> text widget displaying current item quantity needs state reference.
// buttons calling onPress methods improperly.
class ListOfCartItems extends StatelessWidget {
  /// Handles adding 1 to the current cart item quantity.
  /// provide refernce to _products in card state
  /// map products & increment quantity of CartItem with matching id.
  /// ask the boss about delta
  void _incrementQuantity(context, int id, int delta) {}

  /// Handles removing 1 to the current cart item quantity.
  /// Don't forget: we can't have negative numbers of an item in the cart
  /// same logic as above just with --
  /// & only execute if conditional check (quantity > 0) eval to True
  void _decrementQuantity(context, int id, int delta) {}

  @override
  Widget build(BuildContext context) {
    return Consumer<CartState>(
        builder: (BuildContext context, CartState cart, Widget? child) {
      if (cart.totalCartItems == 0) {
        // Return a Widget that tells us there are no items in the cart
        return Text(
          "There are no items in your cart.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24),
        );
      }

      return Column(children: [
        ...cart.products.map(
          (c) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // TODO: Widget for the line item name AND current quantity, eg "Item name x 4".
                Text("Item name x STRING INTERPOLATION WITH PROVIDER"),
                //  Current quantity should update whenever a change occurs.
                // TODO: Button to handle incrementing cart quantity. Handler is above.
                ElevatedButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    // since this should take args I'm assuming I will use the provider lib
                    _incrementQuantity;
                  },
                ),
                // TODO: Button to handle decrementing cart quantity. Handler is above.
                ElevatedButton(
                  child: Icon(Icons.remove),
                  onPressed: () {
                    // provider lib knowledge needed.
                    _decrementQuantity;
                  },
                ),
              ],
            ),
          ),
        ),
      ]);
    });
  }
}

class CartSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartState>(
      builder: (BuildContext context, CartState cart, Widget? child) {
        return Text("Total items: ${cart.totalCartItems}");
      },
    );
  }
}
