Class {
	#name : 'SolarSystem',
	#superclass : 'Object',
	#instVars : [
		'sector',
		'x',
		'y',
		'name',
		'primary'
	],
	#category : 'Traveller',
	#package : 'Traveller'
}

{ #category : 'as yet unclassified' }
SolarSystem >> generatePrimary [

	primary := Star generateNew
]

{ #category : 'accessing' }
SolarSystem >> name [

	^ name
]

{ #category : 'accessing' }
SolarSystem >> name: anObject [

	name := anObject
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

{ #category : 'accessing' }
SolarSystem >> x [

	^ x
]

{ #category : 'accessing' }
SolarSystem >> x: anObject [

	x := anObject
]

{ #category : 'accessing' }
SolarSystem >> y [

	^ y
]

{ #category : 'accessing' }
SolarSystem >> y: anObject [

	y := anObject
]
