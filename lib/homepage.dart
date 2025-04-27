import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'listtrip.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedDeparture;
  String? selectedArrival;
  DateTime? selectedDate;

  final List<String> cities = [
    'Kribi', 'Douala', 'Yaounde', 'Ngaoundere', 'Maroua', 'Baffoussam'
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TravelConneckT'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔸 Publicité en haut
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                color: Colors.amber[100],
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("🔥 Offre Spéciale Voyage !",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(height: 8),
                      Text(
                          "Réservez maintenant et profitez de -20% sur votre prochain trajet avec Finex 🚍"),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Offre spéciale activée !")));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          foregroundColor: Colors.white,
                        ),
                        child: Text("En profiter"),
                      ),
                    ],
                  ),
                ),
              ),

              // 🔽 Espace pour décaler le formulaire
              SizedBox(height: 50),

              // 🔹 Lieu de départ
              Text('Lieu de départ',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF071777))),
              SizedBox(height: 5),
              _buildDropdown(cities, selectedDeparture, (val) {
                setState(() => selectedDeparture = val);
              }),

              SizedBox(height: 20),

              // 🔹 Lieu d’arrivée
              Text('Lieu d’arrivée',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF071777))),
              SizedBox(height: 5),
              _buildDropdown(cities, selectedArrival, (val) {
                setState(() => selectedArrival = val);
              }),

              SizedBox(height: 20),

              // 🔹 Date de départ
              Text('Date de départ',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF071777))),
              SizedBox(height: 5),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 5,
                          spreadRadius: 1),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDate == null
                            ? 'Sélectionner une date'
                            : DateFormat('dd/MM/yyyy')
                            .format(selectedDate!),
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      Icon(Icons.calendar_today, color: Colors.black),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),

              // 🔹 Bouton rechercher
              Center(
                child: ElevatedButton(
                  onPressed: _searchTrips,
                  child: Text('Rechercher'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF071777),
                    foregroundColor: Colors.white,
                    padding:
                    EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                    textStyle:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    shadowColor: Colors.grey.withOpacity(0.5),
                    elevation: 5,
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(List<String> items, String? selectedValue,
      void Function(String?) onChanged) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 5),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: DropdownButtonFormField<String>(
          value: selectedValue,
          onChanged: onChanged,
          items: items
              .map((city) => DropdownMenuItem<String>(
            value: city,
            child: Text(city, style: TextStyle(color: Colors.black)),
          ))
              .toList(),
          decoration: InputDecoration(border: InputBorder.none),
        ),
      ),
    );
  }

  void _searchTrips() {
    if (selectedDeparture == null ||
        selectedArrival == null ||
        selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez remplir tous les champs !'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedDeparture == selectedArrival) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Le lieu de départ et d’arrivée ne peuvent pas être identiques !'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListTripPage(
          selectedDeparture: selectedDeparture!,
          selectedArrival: selectedArrival!,
          selectedDate: DateFormat('dd/MM/yyyy').format(selectedDate!),
        ),
      ),
    );
  }
}