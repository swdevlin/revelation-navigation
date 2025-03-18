"
A sector of space in the Traveller RPG.
"
Class {
	#name : 'Sector',
	#superclass : 'Object',
	#instVars : [
		'id',
		'x',
		'y',
		'name',
		'abbreviation'
	],
	#category : 'Revelation',
	#package : 'Revelation'
}

{ #category : 'instance creation' }
Sector class >> newFromJSON: json [

	^ self new
		  id: (json at: 'id');
		  x: (json at: 'x');
		  y: (json at: 'y');
		  name: (json at: 'name');
		  abbreviation: (json at: 'abbreviation');
		  yourself
]

{ #category : 'accessing' }
Sector >> abbreviation [

	^ abbreviation
]

{ #category : 'accessing' }
Sector >> abbreviation: anObject [

	abbreviation := anObject
]

{ #category : 'accessing' }
Sector >> id [

	^ id
]

{ #category : 'accessing' }
Sector >> id: anObject [

	id := anObject
]

{ #category : 'accessing' }
Sector >> name [

	^ name
]

{ #category : 'accessing' }
Sector >> name: anObject [

	name := anObject
]

{ #category : 'printing' }
Sector >> printOn: aStream [

	aStream
		nextPutAll: self name;
		nextPutAll: ' (';
		nextPutAll: self x asString;
		nextPutAll: ',';
		nextPutAll: self y asString;
		nextPutAll: ')'
]

{ #category : 'accessing' }
Sector >> x [

	^ x
]

{ #category : 'accessing' }
Sector >> x: anObject [

	x := anObject
]

{ #category : 'accessing' }
Sector >> y [

	^ y
]

{ #category : 'accessing' }
Sector >> y: anObject [

	y := anObject
]
