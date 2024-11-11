import 'package:flutter/material.dart';
import '../services/login_service.dart';
import '../widgets/menu_bar.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({Key? key}) : super(key: key);

  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  Map<String, dynamic>? user; // Datos del usuario
  bool isLoading = true; // Indicador de carga

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Método para cargar datos del usuario desde SQLite
  Future<void> _loadUserData() async {
    final loggedInUser = await LoginService.getLoggedInUser();
    setState(() {
      user = loggedInUser;
      isLoading =
          false; // Cambia el estado de carga después de cargar los datos
    });
  }

  // Método para cerrar sesión
  Future<void> _logout() async {
    await LoginService.logout(); // Borra los datos del usuario en SQLite
    Navigator.pushReplacementNamed(
        context, '/login'); // Redirige a la pantalla de inicio de sesión
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.blueGrey,
        automaticallyImplyLeading: false, // Oculta el botón de volver
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Indicador de carga
          : user == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("No se encontraron datos del usuario."),
                      ElevatedButton(
                        onPressed: _logout,
                        child: const Text("Iniciar Sesión"),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            AssetImage('assets/profile_placeholder.png'),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        user!['nombre'] ?? 'Usuario',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user!['email'] ?? 'usuario@ejemplo.com',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user!['telefono'] ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _logout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Cerrar Sesión'),
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: const BottomMenuBar(
        currentIndex: 0,
      ),
    );
  }
}
