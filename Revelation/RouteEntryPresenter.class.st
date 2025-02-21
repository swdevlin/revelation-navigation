"
Add a route stop
"
Class {
	#name : 'RouteEntryPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'yearInput',
		'dayInput',
		'sectorInput',
		'sectors',
		'selectedSector',
		'hexAddressInput'
	],
	#category : 'Revelation',
	#package : 'Revelation'
}

{ #category : 'initialization' }
RouteEntryPresenter >> connectPresenters [

	sectorInput whenSelectionChangedDo: [ :selectedItem |
		| i |
		i := selectedItem selectedIndex.
		i > 0 ifTrue: [
			selectedSector := sectors at: i.
			 ] ].

]

{ #category : 'accessing' }
RouteEntryPresenter >> day [

	^ dayInput number
]

{ #category : 'layout' }
RouteEntryPresenter >> defaultLayout [

	^ SpGridLayout build: [ :builder |
		  builder
			  beColumnNotHomogeneous;
			  column: 2 expand: true;
			  add: 'Year';
			  add: yearInput;
			  nextRow;
			  add: 'Day';
			  add: dayInput;
			  nextRow;
			  add: 'Sector';
			  add: sectorInput;
			  nextRow;
			  add: 'System';
			  add: hexAddressInput;
			  nextRow ]
]

{ #category : 'initialization' }
RouteEntryPresenter >> fetchSectors [

	| sectorNames fetcher url jsonResponse s |
	fetcher := [
	           url := 'http://radiofreewaba.net/deepnight/data/sectors'.
	           jsonResponse := ZnClient new get: url.
	           s := STON fromString: jsonResponse contents.
	           sectors := (s collect: [ :sector | sector ]) sorted: [ :a :b |
		                      (a at: 'name') asUppercase
		                      < (b at: 'name') asUppercase ].
	           sectorNames := sectors collect: [ :sector |
		                          sector at: 'name' ].
	           sectorInput items: sectorNames ].

	fetcher fork
]

{ #category : 'accessing' }
RouteEntryPresenter >> hexAddress [

  ^ hexAddressInput text
]

{ #category : 'accessing' }
RouteEntryPresenter >> hexX [

	^ (hexAddressInput text first: 2) asInteger
]

{ #category : 'accessing' }
RouteEntryPresenter >> hexY [

	^ (hexAddressInput text last: 2) asInteger
]

{ #category : 'initialization' }
RouteEntryPresenter >> initialize [

	sectors := OrderedCollection new.
	self fetchSectors.
	super initialize
]

{ #category : 'initialization' }
RouteEntryPresenter >> initializeDialogWindow: aDialogPresenter [

	aDialogPresenter title: 'Add Route Entry'.

	aDialogPresenter centered.

	aDialogPresenter
		addButton: 'Cancel' do: [ :button | button close ];
		addButton: 'Save' do: [ :button |
			button
				beOk;
				close ]
]

{ #category : 'initialization' }
RouteEntryPresenter >> initializePresenters [

	yearInput := self newNumberInput.
	dayInput := self newNumberInput rangeMinimum: 1 maximum: 365.
	sectorInput := self newDropList.
	hexAddressInput := self newTextInput 
]

{ #category : 'initialization' }
RouteEntryPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: 'Route Entry'
]

{ #category : 'accessing' }
RouteEntryPresenter >> sector [

	^ selectedSector at: #id
]

{ #category : 'accessing' }
RouteEntryPresenter >> sectorX [

	^ selectedSector at: #x
]

{ #category : 'accessing' }
RouteEntryPresenter >> sectorY [

	^ selectedSector at: #y
]

{ #category : 'accessing' }
RouteEntryPresenter >> year [

	^ yearInput number
]
