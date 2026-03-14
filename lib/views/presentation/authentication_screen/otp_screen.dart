import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketmate_app/controllers/auth_controller.dart';
import 'package:marketmate_app/services/manage_http_response.dart';

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _authController = AuthController();
  List<String> otpDigits = List.filled(6, '');
  bool isLoading = false;
  void verifyOtp() async {
        print("OTP digit: $otpDigits");

    if (otpDigits.contains('')) {
      showSnackBar(context, 'Please fill in all OTP fields');
      return;
    }
    setState(() {
      isLoading = true;
    });
    final otp =
        otpDigits.join(); //Combine digits into a single OTP String (453564)
    print("OTP: $otp");
    await _authController
        .verifyOtp(context: context, email: widget.email, otp: otp)
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Widget buildOtpField(int index) {
    return SizedBox(
      width: 45,
      height: 55,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return '';
          }
          return null;
        },
        //Handles changes in the text input.
        onChanged: (value) {
          //check if the input is valid (non-empty)
          if (value.isNotEmpty && value.length == 1) {
            //save the digit to the corresponding index
            otpDigits[index] = value;

            //automatically move focus to the next field if not the last one
            if (index < 5) {
              FocusScope.of(context).nextFocus();
            } 
          }else {
              // Clear the current index when user deletes the input
               otpDigits[index] = '';
              if (index > 0) {
                FocusScope.of(context).previousFocus();
              }
            }
        },
        onFieldSubmitted: (value) {
          //Trigger OTP Verification if on the last field and if the form is valid
          if (index == 5 && _formKey.currentState!.validate()) {
            verifyOtp();
          }
        },
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
            counterText: '',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.grey.shade200),
        style:
            GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    "Verify your account",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                        color: Color.fromARGB(255, 42, 56, 45)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Enter the otp sent to ${widget.email}",
                    style: GoogleFonts.lato(
                        color: const Color(0xFF0d120E), fontSize: 14),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, buildOtpField)),
                  const SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () {
                      verifyOtp();
                    },
                    child: Container(
                      width: 319,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Color(0xFF103DE5),
                          borderRadius: BorderRadius.circular(9)),
                      child: Center(
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Verify',
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
