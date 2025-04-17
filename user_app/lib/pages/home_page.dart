import 'package:flutter/material.dart';
import 'package:user_app/models/store_model.dart';
import 'package:user_app/services/store_service.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Import cached_network_image

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StoreService _storeService = StoreService();
  late Future<List<Store>> _storesFuture;

  @override
  void initState() {
    super.initState();
    _storesFuture = _storeService.getStores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: FutureBuilder<List<Store>>(
        future: _storesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final stores = snapshot.data!;
            return ListView.builder(
              itemCount: stores.length,
              itemBuilder: (context, index) {
                final store = stores[index];
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/store-details', arguments: store.id);
                  },
                  child: ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: store.image,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(store.name),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No stores found.'));
          }
        },
      ),
    );
  }
}