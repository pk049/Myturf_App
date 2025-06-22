import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_turf/splashscreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_turf/provider.dart';
import 'package:my_turf/sidebar.dart';
import 'package:my_turf/setloc.dart';
import 'package:my_turf/bookturf_screen.dart' as BookTurfScreen;
import 'package:my_turf/bookturf_screen.dart';
import 'package:my_turf/turf.dart'; // Import the new Turf model

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocationProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyTurf App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF09D071),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0AC76C),
          primary: const Color(0xFF0AC76C),
          secondary: const Color(0xFF2A3547),
          surface: Colors.white,
          background: const Color(0xFFF8F9FB),
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        iconTheme: const IconThemeData(
          color: Color(0xFF0A9D56),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0AC76C),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Turf> turfs = [];
  List<Turf> filteredTurfs = [];
  bool isLoading = true;
  String errorMessage = '';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchTurfs();
  }

  Future<void> fetchTurfs() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:4000/get_turfs'));
      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 200 && responseJson['status'] == 'success') {
        List turfsData = responseJson['data'];

        setState(() {
          turfs = turfsData.map((json) => Turf.fromJson(json)).toList();
          filteredTurfs = turfs;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load turfs. Status code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching turfs: $e';
        isLoading = false;
      });
    }
  }

  void filterTurfs(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredTurfs = turfs;
      } else {
        filteredTurfs = turfs
            .where((turf) =>
            turf.turfName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void navigateToCityPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LocationSelectionScreen()));
  }

  void navigateToBookingScreen(Turf turf) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TurfDetailsScreen(turf: turf),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: CoolSidebar(),
      body: Column(
        children: [
          // Green themed header section
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0AC76C),
                  Color(0xFF09D071),
                ],
              ),
            ),

            child: SafeArea(

              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 20, 30),
                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 48), // Placeholder for balance
                        Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(Icons.menu, size: 28, color: Colors.white),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Main header content
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Let's Play",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),


                        const SizedBox(height: 8),

                        // City display from provider
                        Consumer<LocationProvider>(
                          builder: (context, locationProvider, child) {
                            return GestureDetector(
                              onTap: navigateToCityPage,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.white,
                                      size: 18,
                                    ),

                                    const SizedBox(width: 6),

                                    Text(
                                      locationProvider.city ?? 'Select City',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),

                                    const SizedBox(width: 6),

                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.white,
                                      size: 18,
                                    ),

                                  ],
                                ),
                              ),
                            );
                          },//builder bracket
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),




          // second child of column Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                onChanged: filterTurfs,
                decoration: InputDecoration(
                  hintText: 'Search for cricket turfs...',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF0AC76C)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),

            ),
          ),



          //Third child Turf list
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF0AC76C)))
                : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red)))
                : filteredTurfs.isEmpty
                ? const Center(child: Text('No cricket turfs available'))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: filteredTurfs.length,
              itemBuilder: (context, index) {
                final turf = filteredTurfs[index];
                return SimpleTurfCard(
                  turf: turf,
                  onTap: () => navigateToBookingScreen(turf),
                );
              },
            ),
          ),
        ],
      ),

    );
  }
}

class SimpleTurfCard extends StatelessWidget {
  final Turf turf;
  final VoidCallback? onTap;

  const SimpleTurfCard({
    super.key,
    required this.turf,
    this.onTap,
  });



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Background image with tap indication
            Stack(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    color: Colors.grey[300],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: turf.photos.isNotEmpty
                        ? Image.network(
                      turf.photos.first,
                      fit: BoxFit.cover,

                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF0AC76C),
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.sports_cricket, size: 50, color: Colors.grey),
                          ),
                        );
                      },

                    )
                        : Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.sports_cricket, size: 50, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                // Tap indicator overlay
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Color(0xFF0AC76C),
                    ),
                  ),
                ),
              ],
            ),

            // Content below image
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Turf name and location
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          turf.turfName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2A3547),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (turf.pinCode.isNotEmpty) ...[
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey[600],
                        ),

                        const SizedBox(width: 4),
                        Text(
                          turf.pinCode,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Price
                  Text(
                    turf.price as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0AC76C),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Available slots and owner info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${turf.availableSlots} slots available',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0AC76C).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Book Now',
                          style: TextStyle(
                            color: Color(0xFF0AC76C),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}