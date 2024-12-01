import 'dart:convert';


import 'package:hdlive_latest/models/tags_model.dart';
import 'package:hdlive_latest/screens/shared/urls.dart';
import 'package:http/http.dart' as http;
class TagsServices{
  
  static Future<Map<String,dynamic>> getAllTags()async{
    List<String> list = [];
    List<String> ids=  [];
    try{
      
      var url = Uri.parse(tagsUrl);
      var response = await http.get(url);
      if(response.statusCode==200){
        var info = jsonDecode(response.body);
        var success = info['success'];
        if(success){
          var data = info['data'];
          if(data.length>0){
            for(var i=0;i<data.length;i++){
              list.add(data[i]['name'].toString());
              ids.add(data[i]['id'].toString());
            }
          }
        }
      }
    }catch(e){
      print(e);
    }
    
    return {
      'tags':list,
      "ids":ids
    };
  }
}