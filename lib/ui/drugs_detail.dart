import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import '../data/favorite_drug_provider.dart';
import '../data/drug_model.dart';

class DrugDetailScreen extends StatefulWidget {
  final Drug drug;

  DrugDetailScreen({super.key, required this.drug});

  @override
  State<DrugDetailScreen> createState() => _DrugDetailScreenState();
}

class _DrugDetailScreenState extends State<DrugDetailScreen> {
  late FavoriteDrugProvider favoriteProvider;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      favoriteProvider = Provider.of<FavoriteDrugProvider>(context, listen: false);
      isFavorite = favoriteProvider.isDrugFavorite(widget.drug);

    });
  }

  void toggleFavorite() {
    Vibration.vibrate(duration: 100);

    setState(() {
      isFavorite = !isFavorite;
    });
    favoriteProvider.toggleFavorite(widget.drug);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isFavorite ? 'Added to favorites' : 'Remove from favorites'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // title: Text(widget.drug.name),
        actions: [
          Consumer<FavoriteDrugProvider>(
            builder: (context, favoriteProvider, _) {
              bool isFavorite = favoriteProvider.isDrugFavorite(widget.drug);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: toggleFavorite,
              );
            },
          ),
        ],

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue[800],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  widget.drug.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            //category title
             Row(
              children: [
                const Icon(Icons.category),
                const SizedBox(width: 8),
                Text(
                  'Category - အုပ်စု',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            //category from database
            Text(
              widget.drug.category,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 34),

            //ingredients title
             Row(
              children: [
                const Center(
                  child: Icon(Icons.local_florist),
                ),
                const SizedBox(width: 8),
                Center(
                  child: Text(
                    'Ingredients - ပါဝင်သောဆေးများ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            //ingredients from database
            Text(
              widget.drug.ingredients,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 34),

            //Dosage form title
            Row(
              children: [
                const Center(
                  child: Icon(Icons.category),
                ),
                const SizedBox(width: 8),
                Center(
                  child: Text(
                    'Dosage Form - ဆေးပုံသဏ္ဌာန်',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            //Dosage form from database
            Text(
              widget.drug.type,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 34),

            //indication title
            Row(
              children: [
                const Center(
                  child: Icon(Icons.format_indent_increase),
                ),
                const SizedBox(width: 8),
                Center(
                  child: Text(
                    'Indication - ဆေးအသုံး',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            //indication from database
            Text(
              widget.drug.indication,
              style: const TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 34),

            //madeIn title
            Row(
              children: [
                const Center(
                  child: Icon(Icons.location_pin),
                ),
                const SizedBox(width: 8),
                Center(
                  child: Text(
                    'Made In - ထုတ်လုပ်သည့်နိုင်ငံ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            //madeIn from database
            Text(
              widget.drug.madeIn,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 34),

            //price title
            Row(
              children: [
                const Center(
                  child: Icon(Icons.attach_money),
                ),
                const SizedBox(width: 8),
                Center(
                  child: Text(
                    'Price - စျေးနှုန်း',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            //price from database
            Text(
              '\MMK ${widget.drug.price}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}



