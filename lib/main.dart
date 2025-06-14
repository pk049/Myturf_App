import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_turf/splashscreen.dart';
import 'package:my_turf/flutterlogo.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

void main() {
  runApp(const MyApp());
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
        // Using Google Fonts for premium typography
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        // Ensure proper icon theme
        iconTheme: const IconThemeData(
          color: Color(0xFF0A9D56),
        ),
        // Add elevated button theme for consistent premium buttons
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
        // Customize card theme for a premium look
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

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  List<Turf> turfs = [];
  List<Turf> filteredTurfs = [];
  bool isLoading = true;
  String errorMessage = '';
  String searchQuery = '';
  String selectedCity = 'Mumbai';
  late TabController _tabController;

  // List of available cities for dropdown
  final List<String> cities = ['Mumbai', 'Delhi', 'Bangalore', 'Chennai', 'Hyderabad', 'Pune'];

  // List of sport categories
  final List<Map<String, dynamic>> categories = [
    {'name': 'Football', 'icon': Icons.sports_soccer},
    {'name': 'Cricket', 'icon': Icons.sports_cricket},
    {'name': 'Tennis', 'icon': Icons.sports_tennis},
    {'name': 'Basketball', 'icon': Icons.sports_basketball},
    {'name': 'Badminton', 'icon': Icons.sports_volleyball},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    fetchTurfs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchTurfs() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:4000/get_turfs'));
      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 200 && responseJson['status'] == 'success') {
        List turfsData = responseJson['data'];
        setState(() {
          turfs = turfsData.map((json) => Turf.fromJson(json)).toList();
          filteredTurfs = turfs; // Initialize filtered turfs with all turfs
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

  void updateSelectedCity(String? city) {
    if (city != null) {
      setState(() {
        selectedCity = city;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: false,
                floating: true,
                snap: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                expandedHeight: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: Theme.of(context).colorScheme.background,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const MyTurfLogo(fontSize: 26),
                      CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: IconButton(
                          icon: const Icon(Icons.person_outlined, color: Color(0xFF2A3547)),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Find Your Perfect',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                      const Text(
                        'Turf Nearby',
                        style: TextStyle(
                          color: Color(0xFF2A3547),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
                  child: Row(
                    children: [
                      Expanded(
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
                              hintText: 'Search for turfs...',
                              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                              prefixIcon: const Icon(Icons.search, color: Color(0xFF0AC76C)),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF0AC76C),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: PopupMenuButton<String>(
                          icon: const Icon(Icons.filter_list, color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onSelected: updateSelectedCity,
                          itemBuilder: (context) {
                            return cities.map((String city) {
                              return PopupMenuItem<String>(
                                value: city,
                                child: Text(city),
                              );
                            }).toList();
                          },
                          tooltip: 'Filter by city',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(top: 15),
                  height: 100,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: index == 0
                                    ? const Color(0xFF0AC76C)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                categories[index]['icon'],
                                color: index == 0
                                    ? Colors.white
                                    : const Color(0xFF2A3547),
                                size: 30,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              categories[index]['name'],
                              style: TextStyle(
                                color: index == 0
                                    ? const Color(0xFF0AC76C)
                                    : Colors.grey[700],
                                fontWeight: index == 0
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Popular Turfs',
                        style: TextStyle(
                          color: Color(0xFF2A3547),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF0AC76C),
                        ),
                        child: const Text(
                          'See All',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: isLoading
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF0AC76C)))
              : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red)))
              : filteredTurfs.isEmpty
              ? const Center(child: Text('No turfs available'))
              : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 5, bottom: 20),
              itemCount: filteredTurfs.length,
              itemBuilder: (context, index) {
                final turf = filteredTurfs[index];
                return PremiumTurfCard(turf: turf);
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_filled, 'Home', true),
              _buildNavItem(Icons.search, 'Search', false),
              _buildNavItem(Icons.bookmark_border, 'Bookmarks', false),
              _buildNavItem(Icons.calendar_month_outlined, 'Bookings', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? const Color(0xFF0AC76C) : Colors.grey[400],
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFF0AC76C) : Colors.grey[400],
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class PremiumTurfCard extends StatelessWidget {
  final Turf turf;

  const PremiumTurfCard({super.key, required this.turf});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and overlay content
          Stack(
            children: [
              // Image with gradient overlay
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Stack(
                  children: [
                    turf.photos.isNotEmpty
                        ? Image.network(
                      turf.photos.first,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 180,
                          color: Colors.grey[300],
                          child: const Icon(Icons.sports_soccer, size: 50, color: Colors.grey),
                        );
                      },
                    )
                        : Container(
                      height: 180,
                      color: Colors.grey[300],
                      child: const Icon(Icons.sports_soccer, size: 50, color: Colors.grey),
                    ),
                    // Gradient overlay for better text visibility
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.center,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bookmark button
              Positioned(
                top: 15,
                right: 15,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(Icons.bookmark_border, size: 20, color: Colors.grey[800]),
                  ),
                ),
              ),

              // Price tag
              Positioned(
                top: 15,
                left: 15,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0AC76C),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    '₹1200/hr',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),

              // Title at the bottom of the image
              Positioned(
                bottom: 15,
                left: 15,
                right: 15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        turf.turfName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              offset: Offset(0, 1),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          const Text(
                            '4.2',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Bottom content
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.grey[600], size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Pin: ${turf.pinCode}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    // Distance
                    Text(
                      '2.5 km away',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Amenities row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildAmenityChip('Football'),
                      _buildAmenityChip('Floodlights'),
                      _buildAmenityChip('Changing Room'),
                      _buildAmenityChip('Parking'),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // Available slots and book now button
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Available Slots',
                          style: TextStyle(
                            color: Color(0xFF2A3547),
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '4 slots today',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Book Now'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityChip(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F8F4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE0F0EA)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF0AC76C),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class Turf {
  final String turfName;
  final String pinCode;
  final List<String> photos;
  final Owner owner;

  Turf({
    required this.turfName,
    required this.pinCode,
    required this.photos,
    required this.owner,
  });

  factory Turf.fromJson(Map<String, dynamic> json) {
    List<String> photosList = [];
    if (json['photos'] != null) {
      photosList = List<String>.from(json['photos']);
    }

    return Turf(
      turfName: json['turf_name'] ?? '',
      pinCode: json['pin_code'] ?? '',
      photos: photosList,
      owner: Owner.fromJson(json['owner'] ?? {}),
    );
  }
}

class Owner {
  final String ownerName;
  final String contactNumber;
  final String email;

  Owner({
    required this.ownerName,
    required this.contactNumber,
    required this.email,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      ownerName: json['owner_name'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      email: json['email'] ?? '',
    );
  }
}