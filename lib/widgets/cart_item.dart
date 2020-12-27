import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem({
    @required this.id,
    @required this.productId,
    @required this.price,
    @required this.quantity,
    @required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to remove the item from the cart?'),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text('Yes'),
              ),
            ],
          ),
        );
      },
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(
                  child: Text('\$$price'),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${(price * quantity)}'),
            trailing: Container(
              width: 125,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Provider.of<Cart>(context, listen: false)
                          .changeQuantity(productId, 0);
                    },
                  ),
                  Text('$quantity x'),
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      Provider.of<Cart>(context, listen: false)
                          .changeQuantity(productId, 1);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
    );
  }
}
