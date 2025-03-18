"
Display the route for the Deepnight Revelation journey
"
Class {
	#name : 'RouteTracker',
	#superclass : 'SpPresenter',
	#instVars : [
		'stops',
		'systemList',
		'yearInput',
		'dayInput',
		'route',
		'revelationClient'
	],
	#category : 'Revelation',
	#package : 'Revelation'
}

{ #category : 'adding' }
RouteTracker >> addStop [

	| presenter dialog url client data response |
	presenter := RouteEntryPresenter new.
	dialog := presenter openModal.
	dialog isOk ifFalse: [ ^ self ].

	url := ZnUrl fromString:
		       'https://radiofreewaba.net/deepnight/data/route'.

	data := NeoJSONWriter toString: {
			        (#sector_x -> presenter sectorX).
			        (#sector_y -> presenter sectorY).
			        (#year -> presenter year).
			        (#day -> presenter day).
			        (#ship_id -> 1).
			        (#hex_x -> presenter hexX).
			        (#hex_y -> presenter hexY) } asDictionary.

	client := ZnClient new.
	client
		beOneShot;
		url: url;
		entity: (ZnEntity with: data type: ZnMimeType applicationJson);
		post.

	response := client execute.

	self fetchRoute
]

{ #category : 'layout' }
RouteTracker >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newTopToBottom 
				   add: systemList;
				   yourself);
		  yourself
]

{ #category : 'initialization' }
RouteTracker >> fetchRoute [

	| routeList fetcher url jsonResponse |
	fetcher := [
	           url := 'http://radiofreewaba.net/deepnight/data/route'.
	           jsonResponse := ZnClient new get: url.
	           route := STON fromString: jsonResponse contents.
	           route := route reversed.
	           routeList := route collect: [ :entry |
		                        RouteEntry new
			                        year: (entry at: #year);
			                        day: (entry at: #day);
			                        sectorName: (entry at: #sector_name);
			                        solarSystemName: (entry at: #solar_system_name);
			                        hexAddress:
				                        ((entry at: #hex_x)
					                         printPaddedWith: $0
					                         to: 2)
				                        ,
					                        ((entry at: #hex_y)
						                         printPaddedWith: $0
						                         to: 2);
			                        yourself ].
	           systemList items: routeList ].

	fetcher fork
]

{ #category : 'initialization' }
RouteTracker >> initialize [
   route := OrderedCollection new.
   revelationClient := RevelationClient new.
	self fetchRoute.
	super initialize.

]

{ #category : 'initialization' }
RouteTracker >> initializePresenters [

	systemList := self newTable
		              beResizable;
		              addColumn:
			              (SpStringTableColumn title: 'Year' evaluated: #year);
		              addColumn:
			              (SpStringTableColumn title: 'Day' evaluated: #day);
		              addColumn:
			              (SpStringTableColumn
				               title: 'Sector'
				               evaluated: #sectorName);
		              addColumn:
			              (SpStringTableColumn
				               title: 'System'
				               evaluated: #solarSystemName);
		              addColumn:
			              (SpStringTableColumn
				               title: 'Coordinates'
				               evaluated: #hexAddress);
		              yourself
]

{ #category : 'initialization' }
RouteTracker >> initializeWindow: aWindowPresenter [

	| refreshButton addButton deleteButton toolbar |
	"	super initializeWindow: aWindowPresenter."
	addButton := self newToolbarButton
		             label: 'Add stop';
		             icon: (self iconNamed: #smallAdd);
		             action: [ self addStop ];
		             yourself.
	refreshButton := self newToolbarButton
		                 label: 'Refresh';
		                 icon: (self iconNamed: #refresh);
		                 action: [ self fetchRoute ];
		                 yourself.
	deleteButton := self newToolbarButton
		                label: 'Delete';
		                icon: (self iconNamed: #smallDelete);
		                action: [ self fetchRoute ];
		                yourself.
	toolbar := self newToolbar
		           add: refreshButton;
		           add: addButton;
		           add: deleteButton;
		           yourself.
	aWindowPresenter
		title: 'Route Tracker';
		initialExtent: 400 @ 500;
		initialPosition: 1240 @ 530;
		toolbar: toolbar
]
