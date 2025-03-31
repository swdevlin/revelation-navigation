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

{ #category : 'tests' }
SolarSystemTest >> testStarCount [

	| solarSystem primary star |
	solarSystem := SolarSystem new.
	primary := Star new.
	solarSystem primary: primary .
	self assert: (solarSystem starCount) equals: 1.

	star := Star new.
	primary addStar: star.
	self assert: (solarSystem starCount) equals: 2.

	star := Star new.
	primary addStar: star.
	self assert: (solarSystem starCount) equals: 3.

]
