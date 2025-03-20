Class {
	#name : 'StarTest',
	#superclass : 'TestCase',
	#instVars : [
		'roller'
	],
	#category : 'Traveller-WorldBuildersHandbook-Tests',
	#package : 'Traveller-WorldBuildersHandbook-Tests'
}

{ #category : 'running' }
StarTest >> setUp [

	roller := DieRoller roller.
	roller clearQueue 
]

{ #category : 'running' }
StarTest >> tearDown [

	roller clearQueue
]

{ #category : 'tests' }
StarTest >> testAdditionalStarCheck [

	| primary |

	"Has DM of 0"
	primary := Star generateNewType: 'K' subtype: 7 class: 'V'.
   
	"Check on 10+"
	roller queueD: 6 value: 	5.
	roller queueD: 6 value: 	4.
	self deny: (primary multipleStarCheck) .

	"Check on 10+"
	roller queueD: 6 value: 	5.
	roller queueD: 6 value: 	5.
	self assert: (primary multipleStarCheck) .

	"DM +1"
	primary := Star generateNewType: 'O' subtype: 7 class: 'III'.

	"Make sure DM is applied"
	roller queueD: 6 value: 	5.
	roller queueD: 6 value: 	4.
   
	self assert: (primary multipleStarCheck) .

]

{ #category : 'tests' }
StarTest >> testAgeCalculatedOnce [

	| star first second |
	star := Star generateNewType: 'K' subtype: 7 class: 'V'.

	first := star age.	
	second := star age.	

	self assert: first equals: second.

]

{ #category : 'tests' }
StarTest >> testCompanionCheck [

	| star |
	star := Star generateNewType: 'K' subtype: 5 class: 'V'.
	roller queueD: 6 value: 5.
	roller queueD: 6 value: 4.
	self deny: star companionCheck
]

{ #category : 'tests' }
StarTest >> testMultipleStarDM [

	| primary |
	primary := Star new.

	primary stellarType: 'BD'.
	self assert: primary multipleStarDM equals: -1.

	
	primary stellarType: 'D'.
	self assert: primary multipleStarDM equals: -1.
	
	primary stellarType: 'PSR'.
	self assert: primary multipleStarDM equals: -1.

	
	primary stellarType: 'NS'.
	self assert: primary multipleStarDM equals: -1.
	
	primary stellarType: 'BH'.
	self assert: primary multipleStarDM equals: -1.

	primary stellarType: 'V'.

	primary stellarClass: 'Ia'.
	self assert: primary multipleStarDM equals: 1.

	primary stellarClass: 'Ib'.
	self assert: primary multipleStarDM equals: 1.

	primary stellarClass: 'II'.
	self assert: primary multipleStarDM equals: 1.

	primary stellarClass: 'III'.
	self assert: primary multipleStarDM equals: 1.

	primary stellarClass: 'IV'.
	self assert: primary multipleStarDM equals: 1.

	primary stellarClass: 'V'.
	self assert: primary multipleStarDM equals: 0.

	primary stellarType: 'M'.
	primary stellarClass: 'V'.
	self assert: primary multipleStarDM equals: -1.

	primary stellarClass: 'VI'.
	self assert: primary multipleStarDM equals: -1.

	#( 'V' 'VI' ) do: [ :class |
		#( 'O' 'B' 'A' 'F' ) do: [ :type |
			primary stellarType: type.
			primary stellarClass: class.
			self assert: primary multipleStarDM equals: 1 ] ].
	

]
