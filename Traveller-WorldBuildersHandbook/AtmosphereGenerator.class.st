"
WBH: pg 78

Generate the atmosphere for a stellar body.
"
Class {
	#name : 'AtmosphereGenerator',
	#superclass : 'Object',
	#instVars : [
		'dice'
	],
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'as yet unclassified' }
AtmosphereGenerator >> adjustForRunawayGreenhouse: aPlanet [

	^ nil
]

{ #category : 'generators' }
AtmosphereGenerator >> assignAtmosphere: aPlanet [

	| hzcoOffset dm atmo roll |
	atmo := Atmosphere new.
	hzcoOffset := aPlanet hzcoOffset.

	"	hzcoOffset < -2.01 ifTrue: [ table := HotAtmosphere2Table ]."


	dm := 0.
	aPlanet gravity < 0.4 ifTrue: [ dm := dm - 2 ].
	(aPlanet gravity between: 0.4 and: 0.5) ifTrue: [ dm := dm - 1 ].

	roll := (dm + (dice roll: 2 d: 6) - 7 + aPlanet sizeCode max: 0)
		        min: 17.
	atmo code: roll.
	(#( 2 4 7 9 12 ) includes: roll) ifTrue: [ 
		TaintGenerator new assignTaint: atmo. ].

		aPlanet atmosphere: atmo.

	self adjustForRunawayGreenhouse: aPlanet.

]

{ #category : 'as yet unclassified' }
AtmosphereGenerator >> assignHot2Atmosphere: aPlanet [

	| hzcoOffset dm atmo roll |
	atmo := Atmosphere new.
	hzcoOffset := aPlanet hzcoOffset.

"	hzcoOffset < -2.01 ifTrue: [ table := HotAtmosphere2Table ]."
]

{ #category : 'as yet unclassified' }
AtmosphereGenerator >> atmosphereAlbedoModifer: code [

	| d |
	d := Dictionary newFrom: {
			     (0 -> [ 0 ]).
			     (1 -> [ (DieRoller roller roll: 2 d: 6) - 3 * 0.01 ]).
			     (2 -> [ (DieRoller roller roll: 2 d: 6) - 3 * 0.01 ]).
			     (3 -> [ (DieRoller roller roll: 2 d: 6) - 3 * 0.01 ]).
			     (4 -> [ (DieRoller roller roll: 2 d: 6) * 0.01 ]).
			     (5 -> [ (DieRoller roller roll: 2 d: 6) * 0.01 ]).
			     (6 -> [ (DieRoller roller roll: 2 d: 6) * 0.01 ]).
			     (7 -> [ (DieRoller roller roll: 2 d: 6) * 0.01 ]).
			     (8 -> [ (DieRoller roller roll: 2 d: 6) * 0.01 ]).
			     (9 -> [ (DieRoller roller roll: 2 d: 6) * 0.01 ]).
			     (10 -> [ (DieRoller roller roll: 2 d: 6) - 2 * 0.05 ]).
			     (11 -> [ (DieRoller roller roll: 2 d: 6) - 2 * 0.05 ]).
			     (12 -> [ (DieRoller roller roll: 2 d: 6) - 2 * 0.05 ]).
			     (13 -> [ (DieRoller roller roll: 2 d: 6) * 0.03 ]).
			     (14 -> [ (DieRoller roller roll: 2 d: 6) - 3 * 0.01 ]).
			     (15 -> [ (DieRoller roller roll: 2 d: 6) - 2 * 0.05 ]).
			     (16 -> [ (DieRoller roller roll: 2 d: 6) - 2 * 0.05 ]).
			     (17 -> [ (DieRoller roller roll: 2 d: 6) - 2 * 0.05 ]) }.

	^ d at: code
]

{ #category : 'as yet unclassified' }
AtmosphereGenerator >> calculateAlbedo: aPlanet [
	"WBH 110"

	| albedo |
	albedo := aPlanet density > 0.4
		          ifTrue: [ (dice roll: 2 d: 6) - 2 * 0.02 + 0.04 ]
		          ifFalse: [
			          aPlanet hzcoOffset < 2
				          ifTrue: [ (dice roll: 2 d: 6) - 3 * 0.05 + 0.2 ]
				          ifFalse: [ (dice roll: 2 d: 6) - 2 * 0.07 + 0.25 ] ].
	albedo := albedo
	          + (self atmosphereAlbedoModifer: aPlanet atmosphere code)
	          +
	          (self hydrographicsAlbedoModifier:
		           aPlanet hydrographics code).
	^ (albedo max: 0.02) min: 0.98
]

{ #category : 'as yet unclassified' }
AtmosphereGenerator >> calculateGreenhouseFactor: aPlanet [

	^ aPlanet atmosphere bar sqrt * 0.5
]

{ #category : 'as yet unclassified' }
AtmosphereGenerator >> hydrographicsAlbedoModifier: code [
	"WBH 110"

	(code between: 2 and: 5) ifTrue: [ ^ (dice roll: 2 d: 6) - 2 * 0.02 ].
	code >= 6 ifTrue: [ ^ (dice roll: 2 d: 6) - 4 * 0.03 ].
	^ 0
]

{ #category : 'initialization' }
AtmosphereGenerator >> initialize [

	super initialize.
	dice := DieRoller new
]
