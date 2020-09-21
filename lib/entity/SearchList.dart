 class SearchList<T> {
   List<T> Or;
   String _data;

   SearchList();

   SearchList.name(this.Or);

   void setOr( List<T> data){
     this.Or = data;
   }


   List<T>  getOr( ){
     return Or;
   }


   Map toJson() {
     Map map = new Map();
     map["Or"] = this.Or;
     return map;
   }


 }