import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserProfile {
  String name;
  String role;
  String dateOfBirth;
  String height;
  String weight;
  String bloodType;
  String email;
  String phone;
  String address;
  String sport;
  String experience;
  String personalBest;
  String coach;
  String imageUrl;

  UserProfile({
    required this.name,
    required this.role,
    required this.dateOfBirth,
    required this.height,
    required this.weight,
    required this.bloodType,
    required this.email,
    required this.phone,
    required this.address,
    required this.sport,
    required this.experience,
    required this.personalBest,
    required this.coach,
    required this.imageUrl,
  });
}

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  // Initial profile data
  late UserProfile _userProfile;

  @override
  void initState() {
    super.initState();
    // Initialize with default data
    _userProfile = UserProfile(
      name: '',
      role: '',
      dateOfBirth: '',
      height: '',
      weight: '',
      bloodType: '',
      email: '',
      phone: '',
      address: '',
      sport: '',
      experience: '',
      personalBest: '',
      coach: '',
      imageUrl: 'lib/assets/profile.png',
    );
  }

  void _showEditProfileForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProfileEditForm(
        userProfile: _userProfile,
        onSave: (updatedProfile) {
          setState(() {
            _userProfile = updatedProfile;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile header
              Center(
                child: Column(
                  children: [
                    Hero(
                      tag: 'profile-image',
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                          child: CircleAvatar(
                            radius: 58,
                            backgroundImage: NetworkImage(_userProfile.imageUrl),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      _userProfile.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _userProfile.role,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton.icon(
                      onPressed: _showEditProfileForm,
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Profile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              
              // Personal Information
              const Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              _buildInfoCard([
                _buildInfoRow(Icons.cake, 'Date of Birth', _userProfile.dateOfBirth),
                _buildInfoRow(Icons.height, 'Height', _userProfile.height),
                _buildInfoRow(Icons.monitor_weight, 'Weight', _userProfile.weight),
                _buildInfoRow(Icons.favorite, 'Blood Type', _userProfile.bloodType),
              ]),
              
              const SizedBox(height: 25),
              
              // Contact Information
              const Text(
                'Contact Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              _buildInfoCard([
                _buildInfoRow(Icons.email, 'Email', _userProfile.email),
                _buildInfoRow(Icons.phone, 'Phone', _userProfile.phone),
                _buildInfoRow(Icons.location_on, 'Address', _userProfile.address),
              ]),
              
              const SizedBox(height: 25),
              
              // Athletic Information
              const Text(
                'Athletic Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              _buildInfoCard([
                _buildInfoRow(Icons.sports, 'Sport', _userProfile.sport),
                _buildInfoRow(Icons.emoji_events, 'Experience', _userProfile.experience),
                _buildInfoRow(Icons.speed, 'Personal Best', _userProfile.personalBest),
                _buildInfoRow(Icons.group, 'Coach', _userProfile.coach),
              ]),
              
              const SizedBox(height: 30),
              
              // Performance Metrics
              const Text(
                'Performance Metrics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              _buildPerformanceMetrics(context),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetrics(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMetricRow('Average Pace', '7:30 min/mile', 0.85, context),
          const SizedBox(height: 15),
          _buildMetricRow('Weekly Distance', '42.5 miles', 0.75, context),
          const SizedBox(height: 15),
          _buildMetricRow('Recovery Rate', 'Excellent', 0.9, context),
          const SizedBox(height: 15),
          _buildMetricRow('Endurance Level', 'Advanced', 0.8, context),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, double progress, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
          borderRadius: BorderRadius.circular(10),
          minHeight: 8,
        ),
      ],
    );
  }
}

class ProfileEditForm extends StatefulWidget {
  final UserProfile userProfile;
  final Function(UserProfile) onSave;

  const ProfileEditForm({
    Key? key,
    required this.userProfile,
    required this.onSave,
  }) : super(key: key);

  @override
  State<ProfileEditForm> createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends State<ProfileEditForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _roleController;
  late TextEditingController _dobController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _bloodTypeController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _sportController;
  late TextEditingController _experienceController;
  late TextEditingController _personalBestController;
  late TextEditingController _coachController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data
    _nameController = TextEditingController(text: widget.userProfile.name);
    _roleController = TextEditingController(text: widget.userProfile.role);
    _dobController = TextEditingController(text: widget.userProfile.dateOfBirth);
    _heightController = TextEditingController(text: widget.userProfile.height);
    _weightController = TextEditingController(text: widget.userProfile.weight);
    _bloodTypeController = TextEditingController(text: widget.userProfile.bloodType);
    _emailController = TextEditingController(text: widget.userProfile.email);
    _phoneController = TextEditingController(text: widget.userProfile.phone);
    _addressController = TextEditingController(text: widget.userProfile.address);
    _sportController = TextEditingController(text: widget.userProfile.sport);
    _experienceController = TextEditingController(text: widget.userProfile.experience);
    _personalBestController = TextEditingController(text: widget.userProfile.personalBest);
    _coachController = TextEditingController(text: widget.userProfile.coach);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _dobController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _bloodTypeController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _sportController.dispose();
    _experienceController.dispose();
    _personalBestController.dispose();
    _coachController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final initialDate = _parseDate(_dobController.text) ?? DateTime(1990, 5, 15);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('MMMM d, yyyy').format(picked);
      });
    }
  }

  DateTime? _parseDate(String dateString) {
    try {
      return DateFormat('MMMM d, yyyy').parse(dateString);
    } catch (e) {
      return null;
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final updatedProfile = UserProfile(
        name: _nameController.text,
        role: _roleController.text,
        dateOfBirth: _dobController.text,
        height: _heightController.text,
        weight: _weightController.text,
        bloodType: _bloodTypeController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        sport: _sportController.text,
        experience: _experienceController.text,
        personalBest: _personalBestController.text,
        coach: _coachController.text,
        imageUrl: widget.userProfile.imageUrl,
      );

      widget.onSave(updatedProfile);
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Form header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: Center(
                child: Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            // Form fields in a scrollable container
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Basic Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    _buildTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      icon: Icons.person,
                      validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
                    ),
                    
                    _buildTextField(
                      controller: _roleController,
                      label: 'Role/Title',
                      icon: Icons.sports,
                      validator: (value) => value == null || value.isEmpty ? 'Please enter your role' : null,
                    ),
                    
                    // Date picker field
                    TextFormField(
                      controller: _dobController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        prefixIcon: Icon(Icons.cake),
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Please select your date of birth' : null,
                    ),
                    const SizedBox(height: 20),
                    
                    const Text(
                      'Physical Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    _buildTextField(
                      controller: _heightController,
                      label: 'Height',
                      icon: Icons.height,
                      validator: (value) => value == null || value.isEmpty ? 'Please enter your height' : null,
                    ),
                    
                    _buildTextField(
                      controller: _weightController,
                      label: 'Weight',
                      icon: Icons.monitor_weight,
                      validator: (value) => value == null || value.isEmpty ? 'Please enter your weight' : null,
                    ),
                    
                    _buildTextField(
                      controller: _bloodTypeController,
                      label: 'Blood Type',
                      icon: Icons.favorite,
                      validator: (value) => value == null || value.isEmpty ? 'Please enter your blood type' : null,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    const Text(
                      'Contact Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    
                    _buildTextField(
                      controller: _phoneController,
                      label: 'Phone',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (value) => value == null || value.isEmpty ? 'Please enter your phone number' : null,
                    ),
                    
                    _buildTextField(
                      controller: _addressController,
                      label: 'Address',
                      icon: Icons.location_on,
                      maxLines: 2,
                      validator: (value) => value == null || value.isEmpty ? 'Please enter your address' : null,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    const Text(
                      'Athletic Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    _buildTextField(
                      controller: _sportController,
                      label: 'Sport',
                      icon: Icons.sports,
                      validator: (value) => value == null || value.isEmpty ? 'Please enter your sport' : null,
                    ),
                    
                    _buildTextField(
                      controller: _experienceController,
                      label: 'Experience',
                      icon: Icons.emoji_events,
                      validator: (value) => value == null || value.isEmpty ? 'Please enter your experience' : null,
                    ),
                    
                    _buildTextField(
                      controller: _personalBestController,
                      label: 'Personal Best',
                      icon: Icons.speed,
                      validator: (value) => value == null || value.isEmpty ? 'Please enter your personal best' : null,
                    ),
                    
                    _buildTextField(
                      controller: _coachController,
                      label: 'Coach',
                      icon: Icons.group,
                      validator: (value) => value == null || value.isEmpty ? 'Please enter your coach name' : null,
                    ),
                    
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            
            // Save and Cancel buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        side: BorderSide(color: Theme.of(context).colorScheme.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
        validator: validator,
      ),
    );
  }
}