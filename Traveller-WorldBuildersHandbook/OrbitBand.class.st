"
Helper class for orbit bands.

An orbit band includes a min and max
"
Class {
	#name : 'OrbitBand',
	#superclass : 'OrbitRange',
	#instVars : [
		'label'
	],
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'instance creation' }
OrbitBand class >> label: aSymbol from: min to: max [

	^ self new
		  label: aSymbol;
		  min: min;
		  max: max
]

{ #category : 'testing' }
OrbitBand >> includes: anOrbit [

	^ anOrbit >= min and: [ anOrbit < max ]
]

{ #category : 'accessing' }
OrbitBand >> label [

	^ label
]

{ #category : 'accessing' }
OrbitBand >> label: anObject [

	label := anObject
]

{ #category : 'accessing' }
OrbitBand >> random [

	^ (DieRoller roller floatBetween: min and: max) round: 3
]
