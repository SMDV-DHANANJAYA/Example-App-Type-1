import 'package:get_storage/get_storage.dart';

class CustomStorage{
  static final storage = GetStorage();

  static setValue(String key, var value){
    storage.write(key, value);
  }

  static getValue(String key){
    return storage.read(key);
  }

  static deleteValue(String key){
    if(storage.hasData(key)){
      return storage.remove(key);
    }
  }

  static deleteAll(){
    return storage.erase();
  }

}