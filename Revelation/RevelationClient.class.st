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

	baseURL := 'https://radiofreewaba.net/deepnight/data/'.

]

{ #category : 'as yet unclassified' }
RevelationClient >> sectors [

	| url jsonResponse s |
	
	cachedSectors ifNil: [
		url := baseURL , 'sectors'.
		jsonResponse := ZnClient new get: url.
		s := STON fromString: jsonResponse contents.
		cachedSectors := (s collect: [ :sector | sector ]) sorted: [ :a :b |
			                 (a at: 'name') asUppercase
			                 < (b at: 'name') asUppercase ] ].
	^ cachedSectors
]
