import 'package:flutter/material.dart';

push(BuildContext context, String route, dynamic args) async {
  return await Navigator.of(context).pushNamed(route, arguments: args);
}

pushReplacement(BuildContext context, String route, dynamic args) async {
  return  await Navigator.of(context).pushReplacementNamed(route, arguments: args);
}

pop(BuildContext context, dynamic state) async {
  return  Navigator.of(context).pop(state);
}
popUntil(BuildContext context, String route) async {
  return Navigator.of(context).popUntil(ModalRoute.withName(route));
}
pushNamedAndRemoveUntil(BuildContext context, String route) async {
  return Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
}

pushPage(BuildContext context, Widget page){
  return Navigator.of(context).push(MaterialPageRoute(builder:(context) => page,));
}