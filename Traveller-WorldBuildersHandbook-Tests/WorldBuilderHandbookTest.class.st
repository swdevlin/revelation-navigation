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

	| solarSystem primary wbh expected secondary |
	wbh := WorldBuildersHandbook new.
	solarSystem := WBHSolarSystem new.
	primary := wbh newStarWithType: 'F' subtype: 5 class: 'V'.
	solarSystem primary: primary.

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
	wbh assignAvailableOrbits: solarSystem.
	expected := OrderedCollection new
		            add: (OrbitRange from: 0.03 to: secondary orbit - 1);
		            add: (OrbitRange from: secondary orbit + 1 to: 20);
		            yourself.
	self assert: primary availableOrbits equals: expected.

	"6. If the eccentricity of any Close, Near or Far
secondary star is greater than 0.2, add one more
Orbit# on either side of the star’s Orbit# to the
primary’s unavailability zone, e.g., in the same
example, if the Near star’s eccentricity was more
than 0.2, then the range of Orbit#s greater than
4.10 and less than 8.10 would be unavailable to
the primary star."
	secondary eccentricity: 0.25.
	wbh assignAvailableOrbits: solarSystem.
	expected := OrderedCollection new
		            add: (OrbitRange from: 0.03 to: secondary orbit - 2);
		            add: (OrbitRange from: secondary orbit + 2 to: 20);
		            yourself.
	self assert: primary availableOrbits equals: expected.


	"7. If any Close or Near secondary star has an
eccentricity of greater than 0.5, add another
Orbit# on either side of the primary star’s orbit to
the unavailability zone, e.g., if the Near star had
an eccentricity of more than 0.5, the primary star
could not use Orbit#s between 3.10 and 9.10.
Note that this additional condition does not apply
to Far secondary stars."

	secondary eccentricity: 0.56.
	wbh assignAvailableOrbits: solarSystem.
	expected := OrderedCollection new
		            add: (OrbitRange from: 0.03 to: secondary orbit - 3);
		            add: (OrbitRange from: secondary orbit + 3 to: 20);
		            yourself.
	self assert: primary availableOrbits equals: expected.


	secondary orbit: 12.5.
	wbh assignAvailableOrbits: solarSystem.
	expected := OrderedCollection new
		            add: (OrbitRange from: 0.03 to: secondary orbit - 2);
		            add: (OrbitRange from: secondary orbit + 2 to: 20);
		            yourself.
	self assert: primary availableOrbits equals: expected
]

{ #category : 'tests' }
WorldBuilderHandbookTest >> testAllowableOrbitsOneStar [

	| star solarSystem primary orbits wbh expected |
	wbh := WorldBuildersHandbook new.
	solarSystem := WBHSolarSystem new.
	primary := wbh newStarWithType: 'F' subtype: 5 class: 'V'.
	solarSystem primary: primary.
	wbh assignAvailableOrbits: solarSystem.
	expected := OrderedCollection new
		            add: (OrbitRange from: 0.03 to: 20);
		            yourself.
	self assert: (primary availableOrbits) equals: expected.
	star := wbh generateCompanionFor: primary in: solarSystem.
	primary companion: star.
	orbits := wbh assignAvailableOrbits: solarSystem.
	expected := OrderedCollection new
		            add: (OrbitRange from: (0.5 + star eccentricity) to: 20);
		            yourself.
	self assert: (primary availableOrbits) equals: expected
]

{ #category : 'tests' }
WorldBuilderHandbookTest >> testBaselineNumber [

	| wbh worlds dice star |
	dice := DieRoller roller.

	wbh := WorldBuildersHandbook new.
	worlds := 9.

	star := Star new
		        stellarType: 'K';
		        subtype: 5;
		        stellarClass: 'V';
		        yourself.

	dice
		queueD: 6 value: 1;
		queueD: 6 value: 1.
	self
		assert: (wbh baselineNumberFor: star totalWorlds: worlds)
		equals: -1.

	dice
		queueD: 6 value: 3;
		queueD: 6 value: 3.
	self assert: (wbh baselineNumberFor: star totalWorlds: 12) equals: 4

]

{ #category : 'tests' }
WorldBuilderHandbookTest >> testBaselineOrbitNumber [

	| bon wbh worlds dice star |
	dice := DieRoller roller.
	dice clearQueue.
	dice
		queueD: 6 value: 3;
		queueD: 6 value: 3.

	wbh := WorldBuildersHandbook new.
	worlds := 9.

	"has mao of 0.05"
	star := wbh newStarWithType: 'A' subtype: 5 class: 'V'.

	star hzco: 3.
	star baselineNumber: 4.

	dice
		clearQueue;
		queueD: 6 value: 3;
		queueD: 6 value: 3.
	bon := wbh baselineOrbitNumberFor: star worlds: worlds.
	self assert: bon equals: 3 + (6 - 7 / 10).


	star := wbh newStarWithType: 'K' subtype: 5 class: 'V'. "mao of 0.02"


	"Step 3B - baseline number < 1"
	"minimum orbit < 1"
	dice
		queueD: 6 value: 1;
		queueD: 6 value: 1;
		queueD: 6 value: 3;
		queueD: 6 value: 3.
	star hzco: 1.2.
	star baselineNumber:
		(wbh baselineNumberFor: star totalWorlds: worlds).

	bon := wbh baselineOrbitNumberFor: star worlds: worlds.
	self assert: bon equals: 0.02 - (-1 / 10) + (4 / 100).

	"Step 3B - baseline number < 1"
	"minimum orbit >= 1"
	star := wbh newStarWithType: 'A' subtype: 5 class: 'II'. "mao of 1.17"

	dice
		clearQueue;
		queueD: 6 value: 3;
		queueD: 6 value: 3.
	star hzco: 1.2.
	star baselineNumber: 0.9.

	bon := wbh baselineOrbitNumberFor: star worlds: worlds.
	self assert: bon equals: 1.2 - star baselineNumber + worlds + 0.4.


	"Step 3C - baseline number > worlds"
	"hzco - baseline + worlds >= 1"
	star
		stellarType: 'A';
		stellarClass: 'III';
		subtype: 0.
	dice
		clearQueue;
		queueD: 6 value: 3;
		queueD: 6 value: 3.
	star hzco: 7.5.
	star baselineNumber: 6.
	worlds := 4.
	bon := wbh baselineOrbitNumberFor: star worlds: worlds.
	self assert: bon equals: 7.5 - 6 + worlds - 0.2.


	"Step 3C - baseline number > worlds"
	"hzco - baseline + worlds < 1"
	star
		stellarType: 'A';
		stellarClass: 'III';
		subtype: 0.
	dice
		clearQueue;
		queueD: 6 value: 3;
		queueD: 6 value: 3.
	star hzco: 2.5.
	star baselineNumber: 6.
	worlds := 2.
	bon := wbh baselineOrbitNumberFor: star worlds: worlds.
	self assert: bon equals: 2.5 - (6 + worlds - 0.2 / 10)
]

{ #category : 'tests' }
WorldBuilderHandbookTest >> testSpread [

	| wbh star |
	wbh := WorldBuildersHandbook new.
	star := WBHStar new.
	star
		baselineOrbitNumber: 3;
		mao: 0.1;
		baselineNumber: 2.

	self assert: (wbh spreadFor: star) equals: 2.9 / 2.

	"baselineNumber less than 1 treated as 1"
	star
		baselineOrbitNumber: 3;
		mao: 0.1;
		baselineNumber: 0.5.

	self assert: (wbh spreadFor: star) equals: 2.9.


	"outermost orbit cannot exceed 20"
	star
		baselineOrbitNumber: 3;
		mao: 0.1;
		baselineNumber: 0.5.

	self assert: (wbh spreadFor: star) equals: 2.9
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
