"
wbh 100
"
Class {
	#name : 'SurfaceDistributionTable',
	#superclass : 'RollTable',
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'initialization' }
SurfaceDistributionTable >> initialize [

	super initialize.

	table := Dictionary newFrom: {
			         (0 -> 'Extremely Dispersed').
			         (1 -> 'Very Dispersed').
			         (2 -> 'Dispersed').
			         (3 -> 'Scattered').
			         (4 -> 'Slightly Scattered').
			         (5 -> 'Mixed').
			         (6 -> 'Slightly Skewed').
			         (7 -> 'Skewed').
			         (8 -> 'Concentrated').
			         (9 -> 'Very Concentrated').
			         (10 -> 'Extremely Concentrated') }
]
