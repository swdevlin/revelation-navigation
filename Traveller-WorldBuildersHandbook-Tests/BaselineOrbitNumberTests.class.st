Class {
	#name : 'BaselineOrbitNumberTests',
	#superclass : 'RollerBaseTest',
	#category : 'Traveller-WorldBuildersHandbook-Tests',
	#package : 'Traveller-WorldBuildersHandbook-Tests'
}

{ #category : 'tests' }
BaselineOrbitNumberTests >> test1 [

	| wbh star worlds bon |
	wbh := WorldBuildersHandbook new.
	worlds := 2.
	star := wbh generateNewBrownDwarf.
	star hzco: 0.0045318.
	star stellarType: 'T'.
	star mao: 0.005.
	star baselineNumber: 4.
	star subtype: 8.
	roller
		clearQueue;
		queueD: 6 value: 6;
		queueD: 6 value: 6.
	bon := wbh baselineOrbitForBaselineGreaterThanWorlds: star worlds: 2.
	self assert: bon equals: 0.025
]
