import 'package:flutter/material.dart';

const Color kMainColorDark = Color(0xFF003AFC);
const Color kMainColorLight = Color(0xFF6589FF);
const Color kBackgroundColor = Color(0xFFF7F6FF);

const Widget kSizeBoxH8 = SizedBox(height: 8);
const Widget kSizeBoxW8 = SizedBox(width: 8);
const Widget kSizeBoxH16 = SizedBox(height: 16);
const Widget kSizeBoxW16 = SizedBox(width: 16);
const Widget kSizeBoxH24 = SizedBox(height: 24);
const Widget kSizeBoxH32 = SizedBox(height: 32);

const kTextFieldDecoration = InputDecoration(
  hintText: 'any text',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: UnderlineInputBorder(),
  prefixIcon: Icon(Icons.email),
  prefixIconColor: kMainColorLight,
);

const kDivider = Divider(
  indent: 10,
  color: Colors.grey,
  thickness: 1,
  endIndent: 10,
);


