//
//  IntPreferenceTest.swift
//  SwiftKit
//
//  Created by Filip Dolník on 25.05.15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class IntPreferenceTest: QuickSpec {

    override func spec() {
        describe("IntPreference") {
            let parameters = [-100, 0, 100, Int.min, Int.max]
            let key = "data"
            var preference: IntPreference!
            
            beforeEach {
                preference = IntPreference(key: key)
                preference.delete()
            }
            
            describe("value") {
                it("persists value") {
                    for parameter in parameters {
                        preference.value = parameter
                        
                        let savedValue = NSUserDefaults.standardUserDefaults().integerForKey(key)
                        expect(savedValue) == parameter
                    }
                }
                
                it("returns saved value") {
                    for parameter in parameters {
                        preference.value = parameter
                        
                        expect(preference.value) == parameter
                    }
                }
                
                it("returns default value if value doesn't exist") {
                    let defaultValue = 10
                    preference = IntPreference(key: key, defaultValue: defaultValue)
                    preference.value = 0
                    
                    preference.delete()
                    
                    expect(preference.value) == defaultValue
                }
            }
            
            describe("exists") {
                it("returns true if value exists") {
                    preference.value = 10
                    
                    expect(preference.exists) == true
                }
                
                it("returns false if value doesn't exist") {
                    preference.delete()
                    
                    expect(preference.exists) == false
                }
                
                it("returns false if is value of different type") {
                    StringPreference(key: key).value = "Value of wrong type"
                    
                    expect(preference.exists) == false
                }
            }
            
            describe("delete") {
                it("deletes the value") {
                    preference.value = 10
                    
                    preference.delete()
                    
                    let value: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(key)
                    expect(value).to(beNil())
                }
            }
            
            describe("onValueChange") {
                it("fires with correct input when value change") {
                    let value = 10
                    var eventData: EventData<IntPreference, Int>?
                    preference.onValueChange += { data in
                        eventData = data
                    }
                    
                    preference.value = value
                    
                    expect(eventData?.input) == value
                }
            }
        }
    }

}