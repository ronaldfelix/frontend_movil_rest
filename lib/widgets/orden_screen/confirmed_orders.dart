import 'package:flutter/material.dart';
import '../qr_button.dart';
import '../payment_dialog.dart';

class ConfirmedOrdersWidget extends StatefulWidget {
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
  _ConfirmedOrdersWidgetState createState() => _ConfirmedOrdersWidgetState();
}

class _ConfirmedOrdersWidgetState extends State<ConfirmedOrdersWidget> {
  bool isEditing = false;
  bool paymentSuccessful = false; // New state variable

  void _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => PaymentDialog(
        onPaymentSuccess: () {
          setState(() {
            paymentSuccessful = true;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.confirmedOrders.length,
      itemBuilder: (context, orderIndex) {
        final order = widget.confirmedOrders[orderIndex];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    'Pedido ${orderIndex + 1} - Total: S/. ${widget.calculateTotal(order).toStringAsFixed(2)}'),
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
                        if (!paymentSuccessful) // Only show buttons if payment is not done
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: isEditing
                                    ? () {
                                        if (pedido['cantidad'] > 1) {
                                          widget.updateQuantity(orderIndex,
                                              index, pedido['cantidad'] - 1);
                                        }
                                      }
                                    : null,
                              ),
                              Text('${pedido['cantidad']}'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: isEditing
                                    ? () {
                                        widget.updateQuantity(orderIndex, index,
                                            pedido['cantidad'] + 1);
                                      }
                                    : null,
                              ),
                              const Spacer(),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: isEditing
                                    ? () => widget.removeFromOrder(
                                        orderIndex, index)
                                    : null,
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
                    if (paymentSuccessful)
                      const Text(
                        'Pago realizado correctamente',
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      )
                    else ...[
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isEditing = !isEditing;
                          });
                        },
                        child: Text(
                          isEditing ? 'Guardar Cambios' : 'Editar Orden',
                          style: TextStyle(
                              color: isEditing ? Colors.green : Colors.blue),
                        ),
                      ),
                      TextButton(
                        onPressed: () => widget.cancelOrder(orderIndex),
                        child: const Text('Cancelar Orden',
                            style: TextStyle(color: Colors.red)),
                      ),
                      ElevatedButton(
                        onPressed: () => _showPaymentDialog(context),
                        child: const Text('Pagar'),
                      ),
                    ],
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
