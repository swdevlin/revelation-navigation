Class {
	#name : 'StellarObjectsTest',
	#superclass : 'RollerBaseTest',
	#category : 'Traveller-WorldBuildersHandbook-Tests',
	#package : 'Traveller-WorldBuildersHandbook-Tests'
}

{ #category : 'tests' }
StellarObjectsTest >> testNumberOfGasGiants [

	| c star wbh solarSystem |
	
	solarSystem := SolarSystem new.
	wbh := WorldBuildersHandbook new.
	star := Star newWithType: 'G' subtype: 0 class: 'IV'.
	solarSystem primary: star.
	wbh assignStarCharacteristicsTo: star orbiting: nil in: solarSystem .

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

{ #category : 'tests' }
StellarObjectsTest >> testNumberOfTerrestrialPlanets [

	| c dice star wbh solarSystem |
	wbh := WorldBuildersHandbook new.

	solarSystem := SolarSystem new.
	star := Star newWithType: 'G' subtype: 0 class: 'IV'.
	solarSystem primary: star.
	dice := DieRoller roller.

	roller queueD: 6 value: 6.
	roller queueD: 6 value: 4.
	roller queueD: 3 value: 1.
	c := wbh numberOfTerrestrialPlanetsFor: solarSystem.

	self assert: c equals: 8.
	
	roller queueD: 6 value: 6.
	roller queueD: 6 value: 4.
	roller queueD: 3 value: 2.
	c := wbh numberOfTerrestrialPlanetsFor: solarSystem.

	self assert: c equals: 9.
	
	
	roller queueD: 6 value: 1.
	roller queueD: 6 value: 1.
	roller queueD: 3 value: 2.
	c := wbh numberOfTerrestrialPlanetsFor: solarSystem.

	self assert: c equals: 4.
	
	solarSystem := SolarSystem new.
	star := Star newWithType: 'BH' subtype: nil class: nil.
	solarSystem primary: star.
	dice := DieRoller roller.

	roller queueD: 6 value: 6.
	roller queueD: 6 value: 4.
	roller queueD: 3 value: 1.
	c := wbh numberOfTerrestrialPlanetsFor: solarSystem.

	self assert: c equals: 7.


]
