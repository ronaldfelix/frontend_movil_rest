import 'package:flutter/material.dart';

class HomeSearchBar extends StatefulWidget {
  final Function(String) onSearch;

  const HomeSearchBar({super.key, required this.onSearch});

  @override
  _HomeSearchBarState createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
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
        onChanged: widget.onSearch,
      ),
    );
  }
}
