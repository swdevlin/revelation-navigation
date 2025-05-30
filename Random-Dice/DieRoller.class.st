"
A dice roller for games.

Get an instance of DieRoller via the roller message:

```language=pharo
myRoller := Dieroller roller.
```


[Rolistream Dice Parser](https://invent.kde.org/rolisteam/rolisteam-diceparser) is the inspiration for this dice roller. It uses the MesenneTwister algorithm included in this package.

Primary message are

**roll: N d: D**  -- roll N D sided dice, return the sum
**roll: N d: D k: K** -- roll N D sided dice, and return the sum of the highest K of them
"
Class {
	#name : 'DieRoller',
	#superclass : 'Object',
	#instVars : [
		'queue'
	],
	#classVars : [
		'rng'
	],
	#classInstVars : [
		'roller'
	],
	#category : 'Random-Dice',
	#package : 'Random-Dice'
}

{ #category : 'accessing' }
DieRoller class >> roller [

	roller ifNil: [ roller := self new ].
	^ roller
]

{ #category : 'as yet unclassified' }
DieRoller >> clearQueue [
  queue := Dictionary new

]

{ #category : 'as yet unclassified' }
DieRoller >> floatBetween: lowerBound and: higherBound [

	^ rng nextBetween: lowerBound and: higherBound
]

{ #category : 'initialization' }
DieRoller >> initialize [

	rng := Random new.
	queue := Dictionary new.
]

{ #category : 'as yet unclassified' }
DieRoller >> integerBetween: lowerBound and: higherBound [

	^ rng nextIntegerBetween: lowerBound and: higherBound

]

{ #category : 'accessing' }
DieRoller >> queue [

	^ queue
]

{ #category : 'as yet unclassified' }
DieRoller >> queueD: die value: value [

	(queue at: die ifAbsentPut: [ OrderedCollection new ]) add: value
]

{ #category : 'as yet unclassified' }
DieRoller >> randomInt: die [

	| dQueue |
	queue
		at: die
		ifPresent: [
			dQueue := queue at: die.
			dQueue isEmpty
				ifTrue: [ ^ rng nextInteger: die ]
				ifFalse: [ ^ dQueue removeAt: 1 ] ]
		ifAbsent: [ ^ rng nextInteger: die ]
]

{ #category : 'as yet unclassified' }
DieRoller >> roll: count d: sides [
	"Roll dice and return the total"

	^ (1 to: count)
		  inject: 0
		  into: [ :total :each | total + (self randomInt: sides) ]
]

{ #category : 'as yet unclassified' }
DieRoller >> roll: diceCount d: sides k: toKeep [
	"Roll dice and return the top keep rolls"

	| rolls |
	rolls := (1 to: diceCount) collect: [ :each |
		         self randomInt: sides].
	^ (rolls sorted reverse first: toKeep) sum
]

{ #category : 'as yet unclassified' }
DieRoller >> roll: diceCount d: sides keep: toKeep [
	"Roll dice and return the top keep rolls"

	| rolls |
	rolls := (1 to: diceCount) collect: [ :each |
		         self randomInt: sides ].
	^ (rolls sorted reverse first: toKeep) sum
]

{ #category : 'as yet unclassified' }
DieRoller >> roll: diceCount d: sides lower: toKeep [
	"Roll dice and return the bottom keep rolls"

	| rolls |
	rolls := (1 to: diceCount) collect: [ :each |
		         self randomInt: sides ].
	^ (rolls sorted first: toKeep) sum
]
