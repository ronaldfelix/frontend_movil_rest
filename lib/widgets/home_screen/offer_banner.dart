import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../services/menu_service.dart';
import '../../config/config.dart';
import '../../widgets/menu_detail_modal.dart';
import '../../screens/orden_screen.dart';

class OfferBanner extends StatefulWidget {
  const OfferBanner({super.key});

  @override
  _OfferBannerState createState() => _OfferBannerState();
}

class _OfferBannerState extends State<OfferBanner> {
  late Future<List<dynamic>> _offers;

  @override
  void initState() {
    super.initState();
    _offers = MenuService().fetchMenus();
  }

  // Función para mostrar el modal de detalles del menú
  void _showMenuDetail(BuildContext context, dynamic offer) {
    showDialog(
      context: context,
      builder: (context) {
        return MenuDetailModal(
          pedido: offer,
          onAddToCart: () {
            Navigator.of(context).pop(); // Cerrar el modal
            OrdenScreen.addToCart({
              'nombre': offer['nombre'],
              'imagen_url': '${Config.baseUrl}/${offer['imagen_url']}',
              'precio': offer['precio'],
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Añadido al carrito')),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _offers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar las ofertas'));
        } else if (snapshot.hasData) {
          final offers = snapshot.data!.take(5).toList();

          return CarouselSlider.builder(
            itemCount: offers.length,
            itemBuilder: (context, index, realIndex) {
              final offer = offers[index];
              return GestureDetector(
                onTap: () => _showMenuDetail(context, offer),
                child: _buildOfferItem(offer),
              );
            },
            options: CarouselOptions(
              height: 150,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              enlargeCenterPage: true,
              viewportFraction: 0.8,
              aspectRatio: 16 / 9,
            ),
          );
        } else {
          return const Center(child: Text('No se encontraron ofertas'));
        }
      },
    );
  }

  Widget _buildOfferItem(dynamic offer) {
    return Stack(
      children: [
        // Imagen de fondo
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: NetworkImage('${Config.baseUrl}/${offer['imagen_url']}'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Nombre del platillo
        Positioned(
          bottom: 10,
          left: 10,
          right: 10,
          child: Container(
            color: Colors.black54,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              offer['nombre'],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
