Class {
	#name : 'DieRollerTest',
	#superclass : 'TestCase',
	#category : 'Random-Dice-Tests',
	#package : 'Random-Dice-Tests'
}

{ #category : 'tests' }
DieRollerTest >> testPullFromQueue [

	| roller r |
	roller := DieRoller roller.
	roller queueD: 6 value: -1.
	roller queueD: 6 value: -5.
	r := roller randomInt: 6.
	self assert: r equals: -1.
	r := roller randomInt: 6.
	self assert: r equals: -5.
	r := roller randomInt: 6.
	self assert: (r between: 1 and: 6).
]
