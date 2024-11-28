import 'package:flutter/material.dart';

import '../payment_button.dart';
import 'qr_button.dart';

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
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.confirmedOrders.length,
      itemBuilder: (context, orderIndex) {
        final order = widget.confirmedOrders[orderIndex];
        final totalAmount = widget.calculateTotal(order);

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
                        if (isEditing)
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  if (pedido['cantidad'] > 1) {
                                    widget.updateQuantity(orderIndex, index,
                                        pedido['cantidad'] - 1);
                                  }
                                },
                              ),
                              Text('${pedido['cantidad']}'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  widget.updateQuantity(orderIndex, index,
                                      pedido['cantidad'] + 1);
                                },
                              ),
                              const Spacer(),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    widget.removeFromOrder(orderIndex, index),
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
                    if (isEditing)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isEditing = false;
                          });
                        },
                        child: const Text('Guardar Cambios',
                            style: TextStyle(color: Colors.green)),
                      )
                    else
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isEditing = true;
                          });
                        },
                        child: const Text('Editar Orden',
                            style: TextStyle(color: Colors.blue)),
                      ),
                    TextButton(
                      onPressed: () {
                        widget.cancelOrder(orderIndex);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Orden ${orderIndex + 1} cancelada correctamente'),
                          ),
                        );
                      },
                      child: const Text('Cancelar Orden',
                          style: TextStyle(color: Colors.red)),
                    ),
                    if (!isEditing)
                      Flexible(
                        child: SizedBox(
                          width: 180,
                          height: 50,
                          child: PaymentButton(
                            amount: totalAmount, // Monto dinámico
                            purchaseNumber:
                                '987654321', // Número único de pedido
                          ),
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
