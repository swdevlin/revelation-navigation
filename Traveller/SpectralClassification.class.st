"
Spectral class
"
Class {
	#name : 'SpectralClassification',
	#superclass : 'Object',
	#instVars : [
		'spectralType',
		'subtype',
		'spectralClass'
	],
	#category : 'Traveller',
	#package : 'Traveller'
}

{ #category : 'accessing' }
SpectralClassification >> spectralClass [

	^ spectralClass
]

{ #category : 'accessing' }
SpectralClassification >> spectralClass: anObject [

	spectralClass := anObject
]

{ #category : 'accessing' }
SpectralClassification >> spectralType [

	^ spectralType
]

{ #category : 'accessing' }
SpectralClassification >> spectralType: anObject [

	spectralType := anObject
]

{ #category : 'accessing' }
SpectralClassification >> subtype [

	^ subtype
]

{ #category : 'accessing' }
SpectralClassification >> subtype: anObject [

	subtype := anObject
]
