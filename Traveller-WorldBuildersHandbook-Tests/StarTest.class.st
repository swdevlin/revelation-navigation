Class {
	#name : 'StarTest',
	#superclass : 'TestCase',
	#category : 'Traveller-WorldBuildersHandbook-Tests',
	#package : 'Traveller-WorldBuildersHandbook-Tests'
}

{ #category : 'tests' }
StarTest >> testAgeCalculatedOnce [

	| star first second |
	star := Star generateNewType: 'K' subtype: 7 class: 'V'.

	first := star age.	
	second := star age.	

	self assert: first equals: second.

]
