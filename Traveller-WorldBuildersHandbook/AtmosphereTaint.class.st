"
wbh 83

Taint severity and persistance
"
Class {
	#name : 'AtmosphereTaint',
	#superclass : 'Object',
	#instVars : [
		'subtype',
		'code',
		'severity',
		'persistence'
	],
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'as yet unclassified' }
AtmosphereTaint class >> descriptionForSubtype: code [
	"Return the full description for a taint subtype letter code."

	^ code
		  caseOf: {
				  ([ 'L' ] -> [ 'Low Oxygen' ]).
				  ([ 'R' ] -> [ 'Radioactivity' ]).
				  ([ 'B' ] -> [ 'Biologic' ]).
				  ([ 'G' ] -> [ 'Gas Mix' ]).
				  ([ 'P' ] -> [ 'Particulates' ]).
				  ([ 'S' ] -> [ 'Sulphur Compounds' ]).
				  ([ 'H' ] -> [ 'High Oxygen' ]) }
		  otherwise: [ nil ]
]

{ #category : 'instance creation' }
AtmosphereTaint class >> newWithSubtype: aCode [

	| taint |
	taint := self new.
	taint subtype: aCode.
	^ taint
]

{ #category : 'accessing' }
AtmosphereTaint >> code [

	^ code
]

{ #category : 'accessing' }
AtmosphereTaint >> code: anObject [

	code := anObject
]

{ #category : 'initialization' }
AtmosphereTaint >> initialize [

	super initialize.
	subtype := ''.
	code := ''.
	severity := nil.
	persistence := nil
]

{ #category : 'accessing' }
AtmosphereTaint >> persistence [

	^ persistence
]

{ #category : 'accessing' }
AtmosphereTaint >> persistence: anObject [

	persistence := anObject
]

{ #category : 'accessing' }
AtmosphereTaint >> severity [

	^ severity
]

{ #category : 'accessing' }
AtmosphereTaint >> severity: anObject [

	severity := anObject
]

{ #category : 'accessing' }
AtmosphereTaint >> subtype [

	^ subtype
]
