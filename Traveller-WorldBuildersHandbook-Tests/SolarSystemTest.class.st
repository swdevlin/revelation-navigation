Class {
	#name : 'SolarSystemTest',
	#superclass : 'RollerBaseTest',
	#category : 'Traveller-WorldBuildersHandbook-Tests',
	#package : 'Traveller-WorldBuildersHandbook-Tests'
}

{ #category : 'tests' }
SolarSystemTest >> testSolarSystemCreate [

	| s |
	s := SolarSystem new.
	self assert: (s sector) isNil.
	self assert: (s coordinates) isNil.
	self assert: (s name) isNil.
	self assert: (s primary) isNil
]
