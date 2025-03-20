Class {
	#name : 'SolarSystemTest',
	#superclass : 'TestCase',
	#category : 'Traveller-WorldBuildersHandbook-Tests',
	#package : 'Traveller-WorldBuildersHandbook-Tests'
}

{ #category : 'tests' }
SolarSystemTest >> testGeneratePrimary [

	| s |
	s := SolarSystem new.
	s generatePrimary.
	
	self assert: ((s primary) isKindOf: Star).

]

{ #category : 'tests' }
SolarSystemTest >> testMultipleStarDM [

	| s primary |
	s := SolarSystem new.
	primary := Star new.
	s primary: primary.

	primary stellarType: 'BD'.
	self assert: s multipleStarDM equals: -1.

	
	primary stellarType: 'D'.
	self assert: s multipleStarDM equals: -1.
	
	primary stellarType: 'PSR'.
	self assert: s multipleStarDM equals: -1.

	
	primary stellarType: 'NS'.
	self assert: s multipleStarDM equals: -1.
	
	primary stellarType: 'BH'.
	self assert: s multipleStarDM equals: -1.

	primary stellarType: 'V'.

	primary stellarClass: 'Ia'.
	self assert: s multipleStarDM equals: 1.

	primary stellarClass: 'Ib'.
	self assert: s multipleStarDM equals: 1.

	primary stellarClass: 'II'.
	self assert: s multipleStarDM equals: 1.

	primary stellarClass: 'III'.
	self assert: s multipleStarDM equals: 1.

	primary stellarClass: 'IV'.
	self assert: s multipleStarDM equals: 1.

	primary stellarClass: 'V'.
	self assert: s multipleStarDM equals: 0.

	primary stellarType: 'M'.
	primary stellarClass: 'V'.
	self assert: s multipleStarDM equals: -1.

	primary stellarClass: 'VI'.
	self assert: s multipleStarDM equals: -1.

	#( 'V' 'VI' ) do: [ :class |
		#( 'O' 'B' 'A' 'F' ) do: [ :type |
			primary stellarType: type.
			primary stellarClass: class.
			self assert: s multipleStarDM equals: 1 ] ].
	

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
