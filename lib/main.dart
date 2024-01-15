import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home()
  ));

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  int userOTP = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auth Handler')),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextFormField(controller: nameController),
            TextFormField(controller: emailController),
            ElevatedButton(
              onPressed: () async {
                userOTP = await sendEmail(
                userName: nameController.text, 
                userEmail: emailController.text,
                generatedOTP: Random().nextInt(900000) + 100000);
              },
              child: const Text('Send OTP'),
            ),
            TextFormField(controller: otpController, keyboardType: TextInputType.number,),
            ElevatedButton(
              onPressed: () {
                if(userOTP == int.parse(otpController.text)){
                  print("verified");
                }
                else{
                  print("brah");
                }
              },
              child: const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }

  Future sendEmail({
    required String userName,
    required String userEmail,
    required int generatedOTP,
  }) async {

    final serviceId = 'service_k6io5gh';
    final templateId = 'template_soz4xc5';
    final userId = 'Vj7z4k6OjbWA05aEe';

    int code = generatedOTP;
    String otp = code.toString();
    int verifyOTP = code;

    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'user_name': userName,
          'user_email': userEmail,
          'generated_otp': otp
        }
      })
    );
    print("otp is $otp");
    print(response.body);
    return code;
  }

}