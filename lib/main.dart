import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String onboardingStatus = "splash";
  String emergencyStatus = "none";
  String emergencyType = "none";

  EmergencyUser currentConfig = new EmergencyUser();
  TextEditingController nameController;
  TextEditingController phoneController;
  String countryString = "Please select your country";
  String cityString = "Please select your city";
  TextEditingController passwordController;

  ScrollController onboardingController;
  Color SALBlue = Color.fromRGBO(5, 76, 171, 1);
  Color SALRed = Color.fromRGBO(237, 59, 61, 1);
  Color SALWhite = Color.fromRGBO(225, 218, 225, 1);

  @override
  void initState() {
    getConfig();
    onboardingController = ScrollController();
    print("starting");
    super.initState();
  }

  getConfig() async{
    currentConfig = await EmergencyUser().readFile();
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: SALBlue,
        child: currentContent(),
      ),
    );
  }

  currentContent(){
    onboardingStatus = "home";
    if(currentConfig == null){
      onboardingStatus = "splash";
    }else if(currentConfig.username == null && currentConfig.token == null){
      onboardingStatus  = "register";
    }else if(currentConfig.username != null && currentConfig.token == null){
      onboardingStatus  = "login";
    }

    if(onboardingStatus == "home"){
      return homeView();
    }else{
      return onboarding(onboardingStatus);
    }
  }

  onboarding(String status){
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: SALBlue,
      child: Column(
        children: [
          Visibility(
            visible: onboardingStatus == "splash",
            child: Padding(
              padding: EdgeInsets.fromLTRB(50, (MediaQuery.of(context).size.height - MediaQuery.of(context).size.width)/2, 50, 0),
              child: Container(
                height: MediaQuery.of(context).size.width - 100,
                width: MediaQuery.of(context).size.width - 100,
                child: Image(image: AssetImage('images/heart_icon_transparent.png'),),
              ),
            ),
          ),
          Visibility(
            visible: (onboardingStatus == "register" || onboardingStatus == "login"),
            child: Padding(
              padding: EdgeInsets.fromLTRB(100, 50, 100, 30),
              child: Container(
                height: MediaQuery.of(context).size.width - 200,
                width: MediaQuery.of(context).size.width - 200,
                child: Image(image: AssetImage('images/heart_icon_transparent.png'),),
              ),
            ),
          ),
          Visibility(
            visible: (onboardingStatus == "splash" || onboardingStatus == "login"),
            child: Center(
              child: Text("SAVE A LIFE",style: TextStyle(color: Colors.white70,fontSize: 40,fontWeight: FontWeight.bold),),
            ),
          ),
          Visibility(
            visible: (onboardingStatus == "register" || onboardingStatus == "login"),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Container(
                width: MediaQuery.of(context).size.width - 40,
                height: 40,
                decoration: BoxDecoration(
                    border: Border.all(color: SALWhite,width: 1)
                ),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: SALWhite,
                    hintText: "Name",
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: (onboardingStatus == "register"),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Container(
                width: MediaQuery.of(context).size.width - 40,
                height: 40,
                decoration: BoxDecoration(
                    border: Border.all(color: SALWhite,width: 1)
                ),
                child: Theme(
                  data: ThemeData(
                      backgroundColor: SALWhite,
                      canvasColor: SALWhite,
                      dialogBackgroundColor: SALWhite
                  ),
                  child:TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: SALWhite,
                      hintText: "Phone Number",
                    ),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
              visible: onboardingStatus == "register",
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: (MediaQuery.of(context).size.width - 50)/2,
                      height: 30,
                      color: SALWhite,
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width - 50)/2,
                      height: 30,
                      color: SALWhite,
                    ),
                  ],
                ),
              )
          ),
          Visibility(
            visible: (onboardingStatus == "register" || onboardingStatus == "login"),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Container(
                width: MediaQuery.of(context).size.width - 40,
                height: 40,
                decoration: BoxDecoration(
                    border: Border.all(color: SALWhite,width: 1)
                ),
                child: Theme(
                  data: ThemeData(
                      backgroundColor: SALWhite,
                      canvasColor: SALWhite,
                      dialogBackgroundColor: SALWhite
                  ),
                  child:TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: SALWhite,
                      hintText: "Password",
                    ),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: (onboardingStatus == "register"),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: InkWell(
                onTap: (){
                  register();
                },
                child:Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 40,
                  color: SALRed,
                  child: Center(child:Text("Sign Up",style: TextStyle(color: SALWhite,fontSize: 24,),),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: (onboardingStatus == "login"),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: InkWell(
                onTap: (){
                  login();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 40,
                  color: SALRed,
                  child: Center(child:Text("Sign In",style: TextStyle(color: SALWhite,fontSize: 24,),),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: onboardingStatus == "register",
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Center(
                child: InkWell(
                  onTap: (){
                    currentConfig.username = "hold";
                    setState(() {});
                  },
                  child: Text("Already a member? Login here.",style: TextStyle(color: Colors.white),),
                ),
              ),
            ),
          ),
          Visibility(
            visible: onboardingStatus == "login",
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Center(
                child: InkWell(
                  onTap: (){
                    currentConfig.username = null;
                    setState(() {});
                  },
                  child: Text("Not a member? Register here.",style: TextStyle(color: Colors.white),),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  homeView(){
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
          children:[
            //logo large normal
            Visibility(
              visible: (emergencyStatus == "none"||emergencyStatus == "setAttendTo"),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Container(
                  height: MediaQuery.of(context).size.width - 100,
                  width: MediaQuery.of(context).size.width - 100,
                  child: Image(image: AssetImage('images/heart_icon_transparent.png'),),
                ),
              ),
            ),
            Visibility(
              visible: (emergencyStatus == "none"),
              child: Center(
                child: Text("SAVE A LIFE",style: TextStyle(color: Colors.white70,fontSize: 40,fontWeight: FontWeight.bold),),
              ),
            ),
            Visibility(
              visible: (emergencyStatus == "setAttendTo"),
              child: Center(
                child: Text("First Responder",style: TextStyle(color: Colors.white70,fontSize: 40,fontWeight: FontWeight.bold),),
              ),
            ),
            Visibility(
              visible: (emergencyStatus == "setAttendTo"),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Center(
                  child: Text("Please select all the emergencies you are willing to attend.",style: TextStyle(color: Colors.white70,fontSize: 16,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                ),
              ),
            ),
            Visibility(
              visible: (emergencyStatus == "none"),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                child: InkWell(
                  onTap: (){
                    emergencyStatus = "start";
                    setState(() {});
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 50,
                    color: SALRed,
                    child: Center(
                      child: Text("Emergency Call",style: TextStyle(color: SALWhite,fontSize: 24),),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: (emergencyStatus == "none"),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                child: InkWell(
                  onTap: (){
                    emergencyStatus = "setAttendTo";
                    setState(() {});
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 50,
                    color: (currentConfig.respondTo == null || currentConfig.respondTo.length==0)?SALRed:Colors.green,
                    child: Center(
                      child: Text("First Responder",style: TextStyle(color: SALWhite,fontSize: 24),),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: (emergencyStatus == "setAttendTo"),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: MediaQuery.of(context).size.height - 500,
                    color: SALWhite,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 40,
                            height: 30,
                            child: InkWell(
                              onTap: (){
                                print("Car Accident");
                                if(currentConfig.respondTo == null) {
                                  currentConfig.respondTo = [];
                                  currentConfig.respondTo.add("Car Accident");
                                }else if(!currentConfig.respondTo.contains("Car Accident")){
                                  currentConfig.respondTo.add("Car Accident");
                                }else{
                                  currentConfig.respondTo.remove("Car Accident");
                                }
                                setState(() {});
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  (currentConfig.respondTo != null && currentConfig.respondTo.contains("Car Accident"))?
                                  Icon(Icons.check_box_outlined,color: Colors.green,)
                                      :
                                  Icon(Icons.check_box_outline_blank,color: SALRed,)
                                  ,
                                  Padding(padding: EdgeInsets.fromLTRB(5, 3, 5, 5),
                                    child: Text("Car Accident",style: TextStyle(color: Colors.black),),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 40,
                            height: 30,
                            child: InkWell(
                              onTap: (){
                                print("Heart attack");
                                if(currentConfig.respondTo == null) {
                                  currentConfig.respondTo = [];
                                  currentConfig.respondTo.add("Heart attack");
                                }else if(!currentConfig.respondTo.contains("Heart attack")){
                                  currentConfig.respondTo.add("Heart attack");
                                }else{
                                  currentConfig.respondTo.remove("Heart attack");
                                }
                                setState(() {});
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  (currentConfig.respondTo != null && currentConfig.respondTo.contains("Heart attack"))?
                                  Icon(Icons.check_box_outlined,color: Colors.green,)
                                      :
                                  Icon(Icons.check_box_outline_blank,color: SALRed,)
                                  ,
                                  Padding(padding: EdgeInsets.fromLTRB(5, 3, 5, 5),
                                    child: Text("Heart attack",style: TextStyle(color: Colors.black),),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 40,
                            height: 30,
                            child: InkWell(
                              onTap: (){
                                print("Burns");
                                if(currentConfig.respondTo == null) {
                                  currentConfig.respondTo = [];
                                  currentConfig.respondTo.add("Burns");
                                }else if(!currentConfig.respondTo.contains("Burns")){
                                  currentConfig.respondTo.add("Burns");
                                }else{
                                  currentConfig.respondTo.remove("Burns");
                                }
                                setState(() {});
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  (currentConfig.respondTo != null && currentConfig.respondTo.contains("Burns"))?
                                  Icon(Icons.check_box_outlined,color: Colors.green,)
                                      :
                                  Icon(Icons.check_box_outline_blank,color: SALRed,)
                                  ,
                                  Padding(padding: EdgeInsets.fromLTRB(5, 3, 5, 5),
                                    child: Text("Burns",style: TextStyle(color: Colors.black),),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 40,
                            height: 30,
                            child: InkWell(
                              onTap: (){
                                print("Cuts");
                                if(currentConfig.respondTo == null) {
                                  currentConfig.respondTo = [];
                                  currentConfig.respondTo.add("Cuts");
                                }else if(!currentConfig.respondTo.contains("Cuts")){
                                  currentConfig.respondTo.add("Cuts");
                                }else{
                                  currentConfig.respondTo.remove("Cuts");
                                }
                                setState(() {});
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  (currentConfig.respondTo != null && currentConfig.respondTo.contains("Cuts"))?
                                  Icon(Icons.check_box_outlined,color: Colors.green,)
                                      :
                                  Icon(Icons.check_box_outline_blank,color: SALRed,)
                                  ,
                                  Padding(padding: EdgeInsets.fromLTRB(5, 3, 5, 5),
                                    child: Text("Cuts",style: TextStyle(color: Colors.black),),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 40,
                            height: 30,
                            child: InkWell(
                              onTap: (){
                                print("Abrasions");
                                if(currentConfig.respondTo == null) {
                                  currentConfig.respondTo = [];
                                  currentConfig.respondTo.add("Abrasions");
                                }else if(!currentConfig.respondTo.contains("Abrasions")){
                                  currentConfig.respondTo.add("Abrasions");
                                }else{
                                  currentConfig.respondTo.remove("Abrasions");
                                }
                                setState(() {});
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  (currentConfig.respondTo != null && currentConfig.respondTo.contains("Abrasions"))?
                                  Icon(Icons.check_box_outlined,color: Colors.green,)
                                      :
                                  Icon(Icons.check_box_outline_blank,color: SALRed,)
                                  ,
                                  Padding(padding: EdgeInsets.fromLTRB(5, 3, 5, 5),
                                    child: Text("Abrasions",style: TextStyle(color: Colors.black),),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 40,
                            height: 30,
                            child: InkWell(
                              onTap: (){
                                print("Stings");
                                if(currentConfig.respondTo == null) {
                                  currentConfig.respondTo = [];
                                  currentConfig.respondTo.add("Stings");
                                }else if(!currentConfig.respondTo.contains("Stings")){
                                  currentConfig.respondTo.add("Stings");
                                }else{
                                  currentConfig.respondTo.remove("Stings");
                                }
                                setState(() {});
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  (currentConfig.respondTo != null && currentConfig.respondTo.contains("Stings"))?
                                  Icon(Icons.check_box_outlined,color: Colors.green,)
                                      :
                                  Icon(Icons.check_box_outline_blank,color: SALRed,)
                                  ,
                                  Padding(padding: EdgeInsets.fromLTRB(5, 3, 5, 5),
                                    child: Text("Stings",style: TextStyle(color: Colors.black),),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 40,
                            height: 30,
                            child: InkWell(
                              onTap: (){
                                print("Splinters");
                                if(currentConfig.respondTo == null) {
                                  currentConfig.respondTo = [];
                                  currentConfig.respondTo.add("Splinters");
                                }else if(!currentConfig.respondTo.contains("Splinters")){
                                  currentConfig.respondTo.add("Splinters");
                                }else{
                                  currentConfig.respondTo.remove("Splinters");
                                }
                                setState(() {});
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  (currentConfig.respondTo != null && currentConfig.respondTo.contains("Splinters"))?
                                  Icon(Icons.check_box_outlined,color: Colors.green,)
                                      :
                                  Icon(Icons.check_box_outline_blank,color: SALRed,)
                                  ,
                                  Padding(padding: EdgeInsets.fromLTRB(5, 3, 5, 5),
                                    child: Text("Splinters",style: TextStyle(color: Colors.black),),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 40,
                            height: 30,
                            child: InkWell(
                              onTap: (){
                                print("Sprains");
                                if(currentConfig.respondTo == null) {
                                  currentConfig.respondTo = [];
                                  currentConfig.respondTo.add("Sprains");
                                }else if(!currentConfig.respondTo.contains("Sprains")){
                                  currentConfig.respondTo.add("Sprains");
                                }else{
                                  currentConfig.respondTo.remove("Sprains");
                                }
                                setState(() {});
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  (currentConfig.respondTo != null && currentConfig.respondTo.contains("Sprains"))?
                                  Icon(Icons.check_box_outlined,color: Colors.green,)
                                      :
                                  Icon(Icons.check_box_outline_blank,color: SALRed,)
                                  ,
                                  Padding(padding: EdgeInsets.fromLTRB(5, 3, 5, 5),
                                    child: Text("Sprains",style: TextStyle(color: Colors.black),),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 40,
                            height: 30,
                            child: InkWell(
                              onTap: (){
                                print("Strains");
                                if(currentConfig.respondTo == null) {
                                  currentConfig.respondTo = [];
                                  currentConfig.respondTo.add("Strains");
                                }else if(!currentConfig.respondTo.contains("Strains")){
                                  currentConfig.respondTo.add("Strains");
                                }else{
                                  currentConfig.respondTo.remove("Strains");
                                }
                                setState(() {});
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  (currentConfig.respondTo != null && currentConfig.respondTo.contains("Strains"))?
                                  Icon(Icons.check_box_outlined,color: Colors.green,)
                                      :
                                  Icon(Icons.check_box_outline_blank,color: SALRed,)
                                  ,
                                  Padding(padding: EdgeInsets.fromLTRB(5, 3, 5, 5),
                                    child: Text("Strains",style: TextStyle(color: Colors.black),),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                ),
              ),
            ),
            Visibility(
              visible: (emergencyStatus == "setAttendTo"),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                child: InkWell(
                  onTap: (){
                    emergencyStatus = "none";
                    setState(() {});
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 50,
                    color: (currentConfig.respondTo == null || currentConfig.respondTo.length==0)?SALRed:Colors.green,
                    child: Center(
                      child: Text("SAVE",style: TextStyle(color: SALWhite,fontSize: 24),),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: (emergencyStatus == "start" || emergencyStatus == "called"),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Container(
                  height: MediaQuery.of(context).size.width - 100,
                  width: MediaQuery.of(context).size.width - 100,
                  child: Image(image: AssetImage('images/heart_call.png'),),
                ),
              ),
            ),
            Visibility(
              visible: (emergencyStatus == "calling" || emergencyStatus=="attending" || emergencyStatus=="onsite"),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Container(
                  height: MediaQuery.of(context).size.width - 300,
                  width: MediaQuery.of(context).size.width - 300,
                  child: Image(image: AssetImage('images/heart_call.png'),),
                ),
              ),
            ),
            Visibility(
              visible: (emergencyStatus == "start" || emergencyStatus == "called" || emergencyStatus == "calling" || emergencyStatus=="attending" || emergencyStatus=="onsite"),
              child: Center(
                child: Text("Emergency Call",style: TextStyle(color: Colors.white70,fontSize: 40,fontWeight: FontWeight.bold),),
              ),
            ),
            Visibility(
              visible: (emergencyStatus == "start"),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 50,
                  color: SALWhite,
                  child: DropdownButton(
                      value: emergencyType,
                      items: [
                        DropdownMenuItem(child: Text("Please select your emergency type."), value: "none",),
                        DropdownMenuItem(child: Text("Car accident"), value: "Car accident",),
                        DropdownMenuItem(child: Text("Heart Attack"), value: "Heart Attack",),
                        DropdownMenuItem(child: Text("Burns"), value: "Burns"),
                        DropdownMenuItem(child: Text("Cuts"), value: "Cuts"),
                        DropdownMenuItem(child: Text("Abrasions"), value: "Abrasions"),
                        DropdownMenuItem(child: Text("Stings"), value: "Stings"),
                        DropdownMenuItem(child: Text("Splinters"), value: "Splinters"),
                        DropdownMenuItem(child: Text("Sprains"), value: "Sprains"),
                        DropdownMenuItem(child: Text("Strains"), value: "Strains")
                      ],
                      onChanged: (value) {
                        setState(() {
                          emergencyType = value;
                        });
                      }),
                ),
              ),
            ),
            Visibility(
              visible: (emergencyStatus == "start"),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                child: InkWell(
                  onTap: (){
                    emergencyStatus = "called";
                    setState(() {});
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 50,
                    color: (currentConfig.respondTo == null || currentConfig.respondTo.length==0)?SALRed:Colors.green,
                    child: Center(
                      child: Text("CALL",style: TextStyle(color: SALWhite,fontSize: 24),),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: (emergencyStatus == "called"),
              child: Center(
                child: Text("Your First Responders",style: TextStyle(color: Colors.white70,fontSize: 16,fontWeight: FontWeight.bold),),
              ),
            ),
            Visibility(
              visible: (emergencyStatus == "called"),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                child: Container(
                  color: SALWhite,
                  width: MediaQuery.of(context).size.width - 40,
                  height: MediaQuery.of(context).size.height - 450,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(padding: EdgeInsets.fromLTRB(5, 3, 5, 0), child: Text("Name Surname",style: TextStyle(color: Colors.black,fontSize: 18),),),
                            Padding(padding: EdgeInsets.fromLTRB(5, 3, 5, 0), child: Text("Responding",style: TextStyle(color: Colors.black,fontSize: 18),),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(padding: EdgeInsets.fromLTRB(5, 3, 5, 0), child: Text("Name Surname",style: TextStyle(color: Colors.black,fontSize: 18),),),
                            Padding(padding: EdgeInsets.fromLTRB(5, 3, 5, 0), child: Text("Responding",style: TextStyle(color: Colors.black,fontSize: 18),),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(padding: EdgeInsets.fromLTRB(5, 3, 5, 0), child: Text("Name Surname",style: TextStyle(color: Colors.black,fontSize: 18),),),
                            Padding(padding: EdgeInsets.fromLTRB(5, 3, 5, 0), child: Text("Responding",style: TextStyle(color: Colors.black,fontSize: 18),),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(padding: EdgeInsets.fromLTRB(5, 3, 5, 0), child: Text("Name Surname",style: TextStyle(color: Colors.black,fontSize: 18),),),
                            Padding(padding: EdgeInsets.fromLTRB(5, 3, 5, 0), child: Text("Responding",style: TextStyle(color: Colors.black,fontSize: 18),),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(padding: EdgeInsets.fromLTRB(5, 3, 5, 0), child: Text("Name Surname",style: TextStyle(color: Colors.black,fontSize: 18),),),
                            Padding(padding: EdgeInsets.fromLTRB(5, 3, 5, 0), child: Text("Responding",style: TextStyle(color: Colors.black,fontSize: 18),),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(padding: EdgeInsets.fromLTRB(5, 3, 5, 0), child: Text("Name Surname",style: TextStyle(color: Colors.black,fontSize: 18),),),
                            Padding(padding: EdgeInsets.fromLTRB(5, 3, 5, 0), child: Text("Responding",style: TextStyle(color: Colors.black,fontSize: 18),),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(padding: EdgeInsets.fromLTRB(5, 3, 5, 0), child: Text("Name Surname",style: TextStyle(color: Colors.black,fontSize: 18),),),
                            Padding(padding: EdgeInsets.fromLTRB(5, 3, 5, 0), child: Text("Responding",style: TextStyle(color: Colors.black,fontSize: 18),),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(padding: EdgeInsets.fromLTRB(5, 3, 5, 0), child: Text("Name Surname",style: TextStyle(color: Colors.black,fontSize: 18),),),
                            Padding(padding: EdgeInsets.fromLTRB(5, 3, 5, 0), child: Text("Responding",style: TextStyle(color: Colors.black,fontSize: 18),),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(padding: EdgeInsets.fromLTRB(5, 3, 5, 0), child: Text("Name Surname",style: TextStyle(color: Colors.black,fontSize: 18),),),
                            Padding(padding: EdgeInsets.fromLTRB(5, 3, 5, 0), child: Text("Responding",style: TextStyle(color: Colors.black,fontSize: 18),),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(padding: EdgeInsets.fromLTRB(5, 3, 5, 0), child: Text("Name Surname",style: TextStyle(color: Colors.black,fontSize: 18),),),
                            Padding(padding: EdgeInsets.fromLTRB(5, 3, 5, 0), child: Text("Responding",style: TextStyle(color: Colors.black,fontSize: 18),),),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: (emergencyStatus == "start" || emergencyStatus == "called"),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                child: InkWell(
                  onTap: (){
                    emergencyStatus = "none";
                    setState(() {});
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 50,
                    color: (currentConfig.respondTo == null || currentConfig.respondTo.length==0)?SALRed:Colors.green,
                    child: Center(
                      child: Text("CANCEL",style: TextStyle(color: SALWhite,fontSize: 24),),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: (emergencyStatus == "calling"),
              child: Center(
                child: Text("Can you help?",style: TextStyle(color: Colors.white70,fontSize: 16,fontWeight: FontWeight.bold),),
              ),
            ),
            Visibility(
              visible: (emergencyStatus == "attending" || emergencyStatus=="onsite"),
              child: Center(
                child: Text("You are helping James Buchannon",style: TextStyle(color: Colors.white70,fontSize: 16,fontWeight: FontWeight.bold),),
              ),
            ),
            Visibility(
              visible: (emergencyStatus == "calling"),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: MediaQuery.of(context).size.height - 300,
                  color: SALWhite,
                  child: Image(image: AssetImage("images/map.png"),),
                ),
              ),),
            Visibility(
              visible: ( emergencyStatus=="attending" || emergencyStatus=="onsite"),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: MediaQuery.of(context).size.height - 300,
                  color: SALWhite,
                  child: Image(image: AssetImage("images/mapTrack.png"),),
                ),
              ),),
            Visibility(
              visible: (emergencyStatus == "calling" || emergencyStatus == "attending" || emergencyStatus=="onsite"),
              child: Center(
                child: Text(emergencyType,style: TextStyle(color: Colors.white70,fontSize: 16,fontWeight: FontWeight.bold),),
              ),
            ),
            Visibility(
                visible: (emergencyStatus == "calling"),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: (){
                          emergencyStatus="none";
                          setState(() {});
                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: SALRed,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: Icon(Icons.cancel_outlined,color: SALWhite,size: 40,),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          emergencyStatus="attending";
                          setState(() {});
                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: Icon(Icons.check,color: SALWhite,size: 40,),
                        ),
                      ),
                    ],
                  ),
                )),
            Visibility(
              visible: (emergencyStatus == "attending"),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: (){
                        emergencyStatus="onsite";
                        setState(() {});
                      },
                      child: Container(
                        height: 30,
                        width: (MediaQuery.of(context).size.width-50)/2,
                        color: Colors.green,
                        child: Center(child:Text("On-Site",style: TextStyle(color: SALWhite,fontSize: 24),),),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        emergencyStatus="none";
                        setState(() {});
                      },
                      child: Container(
                        height: 30,
                        width: (MediaQuery.of(context).size.width-50)/2,
                        color: SALRed,
                        child: Center(child:Text("No Event",style: TextStyle(color: SALWhite,fontSize: 24),),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: (emergencyStatus == "attending"||emergencyStatus=="onsite"),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: InkWell(
                  onTap: (){
                    emergencyStatus="none";
                    setState(() {});
                  },
                  child: Container(
                    height: 30,
                    width: (MediaQuery.of(context).size.width-40),
                    color: Colors.green,
                    child: Center(child:Text("Completed",style: TextStyle(color: SALWhite,fontSize: 24),),),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: (emergencyStatus == "attending"||emergencyStatus=="onsite"),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: InkWell(
                  onTap: (){
                    emergencyStatus="none";
                    setState(() {});
                  },
                  child: Container(
                    height: 30,
                    width: (MediaQuery.of(context).size.width-40),
                    color: SALWhite,
                    child: Center(child:Text("Can no longer respond",style: TextStyle(color:Colors.black,fontSize: 24),),),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Center(
                child: InkWell(
                  onTap: (){
                    if(emergencyStatus=="none"){
                      emergencyStatus="calling";
                      setState(() {});
                    }
                  },
                  child:Text(emergencyStatus,style: TextStyle(color: SALWhite,fontSize: 16),),),
              ),
            ),
          ]
      ),
    );
  }

  login(){
    currentConfig.username = "User";
    currentConfig.phoneNumber = "+49176283746";
    currentConfig.city = "Berlin";
    currentConfig.country = "Germany";
    currentConfig.password = "hellThere";
    currentConfig.userId = "52";
    currentConfig.token = "10293847657483902";
    setState(() {});
  }

  register(){
    currentConfig.username = "User";
    currentConfig.phoneNumber = "+49176283746";
    currentConfig.city = "Berlin";
    currentConfig.country = "Germany";
    currentConfig.password = "hellThere";
    currentConfig.userId = "52";
    currentConfig.token = "10293847657483902";
    setState(() {});
  }

}

class Emergency{
  String eventId;
  String eventType;
  String activatedDateTime;
  String gpsLat;
  String gpsLng;
}

class EmergencyUser{
  String userId;
  String username;
  String city;
  String country;
  String phoneNumber;
  String password;
  String token;
  List<String> respondTo;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/config.txt');
  }

  Future<EmergencyUser> readFile() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return jsonDecode(contents);
    } catch (e) {
      // If encountering an error, return 0
      return EmergencyUser();
    }
  }

  Future<File> writeFiler(EmergencyUser currentConfig) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(jsonEncode(currentConfig));
  }
}
