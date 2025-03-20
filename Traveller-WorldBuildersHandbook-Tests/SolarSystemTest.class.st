Class {
	#name : 'SolarSystemTest',
	#superclass : 'TestCase',
	#instVars : [
		'roller'
	],
	#category : 'Traveller-WorldBuildersHandbook-Tests',
	#package : 'Traveller-WorldBuildersHandbook-Tests'
}

{ #category : 'running' }
SolarSystemTest >> setUp [

	roller := DieRoller roller.
	roller clearQueue
]

{ #category : 'running' }
SolarSystemTest >> tearDown [

	roller clearQueue
]

{ #category : 'tests' }
SolarSystemTest >> testGeneratePrimary [

	| s |
	s := SolarSystem new.
	s generatePrimary.
	
	self assert: ((s primary) isKindOf: Star).

]

{ #category : 'tests' }
SolarSystemTest >> testSolarSystemCreate [

	| s |
	s := SolarSystem new.
	self assert: (s sector) isNil.
	self assert: (s x) isNil.
	self assert: (s y) isNil.
	self assert: (s name) isNil.
	self assert: (s primary) isNil
]
