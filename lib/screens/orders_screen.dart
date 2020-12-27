import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeNamed = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future _ordersFuture;

  Future _obtainedOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  Future<void> _refreshOrders(BuildContext context) async {
    await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainedOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    print('building orders');
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () {
          return _refreshOrders(context);
        },
        child: FutureBuilder(
          future: _ordersFuture,
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (dataSnapshot.error != null) {
              return Center(child: Text('An Error Ocurred!'));
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, index) =>
                      OrderItem(orderData.orders[index]),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
