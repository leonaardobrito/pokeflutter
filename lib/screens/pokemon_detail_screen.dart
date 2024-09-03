import 'package:flutter/material.dart';
import 'package:pokemon_app/screens/pokemon_list_screen.dart';
import '../models/pokemon.dart';

class PokemonDetailScreen extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetailScreen({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name.capitalize()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(pokemon.imageUrl, height: 150),
            ),
            const SizedBox(height: 16),
            Text('Name: ${pokemon.name.capitalize()}',
                style: Theme.of(context).textTheme.headlineSmall),
            Text('ID: ${pokemon.id}',
                style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
