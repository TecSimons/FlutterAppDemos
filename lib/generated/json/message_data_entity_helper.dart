import 'package:flutter_app/entity/message_data_entity.dart';
import 'package:json_annotation/json_annotation.dart';

messageDataEntityFromJson(MessageDataEntity data, Map<String, dynamic> json) {
	if (json['Data'] != null) {
		data.data = new List<MessageDataData>();
		(json['Data'] as List).forEach((v) {
			data.data.add(new MessageDataData().fromJson(v));
		});
	}
	if (json['Status'] != null) {
		data.status = json['Status']?.toInt();
	}
	if (json['Msg'] != null) {
		data.msg = json['Msg']?.toString();
	}
	if (json['Paper'] != null) {
		data.paper = new MessageDataPaper().fromJson(json['Paper']);
	}
	return data;
}

Map<String, dynamic> messageDataEntityToJson(MessageDataEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.data != null) {
		data['Data'] =  entity.data.map((v) => v.toJson()).toList();
	}
	data['Status'] = entity.status;
	data['Msg'] = entity.msg;
	if (entity.paper != null) {
		data['Paper'] = entity.paper.toJson();
	}
	return data;
}

messageDataDataFromJson(MessageDataData data, Map<String, dynamic> json) {
	if (json['ID'] != null) {
		data.iD = json['ID']?.toInt();
	}
	if (json['Type'] != null) {
		data.type = json['Type']?.toString();
	}
	if (json['Label'] != null) {
		data.label = json['Label']?.toString();
	}
	if (json['Deal'] != null) {
		data.deal = json['Deal'];
	}
	if (json['Msg'] != null) {
		data.msg = json['Msg']?.toString();
	}
	if (json['Receiver'] != null) {
		data.receiver = json['Receiver']?.toString();
	}
	if (json['Created'] != null) {
		data.created = json['Created']?.toString();
	}
	return data;
}

Map<String, dynamic> messageDataDataToJson(MessageDataData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['ID'] = entity.iD;
	data['Type'] = entity.type;
	data['Label'] = entity.label;
	data['Deal'] = entity.deal;
	data['Msg'] = entity.msg;
	data['Receiver'] = entity.receiver;
	data['Created'] = entity.created;
	return data;
}

messageDataPaperFromJson(MessageDataPaper data, Map<String, dynamic> json) {
	if (json['PageIndex'] != null) {
		data.pageIndex = json['PageIndex']?.toInt();
	}
	if (json['PageSize'] != null) {
		data.pageSize = json['PageSize']?.toInt();
	}
	if (json['TotalCount'] != null) {
		data.totalCount = json['TotalCount']?.toInt();
	}
	if (json['PageCount'] != null) {
		data.pageCount = json['PageCount']?.toInt();
	}
	if (json['OrderBy'] != null) {
		data.orderBy = json['OrderBy'];
	}
	return data;
}

Map<String, dynamic> messageDataPaperToJson(MessageDataPaper entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['PageIndex'] = entity.pageIndex;
	data['PageSize'] = entity.pageSize;
	data['TotalCount'] = entity.totalCount;
	data['PageCount'] = entity.pageCount;
	data['OrderBy'] = entity.orderBy;
	return data;
}