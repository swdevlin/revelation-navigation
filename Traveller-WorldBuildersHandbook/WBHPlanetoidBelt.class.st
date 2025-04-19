"
World Builder's Handbook version of a planetoid belt.

Build rules need to know what is adjacent to the planetoid belt. Use the developPlanetoidBelt message for the WorldBuildersHandbook class to flesh out the planetoid belt.
"
Class {
	#name : 'WBHPlanetoidBelt',
	#superclass : 'PlanetoidBelt',
	#instVars : [
		'span',
		'sPercentage',
		'mPercentage',
		'cPercentage',
		'bulk',
		'resourceRating',
		'size1Bodies',
		'sizeSBodies'
	],
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'accessing' }
WBHPlanetoidBelt >> bulk [

	^ bulk
]

{ #category : 'accessing' }
WBHPlanetoidBelt >> bulk: anObject [

	bulk := anObject
]

{ #category : 'accessing' }
WBHPlanetoidBelt >> cPercentage [

	^ cPercentage
]

{ #category : 'accessing' }
WBHPlanetoidBelt >> cPercentage: anObject [

	cPercentage := anObject
]

{ #category : 'accessing' }
WBHPlanetoidBelt >> mPercentage [

	^ mPercentage
]

{ #category : 'accessing' }
WBHPlanetoidBelt >> mPercentage: anObject [

	mPercentage := anObject
]

{ #category : 'accessing' }
WBHPlanetoidBelt >> oPercentage [

	^ 100 - mPercentage - sPercentage - cPercentage
]

{ #category : 'accessing' }
WBHPlanetoidBelt >> resourceRating [

	^ resourceRating
]

{ #category : 'accessing' }
WBHPlanetoidBelt >> resourceRating: anObject [

	resourceRating := anObject
]

{ #category : 'accessing' }
WBHPlanetoidBelt >> sPercentage [

	^ sPercentage
]

{ #category : 'accessing' }
WBHPlanetoidBelt >> sPercentage: anObject [

	sPercentage := anObject
]

{ #category : 'accessing' }
WBHPlanetoidBelt >> size1Bodies [

	^ size1Bodies
]

{ #category : 'accessing' }
WBHPlanetoidBelt >> size1Bodies: anObject [

	size1Bodies := anObject
]

{ #category : 'accessing' }
WBHPlanetoidBelt >> sizeSBodies [

	^ sizeSBodies
]

{ #category : 'accessing' }
WBHPlanetoidBelt >> sizeSBodies: anObject [

	sizeSBodies := anObject
]

{ #category : 'accessing' }
WBHPlanetoidBelt >> span [

	^ span
]

{ #category : 'accessing' }
WBHPlanetoidBelt >> span: anObject [

	span := anObject
]
