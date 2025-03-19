"
Lookup a value in a table based on a die roll.
"
Class {
	#name : 'RollTable',
	#superclass : 'Object',
	#instVars : [
		'table',
		'name',
		'mod'
	],
	#classVars : [
		'TableRegistry'
	],
	#category : 'Traveller',
	#package : 'Traveller'
}

{ #category : 'as yet unclassified' }
RollTable class >> allTables [

	^ TableRegistry values
]

{ #category : 'table' }
RollTable class >> hotStarType [

	^ self new
		  initializeWithDictionary: (Dictionary newFrom: {
					   (2 -> 'A').
					   (3 -> 'A').
					   (4 -> 'A').
					   (5 -> 'A').
					   (6 -> 'A').
					   (7 -> 'A').
					   (8 -> 'A').
					   (9 -> 'A').
					   (10 -> 'B').
					   (11 -> 'B').
					   (12 -> 'O') })
		  named: 'HotStarType'
]

{ #category : 'class initialization' }
RollTable class >> initialize [

	TableRegistry := Dictionary new
]

{ #category : 'instance creation' }
RollTable class >> named: aName [

	^ TableRegistry at: aName ifAbsent: [ Error signal: 'No such table' ]
]

{ #category : 'registry' }
RollTable class >> register: aRollTable [

	self tableRegistry at: aRollTable name put: aRollTable
]

{ #category : 'accessing' }
RollTable class >> tableRegistry [

	TableRegistry ifNil: [ TableRegistry := Dictionary new ].
	^ TableRegistry
]

{ #category : 'adding' }
RollTable >> add: value [

	mod := mod + value
]

{ #category : 'initialization' }
RollTable >> at: roll put: aValue [

	table at: roll put: aValue
]

{ #category : 'initialization' }
RollTable >> initialize [

	table := Dictionary new.
	mod := 0
]

{ #category : 'initialization' }
RollTable >> initializeWithDictionary: aDictionary named: aName [

	table := aDictionary.
	name := aName.
	self class register: self
]

{ #category : 'accessing' }
RollTable >> max [

	^ table keys max
]

{ #category : 'accessing' }
RollTable >> min [

	^ table keys min
]

{ #category : 'accessing' }
RollTable >> mod [

	^ mod
]

{ #category : 'accessing' }
RollTable >> mod: anObject [

	mod := anObject
]

{ #category : 'accessing' }
RollTable >> name [

	^ name
]

{ #category : 'accessing' }
RollTable >> name: anObject [

	name := anObject
]

{ #category : 'as yet unclassified' }
RollTable >> roll [

	| r dice |
	dice := DieRoller new.
	r := dice roll: 2 d: 6.
	^ self roll: r

]

{ #category : 'accessing' }
RollTable >> roll: aRoll [

	| min max |
	min := self min.
	aRoll + mod < min ifTrue: [ ^ table at: min ].

	max := self max.
	aRoll + mod > max ifTrue: [ ^ table at: max ].

	^ table at: aRoll ifAbsent: [ 'Invalid roll' ]
]

{ #category : 'as yet unclassified' }
RollTable >> subtract: value [

	mod := mod - value
]
