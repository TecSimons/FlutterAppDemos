import 'dart:convert';
import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class SearchDataEntityEntity with JsonConvert<SearchDataEntityEntity> {
	@JSONField(name: "Or")
	List<SearchDataEntityOr> or;


	SearchDataEntityEntity(this.or);

  static  String getData(String like){

		List<SearchDataEntityOr> list = new List<SearchDataEntityOr>();
		list.add(new SearchDataEntityOr("DeviceName", like));
		list.add(new SearchDataEntityOr("Msg", like));
		list.add(new SearchDataEntityOr("Did", like));
		list.add(new SearchDataEntityOr("LandName", like));
		return	json.encode(SearchDataEntityEntity(list));

	}

}

@JsonSerializable()
class SearchDataEntityOr with JsonConvert<SearchDataEntityOr> {
	@JSONField(name: "Name")
	String name;
	@JSONField(name: "Like")
	String like;


	SearchDataEntityOr(this.name, this.like);
}


