
import 'package:flutter_test/flutter_test.dart';
import 'package:common_tools/common_tools.dart';
void main() {

  group('group description', (){
    test('test description', (){
      // expect(1 == 2, true);

      Map deliveryTodoRuleRes = {
        'uiList': []
      };

      print((deliveryTodoRuleRes['uiList'].elementAtOrElse(0, orElse: ()=>{})));
    });
  });
}
