import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class MessageDataEntity with JsonConvert<MessageDataEntity> {
	@JSONField(name: "Data")
	List<MessageDataData> _data;
	@JSONField(name: "Status")
	int _status;
	@JSONField(name: "Msg")
	String _msg;
	@JSONField(name: "Paper")
	MessageDataPaper _paper;

	List<MessageDataData> get data => _data;

  set data(List<MessageDataData> value) {
    _data = value;
  }

	int get status => _status;

  set status(int value) {
    _status = value;
  }

	String get msg => _msg;

  set msg(String value) {
    _msg = value;
  }

	MessageDataPaper get paper => _paper;

  set paper(MessageDataPaper value) {
    _paper = value;
  }
}
@JsonSerializable()
class MessageDataData with JsonConvert<MessageDataData> {
	@JSONField(name: "ID")
	int iD;
	@JSONField(name: "Type")
	String type;
	@JSONField(name: "Label")
	String label;
	@JSONField(name: "Deal")
	bool deal;
	@JSONField(name: "Msg")
	String msg;@JSONField(name: "Receiver")
	String receiver;
	@JSONField(name: "Created")
	String created;
}
@JsonSerializable()
class MessageDataPaper with JsonConvert<MessageDataPaper> {
	@JSONField(name: "PageIndex")
	int pageIndex;
	@JSONField(name: "PageSize")
	int pageSize;
	@JSONField(name: "TotalCount")
	int totalCount;
	@JSONField(name: "PageCount")
	int pageCount;
	@JSONField(name: "OrderBy")
	dynamic orderBy;
}
