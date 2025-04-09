Class {
	#name : 'OrbitBandTest',
	#superclass : 'TestCase',
	#category : 'Traveller-WorldBuildersHandbook-Tests',
	#package : 'Traveller-WorldBuildersHandbook-Tests'
}

{ #category : 'tests' }
OrbitBandTest >> testOrbitBand [

	| band |
	band := OrbitBand label: #close from: 0.5 to: 3.
	self assert: (band includes: 2.3).
	self deny: (band includes: 5)
]
