"
Display the details about a system. Can update the survey index.
"
Class {
	#name : 'SystemPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'nameText',
		'nameInput',
		'surveyIndexInput',
		'scanPointsText',
		'system',
		'gasGiantCount',
		'terrestrialPlanetCount',
		'planetoidCount',
		'saveButton'
	],
	#category : 'Revelation',
	#package : 'Revelation'
}

{ #category : 'as yet unclassified' }
SystemPresenter >> clearSystem [

	scanPointsText label: ''.
	nameText label: ''.
	surveyIndexInput number: ''.
	gasGiantCount label: ''.
	terrestrialPlanetCount  label: ''.
	planetoidCount label: ''.


]

{ #category : 'layout' }
SystemPresenter >> defaultLayout [

	^ SpGridLayout build: [ :builder |
		  builder
			  beColumnNotHomogeneous;
			  column: 2 expand: true;
			  add: 'Name';
			  add: nameInput;
			  nextRow;
			  add: 'Survey Index';
			  add: surveyIndexInput;
			  nextRow;
			  add: 'Scan Points';
			  add: scanPointsText;
			  nextRow;
			  add: 'Gas Giants';
			  add: gasGiantCount;
			  nextRow;
			  add: 'Terrestrial Planets';
			  add: terrestrialPlanetCount;
			  nextRow;
			  add: 'Planetoid Belts';
			  add: planetoidCount;
			  nextRow;
			  add: saveButton;
			  nextRow ]
]

{ #category : 'initialization' }
SystemPresenter >> initializePresenters [

	nameText := self newLabel.
	nameInput := self newTextInput.
	surveyIndexInput := self newNumberInput rangeMinimum: 0 maximum: 12.
	scanPointsText := self newLabel.
	gasGiantCount := self newLabel.
	terrestrialPlanetCount := self newLabel.
	planetoidCount := self newLabel.
	saveButton := self newButton label: 'Save'.
	saveButton action: [ self saveSystem ]
]

{ #category : 'as yet unclassified' }
SystemPresenter >> saveSystem [

	| url client data response i newName newSurveyIndex |
	i := (system at: #id) asString.

	newName := nameInput text.
	newSurveyIndex := surveyIndexInput number.
	 
	url := ZnUrl fromString:
		       'https://radiofreewaba.net/deepnight/data/stars/' , i.

	data := NeoJSONWriter toString: { #survey_index -> newSurveyIndex . #name -> newName} asDictionary.

	client := ZnClient new.
	client
		beOneShot;
		url: url;
		entity: (ZnEntity with: data type: (ZnMimeType applicationJson ));
		patch.

	response := client execute.

]

{ #category : 'initialization' }
SystemPresenter >> setSystem: aSystem [

	system := aSystem.
	scanPointsText label: (aSystem at: #scan_points) asString.
	nameText label: (aSystem at: #name).
	nameInput text: (aSystem at: #name).
	surveyIndexInput number: (aSystem at: #survey_index).
	gasGiantCount label: (aSystem at: #gas_giant_count) asString.
	terrestrialPlanetCount label:
		(aSystem at: #terrestrial_planet_count) asString.
	planetoidCount label: (aSystem at: #planetoid_belt_count) asString
]
