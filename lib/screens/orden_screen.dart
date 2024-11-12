import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../widgets/menu_bar.dart';
import '../widgets/orden_screen/current_order.dart';
import '../widgets/orden_screen/confirmed_orders.dart';
import '../config/database_helper.dart';

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
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _checkLoginStatus();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    final user = await DatabaseHelper().getUser();
    setState(() {
      isLoggedIn = user != null;
    });
  }

  double _calculateTotal(List<Map<String, dynamic>> items) {
    return items.fold(
        0.0, (sum, item) => sum + item['precio'] * item['cantidad']);
  }

  void _confirmOrder() {
    if (!isLoggedIn) {
      // Mostrar QR provisional y mensaje de inicio de sesión
      _showLoginRequiredDialog();
    } else {
      setState(() {
        OrdenScreen._confirmedOrders.add(List.from(OrdenScreen._cart));
        OrdenScreen._cart.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Orden confirmada')),
      );
    }
  }

  void _showLoginRequiredDialog() {
    // Crear el contenido del QR usando los elementos del carrito
    final cartDetails = OrdenScreen._cart.map((item) {
      return 'Nombre: ${item['nombre']}, Cantidad: ${item['cantidad']}, Precio: S/.${item['precio']}';
    }).join("\n");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Necesitas iniciar sesión'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Para confirmar tu orden, por favor inicia sesión.'),
            const SizedBox(height: 10),
            QrImageView(
              data: cartDetails,
              version: QrVersions.auto,
              size: 200.0,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
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
            isLoggedIn: isLoggedIn,
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
      bottomNavigationBar: const BottomMenuBar(
        currentIndex: 2,
      ),
    );
  }
}
