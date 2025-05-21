"
wbh 78
"
Class {
	#name : 'Atmosphere',
	#superclass : 'Object',
	#instVars : [
		'code',
		'taint',
		'characteristic',
		'bar',
		'gasType',
		'density',
		'hazardCode',
		'exotic'
	],
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'accessing' }
Atmosphere >> bar [

	^ bar
]

{ #category : 'accessing' }
Atmosphere >> bar: anObject [

	bar := anObject
]

{ #category : 'accessing' }
Atmosphere >> characteristic [

	^ characteristic
]

{ #category : 'accessing' }
Atmosphere >> characteristic: anObject [

	characteristic := anObject
]

{ #category : 'accessing' }
Atmosphere >> code [

	^ code
]

{ #category : 'accessing' }
Atmosphere >> code: anObject [

	code := anObject
]

{ #category : 'accessing' }
Atmosphere >> density [

	^ density
]

{ #category : 'accessing' }
Atmosphere >> density: anObject [

	density := anObject
]

{ #category : 'accessing' }
Atmosphere >> exotic [

	^ exotic
]

{ #category : 'accessing' }
Atmosphere >> exotic: anObject [

	exotic := anObject
]

{ #category : 'accessing' }
Atmosphere >> gasType [

	^ gasType
]

{ #category : 'accessing' }
Atmosphere >> gasType: anObject [

	gasType := anObject
]

{ #category : 'accessing' }
Atmosphere >> hazardCode [

	^ hazardCode
]

{ #category : 'accessing' }
Atmosphere >> hazardCode: anObject [

	hazardCode := anObject
]

{ #category : 'initialization' }
Atmosphere >> initialize [

	super initialize.
	code := nil.
	taint := AtmosphereTaint new.
	characteristic := ''.
	bar := 0.
	density := 7.
	exotic := false
]

{ #category : 'accessing' }
Atmosphere >> taint [

	^ taint
]

{ #category : 'accessing' }
Atmosphere >> taint: anObject [

	taint := anObject
]
