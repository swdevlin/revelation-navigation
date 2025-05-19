"
A terrestrial planet built with the Word Builder's Handbook rules.
"
Class {
	#name : 'WBHTerrestrialPlanet',
	#superclass : 'TerrestrialPlanet',
	#instVars : [
		'composition',
		'density',
		'gravity',
		'hydrographics',
		'atmosphere'
	],
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'accessing' }
WBHTerrestrialPlanet >> atmosphere [

	^ atmosphere
]

{ #category : 'accessing' }
WBHTerrestrialPlanet >> atmosphere: anObject [

	atmosphere := anObject
]

{ #category : 'accessing' }
WBHTerrestrialPlanet >> atmosphereCode [

	^ atmosphere code
]

{ #category : 'accessing' }
WBHTerrestrialPlanet >> atmosphereCode: code [

	^ atmosphere code: code
]

{ #category : 'accessing' }
WBHTerrestrialPlanet >> composition [

	^ composition
]

{ #category : 'accessing' }
WBHTerrestrialPlanet >> composition: anObject [

	composition := anObject
]

{ #category : 'accessing' }
WBHTerrestrialPlanet >> density [

	^ density
]

{ #category : 'accessing' }
WBHTerrestrialPlanet >> density: anObject [

	density := anObject
]

{ #category : 'accessing' }
WBHTerrestrialPlanet >> gravity [

	^ gravity
]

{ #category : 'accessing' }
WBHTerrestrialPlanet >> gravity: anObject [

	gravity := anObject
]

{ #category : 'accessing' }
WBHTerrestrialPlanet >> hydrographics [

	^ hydrographics
]

{ #category : 'accessing' }
WBHTerrestrialPlanet >> hydrographics: anObject [

	hydrographics := anObject
]

{ #category : 'accessing' }
WBHTerrestrialPlanet >> hydrographicsCode [

	^ hydrographics code
]

{ #category : 'accessing' }
WBHTerrestrialPlanet >> hydrographicsCode: code [

	^ hydrographics code: code
]

{ #category : 'as yet unclassified' }
WBHTerrestrialPlanet >> hzcoOffset [

	^ orbit - orbiting hzco
]

{ #category : 'initialization' }
WBHTerrestrialPlanet >> initialize [

	super initialize.
	hydrographics := Hydrographics new.
	atmosphere := Atmosphere new
]
