// ignore_for_file: avoid_print, library_private_types_in_public_api, prefer_typing_uninitialized_variables, camel_case_types

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:motion_toast/motion_toast.dart';
import '../utils/url.dart';

class updateProfile extends StatefulWidget {
  final data;
  const updateProfile({super.key, required this.data});

  @override
  _updateProfileState createState() => _updateProfileState();
}

class _updateProfileState extends State<updateProfile> {
  // String baseurl = 'http://10.0.2.2:5000/';
  // String baseurl = 'http://172.25.1.220:5000';
  String token = '';
  final storage = const FlutterSecureStorage();

  // var uid;
  // tokenn() async {
  //   var userData = await parseToken();
  //   uid = userData['userId'];
  //   print("id $uid");
  //   return userData;
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   tokenn().then((responce) {
  //     setState(() {
  //       return responce;
  //     });
  //   });
  // }

  final _formKey = GlobalKey<FormState>();

  File? _image;
  String username = '';
  String email = '';
  String position = '';
  String password = '';

  Future<String> uploaduserImage(String filepath, String userid) async {
    try {
      String url = '${baseUrl}upload/user/photo/$userid';
      var request = http.MultipartRequest('PUT', Uri.parse(url));
      var token = await storage.read(key: 'token');
      request.headers.addAll({
        'Content-type': 'multipart/form-data',
        'Authorization': 'Bearer $token',
      });
      // need a filename
      var filename = filepath.split('/').last;
      // adding the file in the request
      request.files.add(
        http.MultipartFile(
          'image',
          File(filepath).readAsBytes().asStream(),
          File(filepath).lengthSync(),
          filename: filename,
        ),
      );

      var response = await request.send();
      print('check update profile');
      var responseString = await response.stream.bytesToString();
      print(responseString);
      if (response.statusCode == 200) {
        return "ok";
      }
    } catch (e) {
      print(e);
    }
    return 'something went wrong';
  }

  // update user in
  void updateuserInfo(String username, String email, String position,
      String password, File? file) async {
    String s = '';
    Map<String, dynamic> productdata = {
      'username': username,
      'email': email,
      'position': position,
      'password': password
    };
    var token = await storage.read(key: 'token');
    try {
      var userid = widget.data['_id'];
      print(userid);
      var response = await http.put(Uri.parse('${baseUrl}user/update/$userid'),
          body: productdata,
          headers: {
            'Authorization': 'Bearer $token',
          });
      if (response.statusCode == 201) {
        if (file != null) {
          s = await uploaduserImage(file.path, userid);
          if (s == "ok") {
            print(s);
            print('successfully product uploaded');
          } else {
            print("something went wrong");
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  //
  Future<bool> updateProfile_() async {
    var token = await storage.read(key: 'token');
    var userid = widget.data['_id'];
    // try {
    var postUri = Uri.parse("${baseUrl}user/update/$userid");
    var request = http.MultipartRequest("PUT", postUri);
    print(request);
    //Header....
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['username'] = username;
    request.fields['email'] = email;
    request.fields['Position'] = position;
    // image
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
    http.StreamedResponse response = await request.send();
    print(response);
    final respStr = await response.stream.bytesToString();
    var jsonData = jsonDecode(respStr);
    print(jsonData);
    if (jsonData != null) {
      return true;
    }
    return false;
    // } catch (e) {
    //   return false;
    // }
  }

  @override
  void initState() {
    super.initState();
    _image == null;
    // _image = File(widget.data['image']);
  }

  //method to open image from gallery
  _imageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image!.path);
    });
  }

  //method to open image from camera
  _imageFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blueGrey.shade900,
      // drawer: const Drawer(
      //   child: recandrawer(),
      // ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 23, 46, 252),
        title: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "RECANAPP",
                style: TextStyle(
                    fontSize: 22, color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            // decoration: BoxDecoration(color: Colors.black87),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 100,
                        backgroundImage: _image == null
                            ? const AssetImage('images/samishan.jpg')
                                as ImageProvider
                            : FileImage(_image!),
                        child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (builder) => bottomSheet());
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 140, top: 110),
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Icon(
                                  Icons.camera,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      initialValue: '${widget.data['username']}',
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'username cannot be empty';
                        }
                        null;
                        return null;
                      },
                      onSaved: (val) {
                        username = val!;
                      },
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        label: Text('Username'),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 2.0),
                          // borderRadius:
                          // const BorderRadius.all(Radius.circular(40.0)),
                        ),
                        prefixIcon: Icon(
                          Icons.people,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      initialValue: '${widget.data['email']}',
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'email cannot be empty';
                        }
                        null;
                        return null;
                      },
                      onSaved: (val) {
                        email = val!;
                      },
                      decoration: const InputDecoration(
                        label: Text('Email'),
                        border: OutlineInputBorder(
                            // borderRadius:
                            //     const BorderRadius.all(Radius.circular(40.0)),
                            ),
                        prefixIcon: Icon(
                          Icons.email,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      initialValue: '${widget.data['position']}',
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'position cannot be empty';
                        }
                        null;
                        return null;
                      },
                      onSaved: (val) {
                        position = val!;
                      },
                      decoration: const InputDecoration(
                        label: Text('position'),
                        border: OutlineInputBorder(
                            // borderRadius:
                            //     const BorderRadius.all(Radius.circular(40.0)),
                            ),
                        prefixIcon: Icon(
                          Icons.email,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150, 40)),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _formKey.currentState!.reset();
                          // if (_image != null) {
                          // updateuserInfo(username, email,position, password , _image);
                          // print('success');
                          // } else {
                          // }
                          var a = await updateProfile_();
                          if (a) {
                            // ignore: use_build_context_synchronously
                            MotionToast.success(
                                    description:
                                        const Text("Update Sucessfully"))
                                .show(context);
                          }
                        }
                      },
                      child: const Text(
                        "Update",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //
  Widget bottomSheet() {
    return Container(
      height: 105,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          const Text(
            'Choose profile photo',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  _imageFromCamera();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.camera),
                label: const Text('Camera'),
              ),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _imageFromGallery();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.image),
                label: const Text('Gallery'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
