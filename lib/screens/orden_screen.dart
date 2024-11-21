import 'package:flutter/material.dart';
import '../widgets/orden_screen/current_order.dart';
import '../widgets/orden_screen/confirmed_orders.dart';

class OrdenScreen extends StatefulWidget {
  static final List<Map<String, dynamic>> _cart = [];
  static final List<List<Map<String, dynamic>>> _confirmedOrders = [];

  static void addToCart(Map<String, dynamic> pedido) {
    _cart.add({...pedido, 'cantidad': 1});
  }

  const OrdenScreen({super.key});

  @override
  _OrdenScreenState createState() => _OrdenScreenState();
}

class _OrdenScreenState extends State<OrdenScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  double _calculateTotal(List<Map<String, dynamic>> items) {
    return items.fold(
        0.0, (sum, item) => sum + item['precio'] * item['cantidad']);
  }

  void _confirmOrder() {
    setState(() {
      OrdenScreen._confirmedOrders.add(List.from(OrdenScreen._cart));
      OrdenScreen._cart.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Orden confirmada')),
    );
  }

  void _updateQuantity(int orderIndex, int itemIndex, int quantity) {
    setState(() {
      if (orderIndex == -1) {
        OrdenScreen._cart[itemIndex]['cantidad'] = quantity;
      } else {
        OrdenScreen._confirmedOrders[orderIndex][itemIndex]['cantidad'] =
            quantity;
      }
    });
  }

  void _removeFromOrder(int orderIndex, int itemIndex) {
    setState(() {
      if (orderIndex == -1) {
        OrdenScreen._cart.removeAt(itemIndex);
      } else {
        OrdenScreen._confirmedOrders[orderIndex].removeAt(itemIndex);
      }
    });
  }

  void _cancelOrder(int orderIndex) {
    setState(() {
      OrdenScreen._confirmedOrders.removeAt(orderIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Ordenes'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Mi Pedido'),
            Tab(text: 'Pedidos hechos'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CurrentOrderWidget(
            cart: OrdenScreen._cart,
            updateQuantity: (index, quantity) =>
                _updateQuantity(-1, index, quantity),
            removeFromCart: (index) => _removeFromOrder(-1, index),
            confirmOrder: _confirmOrder,
            total: _calculateTotal(OrdenScreen._cart),
            isLoggedIn: true, // Cambiar según sea necesario
          ),
          ConfirmedOrdersWidget(
            confirmedOrders: OrdenScreen._confirmedOrders,
            updateQuantity: _updateQuantity,
            removeFromOrder: _removeFromOrder,
            cancelOrder: _cancelOrder,
            calculateTotal: _calculateTotal,
          ),
        ],
      ),
    );
  }
}
