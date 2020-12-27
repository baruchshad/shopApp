import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://shopapp-bb864.firebaseio.com/orders/$userId.json?auth=$authToken';
    DateTime timeStamp = DateTime.now();
    if (total < 0.01) {
      return;
    }
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timeStamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList()
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        dateTime: timeStamp,
        amount: total,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://shopapp-bb864.firebaseio.com/orders/$userId.json?auth=$authToken';
    final List<OrderItem> loadedOrders = [];
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    if (extractedData != null) {
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price'],
                  ))
              .toList(),
        ));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    }
  }
}
