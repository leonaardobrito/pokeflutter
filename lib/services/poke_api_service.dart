import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokeApiService {
  final String baseUrl = 'https://pokeapi.co/api/v2';

  Future<List<Pokemon>> fetchPokemons(int offset, int limit) async {
    final response = await http
        .get(Uri.parse('$baseUrl/pokemon?offset=$offset&limit=$limit'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Pokemon> pokemons = [];

      for (var result in data['results']) {
        final pokemonResponse = await http.get(Uri.parse(result['url']));
        final pokemonData = json.decode(pokemonResponse.body);
        pokemons.add(Pokemon.fromJson(pokemonData));
      }
      return pokemons;
    } else {
      throw Exception('Failed to load pokemons');
    }
  }
}

/* import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokeApiService {
  // [turn the baseUrls into array]
  final String baseUrl = 'https://pokeapi.co/api/v2';

  Future<List<Pokemon>> fetchPokemons() async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon?limit=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Pokemon> pokemons = [];

      for (var result in data['results']) {
        final pokemonResponse = await http.get(Uri.parse(result['url']));
        final pokemonData = json.decode(pokemonResponse.body);
        pokemons.add(Pokemon.fromJson(pokemonData));
      }
      return pokemons;
    } else {
      throw Exception('Failed to load pokemons');
    }
  }
}
 */