"
WBH: Page 99

Generate hydrographic characteristics for the world.
"
Class {
	#name : 'HydrographicsGenerator',
	#superclass : 'Object',
	#instVars : [
		'dice'
	],
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'as yet unclassified' }
HydrographicsGenerator >> assignHydrosphere: aPlanet [

	aPlanet size < 2
		ifTrue: [
			aPlanet hydrographicsCode: 0.
			aPlanet hydrographics percent: 0.
			aPlanet hydrographics distribution: 10 ]
		ifFalse: [
			| dm code |
			dm := self calculateDM: aPlanet.
			code := ((dice roll: 2 d: 6) + aPlanet atmosphereCode + dm max: 0)
				        min: 10.
			code = 0
				ifTrue: [ aPlanet hydrographics percent: (dice randomInt: 6 - 1) ]
				ifFalse: [
					code = 10
						ifTrue: [
						aPlanet hydrographics percent: 95 + (dice randomInt: 5) ]
						ifFalse: [
						aPlanet hydrographics percent:
							code * 10 - 5 + (dice randomInt: 10) ] ].
			aPlanet hydrographics distribution: (dice roll: 2 d: 6) - 2.
			aPlanet hydrographicsCode: code ]
]

{ #category : 'as yet unclassified' }
HydrographicsGenerator >> assignLiquid: aPlanet [

	| t |
	aPlanet hydrographics percent > 0 ifFalse: [ ^ self ].
	t := aPlanet temperature.
	(t between: 274.14 and: 373.15)
		ifTrue: [ aPlanet hydrographics liquid: 'Water' ]
		ifFalse: [
		aPlanet hydrographics liquid: (ExoticLiquid randomLiquidAt: t) name ]
]

{ #category : 'as yet unclassified' }
HydrographicsGenerator >> calculateDM: aPlanet [

	| dm code temp |
	code := aPlanet atmosphereCode.
	temp := aPlanet temperature.
	dm := 0.
	(code < 2 or: code > 9) ifTrue: [ dm := dm - 4 ].
	temp > 373.15
		ifTrue: [ dm := dm - 6 ]
		ifFalse: [ temp > 323.15 ifTrue: [ dm := dm - 2 ] ].

	^ dm
]

{ #category : 'initialization' }
HydrographicsGenerator >> initialize [

	super initialize.
	dice := DieRoller roller
]
