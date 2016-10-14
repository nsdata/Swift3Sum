/*
 * Copyright 1999-2101 Alibaba Group.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//  Created by cijianzy(cijainzy@gmail.com) on 17/9/16.
//

import Foundation
import XCTest
import HandyJSON

class serializeToJSONTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func stringCompareHelper(_ actual: String?, _ expected: String?) {
        print(actual)
        print(expected)
        XCTAssertTrue(expected == actual, "expected value:\(expected) not equal to actual:\(actual)")
    }

    func testValue() {
        stringCompareHelper(JSONSerializer.serializeToJSON(object: 1), "1")
        stringCompareHelper(JSONSerializer.serializeToJSON(object: "HandyJSON"), "\"HandyJSON\"")
        stringCompareHelper(JSONSerializer.serializeToJSON(object: 1.2), "1.2")
        stringCompareHelper(JSONSerializer.serializeToJSON(object: 10), "10")
        stringCompareHelper(JSONSerializer.serializeToJSON(object: true), "true")

        enum Week: String {
            case Monday
            case Tuesday
            case Wednesday
            case Thursday
            case Friday
            case Saturday
            case Sunday
        }

        stringCompareHelper(JSONSerializer.serializeToJSON(object: Week.Friday), "\"Friday\"")
    }

    func testIntArray() {
        let array = [1,2,3,4]
        let json = JSONSerializer.serializeToJSON(object: array)
        stringCompareHelper(json, "[1,2,3,4]")
    }

    func testStringArray() {
        let array = ["Monday", "Tuesday", "Wednesday"]
        let json = JSONSerializer.serializeToJSON(object: array)
        stringCompareHelper(json, "[\"Monday\",\"Tuesday\",\"Wednesday\"]")
    }

    func testNSDictionary() {
        let dic: NSDictionary = NSDictionary.init(dictionary: ["Today": "Monday"])
        let json = JSONSerializer.serializeToJSON(object: dic)
        stringCompareHelper(json, "{\"Today\":\"Monday\"}")
    }

    func testClass() {
        enum Week: String {
            case Monday
            case Tuesday
            case Wednesday
            case Thursday
            case Friday
            case Saturday
            case Sunday
        }

        class ClassA {
            let month = 4
            let day = 18
            let year = 1994
            let today = Week.Monday
            let name = "cijian"
            let time = ["Morning","Afternoon","Night"]
            let dic = ["today": "Monday", "tomorrow": "Tuesday"]
        }

        stringCompareHelper(JSONSerializer.serializeToJSON(object: ClassA()), "{\"month\":4,\"day\":18,\"year\":1994,\"today\":\"Monday\",\"name\":\"cijian\",\"time\":[\"Morning\",\"Afternoon\",\"Night\"],\"dic\":{\"tomorrow\":\"Tuesday\",\"today\":\"Monday\"}}")
    }

    func testOptional() {
        var optianlInt: Int?
        var optianlString: String?
        var optianlBool: Bool?
        var optianlDouble: Double?

        optianlInt = 10
        optianlString = "hello"
        optianlBool = false
        optianlDouble = 1.23

        stringCompareHelper(JSONSerializer.serializeToJSON(object: optianlInt),"10")
        stringCompareHelper(JSONSerializer.serializeToJSON(object: optianlString),"\"hello\"")
        stringCompareHelper(JSONSerializer.serializeToJSON(object: optianlBool),"false")
        stringCompareHelper(JSONSerializer.serializeToJSON(object: optianlDouble),"1.23")
    }

    func testOptionalInArray() {
        var optionalvalue: Int?
        var array: [Int?] = []
        optionalvalue = 1
        array.append(optionalvalue)
        optionalvalue = 10
        array.append(optionalvalue)
        optionalvalue = 50
        array.append(optionalvalue)
        stringCompareHelper(JSONSerializer.serializeToJSON(object: array),"[1,10,50]")
    }

    func testOptinalInClass() {
        class ClassA {
            var value: Int? = 2
        }
        stringCompareHelper(JSONSerializer.serializeToJSON(object: ClassA()),"{\"value\":2}")
    }

    func testEnumString() {
        enum Week: String {
            case Monday
            case Tuesday
            case Wednesday
            case Thursday
            case Friday
            case Saturday
            case Sunday
        }

        class ClassA {

            var today = Week.Monday
            var tomorrow = Week.Tuesday
        }

        let expected = "{\"today\":\"Monday\",\"tomorrow\":\"Tuesday\"}"

        let json = JSONSerializer.serializeToJSON(object: ClassA())

        stringCompareHelper(json, expected)
    }

    func testEnumValue() {
        enum Week: Int {
            case Monday = 1000
            case Tuesday
            case Wednesday
            case Thursday
            case Friday
            case Saturday
            case Sunday
        }


        class ClassA {

            var today = Week.Monday
            var tomorrow = Week.Tuesday
        }

        let m = ClassA()

        let expected = "{\"today\":\"Monday\",\"tomorrow\":\"Tuesday\"}"

        let json = JSONSerializer.serializeToJSON(object: m) ?? ""

        stringCompareHelper(json, expected)
    }

    func testEnumStringChange() {
        enum Week: String {
            case Monday = "hello"
            case Tuesday
            case Wednesday
            case Thursday
            case Friday
            case Saturday
            case Sunday
        }

        class ClassA {

            var today = Week.Monday
            var tomorrow = Week.Tuesday
        }

        let m = ClassA()

        let expected = "{\"today\":\"Monday\",\"tomorrow\":\"Tuesday\"}"

        let json = JSONSerializer.serializeToJSON(object: m) ?? ""

        stringCompareHelper(json, expected)
    }

    func testIntKeyDictionaray() {
        class ClassA {
            var dic = [1: "Teacher", 2: "Worker"]
        }

        let m = ClassA()

        let expected = "{\"dic\":{2:\"Worker\",1:\"Teacher\"}}"

        let json = JSONSerializer.serializeToJSON(object: m) ?? ""

        stringCompareHelper(json, expected)
    }

    func testStringKeyDictionary() {
        class ClassA {
            var dic = ["today": "Monday", "tomorrow": "Tuesday"]
        }

        let m = ClassA()

        let expected = "{\"dic\":{\"tomorrow\":\"Tuesday\",\"today\":\"Monday\"}}"

        let json = JSONSerializer.serializeToJSON(object: m) ?? ""

        stringCompareHelper(json, expected)
    }

    func testClassValueDictionary() {
        print("test_Class_Value_Dictionary")
        class ClassB {
            var value: Int?
            init(value: Int) {
                self.value = value
            }
        }

        class ClassA {
            var dic = ["today": ClassB(value: 1), "tomorrow": ClassB(value: 2)]
        }

        let m = ClassA()

        let expected = "{\"dic\":{\"tomorrow\":{\"value\":2},\"today\":{\"value\":1}}}"

        let json = JSONSerializer.serializeToJSON(object: m) ?? ""

        stringCompareHelper(json, expected)

    }

    func testValueInsertBlock() {
        let value: Int = {

            class ClassA {
                var dic = ["today": "Monday", "tomorrow": "Tuesday"]
            }

            let m = ClassA()

            let expected = "{\"dic\":{\"tomorrow\":\"Tuesday\",\"today\":\"Monday\"}}"

            let json = JSONSerializer.serializeToJSON(object: m) ?? ""

            stringCompareHelper(json, expected)

            return 1
        }()

        XCTAssert(value == 1)
    }

    func testSetNoIndex() {
        let set: Set = [1, 2, 3, 4]

        let expected = "[2,3,1,4]"

        let json = JSONSerializer.serializeToJSON(object: set) ?? ""
        stringCompareHelper(json, expected)
    }

    func testSetInClass() {

        class ClassA {
            let set: Set = [1, 2, 3, 4]
        }

        let json = JSONSerializer.serializeToJSON(object: ClassA()) ?? ""
        stringCompareHelper(json, "{\"set\":[2,3,1,4]}")
    }

    func testDictionaryInClass() {
        class ClassA {
            var dic = ["today": "Monday", "tomorrow": "Tuesday"]
        }

        let json = JSONSerializer.serializeToJSON(object: ClassA()) ?? ""
        stringCompareHelper(json, "{\"dic\":{\"tomorrow\":\"Tuesday\",\"today\":\"Monday\"}}")
    }
}
