"
Wrapper for the Revelation API.

End points are

route - return the route the revelation has taken
"
Class {
	#name : 'RevelationAPI',
	#superclass : 'Object',
	#classVars : [
		'url'
	],
	#category : 'Revelation-Objects',
	#package : 'Revelation',
	#tag : 'Objects'
}

{ #category : 'class initialization' }
RevelationAPI class >> initialize [

	url := 'http://radiofreewaba.net/deepnight/data'
]

{ #category : 'data' }
RevelationAPI class >> routes [

	| routeURL jsonResponse |
	routeURL := self url , '/route'.
	jsonResponse := ZnClient new get: routeURL.
	^ STON fromString: jsonResponse contents
]

{ #category : 'data' }
RevelationAPI class >> sectors [

	| sectorURL response json data |
	sectorURL := self url , '/sectors'.
	response := ZnClient new get: sectorURL.
	json := STON fromString: response contents.
	data := OrderedCollection new.
	json do: [ :each | data add: (Sector newFromJSON: each) ].
	
	^ data
]

{ #category : 'accessing' }
RevelationAPI class >> url [

	^ url ifNil: [ url := 'http://radiofreewaba.net/deepnight/data' ]
]

{ #category : 'accessing' }
RevelationAPI class >> url: newURL [

	url := newURL
]
