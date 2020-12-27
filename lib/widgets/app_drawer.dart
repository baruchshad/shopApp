import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/user_product_screen.dart';
import '../screens/orders_screen.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello freind'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop', style: Theme.of(context).textTheme.title),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders', style: Theme.of(context).textTheme.title),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeNamed);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products',
                style: Theme.of(context).textTheme.title),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout', style: Theme.of(context).textTheme.title),
            onTap: () {
              // Navigator.of(context)
              //     .pushReplacementNamed(UserProductScreen.routeName);
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
