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
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      favoriteProvider = Provider.of<FavoriteDrugProvider>(context, listen: false);
      isFavorite = favoriteProvider.isDrugFavorite(widget.drug);

    });
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

            //category
            Row(
              children: [
                Icon(Icons.category),
                SizedBox(width: 8),
                Text(
                  'Category - အုပ်စု',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            //category
            Text(
              widget.drug.category,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 34),

            //ingredients
            Row(
              children: [
                Center(
                  child: Icon(Icons.local_florist),
                ),
                SizedBox(width: 8),
                Center(
                  child: Text(
                    'Ingredients - ပါဝင်သောဆေးများ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                        color: Colors.blueAccent
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            //ingredients
            Text(
              widget.drug.ingredients,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 34),
            //type
            Row(
              children: [
                Center(
                  child: Icon(Icons.category),
                ),
                SizedBox(width: 8),
                Center(
                  child: Text(
                    'Type - အမျိုးအစား',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                        color: Colors.blueAccent
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            //type
            Text(
              widget.drug.type,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 34),
            //indication
            Row(
              children: [
                Center(
                  child: Icon(Icons.format_indent_increase),
                ),
                SizedBox(width: 8),
                Center(
                  child: Text(
                    'Indication - ဆေးအသုံး',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                        color: Colors.blueAccent
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            //indication
            Text(
              widget.drug.indication,
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 34),
            //madeIn
            Row(
              children: [
                Center(
                  child: Icon(Icons.location_pin),
                ),
                SizedBox(width: 8),
                Center(
                  child: Text(
                    'Made In - တင်သွင်းသည့်နိုင်ငံ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                        color: Colors.blueAccent
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            //madeIn
            Text(
              widget.drug.madeIn,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 34),
            //price
            Row(
              children: [
                Center(
                  child: Icon(Icons.attach_money),
                ),
                SizedBox(width: 8),
                Center(
                  child: Text(
                    'Price - စျေးနှုန်း',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                        color: Colors.blueAccent
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            //price
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



