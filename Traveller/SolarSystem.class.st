"
Solar system has a primary star.
"
Class {
	#name : 'SolarSystem',
	#superclass : 'Object',
	#instVars : [
		'sector',
		'coordinates',
		'name',
		'primary'
	],
	#category : 'Traveller',
	#package : 'Traveller'
}

{ #category : 'adding' }
SolarSystem >> addStar: star [

	self primary addStar: star
]

{ #category : 'accessing' }
SolarSystem >> coordinates [

	^ coordinates
]

{ #category : 'accessing' }
SolarSystem >> coordinates: anObject [

	coordinates := anObject
]

{ #category : 'accessing' }
SolarSystem >> name [

	^ name
]

{ #category : 'accessing' }
SolarSystem >> name: anObject [

	name := anObject
]

{ #category : 'as yet unclassified' }
SolarSystem >> postStellarCount [

	| c |
	c := primary isPostStellar
		     ifTrue: [ 1 ]
		     ifFalse: [ 0 ].
	^ c + (primary stellarBodies count: [ :obj |
		   (obj isKindOf: Star) and: obj isPostStellar ])
]

{ #category : 'accessing' }
SolarSystem >> primary [

	^ primary
]

{ #category : 'accessing' }
SolarSystem >> primary: anObject [

	primary := anObject
]

{ #category : 'accessing' }
SolarSystem >> sector [

	^ sector
]

{ #category : 'accessing' }
SolarSystem >> sector: anObject [

	sector := anObject
]

{ #category : 'as yet unclassified' }
SolarSystem >> starCount [

	^ 1 + (primary stellarBodies count: [ :obj | obj isKindOf: Star ])
]
