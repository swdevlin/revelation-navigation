"
wbh 27

"
Class {
	#name : 'EccentricityTable',
	#superclass : 'RollTable',
	#instVars : [
		'stellarObject',
		'star',
		'solarSystem'
	],
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'as yet unclassified' }
EccentricityTable >> computeDM [

	| dm modifierMap |
	dm := super computeDM.
	modifierMap := Dictionary newFromPairs: {
			               (Star -> 2).
			               (Planetoid -> 1) }.

	dm := modifierMap at: stellarObject class ifAbsent: [ 0 ].
	star companion ifNotNil: [ dm := dm + 1 ].
	(stellarObject orbit < 1 and: solarSystem primary age > 1) ifTrue: [
		dm := dm - 1 ].

	^ dm
]

{ #category : 'initialization' }
EccentricityTable >> initialize [

	super initialize.

	table := Dictionary newFrom: {
			         (5 -> [ DieRoller roller floatBetween: 0.0 and: 0.005 ]).
			         (6 -> [ DieRoller roller floatBetween: 0.005 and: 0.035 ]).
			         (7 -> [ DieRoller roller floatBetween: 0.005 and: 0.035 ]).
			         (8 -> [ DieRoller roller floatBetween: 0.035 and: 0.095 ]).
			         (9 -> [ DieRoller roller floatBetween: 0.035 and: 0.095 ]).
			         (10 -> [ DieRoller roller floatBetween: 0.095 and: 0.35 ]).
			         (11 -> [ DieRoller roller floatBetween: 0.15 and: 0.65 ]).
			         (12 -> [ DieRoller roller floatBetween: 0.4 and: 0.9 ]) }
]

{ #category : 'roll' }
EccentricityTable >> rollFor: aStellarObject orbiting: aStar in: aSolarSystem [

	stellarObject := aStellarObject.
	star := aStar.
	solarSystem := aSolarSystem.

	^ ((self roll max: 0) min: 0.999) roundTo: 0.001
]
