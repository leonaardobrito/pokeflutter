import 'package:flutter/material.dart';
import 'old/poke_api_service.dart';

class PokemonDetailPage extends StatelessWidget {
  final String pokemonName;
  final PokeApiService apiService = PokeApiService();

  PokemonDetailPage({super.key, required this.pokemonName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemonName.capitalize()), // Usando a extensão capitalize
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: apiService.fetchPokemonDetails(pokemonName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          } else {
            final pokemonData = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.network(
                      pokemonData['sprites']['front_default'],
                      height: 150,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Name: ${pokemonData['name'].capitalize()}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'Height: ${pokemonData['height']}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    'Weight: ${pokemonData['weight']}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Types:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Wrap(
                    spacing: 8,
                    children: pokemonData['types']
                        .map<Chip>((typeData) => Chip(
                              label:
                                  Text(typeData['type']['name'].capitalize()),
                            ))
                        .toList(),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) return this;
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
