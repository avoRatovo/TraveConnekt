import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListTripPage extends StatefulWidget {
  final String selectedDeparture;
  final String selectedArrival;
  final String selectedDate;

  ListTripPage({
    required this.selectedDeparture,
    required this.selectedArrival,
    required this.selectedDate,
  });

  @override
  _ListTripPageState createState() => _ListTripPageState();
}

class _ListTripPageState extends State<ListTripPage> {
  List<Map<String, String>> filteredTrips = [];
  String selectedFilter = "heure"; // Par défaut, tri par heure
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTripsFromFirebase();
  }

  Future<void> _loadTripsFromFirebase() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('Travel').get();

      final trips = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          "depart": data["depart"]?.toString() ?? "",
          "arrivee": data["arrivee"]?.toString() ?? "",
          "date": data["date"]?.toString() ?? "",
          "heure_depart": data["heure_depart"]?.toString() ?? "",
          "heure_arrivee": data["heure_arrivee"]?.toString() ?? "",
          "agence": data["agence"]?.toString() ?? "",
          "prix": data["prix"]?.toString() ?? "0",
          "place_libre": data["place_libre"]?.toString() ?? "0",
        };
      }).toList();

      setState(() {
        filteredTrips = trips.where((trip) =>
        trip["depart"] == widget.selectedDeparture &&
            trip["arrivee"] == widget.selectedArrival &&
            trip["date"] == widget.selectedDate
        ).toList();

        _sortTrips();
        isLoading = false;
      });
    } catch (e) {
      print("Erreur lors du chargement : $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _sortTrips() {
    if (selectedFilter == "heure") {
      filteredTrips.sort((a, b) => a["heure_depart"]!.compareTo(b["heure_depart"]!));
    } else if (selectedFilter == "prix") {
      filteredTrips.sort((a, b) => int.parse(a["prix"]!).compareTo(int.parse(b["prix"]!)));
    } else if (selectedFilter == "agence") {
      filteredTrips.sort((a, b) => a["agence"]!.compareTo(b["agence"]!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voyages disponibles'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 🔹 Section filtres
          Padding(
            padding: EdgeInsets.all(10),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Filtrer par",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildRadioButton("Heure", "heure"),
                        _buildRadioButton("Prix", "prix"),
                        _buildRadioButton("Agence", "agence"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 🔹 Affichage résultats
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredTrips.isEmpty
                ? Center(
              child: Text(
                "Aucun voyage trouvé pour ces critères",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
                : ListView.builder(
              itemCount: filteredTrips.length,
              itemBuilder: (context, index) {
                final trip = filteredTrips[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${trip["depart"]} → ${trip["arrivee"]}',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(
                              "${trip["prix"]} FCFA",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.orange, size: 18),
                            SizedBox(width: 5),
                            Text(
                              'Départ: ${trip["heure_depart"]} - Arrivée: ${trip["heure_arrivee"]}',
                              style: TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.business, color: Colors.purple, size: 18),
                            SizedBox(width: 5),
                            Text(
                              'Agence: ${trip["agence"]}',
                              style: TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioButton(String label, String value) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: selectedFilter,
          activeColor: Colors.blue,
          onChanged: (String? newValue) {
            setState(() {
              selectedFilter = newValue!;
              _sortTrips();
            });
          },
        ),
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
