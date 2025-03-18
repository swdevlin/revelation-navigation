"
Client for the Revelation REST API.
"
Class {
	#name : 'RevelationClient',
	#superclass : 'Object',
	#instVars : [
		'baseURL',
		'cachedSectors'
	],
	#category : 'Revelation',
	#package : 'Revelation'
}

{ #category : 'initialization' }
RevelationClient >> initialize [

	baseURL := 'https://radiofreewaba.net/deepnight/data'.

]

{ #category : 'data' }
RevelationClient >> route [

	| url jsonResponse routeJSON r |
	url := baseURL , '/route'.
	jsonResponse := ZnClient new get: url.
	routeJSON := STON fromString: jsonResponse contents.

	r := OrderedCollection new.
	routeJSON do: [ :each |
		| s |
		s := self sectorFromX: (each at: #sector_x) y: (each at: #sector_y).
		each at: 'sector' put: s.

		r add: (Route newFromJSON: each) ].
	^ r
]

{ #category : 'data' }
RevelationClient >> sectorFromX: x y: y [

	^ self sectors
		  detect: [ :sector | sector x = x and: [ sector y = y ] ]
		  ifNone: [ nil ]
]

{ #category : 'data' }
RevelationClient >> sectors [

	| url jsonResponse s |
	
	cachedSectors ifNil: [
		url := baseURL , '/sectors'.
		jsonResponse := ZnClient new get: url.
		s := STON fromString: jsonResponse contents.
		cachedSectors := (s collect: [ :sector | Sector newFromJSON: sector ]) sorted: [ :a :b |
			                 (a name) asUppercase
			                 < (b name) asUppercase ] ].
	^ cachedSectors
]
