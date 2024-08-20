import 'package:flutter/material.dart';
import 'package:beauty_hack/utils/color_utils.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';


class CreditCardPage extends StatefulWidget {
  const CreditCardPage({Key? key}) : super(key: key);

  @override
  _CreditCardPageState createState() => _CreditCardPageState();
}

class _CreditCardPageState extends State<CreditCardPage> {
  String cardNumber = '';
  String expiryDate= '';
  String cardHolderName = '';
  String cvvCode= '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Make payment",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              hexStringToColor("0B5394"),
              hexStringToColor("53677A"),
              hexStringToColor("F3F6F4")
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SafeArea(
          
          child: Column(
            
            children: [
              CreditCardWidget(
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  showBackView: isCvvFocused,
                  obscureCardNumber: true,
                  obscureCardCvv: true,),
              Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
      
                        CreditCardForm(cardNumber: cardNumber,
                            expiryDate: expiryDate,
                            cardHolderName: cardHolderName,
                            cvvCode: cvvCode,
                            onCreditCardModelChange: onCreditCardModelChange,
                            themeColor: Colors.blue,
                            formKey: formKey,
      
                            cardNumberDecoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Number',
                              hintText: 'xxxx xxxx xxxx xxxx'
                            ),
      
                            expiryDateDecoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Expired Date',
                                hintText: 'xx/xx'
                            ),
      
                            cvvCodeDecoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'CVV',
                                hintText: 'xxx'
                            ),
      
                            cardHolderDecoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Card Holder',
                            ),
      
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ), backgroundColor: Color(0xff1b447b)
      
                            ),
                            child: Container(
                              margin: EdgeInsets.all(8.0),
                              child: Text(
                                'validate',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'halter',
                                  fontSize: 14,
                                  package: 'flutter_credit_card',
                                ),
                              ),
                            ),
                          onPressed: (){
                              if(formKey.currentState!.validate()){
                                print('valid');
                              }
                              else{
                                print('inValid');
                              }
                          },)
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel){
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}