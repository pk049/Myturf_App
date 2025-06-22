import 'package:flutter/material.dart';
import 'package:my_turf/provider.dart';
import 'package:provider/provider.dart';

class LocationSelectionScreen extends StatefulWidget {
  const LocationSelectionScreen({Key? key}) : super(key: key);

  @override
  State<LocationSelectionScreen> createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<LocationModel> _locations = [
    LocationModel(
      name: 'Pune',
      subtitle: 'Maharashtra',
      icon: Icons.location_city,
      isPopular: true,
    ),
    LocationModel(
      name: 'Mumbai',
      subtitle: 'Maharashtra',
      icon: Icons.location_city,
      isPopular: true,
    ),
    LocationModel(
      name: 'Nagpur',
      subtitle: 'Maharashtra',
      icon: Icons.location_city,
      isPopular: false,
    ),
    LocationModel(
      name: 'Sangli',
      subtitle: 'Maharashtra',
      icon: Icons.location_city,
      isPopular: false,
    ),
    LocationModel(
      name: 'Nashik',
      subtitle: 'Maharashtra',
      icon: Icons.location_city,
      isPopular: false,
    ),
    LocationModel(
      name: 'Aurangabad',
      subtitle: 'Maharashtra',
      icon: Icons.location_city,
      isPopular: false,
    ),
  ];

  List<LocationModel> get _filteredLocations {
    if (_searchQuery.isEmpty) {
      return _locations;
    }
    return _locations
        .where((location) =>
        location.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  List<LocationModel> get _popularLocations {
    return _locations.where((location) => location.isPopular).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2A3547)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Select Location',
          style: TextStyle(
            color: Color(0xFF2A3547),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search your city...',
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Current Location Button
                InkWell(
                  onTap: () {
                    _selectCurrentLocation();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0AC76C).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF0AC76C),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0AC76C),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.my_location,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Use Current Location',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2A3547),
                                ),
                              ),
                              Text(
                                'Auto-detect your location',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Color(0xFF0AC76C),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Location List
          Expanded(
            child: _searchQuery.isEmpty
                ? _buildLocationSections()
                : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSections() {
    return ListView(
      children: [
        // Popular Cities Section
        if (_popularLocations.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Popular Cities',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2A3547),
              ),
            ),
          ),
          ..._popularLocations.map((location) => _buildLocationTile(location)),
          const SizedBox(height: 16),
        ],

        // All Cities Section
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'All Cities',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2A3547),
            ),
          ),
        ),
        ..._locations.map((location) => _buildLocationTile(location)),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (_filteredLocations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No cities found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching for a different city',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Search Results (${_filteredLocations.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2A3547),
            ),
          ),
        ),
        ..._filteredLocations.map((location) => _buildLocationTile(location)),
      ],
    );
  }

  Widget _buildLocationTile(LocationModel location) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF0AC76C).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            location.icon,
            color: const Color(0xFF0AC76C),
            size: 24,
          ),
        ),
        title: Row(
          children: [
            Text(
              location.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2A3547),
              ),
            ),
            if (location.isPopular) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF0AC76C),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Popular',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(
          location.subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: () => _selectLocation(location.name),
      ),
    );
  }

  void _selectLocation(String locationName) {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    locationProvider.setLocation(locationName);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Location set to $locationName'),
        backgroundColor: const Color(0xFF0AC76C),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // Navigate back or to next screen
    Navigator.pop(context);
  }

  void _selectCurrentLocation() {
    // Simulate getting current location
    // In real app, use location services
    _selectLocation('Current Location');
  }
}

// location_model.dart
class LocationModel {
  final String name;
  final String subtitle;
  final IconData icon;
  final bool isPopular;

  LocationModel({
    required this.name,
    required this.subtitle,
    required this.icon,
    this.isPopular = false,
  });
}

