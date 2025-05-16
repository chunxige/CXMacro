import CXMacro

 
@CaseCheck
enum Kind {
    case one
}

var k = Kind.one
print(k.isOne)


//struct Person {
//    @UserDefault(key: "aaa", defaultValue: 11)
//    var age: Int
//
//}
