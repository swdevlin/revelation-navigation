"
Lookup a value in a table based on a die roll.
"
Class {
	#name : 'RollTable',
	#superclass : 'Object',
	#instVars : [
		'table',
		'name',
		'mod',
		'lastRoll'
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
RollTable class >> companionStarDetermination [
	"WBH: page 29"

	^ self new
		  initializeWithDictionary: (Dictionary newFrom: {
					   (2 -> #Other).
					   (3 -> #Other).
					   (4 -> #Random).
					   (5 -> #Random).
					   (6 -> #Random).
					   (7 -> #Lesser).
					   (8 -> #Sibling).
					   (9 -> #Sibling).
					   (10 -> #Twin).
					   (11 -> #Twin).
					   (12 -> #Twin) })
		  named: 'CompanionStarDetermination'
]

{ #category : 'table' }
RollTable class >> giantStarClass [

	^ self new
		  initializeWithDictionary: (Dictionary newFrom: {
					   (2 -> 'III').
					   (3 -> 'III').
					   (4 -> 'III').
					   (5 -> 'III').
					   (6 -> 'III').
					   (7 -> 'III').
					   (8 -> 'III').
					   (9 -> 'II').
					   (10 -> 'II').
					   (11 -> 'Ib').
					   (12 -> 'Ia') })
		  named: 'GiantStarClass'
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

{ #category : 'table' }
RollTable class >> mPrimarySubtype [

	^ self new
		  initializeWithDictionary: (Dictionary newFrom: {
					   (2 -> 8).
					   (3 -> 6).
					   (4 -> 5).
					   (5 -> 4).
					   (6 -> 0).
					   (7 -> 2).
					   (8 -> 1).
					   (9 -> 3).
					   (10 -> 5).
					   (11 -> 7).
					   (12 -> 9) })
		  named: 'MPrimarySubtype'
]

{ #category : 'instance creation' }
RollTable class >> named: aName [

	^ TableRegistry at: aName ifAbsent: [ Error signal: 'No such table' ]
]

{ #category : 'registry' }
RollTable class >> register: aRollTable [

	self tableRegistry at: aRollTable name put: aRollTable
]

{ #category : 'table' }
RollTable class >> secondaryStarDetermination [
	"WBH: page 29"

	^ self new
		  initializeWithDictionary: (Dictionary newFrom: {
					   (2 -> #Other).
					   (3 -> #Other).
					   (4 -> #Random).
					   (5 -> #Random).
					   (6 -> #Random).
					   (7 -> #Lesser).
					   (8 -> #Lesser).
					   (9 -> #Sibling).
					   (10 -> #Sibling).
					   (11 -> #Twin).
					   (12 -> #Twin) })
		  named: 'SecondaryStarDetermination'
]

{ #category : 'table' }
RollTable class >> specialStarClass [

	^ self new
		  initializeWithDictionary: (Dictionary newFrom: {
					   (2 -> 'VI').
					   (3 -> 'VI').
					   (4 -> 'VI').
					   (5 -> 'VI').
					   (6 -> 'IV').
					   (7 -> 'IV').
					   (8 -> 'IV').
					   (9 -> 'III').
					   (10 -> 'III').
					   (11 -> #Giant).
					   (12 -> #Giant) })
		  named: 'SpecialStarClass'
]

{ #category : 'table' }
RollTable class >> starSubtype [

	^ StarSubtypeRollTable new
		  initializeWithDictionary: (Dictionary newFrom: {
					   (2 -> 0).
					   (3 -> 1).
					   (4 -> 3).
					   (5 -> 5).
					   (6 -> 7).
					   (7 -> 9).
					   (8 -> 8).
					   (9 -> 6).
					   (10 -> 4).
					   (11 -> 2).
					   (12 -> 0) })
		  named: 'StarSubtype'
]

{ #category : 'table' }
RollTable class >> starType [

	^ self new
		  initializeWithDictionary: (Dictionary newFrom: {
					   (2 -> #Special).
					   (3 -> 'M').
					   (4 -> 'M').
					   (5 -> 'M').
					   (6 -> 'M').
					   (7 -> 'K').
					   (8 -> 'K').
					   (9 -> 'G').
					   (10 -> 'G').
					   (11 -> 'F').
					   (12 -> #Hot) })
		  named: 'StarType'
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
RollTable >> lastRoll [

	^ lastRoll
]

{ #category : 'accessing' }
RollTable >> lastRoll: anObject [

	lastRoll := anObject
]

{ #category : 'as yet unclassified' }
RollTable >> lastRollResult [

	^ self roll: lastRoll 

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
	dice := DieRoller roller .
	r := dice roll: 2 d: 6.
	^ self roll: r

]

{ #category : 'accessing' }
RollTable >> roll: aRoll [

	| min max result |
	lastRoll := aRoll.

	min := self min.
	max := self max.
	(aRoll + mod between: min and: max)
		ifTrue: [
			result := table
				          at: aRoll
				          ifAbsent: [ Error signal: 'Roll not found in table' ] ]
		ifFalse: [
			aRoll + mod < min ifTrue: [ result := table at: min ].
			aRoll + mod > max ifTrue: [ result := table at: max ] ].

	result isBlock
		ifTrue: [ ^ result value ]
		ifFalse: [ ^ result ]
]

{ #category : 'as yet unclassified' }
RollTable >> subtract: value [

	mod := mod - value
]
