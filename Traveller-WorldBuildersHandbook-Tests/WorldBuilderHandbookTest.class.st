Class {
	#name : 'WorldBuilderHandbookTest',
	#superclass : 'TestCase',
	#category : 'Traveller-WorldBuildersHandbook-Tests',
	#package : 'Traveller-WorldBuildersHandbook-Tests'
}

{ #category : 'tests' }
WorldBuilderHandbookTest >> testAdjacentStars [

	| primary solarSystem close near far wbh adjacent |
	wbh := WorldBuildersHandbook new.
	solarSystem := SolarSystem new.
	primary := Star new.
	solarSystem primary: primary.
	close := Star new.
	close orbit: 0.001 + wbh closeOrbitBand min.
	solarSystem addStar: close.
	near := Star new.
	near orbit: 0.002 + wbh nearOrbitBand min.
	solarSystem addStar: near.
	far := Star new.
	far orbit: 0.002 + wbh farOrbitBand min.
	solarSystem addStar: far.

	adjacent := wbh starsAdjacentTo: far in: solarSystem.
	self assert: adjacent size equals: 1.
	self assert: (adjacent at: 1) equals: near.

	adjacent := wbh starsAdjacentTo: near in: solarSystem.
	self assert: adjacent size equals: 2.
	self assert: (adjacent at: 1) equals: close.
	self assert: (adjacent at: 2) equals: far.

	adjacent := wbh starsAdjacentTo: close in: solarSystem.
	self assert: adjacent size equals: 1.
	self assert: (adjacent at: 1) equals: near
]

{ #category : 'tests' }
WorldBuilderHandbookTest >> testAllowableOrbitsMultipleStars [

	| star solarSystem primary orbits wbh expected secondary |
	wbh := WorldBuildersHandbook new.
	solarSystem := SolarSystem new.
	primary := Star newWithType: 'F' subtype: 5 class: 'V'.
	solarSystem primary: primary.
	wbh
		assignStarCharacteristicsTo: primary
		orbiting: nil
		in: solarSystem.

	"5. For the Close, Near or Far Orbit occupied by a
secondary star, consider the Orbits# 1.00 from
that secondary star to be the nearest available
to the primary star, e.g., if a Near star occupied
Orbit# 6.10, then the range of Orbit#s from 5.10
and below and from 7.10 and above would be
available to the primary star but from 5.11 to 7.09
would be unavailable."
	secondary := wbh
		             generateSecondaryFor: primary
		             in: solarSystem
		             inBand: (OrbitBand label: #near from: 5.5 to: 11.5).
	secondary eccentricity: 0.15.
	solarSystem addStar: secondary.
	orbits := wbh availableOrbits: solarSystem.
	expected := OrderedCollection new
		            add: 0.03 @ (secondary orbit - 1);
		            add: secondary orbit + 1 @ 20;
		            yourself.
	self assert: (orbits at: primary) equals: expected.

	"6. If the eccentricity of any Close, Near or Far
secondary star is greater than 0.2, add one more
Orbit# on either side of the star’s Orbit# to the
primary’s unavailability zone, e.g., in the same
example, if the Near star’s eccentricity was more
than 0.2, then the range of Orbit#s greater than
4.10 and less than 8.10 would be unavailable to
the primary star."
	secondary eccentricity: 0.25.
	orbits := wbh availableOrbits: solarSystem.
	expected := OrderedCollection new
		            add: 0.03 @ (secondary orbit - 2);
		            add: secondary orbit + 2 @ 20;
		            yourself.
	self assert: (orbits at: primary) equals: expected.


	"7. If any Close or Near secondary star has an
eccentricity of greater than 0.5, add another
Orbit# on either side of the primary star’s orbit to
the unavailability zone, e.g., if the Near star had
an eccentricity of more than 0.5, the primary star
could not use Orbit#s between 3.10 and 9.10.
Note that this additional condition does not apply
to Far secondary stars."

	secondary eccentricity: 0.56.
	orbits := wbh availableOrbits: solarSystem.
	expected := OrderedCollection new
		            add: 0.03 @ (secondary orbit - 3);
		            add: secondary orbit + 3 @ 20;
		            yourself.
	self assert: (orbits at: primary) equals: expected.


	secondary orbit: 12.5.
	orbits := wbh availableOrbits: solarSystem.
	expected := OrderedCollection new
		            add: 0.03 @ (secondary orbit - 2);
		            add: secondary orbit + 2 @ 20;
		            yourself.
	self assert: (orbits at: primary) equals: expected
]

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
	self assert: (orbits at: primary) equals: expected.
	star := wbh generateCompanionFor: primary in: solarSystem.
	primary companion: star.
	orbits := wbh availableOrbits: solarSystem.
	expected := OrderedCollection new
		            add: 0.5 + star eccentricity @ 20;
		            yourself.
	self assert: (orbits at: primary) equals: expected
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
