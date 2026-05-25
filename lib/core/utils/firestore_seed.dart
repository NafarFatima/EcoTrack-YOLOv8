import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../constant/app_assets.dart';

class FirestoreSeed {
  static Future<void> seedCategories() async {
    final firestore = FirebaseFirestore.instance;
    final categoriesCollection = firestore.collection('categories');

    final snapshot = await categoriesCollection.get();
    
    final categories = [
      {
        'title': 'Plastic',
        'description': 'Recyclable plastic bottles and containers',
        'iconPath': AppAssets.plasticIcon,
        'colorValue': 0xFF2196F3,
        'pointsPerKg': 50,
      },
      {
        'title': 'Paper',
        'description': 'Newspapers, cardboard, and office paper',
        'iconPath': AppAssets.paperIcon,
        'colorValue': 0xFFFFC107,
        'pointsPerKg': 100,
      },
      {
        'title': 'Glass',
        'description': 'Glass bottles and jars',
        'iconPath': AppAssets.glassIcon,
        'colorValue': 0xFF4CAF50,
        'pointsPerKg': 40,
      },
      {
        'title': 'Metal',
        'description': 'Aluminum cans and scrap metal',
        'iconPath': AppAssets.metalIcon,
        'colorValue': 0xFFF44336,
        'pointsPerKg': 40,
      },
      {
        'title': 'Organic',
        'description': 'Food waste and garden clippings',
        'iconPath': AppAssets.leafIcon,
        'colorValue': 0xFF795548,
        'pointsPerKg': 30,
      },
    ];

    if (snapshot.docs.isEmpty) {
      for (var category in categories) {
        await categoriesCollection.add(category);
      }
      debugPrint('Categories seeded successfully.');
    } else {
      // Update existing categories if points or other details changed
      for (var target in categories) {
        final existing = snapshot.docs.where((doc) => doc['title'] == target['title']).toList();
        if (existing.isNotEmpty) {
          await categoriesCollection.doc(existing.first.id).update({
            'pointsPerKg': target['pointsPerKg'],
            'description': target['description'],
            'iconPath': target['iconPath'],
            'colorValue': target['colorValue'],
          });
        }
      }
      debugPrint('Categories updated successfully.');
    }
  }

  static Future<void> seedMissions() async {
    final firestore = FirebaseFirestore.instance;
    final missionsCollection = firestore.collection('missions');

    final snapshot = await missionsCollection.get();
    
    final missions = [
      {
        'title': 'Plastic Recycler',
        'description': 'Log any plastic waste to complete this mission',
        'points': 50,
        'type': 'daily',
        'iconPath': AppAssets.plasticIcon,
      },
      {
        'title': 'Paper Saver',
        'description': 'Help save trees by recycling paper',
        'points': 100,
        'type': 'daily',
        'iconPath': AppAssets.paperIcon,
      },
      {
        'title': 'Organic Recycler',
        'description': 'Compost your organic waste',
        'points': 30,
        'type': 'daily',
        'iconPath': AppAssets.leafIcon,
      },
      {
        'title': 'Metal Recycler',
        'description': 'Recycle aluminum or scrap metal',
        'points': 40,
        'type': 'daily',
        'iconPath': AppAssets.metalIcon,
      },
      {
        'title': 'Glass Recycler',
        'description': 'Properly dispose of glass containers',
        'points': 40,
        'type': 'daily',
        'iconPath': AppAssets.glassIcon,
      },
    ];

    if (snapshot.docs.isEmpty) {
      for (var mission in missions) {
        await missionsCollection.add(mission);
      }
      debugPrint('Missions seeded successfully.');
    } else {
      // Update mission points to match new requirements
      for (var target in missions) {
        final existing = snapshot.docs.where((doc) => doc['title'] == target['title']).toList();
        if (existing.isNotEmpty) {
          await missionsCollection.doc(existing.first.id).update({
            'points': target['points'],
          });
        } else {
          await missionsCollection.add(target);
        }
      }
      debugPrint('Missions updated successfully.');
    }
  }
}
