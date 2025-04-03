Class {
	#name : 'WorldBuilderHandbookTest',
	#superclass : 'TestCase',
	#category : 'Traveller-WorldBuildersHandbook-Tests',
	#package : 'Traveller-WorldBuildersHandbook-Tests'
}

{ #category : 'tests' }
WorldBuilderHandbookTest >> testAllowableOrbitsOneStar [

	| star solarSystem primary orbits wbh expected |
	wbh := WorldBuildersHandbook new.
	solarSystem := SolarSystem new.
	primary := Star newWithType: 'F' subtype: 5 class: 'V'.
	solarSystem primary: primary.
	wbh
		assignStarCharacteristicsTo: primary
		orbiting: nil
		in: solarSystem.
	orbits := wbh availableOrbits: solarSystem.
	expected := OrderedCollection new
		            add: 0.03 @ 20;
		            yourself.
	self assert: orbits equals: expected.
	star := wbh generateCompanionFor: primary in: solarSystem.
	primary companion: star.
	orbits := wbh availableOrbits: solarSystem.
	expected := OrderedCollection new
		            add: 0.5 + star eccentricity @ 20;
		            yourself.
	self assert: orbits equals: expected
]

{ #category : 'tests' }
WorldBuilderHandbookTest >> testSubtypeInterpolate [

	| v l u subtype result expected |
	v := #( 2400 1850 1300 900 550 300 ).
	l := 1.
	u := 2.
	subtype := 0.
	expected := 2400.
	result := WorldBuildersHandbook
		          subtypeInterpolate: v
		          lower: l
		          upper: u
		          subtype: subtype.
	self assert: result equals: expected.
	
	subtype := 1.
	expected := 2290.
	result := WorldBuildersHandbook
		          subtypeInterpolate: v
		          lower: l
		          upper: u
		          subtype: subtype.
	self assert: result equals: expected.
	
	subtype := 4.
	expected := 1960.
	result := WorldBuildersHandbook
		          subtypeInterpolate: v
		          lower: l
		          upper: u
		          subtype: subtype.
	self assert: result equals: expected.
	
	l := 2.
	u := 3.
	subtype := 5.
	expected := 1850.
	result := WorldBuildersHandbook
		          subtypeInterpolate: v
		          lower: l
		          upper: u
		          subtype: subtype.
	self assert: result equals: expected.
	
	l := 2.
	u := 3.
	subtype := 6.
	expected := 1740.
	result := WorldBuildersHandbook
		          subtypeInterpolate: v
		          lower: l
		          upper: u
		          subtype: subtype.
	self assert: result equals: expected.
	
	l := 2.
	u := 3.
	subtype := 9.
	expected := 1410.
	result := WorldBuildersHandbook
		          subtypeInterpolate: v
		          lower: l
		          upper: u
		          subtype: subtype.
	self assert: result equals: expected.
	

]

{ #category : 'tests' }
WorldBuilderHandbookTest >> testSubtypeInterpolatePastEnd [

	| v l u subtype result expected |
	v := #( 2400 1850 1300 900 550 300 ).
	
	l := 6.
	u := 7.
	subtype := 5.
	expected := 300.
	result := WorldBuildersHandbook 
		          subtypeInterpolate: v
		          lower: l
		          upper: u
		          subtype: subtype.
	self assert: result equals: expected.
	
	subtype := 6.
	expected := 250.
	result := WorldBuildersHandbook
		          subtypeInterpolate: v
		          lower: l
		          upper: u
		          subtype: subtype.
	self assert: result equals: expected.
		
	subtype := 9.
	expected := 100.
	result := WorldBuildersHandbook
		          subtypeInterpolate: v
		          lower: l
		          upper: u
		          subtype: subtype.
	self assert: result equals: expected.
	

]
