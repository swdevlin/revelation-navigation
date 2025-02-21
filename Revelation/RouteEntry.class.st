"
Route entry
"
Class {
	#name : 'RouteEntry',
	#superclass : 'Object',
	#instVars : [
		'year',
		'day',
		'sectorName',
		'solarSystemName',
		'hexAddress'
	],
	#category : 'Revelation',
	#package : 'Revelation'
}

{ #category : 'accessing' }
RouteEntry >> day [

	^ day
]

{ #category : 'accessing' }
RouteEntry >> day: anObject [

	day := anObject
]

{ #category : 'accessing' }
RouteEntry >> hexAddress [

	^ hexAddress
]

{ #category : 'accessing' }
RouteEntry >> hexAddress: anObject [

	hexAddress := anObject
]

{ #category : 'accessing' }
RouteEntry >> sectorName [

	^ sectorName
]

{ #category : 'accessing' }
RouteEntry >> sectorName: anObject [

	sectorName := anObject
]

{ #category : 'accessing' }
RouteEntry >> solarSystemName [

	^ solarSystemName
]

{ #category : 'accessing' }
RouteEntry >> solarSystemName: anObject [

	solarSystemName := anObject
]

{ #category : 'accessing' }
RouteEntry >> year [

	^ year
]

{ #category : 'accessing' }
RouteEntry >> year: anObject [

	year := anObject
]
