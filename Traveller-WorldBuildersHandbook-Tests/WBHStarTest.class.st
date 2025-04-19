Class {
	#name : 'WBHStarTest',
	#superclass : 'RollerBaseTest',
	#category : 'Traveller-WorldBuildersHandbook-Tests',
	#package : 'Traveller-WorldBuildersHandbook-Tests'
}

{ #category : 'tests' }
WBHStarTest >> testAddStellarBody [

	| wbh star so |
	wbh := WorldBuildersHandbook new.
	so := StellarObject new.
	star := wbh generatePrimaryStar.
	star spread: 0.5.
	star addAvailableOrbitsFrom: 0.5 to: 6.9.
	star addAvailableOrbitsFrom: 7 to: 12.
	star addStellarBody: so.
	self assert: star nextOrbit equals: 1.
	
	star := wbh generatePrimaryStar.
	star spread: 0.5.
	star addAvailableOrbitsFrom: 0.5 to: 0.9.
	star addAvailableOrbitsFrom: 7 to: 12.
	star addStellarBody: so.
	self assert: star nextOrbit equals: 7.
	star addStellarBody: nil.
	self assert: star nextOrbit equals: 7.5.
	
]
