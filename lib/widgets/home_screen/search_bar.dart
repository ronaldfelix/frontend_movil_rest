import 'package:flutter/material.dart';

class HomeSearchBar extends StatefulWidget {
  final Function(String) onSearch;

  const HomeSearchBar({super.key, required this.onSearch});

  @override
  _HomeSearchBarState createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];

  void _handleSearch(String query) async {
    widget.onSearch(query);
    if (query.isEmpty) {
      setState(() {
        _searchResults.clear(); // Limpiar resultados
      });
      return;
    }

    final results =
        await widget.onSearch(query); // Llamada para obtener resultados
    setState(() {
      _searchResults = results; // Actualizar los res busqueda
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Buscar...',
              suffixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              fillColor: Colors.white,
              filled: true,
            ),
            onChanged: _handleSearch, // Si cambia llama busqueda
          ),
        ),
        if (_searchResults.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: List.generate(_searchResults.length, (index) {
                    return ListTile(
                      leading: const Icon(Icons.search, color: Colors.grey),
                      title: Text(_searchResults[index]),
                      onTap: () {
                        print('Seleccionado: ${_searchResults[index]}');
                      },
                    );
                  }),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
