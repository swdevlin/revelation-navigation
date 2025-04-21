"
An orbit range, from min to max. Used to track availableOrbits for a star.
"
Class {
	#name : 'OrbitRange',
	#superclass : 'Object',
	#instVars : [
		'min',
		'max'
	],
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'instance creation' }
OrbitRange class >> from: min to: max [

	^ self new
		  min: min;
		  max: max;
		  yourself
]

{ #category : 'comparing' }
OrbitRange >> = other [

	^ self class = other class and: [
		  self min = other min and: [ self max = other max ] ]
]

{ #category : 'comparing' }
OrbitRange >> hash [

	^ self min hash bitXor: self max hash
]

{ #category : 'testing' }
OrbitRange >> includes: anOrbit [

	^ anOrbit between: min and: max
]

{ #category : 'accessing' }
OrbitRange >> max [

	^ max
]

{ #category : 'accessing' }
OrbitRange >> max: anObject [

	max := anObject
]

{ #category : 'accessing' }
OrbitRange >> min [

	^ min
]

{ #category : 'accessing' }
OrbitRange >> min: anObject [

	min := anObject
]

{ #category : 'printing' }
OrbitRange >> printOn: aStream [

	aStream
		nextPutAll: 'OrbitRange(';
		print: self min;
		nextPutAll: ' .. ';
		print: self max;
		nextPut: $)
]

{ #category : 'accessing' }
OrbitRange >> size [

	^ max - min
]
