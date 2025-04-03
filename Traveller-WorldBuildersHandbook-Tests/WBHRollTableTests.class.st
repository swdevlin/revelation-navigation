Class {
	#name : 'WBHRollTableTests',
	#superclass : 'RollerBaseTest',
	#category : 'Traveller-WorldBuildersHandbook-Tests',
	#package : 'Traveller-WorldBuildersHandbook-Tests'
}

{ #category : 'tests' }
WBHRollTableTests >> testGasGiantQuantityTable [

	| solarSystem star dm table |
	table := GasGiantQuantityTable new.

	"Single class V star is +1"
	solarSystem := SolarSystem new.
	star := Star new.
	solarSystem primary: star.
	table solarSystem: solarSystem.
	dm := table computeDM.
	self assert: dm equals: 0.

	solarSystem := SolarSystem new.
	star := Star new.
	star stellarClass: 'V'.
	solarSystem primary: star.
	table solarSystem: solarSystem.
	dm := table computeDM.
	self assert: dm equals: 1.

	"Primary is a brown dwarf"
	solarSystem := SolarSystem new.
	star := Star new.
	star stellarType: 'L'.
	solarSystem primary: star.
	table solarSystem: solarSystem.
	dm := table computeDM.
	"-2 for brown dwarf"
	self assert: dm equals: -2.

	"Primary is post-stellar"
	solarSystem := SolarSystem new.
	star := Star new.
	star stellarType: 'BH'.
	solarSystem primary: star.
	table solarSystem: solarSystem.
	dm := table computeDM.
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

	table solarSystem: solarSystem.
	dm := table computeDM.
	" -1 for 4+ stars"
	self assert: dm equals: -1
]

{ #category : 'tests' }
WBHRollTableTests >> testPlanetoidBeltQuantityTable [
"wbh 37"
	| solarSystem star dm table |
table := PlanetoidBeltQuantityTable new.

	"1+ gas giants is +1"
	solarSystem := SolarSystem new.
	star := Star new.
	solarSystem primary: star.
	table solarSystem: solarSystem .
	table gasGiantCount: 1.
	dm := table computeDM.
	self assert: dm equals: 1.

	"0 gas giants is 0"
	solarSystem := SolarSystem new.
	star := Star new.
	solarSystem primary: star.
	table solarSystem: solarSystem .
	table gasGiantCount: 0.
	dm := table computeDM.
	self assert: dm equals: 0.
	
	"primary is a protostar is +3"
	solarSystem := SolarSystem new.
	star := Star new.
	star stellarType: 'K'.
	star isProtoStar: true.
	solarSystem primary: star.
	table solarSystem: solarSystem .
	table gasGiantCount: 0.
	dm := table computeDM.
	self assert: dm equals: 3.
	
	"primary is poststellar is +2"
	solarSystem := SolarSystem new.
	star := Star new.
	star stellarType: 'BH'.
	solarSystem primary: star.
	table solarSystem: solarSystem .
	table gasGiantCount: 0.
	dm := table computeDM.
	self assert: dm equals: 2.
	
	"+1 per poststellar, and +1 for primary being poststellar, and +1 for more than 1 star"
	solarSystem := SolarSystem new.
	star := Star new.
	star stellarType: 'BH'.
	solarSystem primary: star.

	star := Star new.
	star stellarType: 'BH'.
	solarSystem addStar: star.
	table solarSystem: solarSystem .
	table gasGiantCount: 0.
	dm := table computeDM.
	self assert: dm equals: 4.

]
