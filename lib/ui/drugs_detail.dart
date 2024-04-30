// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../data/favorite_drug_provider.dart';
// import '../data/drug_model.dart';
//
// class DrugDetailScreen extends StatefulWidget {
//   final Drug drug;
//
//   DrugDetailScreen({required this.drug});
//
//   @override
//   State<DrugDetailScreen> createState() => _DrugDetailScreenState();
// }
//
// class _DrugDetailScreenState extends State<DrugDetailScreen> {
//   late FavoriteDrugProvider favoriteProvider;
//   bool isFavorite = false;
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     favoriteProvider = Provider.of<FavoriteDrugProvider>(context, listen: false);
//     setState(() {
//       isFavorite = favoriteProvider.isDrugFavorite(widget.drug);
//     });
//   }
//
//
//   void toggleFavorite() {
//     setState(() {
//       isFavorite = !isFavorite;
//     });
//     favoriteProvider.toggleFavorite(widget.drug);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.drug.name),
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.favorite,
//               color: isFavorite ? Colors.red : null,
//             ),
//             onPressed: toggleFavorite,
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Category: ${widget.drug.category}'),
//             Text('Ingredients: ${widget.drug.ingredients}'),
//             Text('Type: ${widget.drug.type}'),
//             Text('Price: \$${widget.drug.price}'),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/favorite_drug_provider.dart';
import '../data/drug_model.dart';
import '../data/hitory_provider.dart';

class DrugDetailScreen extends StatefulWidget {
  final Drug drug;

  DrugDetailScreen({required this.drug});

  @override
  State<DrugDetailScreen> createState() => _DrugDetailScreenState();
}

class _DrugDetailScreenState extends State<DrugDetailScreen> {
  late FavoriteDrugProvider favoriteProvider;
  bool isFavorite = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    favoriteProvider = Provider.of<FavoriteDrugProvider>(context, listen: false);
    setState(() {
      isFavorite = favoriteProvider.isDrugFavorite(widget.drug);
    });

    Provider.of<HistoryProvider>(context, listen: false).addToHistory(widget.drug);
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
    favoriteProvider.toggleFavorite(widget.drug);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.drug.name),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  widget.drug.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Category',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.drug.category,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'Ingredients',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.drug.ingredients,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'Type',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.drug.type,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'Price',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '\$${widget.drug.price}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
