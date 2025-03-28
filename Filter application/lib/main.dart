import 'dart:typed_data';

import 'package:appyay/utils.dart';
import 'package:flutter/material.dart';
import 'package:appyay/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyDsMlUfJdV6kl8Nojda-hQBjqoCdu3tPjU",
          authDomain: "appyay.firebaseapp.com",
          projectId: "appyay",
          storageBucket: "appyay.appspot.com",
          messagingSenderId: "69396547286",
          appId: "1:69396547286:web:121cc7902c44dec6616b77",
          measurementId: "G-H29KTXC72F"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/home', // Set the initial route to '/home'
      routes: {
        '/home': (context) => HomeScreen(), // Add HomeScreen route
        '/initial': (context) => InitialScreen(),
        '/loading': (context) => LoadingScreen(),
        '/filtered': (context) => FilteredScreen(),
        '/ending': (context) => EndingScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to our Black and White Image App!',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            Text(
              'This is an app we\'ve created to let you see images in black and white.\n'
              'A lot of landscape and architectural photographers will use this filter\n'
              'to create dramatic separation between blue skies, trees, clouds, and buildings.\n'
              'The filter nearly eliminates all Blue UV haze resulting in crisp, sharp images of distant subjects like mountains.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 60.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/initial');
              },
              child: Text('Proceed'),
            ),
          ],
        ),
      ),
    );
  }
}

class InitialScreen extends StatefulWidget {
  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  Uint8List? _image;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select your image!'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Stack(
            children: [
              _image != null
                  ? CircleAvatar(
                      radius: 80,
                      backgroundImage: MemoryImage(_image!),
                    )
                  : const CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(
                          'https://p1.hiclipart.com/preview/722/763/698/circle-silhouette-user-user-profile-user-interface-login-avatar-user-account-skin-png-clipart-thumbnail.jpg'),
                    ),
              Positioned(
                child: IconButton(
                  onPressed: selectImage,
                  icon: const Icon(Icons.add_a_photo),
                ),
              )
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/loading',
                arguments: _image,
              );
            },
            child: Text('Proceed'),
          ),
        ]),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Uint8List? _image =
        ModalRoute.of(context)!.settings.arguments as Uint8List?;
    // Simulate loading time
    Future.delayed(Duration(seconds: 6), () {
      Navigator.pushNamed(
        context,
        '/filtered',
        arguments: _image,
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Loading Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 40.0),
            Text('Loading...'),
          ],
        ),
      ),
    );
  }
}

class FilteredScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Uint8List? _image =
        ModalRoute.of(context)!.settings.arguments as Uint8List?;
    return Scaffold(
      appBar: AppBar(
        title: Text('This is your filtered image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ColorFiltered(
                colorFilter:
                    ColorFilter.mode(Colors.grey, BlendMode.saturation),
                child: CircleAvatar(
                    radius: 80, backgroundImage: MemoryImage(_image!))),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/ending');
              },
              child: Text('Go to Ending Screen'),
            ),
          ],
        ),
      ),
    );
  }
}

class EndingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hope you enjoyed!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Black and white photos have a timeless quality, don\'t they?\nStripping away color can enhance the focus on composition, light, and shadows.\n Like capturing the essence of a moment without the distractions of vibrant hues. Plus, there is a certain nostalgia associated with black and white photography—it connects us to the past and evokes a sense of classic beauty! What do you think?',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
