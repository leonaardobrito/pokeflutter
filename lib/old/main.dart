import 'package:flutter/material.dart';
import 'package:pokemon_app/pokemon_datail_page.dart';
import 'poke_api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokémon Search',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const PokemonSearchPage(),
    );
  }
}

class PokemonSearchPage extends StatefulWidget {
  const PokemonSearchPage({super.key});

  @override
  _PokemonSearchPageState createState() => _PokemonSearchPageState();
}

class _PokemonSearchPageState extends State<PokemonSearchPage> {
  final PokeApiService apiService = PokeApiService();
  List<String> _pokemonList = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchPokemonList();
  }

  Future<void> _fetchPokemonList() async {
    try {
      final list = await apiService.fetchPokemonList();
      setState(() {
        _pokemonList = list;
      });
    } catch (e) {
        // ignore: avoid_print
        print("Exception");
    }
  }
@override
  Widget build(BuildContext context) {
    final filteredList = _pokemonList
        .where((pokemon) =>
            pokemon.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search Pokémon',
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredList[index].capitalize()),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PokemonDetailPage(
                          pokemonName: filteredList[index],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  /* 
  @override
  Widget build(BuildContext context) {
    final filteredList = _pokemonList
        .where((pokemon) =>
            pokemon.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search Pokémon',
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredList[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  } */
}
