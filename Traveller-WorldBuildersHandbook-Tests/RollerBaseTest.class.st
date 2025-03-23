Class {
	#name : 'RollerBaseTest',
	#superclass : 'TestCase',
	#instVars : [
		'roller'
	],
	#category : 'Traveller-WorldBuildersHandbook-Tests',
	#package : 'Traveller-WorldBuildersHandbook-Tests'
}

{ #category : 'initialization' }
RollerBaseTest >> initialize [

	super initialize.
	roller := DieRoller roller
]

{ #category : 'running' }
RollerBaseTest >> setUp [

	super setUp.
	roller := DieRoller roller.
	roller clearQueue
]

{ #category : 'running' }
RollerBaseTest >> tearDown [

	super tearDown.

	roller clearQueue
]
