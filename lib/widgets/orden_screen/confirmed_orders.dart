import 'package:flutter/material.dart';
import '..//niubiz_button.dart';
import '..//qr_button.dart';

class ConfirmedOrdersWidget extends StatelessWidget {
  final List<List<Map<String, dynamic>>> confirmedOrders;
  final Function(int, int, int) updateQuantity;
  final Function(int, int) removeFromOrder;
  final Function(int) cancelOrder;
  final double Function(List<Map<String, dynamic>>) calculateTotal;

  const ConfirmedOrdersWidget({
    super.key,
    required this.confirmedOrders,
    required this.updateQuantity,
    required this.removeFromOrder,
    required this.cancelOrder,
    required this.calculateTotal,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: confirmedOrders.length,
      itemBuilder: (context, orderIndex) {
        final order = confirmedOrders[orderIndex];
        final totalAmount = calculateTotal(order);

        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Pedido ${orderIndex + 1} - Total: S/. ${totalAmount.toStringAsFixed(2)}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                QRButton(order: order),
              ],
            ),
            children: [
              Column(
                children: order.map((pedido) {
                  final index = order.indexOf(pedido);
                  return ListTile(
                    title: Text(pedido['nombre']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('S/. ${pedido['precio']}'),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (pedido['cantidad'] > 1) {
                                  updateQuantity(orderIndex, index,
                                      pedido['cantidad'] - 1);
                                }
                              },
                            ),
                            Text('${pedido['cantidad']}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                updateQuantity(
                                    orderIndex, index, pedido['cantidad'] + 1);
                              },
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  removeFromOrder(orderIndex, index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: SizedBox(
                        width: 180,
                        height: 50,
                        child: NiubizButton(amount: totalAmount),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
