Class {
	#name : 'StellarObjectsTest',
	#superclass : 'RollerBaseTest',
	#category : 'Traveller-WorldBuildersHandbook-Tests',
	#package : 'Traveller-WorldBuildersHandbook-Tests'
}

{ #category : 'tests' }
StellarObjectsTest >> testGasGiantQuantityDM [

	| solarSystem star dm wbh |
	wbh := WorldBuildersHandbook new.

	"Single class V star is +1"
	solarSystem := SolarSystem new.
	star := Star new.
	solarSystem primary: star.
	dm := wbh gasGiantQuantityDMFor: solarSystem.
	self assert: dm equals: 0.
	
	solarSystem := SolarSystem new.
	star := Star new.
	star stellarClass: 'V'.
	solarSystem primary: star.
	dm := wbh gasGiantQuantityDMFor: solarSystem.
	self assert: dm equals: 1.
	
	"Primary is a brown dwarf"
	solarSystem := SolarSystem new.
	star := Star new.
	star stellarType: 'L'.
	solarSystem primary: star.
	dm := wbh gasGiantQuantityDMFor: solarSystem.
	"-2 for brown dwarf"
	self assert: dm equals: -2.
	
	"Primary is post-stellar"
	solarSystem := SolarSystem new.
	star := Star new.
	star stellarType: 'BH'.
	solarSystem primary: star.
	dm := wbh gasGiantQuantityDMFor: solarSystem.
	" -2 for post stellar"
	self assert: dm equals: -2.
		
	"Four or more stars is -1"
	solarSystem := SolarSystem new.
	star := Star new.
	star stellarType: 'K'.
	solarSystem primary: star.

	star := Star new.
	star stellarType: 'K'.
	solarSystem addStar: star.

	star := Star new.
	star stellarType: 'K'.
	solarSystem addStar: star.

	star := Star new.
	star stellarType: 'K'.
	solarSystem addStar: star.

	dm := wbh gasGiantQuantityDMFor: solarSystem.
	" -1 for 4+ stars"
	self assert: dm equals: -1
]

{ #category : 'tests' }
StellarObjectsTest >> testNumberOfGasGiants [

	| c wbh solarSystem |
	
	solarSystem := SolarSystem new.
	wbh := WorldBuildersHandbook new.
	roller queueD: 6 value: 6.
	roller queueD: 6 value: 4.
	c := wbh numberOfGasGiantsFor: solarSystem .
	self assert: c equals: 0.
	
	roller queueD: 6 value: 3.
	roller queueD: 6 value: 4.
	roller queueD: 6 value: 5.
	roller queueD: 6 value: 1.
	c := wbh numberOfGasGiantsFor: solarSystem .
	self assert: c equals: 2.

]
