"
A stop that the Revelation has made on its journey.
"
Class {
	#name : 'Route',
	#superclass : 'Object',
	#instVars : [
		'id',
		'sector',
		'shipId',
		'day',
		'year',
		'hexX',
		'hexY',
		'solarSystemName'
	],
	#category : 'RevelationClient',
	#package : 'RevelationClient'
}

{ #category : 'instance creation' }
Route class >> newFromJSON: json [
	^ self new
		  day: (json at: 'day');
		  year: (json at: 'year');
		  hexX: (json at: 'hex_x');
		  hexY: (json at: 'hex_y');
		  shipId: (json at: 'ship_id');
		  solarSystemName: (json at: 'solar_system_name');
		  sector: (json at: 'sector');
		  yourself
]

{ #category : 'accessing' }
Route >> day [

	^ day
]

{ #category : 'accessing' }
Route >> day: anObject [

	day := anObject
]

{ #category : 'accessing' }
Route >> hexX [

	^ hexX
]

{ #category : 'accessing' }
Route >> hexX: anObject [

	hexX := anObject
]

{ #category : 'accessing' }
Route >> hexY [

	^ hexY
]

{ #category : 'accessing' }
Route >> hexY: anObject [

	hexY := anObject
]

{ #category : 'accessing' }
Route >> id [

	^ id
]

{ #category : 'accessing' }
Route >> id: anObject [

	id := anObject
]

{ #category : 'printing' }
Route >> printOn: aStream [

	aStream
		nextPutAll: self year asString;
		nextPutAll: '-';
		nextPutAll: (self day asString padLeftTo: 3 with: $0);
		nextPutAll: ' ';
		nextPutAll: self sector name;
		nextPutAll: ' ';
		nextPutAll: (self hexX asString padLeftTo: 2 with: $0);
		nextPutAll: (self hexY asString padLeftTo: 2 with: $0)
]

{ #category : 'accessing' }
Route >> sector [

	^ sector
]

{ #category : 'accessing' }
Route >> sector: anObject [

	sector := anObject
]

{ #category : 'accessing' }
Route >> shipId [

	^ shipId
]

{ #category : 'accessing' }
Route >> shipId: anObject [

	shipId := anObject
]

{ #category : 'accessing' }
Route >> solarSystemName [

	^ solarSystemName
]

{ #category : 'accessing' }
Route >> solarSystemName: anObject [

	solarSystemName := anObject
]

{ #category : 'accessing' }
Route >> year [

	^ year
]

{ #category : 'accessing' }
Route >> year: anObject [

	year := anObject
]
