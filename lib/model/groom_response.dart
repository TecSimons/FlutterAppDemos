import 'package:json_annotation/json_annotation.dart';

part 'groom_response.g.dart';

@JsonSerializable()
class GroomResponse extends Object {

  List<Data> data;

  int errorCode;

  String errorMsg;

  GroomResponse(this.data,this.errorCode,this.errorMsg,);

  factory GroomResponse.fromJson(Map<String, dynamic> srcJson) => _$GroomResponseFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GroomResponseToJson(this);


}


@JsonSerializable()
class Data extends Object {

  int id;

  String link;

  String name;

  int order;

  int visible;

  Data(this.id,this.link,this.name,this.order,this.visible,);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);

}