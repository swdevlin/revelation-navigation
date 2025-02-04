Class {
	#name : 'RevelationScanner',
	#superclass : 'SpPresenter',
	#instVars : [
		'buttonHappy',
		'buttonNeutral',
		'buttonBad',
		'result',
		'sectors',
		'sectorList'
	],
	#category : 'Revelation',
	#package : 'Revelation'
}

{ #category : 'initialization' }
RevelationScanner >> connectPresenters [

	sectorList whenSelectionChangedDo: [ :selectedItemMode |
		| i sector |
		selectedItemMode inspect.
		i := selectedItemMode selectedIndex.
		sector := sectors at: i.
		sector inspect ]
]

{ #category : 'layout' }
RevelationScanner >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
				   add: buttonHappy;
				   add: buttonNeutral;
				   add: buttonBad;
				   add: sectorList;
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
RevelationScanner >> initialize [

	self fetchSectors.
	super initialize
]

{ #category : 'initialization' }
RevelationScanner >> initializePresenters [
| sectorNames |
	result := self newLabel.
	buttonHappy := self newButton.
	buttonNeutral := self newButton.
	buttonBad := self newButton.

	sectorList := self newList.
	sectorNames := sectors collect: [ :sector | sector at: 'name' ].
	
	sectorList items: sectorNames.

	result label: 'Please give us your feedback'.

	buttonHappy
		label: 'Happy';
		icon: (self iconNamed: #thumbsUp).

	buttonNeutral
		label: 'Neutral';
		icon: (self iconNamed: #user).

	buttonBad
		label: 'Bad';
		icon: (self iconNamed: #thumbsDown).

	buttonHappy action: [ result label: buttonHappy label ].
	buttonNeutral action: [ result label: buttonNeutral label ].
	buttonBad action: [ result label: buttonBad label ]
]

{ #category : 'initialization' }
RevelationScanner >> initializeWindow: aWindowPresenter [
  super initializeWindow: aWindowPresenter .
  aWindowPresenter title: 'Revelation Scanner';
initialExtent: 400@100.

]
