import 'package:flutter_app/entity/search_data_entity_entity.dart';

searchDataEntityEntityFromJson(SearchDataEntityEntity data, Map<String, dynamic> json) {
	if (json['Or'] != null) {
		data.or = new List<SearchDataEntityOr>();
		(json['Or'] as List).forEach((v) {
			data.or.add(new SearchDataEntityOr(json['Name'],json['Like']).fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> searchDataEntityEntityToJson(SearchDataEntityEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.or != null) {
		data['Or'] =  entity.or.map((v) => v.toJson()).toList();
	}
	return data;
}

searchDataEntityOrFromJson(SearchDataEntityOr data, Map<String, dynamic> json) {
	if (json['Name'] != null) {
		data.name = json['Name']?.toString();
	}
	if (json['Like'] != null) {
		data.like = json['Like']?.toString();
	}
	return data;
}

Map<String, dynamic> searchDataEntityOrToJson(SearchDataEntityOr entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['Name'] = entity.name;
	data['Like'] = entity.like;
	return data;
}