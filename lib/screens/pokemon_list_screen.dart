import 'package:flutter/material.dart';
import '../services/poke_api_service.dart';
import '../models/pokemon.dart';
import 'pokemon_detail_screen.dart';

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PokemonListScreenState createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  final PokeApiService _apiService = PokeApiService();
  final List<Pokemon> _pokemons = [];
  List<Pokemon> _filteredPokemons = [];
  String _searchQuery = '';
  bool _isLoading = false;
  int _offset = 0;
  final int _limit = 10;
  final ScrollController _scrollController = ScrollController();
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchInitialPokemons();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialPokemons() async {
    await _fetchMorePokemons(20);
  }

  Future<void> _fetchMorePokemons([int? customLimit]) async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final limit = customLimit ?? _limit;
      final newPokemons = await _apiService.fetchPokemons(_offset, limit);

      if (!mounted) return; 

      if (newPokemons.isEmpty) {
        setState(() {
          _hasMore = false;
        });
      } else {
        setState(() {
          _pokemons.addAll(newPokemons);
          _offset += limit;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load Pokémon: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading &&
        _hasMore) {
      _fetchMorePokemons();
    }
  }

  void _filterPokemons(String query) {
    setState(() {
      _searchQuery = query;
      _filteredPokemons = _pokemons
          .where((pokemon) => pokemon.name.contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pokemonsToDisplay =
        _searchQuery.isEmpty ? _pokemons : _filteredPokemons;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon List'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search Pokémon',
                border: OutlineInputBorder(),
              ),
              onChanged: _filterPokemons,
            ),
          ),
        ),
      ),
      body: _buildPokemonList(pokemonsToDisplay),
    );
  }

  Widget _buildPokemonList(List<Pokemon> pokemons) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: pokemons.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == pokemons.length) {
          return const Center(child: CircularProgressIndicator());
        }

        final pokemon = pokemons[index];
        return ListTile(
          leading: Image.network(pokemon.imageUrl),
          title: Text(pokemon.name.capitalize()),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PokemonDetailScreen(pokemon: pokemon),
              ),
            );
          },
        );
      },
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}


/* import 'package:flutter/material.dart';
import '../services/poke_api_service.dart';
import '../models/pokemon.dart';
import 'pokemon_detail_screen.dart';

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PokemonListScreenState createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  late Future<List<Pokemon>> _pokemons;
  List<Pokemon> _filteredPokemons = [];
  String _searchQuery = '';

  final PokeApiService _apiService = PokeApiService();

  @override
  void initState() {
    super.initState();
    _pokemons = _apiService.fetchPokemons();
  }

  void _filterPokemons(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredPokemons = [];
      } else {
        _filteredPokemons = _pokemons
            .asStream()
            .expand((pokemons) => pokemons)
            .where((pokemon) => pokemon.name.contains(query.toLowerCase()))
            .toList() as List<Pokemon>;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon List'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search Pokémon',
                border: OutlineInputBorder(),
              ),
              onChanged: _filterPokemons,
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Pokemon>>(
        future: _pokemons,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final pokemons =
                _searchQuery.isEmpty ? snapshot.data! : _filteredPokemons;
            return ListView.builder(
              itemCount: pokemons.length,
              itemBuilder: (context, index) {
                final pokemon = pokemons[index];
                return ListTile(
                  leading: Image.network(pokemon.imageUrl),
                  title: Text(pokemon.name.capitalize()),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PokemonDetailScreen(pokemon: pokemon),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('No data found'));
          }
        },
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) return this;
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }
}
 */