import 'package:flutter/material.dart';

class MenuDetailModal extends StatelessWidget {
  final dynamic pedido; // Información del pedido
  final VoidCallback onAddToCart; // Función para añadir al carrito

  const MenuDetailModal({
    Key? key,
    required this.pedido,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ajustar el tamaño al contenido
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen del pedido
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: NetworkImage(pedido['imagen_url']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Nombre del pedido
              Text(
                pedido['nombre'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Descripción del pedido
              Text(
                pedido['descripcion'],
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              // Precio del pedido
              Text(
                'S/. ${pedido['precio']}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Botones
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Cerrar modal
                    },
                    child: const Text('Cerrar'),
                  ),
                  ElevatedButton(
                    onPressed: onAddToCart, // Añadir al carrito
                    child: const Text('Añadir al carrito'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
