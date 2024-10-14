//Important Imports
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';


File? _selectedImage;
String? _emergencyContactNumber;

// Main Block
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: SurakshaApp(), // HomePage of the App
    ),
  );
}

// Theme Provider
class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme = ThemeData.light();
  String _currentBackgroundImage = 'assets/light_background1.jpg';

  String _currentWallpaper = 'assets/light_background1.jpg';
  String get currentWallpaper => _currentWallpaper;

  ThemeData get currentTheme => _currentTheme;
  String get currentBackgroundImage => _currentBackgroundImage;

  void setLightTheme() {
    _currentTheme = ThemeData.light().copyWith(
      primaryColor: Colors.blue.shade900,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(backgroundColor: Colors.blue.shade900),
    );
    _currentBackgroundImage = 'assets/light_background1.jpg';
    notifyListeners();
  }

  void setDarkTheme() {
    _currentTheme = ThemeData.dark().copyWith(
      primaryColor: Colors.blue.shade200,
      scaffoldBackgroundColor: Colors.grey.shade900,
      appBarTheme: AppBarTheme(backgroundColor: Colors.blue.shade200),
    );
    _currentBackgroundImage = 'assets/dark_background1.jpg';
    notifyListeners();
  }

  void setAestheticTheme() {
    _currentTheme = ThemeData.light().copyWith(
      primaryColor: Colors.green.shade700, // Primary color
      scaffoldBackgroundColor: Colors.green.shade50, // Background color
      appBarTheme: AppBarTheme(backgroundColor: Colors.green.shade700), // App bar color
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade600, // Button background color
          foregroundColor: Colors.white,          // Button text color
        ),
      ),
    );
    void setWallpaper(String wallpaperPath) {
      _currentWallpaper = wallpaperPath;
      notifyListeners();
    }
    _currentBackgroundImage = 'assets/aesthetic_background1.jpg';
    notifyListeners();
  }
}

class ThemeSettingsPage extends StatefulWidget {
  @override
  _ThemeSettingsPageState createState() => _ThemeSettingsPageState();
}

class _ThemeSettingsPageState extends State<ThemeSettingsPage> {
  // Track the selected theme by a string
  String _selectedTheme = 'light'; // Options: 'light', 'dark', 'aesthetic'
  int _selectedBackgroundImageIndex = 0;

  List<String> _lightBackgroundImagePaths = [
    'assets/light_background1.jpg',
    'assets/light_background2.jpg',
    'assets/light_background3.jpg',
    'assets/light_background4.jpg',
    'assets/light_background5.jpg',
    'assets/light_background6.jpg',
  ];

  List<String> _aestheticBackgroundImagePaths = [
    'assets/aesthetic_background1.jpg',
    'assets/aesthetic_background2.jpg',
    'assets/aesthetic_background3.jpg',
    'assets/aesthetic_background4.jpg',
    'assets/aesthetic_background5.jpg',
    'assets/aesthetic_background6.jpg',
  ];

  List<String> _darkBackgroundImagePaths = [
    'assets/dark_background1.jpg',
    'assets/dark_background2.jpg',
    'assets/dark_background3.jpg',
    'assets/dark_background4.jpg',
    'assets/dark_background5.jpg',
    'assets/dark_background6.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Theme Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Select Theme'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildThemeOption('light', 'Light'),
                SizedBox(width: 16),
                _buildThemeOption('dark', 'Dark'),
                SizedBox(width: 16),
                _buildThemeOption('aesthetic', 'Aesthetic'),
              ],
            ),
            SizedBox(height: 16),
            Text('Select Background Image'),
            Expanded(
              child: _buildBackgroundImageSelection(), // Wrap GridView in Expanded
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(String theme, String label) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedTheme = theme;
        });
      },
      child: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: _getPrimaryColorForTheme(theme),
        foregroundColor: Colors.white,
      ),
    );
  }

  Color _getPrimaryColorForTheme(String theme) {
    switch (theme) {
      case 'dark':
        return Colors.blue.shade200;
      case 'aesthetic':
        return Colors.green.shade700;
      case 'light':
      default:
        return Colors.blue.shade900;
    }
  }

  Widget _buildBackgroundImageSelection() {
    List<String> backgroundImagePaths;
    switch (_selectedTheme) {
      case 'dark':
        backgroundImagePaths = _darkBackgroundImagePaths;
        break;
      case 'aesthetic':
        backgroundImagePaths = _aestheticBackgroundImagePaths;
        break;
      case 'light':
      default:
        backgroundImagePaths = _lightBackgroundImagePaths;
        break;
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: backgroundImagePaths.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedBackgroundImageIndex = index;
            });

            // Set the background image and theme in the ThemeProvider
            final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

            if (_selectedTheme == 'light') {
              themeProvider.setLightTheme();
            } else if (_selectedTheme == 'dark') {
              themeProvider.setDarkTheme();
            } else if (_selectedTheme == 'aesthetic') {
              themeProvider.setAestheticTheme();
            }

            themeProvider._currentBackgroundImage = backgroundImagePaths[index];
            themeProvider.notifyListeners(); // Notify listeners to update the theme

            // Show a confirmation message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Wallpaper Applied')),
            );
          },

          child: Container(
            decoration: BoxDecoration(
              border: _selectedBackgroundImageIndex == index
                  ? Border.all(color: Colors.blue)
                  : null,
            ),
            child: Image.asset(
              backgroundImagePaths[index],
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
  }) : super(key: key);
  Color getButtonColors(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    // Implement logic to determine button colors based on theme and wallpaper
    if (themeProvider.currentWallpaper.contains('light')) {
      return Colors.blue; // Example for light wallpaper
    } else if (themeProvider.currentWallpaper.contains('dark')) {
      return Colors.purple; // Example for dark wallpaper
    } else {
      return Colors.green; // Example for aesthetic wallpaper
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: getButtonColors(context),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}


//Updated SurakshaApp with ThemeProvider
//Suraksha SignUp Page

class SurakshaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Suraksha',
            theme: themeProvider.currentTheme,
            home: SignUpPage(),
          );

        },
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  String _selectedUserType = 'Citizen';

  void _signUp() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill all fields'),
      ));
      return;
    }

    if (_selectedUserType == 'Citizen') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CitizenDashboard(username: username)),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AuthorityDashboard(username: username)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suraksha - Sign Up'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'), // Add your image here
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                ),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                ),
                obscureText: !_showPassword,
              ),
              Row(
                children: [
                  Checkbox(
                    value: _showPassword,
                    onChanged: (bool? value) {
                      setState(() {
                        _showPassword = value!;
                      });
                    },
                  ),
                  Text('Show Password')
                ],
              ),
              SizedBox(height: 20),
              DropdownButton<String>(
                value: _selectedUserType,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedUserType = newValue!;
                  });
                },
                items: <String>['Citizen', 'Authority']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signUp,
                child: Text('Sign Up'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary, // Button background color
                  foregroundColor: Theme.of(context).colorScheme.onPrimary, // Button text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// Profile Page for Citizen Dashboard
class ProfilePage extends StatefulWidget {
  final String username;
  final String userType;
  final Map<String, dynamic> profileData;

  ProfilePage({required this.username, required this.userType, required this.profileData});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profileData['name'] ?? '');
    _emailController = TextEditingController(text: widget.profileData['email'] ?? '');
    _phoneController = TextEditingController(text: widget.profileData['phone'] ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Add email format validation if needed
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  // Add phone number format validation if needed
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, update the profile data
                    Map<String, dynamic> updatedProfileData = {
                      'name': _nameController.text,
                      'email': _emailController.text,
                      'phone': _phoneController.text,
                    };
                    Navigator.pop(context, updatedProfileData);
                  }
                },
                child: Text('Save Profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary, // Button background color
                  foregroundColor: Theme.of(context).colorScheme.onPrimary, // Button text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CitizenDashboard extends StatefulWidget {
  final String username;
  CitizenDashboard({required this.username});

  @override
  _CitizenDashboardState createState() => _CitizenDashboardState();
}

class _CitizenDashboardState extends State<CitizenDashboard> {

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _alertActive = false;
  String _statusText = 'Press the button and say "Raksha" three times to activate';
  String _lastWords = '';
  int _rakshaCount = 0;
  Map<String, dynamic> _profileData = {};

  @override
  void initState() {
    super.initState();
    _initSpeechRecognizer();
  }

  void _initSpeechRecognizer() async {
    await _speech.initialize(
      onStatus: (status) => print('onStatus: $status'),
      onError: (errorNotification) => print('onError: $errorNotification'),
    );
  }

  void _listen() async {
    if (!_speech.isAvailable) {
      setState(() => _statusText = 'Speech recognition not available');
      return;
    }

    var status = await Permission.microphone.status;
    if (status.isDenied) {
      status = await Permission.microphone.request();
      if (status.isDenied) {
        setState(() => _statusText = 'Microphone permission denied');
        return;
      }
    }

    if (!_isListening) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            _lastWords = result.recognizedWords;
            _statusText = 'Listening: $_lastWords';
            if (_lastWords.toLowerCase().contains('raksha')) {
              _rakshaCount++;
              _statusText = 'Raksha count: $_rakshaCount';
              if (_rakshaCount >= 3) {
                _activateAlert();
              }
            }
          });
        },
        listenFor: Duration(seconds: 30),
        pauseFor: Duration(seconds: 5),
        partialResults: true,
        cancelOnError: true,
        listenMode: stt.ListenMode.confirmation,
      );
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      setState(() => _statusText = 'Stopped listening');
    }
  }
  void _showSafeMaps() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Safe Maps'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/your_map_image.png', // Replace with your image path
                fit: BoxFit.cover,
              ),
              ElevatedButton(
                onPressed: () async {
                  var status = await Permission.location.status;
                  if (status.isDenied) {
                    status = await Permission.location.request();
                    if (status.isDenied)
                  {
                  ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Location permission denied')),
                  );
                  return;
                  }
                  }

                  Navigator.of(context).pop();
                },
                child: Text('Show My Location'),
              ),
            ],
          ),
        );
      },
    );
  }
  void _uploadIncidence() async {
    final ImagePicker picker = ImagePicker();

    // Request camera permission
    await Permission.camera.request();

    // Pick an image
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);

      });

      // TODO: Implement logic to send the image, time, and location to authorities
      // You can use a cloud storage service like Firebase Storage or AWS S3 to upload the image
      // and then send the image URL, time, and location to your backend server.

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Incidence, time, and location sent to authorities')),
      );
    } else {
      // Handle case where no image was selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected')),
      );
    }
  }

  void _activateAlert() {
    setState(() {
      _alertActive = true;
      _isListening = false;
      _statusText = 'EMERGENCY ALERT ACTIVATED!\nAttempting to notify authorities...';
    });
    _speech.stop();
    _notifyAuthorities();
  }

  Future<void> _notifyAuthorities() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      _statusText += '\nAuthorities have been notified. Help is on the way.';
    });
  }

  void _addEmergencyContact() {
    // Prompt the user to enter the emergency contact number
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Emergency Contact'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                _emergencyContactNumber = value;
              });
            },
            decoration: InputDecoration(hintText: 'Enter emergency contact number'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_emergencyContactNumber != null && _emergencyContactNumber!.isNotEmpty) {
                  // Save the emergency contact number (e.g., to a database or shared preferences)
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Emergency contact added successfully')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid emergency contact number')),
                  );
                }
              },
              child: Text('Save'),
              style: ElevatedButton.styleFrom(

              ),
            ),
          ],
        );
      },
    );
  }

  void _submitFeedback() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String _selectedSubject = 'Interface';
        final _feedbackController = TextEditingController();

        return AlertDialog(
          title: Text('Submit Feedback'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: _selectedSubject,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSubject = newValue!;
                  });
                },
                items: <String>[
                  'Interface',
                  'Crash Issue',
                  'Report User',
                  'Something Else'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              TextField(
                controller: _feedbackController,
                decoration: InputDecoration(hintText: 'Enter feedback'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                String feedback = _feedbackController.text;
                if (feedback.isNotEmpty) {
                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Feedback submitted successfully!'),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please enter your feedback'),
                  ));
                }
              },
              child: Text('Send'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary, // Button background color
                foregroundColor: Theme.of(context).colorScheme.onPrimary, // Button text color
              ),
            ),
          ],
        );
      },
    );
  }

  void _openProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(
          username: widget.username,
          userType: 'Citizen',
          profileData: _profileData,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _profileData = result;
      });
    }
  }

  void _openMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
              children: <Widget>[
                ListTile(
                  leading:
                  Icon(Icons.person),
                  title: Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    _openProfile();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.feedback),
                  title: Text('Submit Feedback'),
                  onTap: () {
                    Navigator.pop(context);
                    _submitFeedback();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.map),
                  title: Text('Safe Maps'),
                  onTap: () {
                    _showSafeMaps(); // Call the _showSafeMaps method
                  },
                ),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text('Emergency Contact'),
                  onTap: () {
                    Navigator.pop(context);
                    _addEmergencyContact();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to the Settings page (assuming it's defined)
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.help),
                  title: Text('Help'),
                  onTap: () {
                    Navigator.pop(context);
                    // Implement help functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Help content will be displayed here')),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout'),
                  onTap: () {
                    Navigator.pop(context);
                    // Implement logout functionality
                  },
                ),
              ]),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Citizen Dashboard'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: _openMenu,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(themeProvider.currentBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _listen,
                child: Text('Panic Button'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeProvider.currentTheme.colorScheme.primary,
                  foregroundColor : themeProvider.currentTheme.colorScheme.onPrimary,
                  shape: CircleBorder(),
                  minimumSize: Size(100, 100), // Adjust the size as needed
                ),
              ),
              SizedBox(height: 40), // Increase gap size
              ElevatedButton(
                onPressed: _uploadIncidence,
                child: Text('Incidence Reporting'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary, // Button background color
                  foregroundColor: Theme.of(context).colorScheme.onPrimary, // Button text color
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _openProfile,
                child: Text(_profileData.isEmpty ? 'Create Profile' : 'Edit Profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary, // Button background color
                  foregroundColor: Theme.of(context).colorScheme.onPrimary, // Button text color
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Profile Details'),
                        content: _profileData.isNotEmpty
                            ? Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _profileData.entries
                              .map((entry) =>
                              Text('${entry.key}: ${entry.value}'))
                              .toList(),
                        )
                            : Text('No profile data available'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Show Profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary, // Button background color
                  foregroundColor: Theme.of(context).colorScheme.onPrimary, // Button text color
                ),
              ),
              SizedBox(height: 20),
              Text(
                _statusText,
                style: TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),

    );
  }
}


//Authority Dashboard
class AuthorityDashboard extends StatefulWidget {
  final String username;
  AuthorityDashboard({required this.username});

  @override
  _AuthorityDashboardState createState() => _AuthorityDashboardState();
}

class ThemeSelectionButtons1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => themeProvider.setLightTheme(),
          child: Text('Light'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade900,
            foregroundColor: Colors.white,
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => themeProvider.setDarkTheme(),
          child: Text('Dark'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade800,
            foregroundColor: Colors.white,
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => themeProvider.setAestheticTheme(),
          child: Text('Aesthetic'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

class SettingsPage extends StatelessWidget {
  void _openThemeSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ThemeSettingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Text('Theme'),
            onTap: () => _openThemeSettings(context),  // Navigate to Theme Settings
          ),
          // Add other settings options if needed...
        ],
      ),
    );
  }
}

class _AuthorityDashboardState extends State<AuthorityDashboard> {
  List<Map<String, String>> _alerts = [];
  Map<String, dynamic> _profileData = {};

  @override
  void initState() {
    super.initState();
    // Simulate fetching alerts
    _fetchAlerts();
  }

  void _fetchAlerts() {
    // This is a mock function to simulate fetching alerts from a server
    setState(() {
      _alerts = [
        {'id': '1', 'location': 'Main St & 5th Ave', 'status': 'Active'},
        {'id': '2', 'location': 'Park Lane', 'status': 'Resolved'},
        {'id': '3', 'location': 'City Center', 'status': 'Active'},
      ];
    });
  }

  void _openProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(
          username: widget.username,
          userType: 'Authority',
          profileData: _profileData,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _profileData = result;
      });
    }
  }
  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsPage()),
    );
  }

  void _viewAlertDetails(Map<String, String> alert) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID: ${alert['id']}'),
              Text('Location: ${alert['location']}'),
              Text('Status: ${alert['status']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                // Here you would implement the logic to respond to the alert
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Responding to alert ${alert['id']}')),
                );
              },
              child: Text('Respond'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary, // Button background color
                foregroundColor: Theme.of(context).colorScheme.onPrimary, // Button text color
              ),
            ),
          ],
        );
      },
    );
  }

  @override

  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Suraksha - Authority Dashboard'),
        backgroundColor: themeProvider.currentTheme.appBarTheme.backgroundColor, // Use theme colors
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: themeProvider.currentTheme.primaryColor,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                _openProfile();
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                _openSettings();
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Help'),
              onTap: () {
                // Implement help functionality
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                // Implement logout functionality
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(themeProvider.currentBackgroundImage), // Use the theme's background image
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'Active Alerts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _alerts.length,
                  itemBuilder: (context, index) {
                    final alert = _alerts[index];
                    return Card(
                      child: ListTile(
                        title: Text('Alert ${alert['id']}'),
                        subtitle: Text('Location: ${alert['location']}'),
                        trailing: Text(
                          alert['status']!,
                          style: TextStyle(
                            color: alert['status'] == 'Active' ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () => _viewAlertDetails(alert),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchAlerts,
        child: Icon(Icons.refresh),
        backgroundColor: themeProvider.currentTheme.primaryColor, // Apply theme color
      ),
    );
  }
}

