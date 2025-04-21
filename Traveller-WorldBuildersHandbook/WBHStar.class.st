"
The World Builder's Handbook implementation of a star.
"
Class {
	#name : 'WBHStar',
	#superclass : 'Star',
	#instVars : [
		'mao',
		'baselineNumber',
		'hzco',
		'spread',
		'baselineOrbitNumber',
		'availableOrbits'
	],
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'accessing' }
WBHStar class >> brownDwarfLuminosity [

	^ brownDwarfLuminosity
]

{ #category : 'accessing' }
WBHStar class >> brownDwarfMass [

	^ brownDwarfMass
]

{ #category : 'accessing' }
WBHStar class >> brownDwarfTemperature [

	^ brownDwarfTemperature
]

{ #category : 'as yet unclassified' }
WBHStar class >> brownDwarfTypeAndSubtypeFromMass: mass [

    | type subtype lower upper stepSize lowerValue upperValue massVector epsilon |

    massVector := self brownDwarfMass.

    "Check if mass is larger than or equal to the largest known mass"
    mass >= massVector first ifTrue: [
        ^ { self brownDwarfTypes first. 0 } ].

    epsilon := 1.0e-10.

    "Find upper and lower bounds"
    upper := massVector detectIndex: [ :value | mass > value ] ifNone: [ 7 ].
    lower := upper - 1.

    "Check if upper exceeds the known data range"
    upper > massVector size
        ifTrue: [
            type := self brownDwarfTypes last.
            subtype := ((0.013 - mass) / 0.0024 - epsilon) floor + 6.
            ^ { type. subtype } ].

    "Within known mass range"
    type := self brownDwarfTypes at: (lower / 2) ceiling.
    lowerValue := massVector at: lower.

    "Determine subtype"
    lowerValue = mass
        ifTrue: [ subtype := 0 ]
        ifFalse: [
            upperValue := massVector at: upper.
            stepSize := (lowerValue - upperValue) / 5.
            subtype := ((lowerValue - mass) / stepSize - epsilon) floor + 1 ].

    "Adjust subtype for even-indexed mass values"
    lower even ifTrue: [ subtype := subtype + 5 ].

    ^ { type. subtype }

]

{ #category : 'accessing' }
WBHStar class >> brownDwarfTypes [

	^ brownDwarfTypes
]

{ #category : 'adding' }
WBHStar >> addAvailableOrbitsFrom: minOrbit to: maxOrbit [

	availableOrbits add: (minOrbit to: maxOrbit)
]

{ #category : 'adding' }
WBHStar >> addStellarBody: aStellarBody [

	aStellarBody ifNotNil: [
		aStellarBody orbit: self nextOrbit.
		aStellarBody orbiting: self.
		stellarBodies add: aStellarBody ].
	self gotoNextOrbit
]

{ #category : 'accessing' }
WBHStar >> availableOrbits [

	^ availableOrbits
]

{ #category : 'accessing' }
WBHStar >> baselineNumber [

	^ baselineNumber
]

{ #category : 'accessing' }
WBHStar >> baselineNumber: anObject [

	baselineNumber := anObject
]

{ #category : 'accessing' }
WBHStar >> baselineOrbitNumber [

	^ baselineOrbitNumber
]

{ #category : 'accessing' }
WBHStar >> baselineOrbitNumber: anObject [

	baselineOrbitNumber := anObject
]

{ #category : 'as yet unclassified' }
WBHStar >> clearAvailableOrbits [

	availableOrbits := OrderedCollection new
]

{ #category : 'as yet unclassified' }
WBHStar >> gotoNextOrbit [

	| currentBand f l |
	currentBand := availableOrbits at: 1.
	f := currentBand first.
	l := currentBand stop.

	(currentBand rangeIncludes: f + spread)
		ifTrue: [ currentBand setFrom: f + spread to: l by: spread ]
		ifFalse: [ availableOrbits removeAt: 1 ]
]

{ #category : 'accessing' }
WBHStar >> hzco [

	^ hzco
]

{ #category : 'accessing' }
WBHStar >> hzco: anObject [

	hzco := anObject
]

{ #category : 'initialization' }
WBHStar >> initialize [

	super initialize.
	availableOrbits := OrderedCollection new
]

{ #category : 'accessing' }
WBHStar >> mao [

	^ mao
]

{ #category : 'accessing' }
WBHStar >> mao: anObject [

	mao := anObject
]

{ #category : 'as yet unclassified' }
WBHStar >> nextOrbit [

	^ (availableOrbits at: 1) first
]

{ #category : 'accessing' }
WBHStar >> spread [

	^ spread
]

{ #category : 'accessing' }
WBHStar >> spread: anObject [

	spread := anObject
]

{ #category : 'accessing' }
WBHStar >> totalAvailableOrbits [

	^ availableOrbits inject: 0 into: [ :sum :range | sum + range size ]
]
