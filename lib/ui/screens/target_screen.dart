import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/item_viewmodel.dart';
import '../../viewmodels/cart_viewmodel.dart';
import '../../models/item.dart';
import 'dart:io';
import 'package:flutter/services.dart'; // <-- add this
import '../../app_colors.dart';


class TargetScreen extends StatefulWidget {
  const TargetScreen({super.key});

  @override
  State<TargetScreen> createState() => _TargetScreenState();
}

class _TargetScreenState extends State<TargetScreen> {
  // Keep track of the selected category index
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load items once when screen is created
    Future.microtask(() =>
        Provider.of<ItemViewModel>(context, listen: false).loadItems());
  }

  @override
  Widget build(BuildContext context) {
    // Step 4: Consume CartViewModel to display dynamic total price

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Quit the program when pressed
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else {
              exit(0); // force quit (works on desktop/web/iOS, but not recommended for iOS)
            }
          },
        ),
        title: const Text("التصنيفات"),
        centerTitle: true, // Align title to the left
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search action
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50, // Define a fixed height for the horizontal ListView
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _CategoryChip(
                  label: "أفضل العروض",
                  isSelected: _selectedCategoryIndex == 0,
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = 0;
                    });
                  },
                ),
                const SizedBox(width: 8),
                _CategoryChip(
                  label: "مستورد",
                  isSelected: _selectedCategoryIndex == 1,
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = 1;
                    });
                  },
                ),
                const SizedBox(width: 8),
                _CategoryChip(
                  label: "أجبان قابلة للدهن",
                  isSelected: _selectedCategoryIndex == 2,
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = 2;
                    });
                  },
                ),
                const SizedBox(width: 8),
                _CategoryChip(
                  label: "أجبان",
                  isSelected: _selectedCategoryIndex == 3,
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = 3;
                    });
                  },
                ),
                const SizedBox(width: 8),
                _CategoryChip(
                  label: "لحوم", // Added 'لحوم' as per original request, though not in the image
                  isSelected: _selectedCategoryIndex == 4,
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = 4;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded( // Ensure the GridView takes the remaining space
            child: Consumer<ItemViewModel>(
              builder: (context, vm, child) {
                if (vm.items.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 columns on mobile
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: vm.items.length,
                  itemBuilder: (ctx, i) => _ItemCard(item: vm.items[i]),
                );
              },
            ),
          ),
        ],
      ),
      // Step 4: Add a bottom navigation bar/cart summary
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer<CartViewModel>(
        builder: (context, cart, child) => Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () {
                  // navigate to cart screen later
                },
                icon: const Icon(Icons.arrow_left_outlined, color: Colors.white, size: 20),
                label: Text(
                  "(${cart.totalItems}) عرض السلة",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              Text(
                "${cart.totalPrice.toStringAsFixed(2)} SAR",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),

    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected && label == "أفضل العروض") // Only show checkmark for "أفضل العروض" when selected
              const Padding(
                padding: EdgeInsets.only(right: 4.0),
                child: Icon(Icons.check, size: 16, color: Colors.white),
              ),
            Text(label),
          ],
        ),
        backgroundColor: isSelected ? primaryColor : primaryColor.withOpacity(0.1),
        labelStyle: TextStyle(color: isSelected ? Colors.white : primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: isSelected ? primaryColor : primaryColor.withOpacity(0.3)),
        ),
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final Item item;
  const _ItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartViewModel>(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  /// 🍔 Rounded Burger Image with Yellow Border
                  Center(
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.amber, // yellow edge
                          width: 2,
                        ),
                        color: Colors.white,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          item.image,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  /// 🔖 Burger King Logo on top-right
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Image.asset(
                      'assets/burger_king_logo.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            /// 📝 Item Name
            Text(
              item.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            /// 💰 Price + Counter
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${item.price.toStringAsFixed(2)} SAR",
                  style: const TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.chipInactive,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.chipBorder),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () => cart.removeItem(item),
                        child: const Padding(
                          padding: EdgeInsets.all(4), // smaller tap target
                          child: Icon(Icons.remove, size: 16, color: AppColors.primary),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          '${cart.getItemQuantity(item)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      InkWell(
                        onTap: () => cart.addItem(item),
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(Icons.add, size: 16, color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


