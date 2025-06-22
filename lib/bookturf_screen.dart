import 'package:flutter/material.dart';
import 'package:my_turf/turf.dart'; // Import the unified Turf model

class TurfDetailsScreen extends StatefulWidget {
  final Turf turf;

  const TurfDetailsScreen({Key? key, required this.turf}) : super(key: key);

  @override
  State<TurfDetailsScreen> createState() => _TurfDetailsScreenState();
}

class _TurfDetailsScreenState extends State<TurfDetailsScreen> {
  PageController _pageController = PageController();
  int _currentPhotoIndex = 0;

  // Mock available slots for demonstration - you can replace this with actual data
  List<String> get mockAvailableSlots => [
    "6:00 AM - 8:00 AM",
    "8:00 AM - 10:00 AM",
    "10:00 AM - 12:00 PM",
    "2:00 PM - 4:00 PM",
    "4:00 PM - 6:00 PM",
    "6:00 PM - 8:00 PM",
    "8:00 PM - 10:00 PM",
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: const Color(0xFF09D071),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0AC76C),
          primary: const Color(0xFF0AC76C),
          secondary: const Color(0xFF2A3547),
          surface: Colors.white,
          background: const Color(0xFFF8F9FB),
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FB),
        appBar: AppBar(
          backgroundColor:Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF2A3547)),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.turf.turfName,
            style: const TextStyle(
              color: Color(0xFF2A3547),
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Carousel
              _buildPhotoCarousel(),

              const SizedBox(height: 20),

              // Turf Name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.turf.turfName,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2A3547),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Pin Code
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color(0xFF0AC76C),
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'PIN: ${widget.turf.pinCode}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF2A3547),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Turf Description
              _buildTurfDescription(),

              const SizedBox(height: 24),

              // Available Slots
              _buildAvailableSlots(),

              const SizedBox(height: 24),

              // Owner Info
              _buildOwnerInfo(),

              const SizedBox(height: 32),

              // Book Now Button
              _buildBookNowButton(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoCarousel() {
    // Handle case where photos list might be empty
    if (widget.turf.photos.isEmpty) {
      return Container(
        height: 250,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[300],
        ),
        child: const Center(
          child: Icon(
            Icons.sports_cricket,
            size: 50,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Container(
      height: 250,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPhotoIndex = index;
              });
            },
            itemCount: widget.turf.photos.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.turf.photos[index],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF0AC76C),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.sports_cricket,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          // Photo indicator dots
          if (widget.turf.photos.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.turf.photos.length,
                      (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPhotoIndex == index
                          ? const Color(0xFF0AC76C)
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTurfDescription() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2A3547),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'A premium quality turf perfect for sports and recreational activities. Well-maintained facilities with proper lighting and amenities.',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableSlots() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Available Slots',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2A3547),
                ),
              ),
              Text(
                '${widget.turf.availableSlots} slots',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF0AC76C),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: mockAvailableSlots.map((slot) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF0AC76C).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF0AC76C).withOpacity(0.3)),
                ),
                child: Text(
                  slot,
                  style: const TextStyle(
                    color: Color(0xFF0AC76C),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOwnerInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Owner Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2A3547),
            ),
          ),
          const SizedBox(height: 16),
          _buildOwnerInfoRow(Icons.person, 'Name', widget.turf.owner.ownerName),
          const SizedBox(height: 12),
          _buildOwnerInfoRow(Icons.phone, 'Contact', widget.turf.owner.contactNumber),
          const SizedBox(height: 12),
          _buildOwnerInfoRow(Icons.email, 'Email', widget.turf.owner.email),
        ],
      ),
    );
  }

  Widget _buildOwnerInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF0AC76C),
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF666666),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value.isNotEmpty ? value : 'Not provided',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2A3547),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookNowButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          // Handle book now action
          _showBookingDialog();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0AC76C),
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: const Color(0xFF0AC76C).withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'BOOK NOW',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  void _showBookingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Book Turf'),
          content: Text('Book ${widget.turf.turfName}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Add your booking logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Booking initiated!')),
                );
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}