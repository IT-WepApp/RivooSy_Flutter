import 'package:flutter/material.dart';
import 'package:shared_models/store_model.dart';
import 'package:user_app/services/store_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storesState = ref.watch(storesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: storesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        data: (stores) {
          if (stores.isNotEmpty) {
            return _buildStoreList(context, stores);
          } else {
            return const Center(child: Text('No stores found.'));
          }
        },
      ),
    );
  }

  Widget _buildStoreList(BuildContext context, List<Store> stores) {
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
  }
}

final storesProvider = StateNotifierProvider<StoresNotifier, AsyncValue<List<Store>>>(
  (ref) => StoresNotifier(ref),
);

class StoresNotifier extends StateNotifier<AsyncValue<List<Store>>> {
  final Ref ref;
  StoresNotifier(this.ref) : super(const AsyncValue.loading()) {
    getStores();
  }

  Future<void> getStores() async {
    try {
      final storeService = ref.read(storeServiceProvider);
      final stores = await storeService.getStores();
      state = AsyncValue.data(stores);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
}
}