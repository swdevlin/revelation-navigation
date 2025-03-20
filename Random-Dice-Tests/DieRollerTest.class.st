Class {
	#name : 'DieRollerTest',
	#superclass : 'TestCase',
	#category : 'Random-Dice-Tests',
	#package : 'Random-Dice-Tests'
}

{ #category : 'tests' }
DieRollerTest >> testPullFromCache [

	| roller r |
	roller := DieRoller new.
	roller cacheD: 6 value: 1.
	roller cacheD: 6 value: 5.
	r := roller randomInt: 6.
	self assert: r equals: 1.
	r := roller randomInt: 6.
	self assert: r equals: 5
]
