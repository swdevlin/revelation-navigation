Class {
	#name : 'RevelationScanner',
	#superclass : 'SpPresenter',
	#instVars : [
		'result',
		'sectors',
		'sectorList',
		'systems',
		'systemList',
		'selectedSector'
	],
	#category : 'Revelation',
	#package : 'Revelation'
}

{ #category : 'initialization' }
RevelationScanner >> connectPresenters [

	sectorList whenSelectionChangedDo: [ :selectedItemMode |
		selectedSector := sectors at: selectedItemMode selectedIndex.
		self fetchSystems ]
]

{ #category : 'layout' }
RevelationScanner >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
				   add: sectorList;
				   add: systemList;
				   yourself);
		  add: result;
		  yourself
]

{ #category : 'initialization' }
RevelationScanner >> fetchSectors [

	| url jsonResponse s |
	url := 'http://radiofreewaba.net/deepnight/data/sectors'.
	jsonResponse := ZnClient new get: url.
	s := STON fromString: jsonResponse contents.
	sectors := (s collect: [ :sector | sector ]) sorted: [ :a :b |
		           (a at: 'name') asUppercase < (b at: 'name') asUppercase ]
	
]

{ #category : 'initialization' }
RevelationScanner >> fetchSystems [

	| url jsonResponse s |
	url := ZnUrl fromString:
		       'http://radiofreewaba.net/deepnight/data/stars'.
	url queryAt: #sx add: (selectedSector at: #x).
	url queryAt: #sy add: (selectedSector at: #y).

	jsonResponse := ZnClient new
		                queryAt: #sx add: (selectedSector at: #x);
		                queryAt: #sy add: (selectedSector at: #y);
		                get: url.
	s := STON fromString: jsonResponse contents.
	systems := (s collect: [ :sector | sector ]) sorted: [ :a :b |
		| ax ay bx by |
		ax := a at: 'x'.
		bx := b at: 'x'.
			ay := a at: 'y'.
		by := b at: 'y'.
		(ax = bx)
			           ifTrue: [ ay < by ]
			           ifFalse: [ ax < bx ] ].

	self updateSystemList
]

{ #category : 'initialization' }
RevelationScanner >> initialize [

	self fetchSectors.
	super initialize.
	selectedSector := nil.
]

{ #category : 'initialization' }
RevelationScanner >> initializePresenters [
| sectorNames |
	result := self newLabel.

	sectorList := self newList.
	sectorNames := sectors collect: [ :sector | sector at: 'name' ].
	sectorList items: sectorNames.

	systemList := self newList.
	systemList items: #().

	result label: 'Please give us your feedback'.


]

{ #category : 'initialization' }
RevelationScanner >> initializeWindow: aWindowPresenter [
  super initializeWindow: aWindowPresenter .
  aWindowPresenter title: 'Revelation Scanner';
initialExtent: 400@300.

]

{ #category : 'as yet unclassified' }
RevelationScanner >> updateSystemList [

	| hexNumber |
	hexNumber := [ :number |
	             number < 10
		             ifTrue: [ '0' , number asString ]
		             ifFalse: [ number asString ] ].
	
	systemList items: (systems collect: [ :system |
			 (hexNumber
				 value: (system at: #x)) , (hexNumber
				 value: (system at: #y)) ])
]
