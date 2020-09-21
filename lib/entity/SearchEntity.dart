
import 'package:json_annotation/json_annotation.dart';
import 'SearchList.dart';

@JsonSerializable()
class SearchEntity  extends Object {
    String Name;
    String Like;


   void setName(String name){
     this.Name = name;
   }
   String getName(){
     return Name;
   }

   SearchEntity(this.Name, this.Like);

    void setLike(String like){
      this.Like = like;
    }

    String getLike(){
      return Like;
    }


    Map toJson() {
      Map map = new Map();
      map["Name"] = this.Name;
      map["Like"] = this.Like;
      return map;
    }


//    factory SearchEntity.fromJson(Map<String, dynamic> srcJson) => _$SearchEntityFromJson(srcJson);
//
//    Map<String, dynamic> toJson() => _$SearchEntityToJson(this);



  static  SearchList<SearchEntity> getData(String like){
      SearchList<SearchEntity> entity = new SearchList<SearchEntity>();
      List<SearchEntity> list = new List<SearchEntity>();
      list.add(new SearchEntity("DeviceName", like));
      list.add(new SearchEntity("Msg", like));
      list.add(new SearchEntity("Did", like));
      list.add(new SearchEntity("LandName", like));
      entity.setOr(list);
      return entity;
    }

}
