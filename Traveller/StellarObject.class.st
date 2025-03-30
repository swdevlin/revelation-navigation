"
Core definition of a stellar object. 
"
Class {
	#name : 'StellarObject',
	#superclass : 'Object',
	#instVars : [
		'orbitPosition',
		'inclination',
		'eccentricity',
		'effectiveHZCODeviation',
		'orbit',
		'diameter',
		'name',
		'period',
		'temperature',
		'mass',
		'orbiting'
	],
	#category : 'Traveller',
	#package : 'Traveller'
}

{ #category : 'accessing' }
StellarObject >> diameter [

	^ diameter
]

{ #category : 'accessing' }
StellarObject >> diameter: anObject [

	diameter := anObject
]

{ #category : 'accessing' }
StellarObject >> eccentricity [

	^ eccentricity
]

{ #category : 'accessing' }
StellarObject >> eccentricity: anObject [

	eccentricity := anObject
]

{ #category : 'accessing' }
StellarObject >> effectiveHZCODeviation [

	^ effectiveHZCODeviation
]

{ #category : 'accessing' }
StellarObject >> effectiveHZCODeviation: anObject [

	effectiveHZCODeviation := anObject
]

{ #category : 'accessing' }
StellarObject >> inclination [

	^ inclination
]

{ #category : 'accessing' }
StellarObject >> inclination: anObject [

	inclination := anObject
]

{ #category : 'accessing' }
StellarObject >> mass [

	^ mass
]

{ #category : 'accessing' }
StellarObject >> mass: anObject [

	mass := anObject
]

{ #category : 'accessing' }
StellarObject >> name [

	^ name
]

{ #category : 'accessing' }
StellarObject >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
StellarObject >> orbit [

	^ orbit
]

{ #category : 'accessing' }
StellarObject >> orbit: anObject [

	orbit := anObject
]

{ #category : 'accessing' }
StellarObject >> orbitPosition [

	^ orbitPosition
]

{ #category : 'accessing' }
StellarObject >> orbitPosition: anObject [

	orbitPosition := anObject
]

{ #category : 'accessing' }
StellarObject >> orbiting [

	^ orbiting
]

{ #category : 'accessing' }
StellarObject >> orbiting: anObject [

	orbiting := anObject
]

{ #category : 'accessing' }
StellarObject >> period [

	^ period
]

{ #category : 'accessing' }
StellarObject >> period: anObject [

	period := anObject
]

{ #category : 'accessing' }
StellarObject >> temperature [

	^ temperature
]

{ #category : 'accessing' }
StellarObject >> temperature: anObject [

	temperature := anObject
]
