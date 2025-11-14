import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/favorite_service.dart';
import '../services/property_service.dart';
import '../models/property_model.dart';
import '../widgets/property_card.dart';
import 'property_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _propertyService = PropertyService();
  final _favoriteService = FavoriteService();
  final _user = FirebaseAuth.instance.currentUser;

  List<PropertyModel> favoriteProperties = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    if (_user == null) return;

    setState(() => isLoading = true);

    final favoriteIds = await _favoriteService.getFavorites(_user.uid);
    final allProperties = await _propertyService.getAllProperties();

    setState(() {
      favoriteProperties = allProperties
          .where((property) => favoriteIds.contains(property.id))
          .toList();
      isLoading = false;
    });
  }

  Future<void> _removeFavorite(String propertyId) async {
    if (_user == null) return;
    await _favoriteService.removeFromFavorites(_user.uid, propertyId);
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المفضلة')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favoriteProperties.isEmpty
          ? const Center(child: Text('لا توجد عناصر مفضلة'))
          : RefreshIndicator(
              onRefresh: _loadFavorites,
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: favoriteProperties.length,
                itemBuilder: (context, index) {
                  final property = favoriteProperties[index];
                  return PropertyCard(
                    property: property,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PropertyDetailsScreen(property: property),
                        ),
                      );
                    },
                    onDelete: () => _removeFavorite(property.id),
                  );
                },
              ),
            ),
    );
  }
}
