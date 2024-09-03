import 'dart:convert';
import 'package:http/http.dart' as http;

class PokeApiService {
  // [turn the baseUrls into array]
  static const String baseUrl = 'https://pokeapi.co/api/v2';

  Future<List<String>> fetchPokemonList() async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon?limit=100'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // criar estrutura/tipo do dado recebido
      final List<dynamic> results = data['results'];
      return results.map((pokemon) => pokemon['name'].toString()).toList();
    } else {
      throw Exception('Failed to load Pokémon list');
    }
  }

  Future<Map<String, dynamic>> fetchPokemonDetails(String name) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon/$name'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load Pokémon details');
    }
  }
}
