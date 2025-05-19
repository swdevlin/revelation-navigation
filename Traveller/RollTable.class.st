"
Lookup a value in a table based on a die roll.

The table can contain code blocks.

the roll method rolls 2D6 and returns the result of the roll: message

the roll: message uses computeDM to determine the DM for the roll and then returns the result of the roll:dm: message

the roll:dm: message looks up the value in the table and returns the result. If the roll + dm is less than the lowest key in the table, the value for the lowest key is returned. Similarly, if roll + dm is greater than the largest key, the value for the largest key is return.
"
Class {
	#name : 'RollTable',
	#superclass : 'Object',
	#instVars : [
		'table',
		'lastRoll',
		'lastDM'
	],
	#category : 'Traveller',
	#package : 'Traveller'
}

{ #category : 'as yet unclassified' }
RollTable class >> findTable: aName [

	self subclassesDo: [ :aClass |
		aClass tableName = aName ifTrue: [ ^ aClass ] ].
	^ self error: 'Table not found'
]

{ #category : 'accessing' }
RollTable class >> tableName [
	self subclassResponsibility.

]

{ #category : 'initialization' }
RollTable >> at: roll put: aValue [

	table at: roll put: aValue
]

{ #category : 'as yet unclassified' }
RollTable >> computeDM [

	^ 0
]

{ #category : 'initialization' }
RollTable >> initialize [

	table := Dictionary new.
	lastDM := 0.
]

{ #category : 'accessing' }
RollTable >> lastDM [

	^ lastDM
]

{ #category : 'accessing' }
RollTable >> lastRoll [

	^ lastRoll
]

{ #category : 'accessing' }
RollTable >> lastRoll: anObject [

	lastRoll := anObject
]

{ #category : 'roll' }
RollTable >> lastRollResult [

	^ self roll: lastRoll dm: lastDM

]

{ #category : 'accessing' }
RollTable >> max [

	^ table keys max
]

{ #category : 'accessing' }
RollTable >> min [

	^ table keys min
]

{ #category : 'roll' }
RollTable >> roll [

	| r dice |
	dice := DieRoller roller .
	r := dice roll: 2 d: 6.
	^ self roll: r

]

{ #category : 'roll' }
RollTable >> roll: aRoll [

	| dm |
	dm := self computeDM.
	^ self roll: aRoll dm: dm
]

{ #category : 'roll' }
RollTable >> roll: aRoll dm: dm [

	| result total |
	total := aRoll + dm.
	lastRoll := aRoll.
	lastDM := dm.

	total := (total max: self min) min: self max.
	result := table
		          at: total
		          ifAbsent: [ Error signal: 'Roll not found in table' ].

	result isBlock
		ifTrue: [ ^ result value ]
		ifFalse: [ ^ result ]
]

{ #category : 'roll' }
RollTable >> rollwithDM: dm [

	| r dice |
	dice := DieRoller roller.
	r := dice roll: 2 d: 6.

	^ self roll: r dm: dm
]
