"
System information for a Deepnight Revelation campaign.
"
Class {
	#name : 'RevelationScanner',
	#superclass : 'SpPresenter',
	#instVars : [
		'detail',
		'sectors',
		'sectorList',
		'systems',
		'systemList',
		'selectedSector',
		'revelationClient'
	],
	#category : 'Revelation',
	#package : 'Revelation'
}

{ #category : 'initialization' }
RevelationScanner >> connectPresenters [

	sectorList whenSelectionChangedDo: [ :selectedItemMode |
		| i |
		i := selectedItemMode selectedIndex.
		i > 0 ifTrue: [
			selectedSector := sectors at: i.
			self fetchSystems ] ].

	systemList whenSelectionChangedDo: [ :selectedItem |
		0 < selectedItem selectedIndex
			ifFalse: [ detail clearSystem ]
			ifTrue: [
			detail setSystem: (systems at: selectedItem selectedIndex) ] ]
]

{ #category : 'layout' }
RevelationScanner >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
				   add: sectorList;
				   add: systemList;
				   yourself);
		  add: detail height: 210;
		  yourself
]

{ #category : 'initialization' }
RevelationScanner >> fetchSectors [

	| sectorNames fetcher |
	fetcher := [
	           sectors := revelationClient sectors.
	           sectorNames := sectors collect: [ :sector |
		                          sector name ].
	           sectorList items: sectorNames ].

	fetcher fork
]

{ #category : 'initialization' }
RevelationScanner >> fetchSystems [

	| url jsonResponse s |
	url := ZnUrl fromString:
		       'https://radiofreewaba.net/deepnight/data/stars'.
	url queryAt: #sx add: (selectedSector at: 'x').
	url queryAt: #sy add: (selectedSector at: 'y').

	jsonResponse := ZnClient new
		                queryAt: #sx add: (selectedSector at: 'x');
		                queryAt: #sy add: (selectedSector at: 'y');
		                get: url.
	s := STON fromString: jsonResponse contents.
	systems := (s collect: [ :sector | sector ]) sorted: [ :a :b |
		           | ax ay bx by |
		           ax := a at: 'x'.
		           bx := b at: 'x'.
		           ay := a at: 'y'.
		           by := b at: 'y'.
		           ax = bx
			           ifTrue: [ ay < by ]
			           ifFalse: [ ax < bx ] ].

	self updateSystemList
]

{ #category : 'initialization' }
RevelationScanner >> initialize [

	revelationClient := RevelationClient new.
	sectors := OrderedCollection new.
	self fetchSectors.
	super initialize
]

{ #category : 'initialization' }
RevelationScanner >> initializePresenters [
| sectorNames |
	sectorList := self newList.
	sectorNames := sectors collect: [ :sector | sector at: 'name' ].
	sectorList items: sectorNames.

	systemList := self newList.
	systemList items: #().

	detail := self instantiate: SystemPresenter.


]

{ #category : 'initialization' }
RevelationScanner >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'Revelation Scanner';
		initialExtent: 400 @ 500;
		initialPosition: 1240 @ 30
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
