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

{ #category : 'formatting' }
WBHPlanetoidBelt >> formatPct: aNumber [

	| s |
	s := aNumber printString.
	^ s size = 1
		  ifTrue: [ '0' , s ]
		  ifFalse: [ s ]
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

{ #category : 'printing' }
WBHPlanetoidBelt >> printString [

	^ self profile
]

{ #category : 'accessing' }
WBHPlanetoidBelt >> profile [
	"WBH 74"

	^ String streamContents: [ :str |
		  str
			  nextPutAll: span printString;
			  nextPut: $-;
			  nextPutAll: (self formatPct: mPercentage);
			  nextPut: $.;
			  nextPutAll: (self formatPct: sPercentage);
			  nextPut: $.;
			  nextPutAll: (self formatPct: cPercentage);
			  nextPut: $.;
			  nextPutAll: (self formatPct: self oPercentage);
			  nextPut: $-;
			  nextPutAll: self bulk printString;
			  nextPut: $-;
			  nextPutAll: self resourceRating printString;
			  nextPut: $-;
			  nextPutAll: size1Bodies printString;
			  nextPut: $-;
			  nextPutAll: sizeSBodies printString ]
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
