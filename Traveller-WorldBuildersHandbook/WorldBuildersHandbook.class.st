"
Implement the rules that generate star systems.

Messages that start with `generate` create a complete instance of the object. e.g. `generatePlanet` will create a new planet and all associated characteristics and moons.

Messages that start with `calculate` calculate a value and return a value. e.g. `calculateEccentricityFor:orbiting:in:` calculates the orbit eccentricity of an object but does not assign the value to the object.

Messages that start with `assign` will assign the value to the object. e.g. `assignHotStarTypeTo:` will set the stellar type, subtype, and class to the object.


wbh := WorldBuilderHandbook new.

""This generates a completely populated solar system""
solarSystem := wbh generateSolarSystem.

""Generate a new star""
star := wbh newStar.

""Generate the primary star for a solar system""
primary := wbh generatePrimaryStar.

"
Class {
	#name : 'WorldBuildersHandbook',
	#superclass : 'Object',
	#instVars : [
		'colours',
		'classOrder',
		'typeOrder',
		'massData',
		'temperatures',
		'diameters',
		'luminosity',
		'minimumAllowableOrbit'
	],
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'as yet unclassified' }
WorldBuildersHandbook class >> planetoidBeltQuantityTable [

	^ RollTable new
		  initializeWithDictionary: (Dictionary newFrom: {
					   (6 -> 1).
					   (7 -> 2).
					   (8 -> 2).
					   (9 -> 2).
					   (10 -> 2).
					   (11 -> 2).
					   (12 -> 3) })
		  named: 'PlanetoidBeltQuantity'
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook class >> subtypeInterpolate: vector lower: lower upper: upper subtype: subtype [

	| lowerValue upperValue factor items |
	items := vector size.
	lowerValue := vector at: lower.
	upperValue := upper > items
		              ifTrue: [
			              | delta |
			              delta := (vector at: items) - (vector at: items - 1).
			              upperValue := (vector at: items) + delta ]
		              ifFalse: [ vector at: upper ].

	factor := subtype < 5
		          ifTrue: [ subtype / 5.0 ]
		          ifFalse: [ subtype - 5 / 5.0 ].

	^ lowerValue + (factor * (upperValue - lowerValue))
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> assignHotStarTypeTo: sc [

	sc spectralType: HotStarTypeTable new roll.

]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> assignSpecialStarTypeTo: sc [
	"wbh: 15,16"

	| type |
	sc spectralClass: SpecialStarClassTable new roll.

	sc spectralClass == #Giant ifTrue: [
		sc spectralClass: GiantStarClassTable new roll.
		sc spectralType: (self nonSpecialStarTypeWithRoll: nil).
		^ sc ].

	type := self nonSpecialStarTypeWithRoll: nil.

	sc spectralClass == 'IV' ifTrue: [
		type == 'M' ifTrue: [
			| r |
			r := 5 + RollTable starType lastRoll.
			type := self nonSpecialStarTypeWithRoll: r.
			type == 'O' ifTrue: [ type := 'B' ] ] ].

	sc spectralClass == 'VI' ifTrue: [
		type == 'F' ifTrue: [ type := 'G' ].
		type == 'A' ifTrue: [ type := 'B' ] ].

	^ sc spectralType: type
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> assignStarCharacteristicsTo: star orbiting: parent in: solarSystem [

	star
		eccentricity: (parent ifNil: [ 0 ] ifNotNil: [
					 self
						 calculateEccentricityFor: star
						 orbiting: parent
						 in: solarSystem ]);
		inclination: self calculateInclination;
		mass: (self
				 massForType: star stellarType
				 subtype: star subtype
				 class: star stellarClass);
		colour: (self colourForType: star stellarType);
		diameter: (self
				 diameterForType: star stellarType
				 subtype: star subtype
				 class: star stellarClass);
		temperature:
			(self temperatureForType: star stellarType subtype: star subtype);
		age: (self calculateAgeFor: star);
		orbitPosition: 0 @ 0;
		inclination: 0
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> assignStellarObjects: aSolarSystem [

	| gasGiants planetoidBelts terrestrialPlanets availableOrbits |
	gasGiants := self numberOfGasGiantsFor: aSolarSystem.
	planetoidBelts := self
		                  numberOfPlanetoidBeltsFor: aSolarSystem
		                  gasGiants: gasGiants.
	terrestrialPlanets := self numberOfTerrestrialPlanetsFor:
		                      aSolarSystem.
	availableOrbits := self availableOrbits: aSolarSystem
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> availableOrbits: aSolarSystem [
	"wbh: page 38"

	aSolarSystem starCount = 1
		ifTrue: [ ^ self availableOrbitsForSingleStarSystem: aSolarSystem ]
		ifFalse: [ ^ self availableOrbitsForMultiStarSystem: aSolarSystem ]
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> availableOrbitsForMultiStarSystem: aSolarSystem [
	"wbh: page 38"

	| availableOrbits orbits mao primary minOrbit |
	availableOrbits := Dictionary new.
	primary := aSolarSystem primary.
	orbits := OrderedCollection new.
	mao := self minimumAllowableOrbit: primary.

	primary companion ifNotNil: [
		mao := 0.5 + primary companion eccentricity ].
	minOrbit := mao.
	aSolarSystem secondaryStars do: [ :star |
		| offset orbit ownOrbits |
		offset := self starOrbitOffset: star.
		orbit := star orbit.
		orbits add: minOrbit @ (orbit - offset).
		minOrbit := orbit + offset.
		ownOrbits := self calculateSecondaryAvailableOrbits: star in: aSolarSystem .
		ownOrbits := orbit - 3.
		ownOrbits > 0 ifTrue: [
			| starOrbits |
			starOrbits := OrderedCollection new.
			starOrbits add: (self minimumAllowableOrbit: primary) @ ownOrbits.
			availableOrbits at: star put: starOrbits ] ].
	orbits add: minOrbit @ 20.
	availableOrbits at: primary put: orbits.

	^ availableOrbits
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> availableOrbitsForSingleStarSystem: aSolarSystem [
	"wbh: page 38"

	| orbits mao primary |
	primary := aSolarSystem primary.
	orbits := OrderedCollection new.
	mao := self
		       interpolatedLookup: minimumAllowableOrbit
		       type: primary stellarType
		       subtype: primary subtype
		       class: primary stellarClass.
	primary companion ifNotNil: [
		mao := 0.5 + primary companion eccentricity ].
	orbits add: mao @ 20.
	^ Dictionary new
		  at: primary put: orbits;
		  yourself
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> band: orbitBand HasStarIn: aSolarSystem [

	^ aSolarSystem secondaryStars anySatisfy: [ :star |
		  | orbit |
		  orbit := star orbit.
		  orbitBand includes: orbit ]
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> bandFor: aStar [

	(self closeOrbitBand includes: aStar orbit) ifTrue: [ ^ #close ].
	(self nearOrbitBand includes: aStar orbit) ifTrue: [ ^ #near ].
	(self farOrbitBand includes: aStar orbit) ifTrue: [ ^ #far ].
	^ nil
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> calculateAgeFor: star [

	| age msl dice subGiantLifespan giantLifespan |
	dice := DieRoller roller.

	msl := 10 / (star mass raisedTo: 2.5).

	(#( 'Ia' 'Ib' 'II' 'V' 'VI' ) includes: star stellarClass)
		ifTrue: [
			age := star mass > 0.9
				       ifTrue: [ msl * (dice roll: 1 d: 100) / 100.0 ]
				       ifFalse: [
					       (dice roll: 1 d: 6) * 2 + ((dice roll: 1 d: 3) - 2)
					       + ((dice roll: 1 d: 10) / 10.0) ].

			star mass < 4.7 ifTrue: [ age := 0.01 max: age ] ]
		ifFalse: [
			subGiantLifespan := msl / (4 + star mass).
			star stellarClass = 'IV'
				ifTrue: [
				age := msl + (subGiantLifespan * (dice roll: 1 d: 100) / 100.0) ]
				ifFalse: [
					giantLifespan := msl / (10 * (star mass raisedTo: 3)).
					age := msl + subGiantLifespan
					       + (giantLifespan * (dice roll: 1 d: 100) / 100.0) ] ].
	^ age
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> calculateEccentricityFor: stellarObject orbiting: star in: solarSystem [
	"wbh 27"

	| r table |
	table := EccentricityTable new.
	r := table rollFor: stellarObject orbiting: star in: solarSystem.

	r := ((r max: 0) min: 0.999) roundTo: 0.001.

	^ r
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> calculateInclination [

	^ InclinationTable new roll roundTo: 0.1
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> calculateSecondaryAvailableOrbits: aStar in: aSolarSystem [

	| maxOrbit orbits mao adjacentStars |
	orbits := OrderedCollection new.
	maxOrbit := aStar orbit - 3.
	(self hasAdjacentStarIn: aSolarSystem for: aStar) ifTrue: [
		maxOrbit := maxOrbit - 1 ].
	mao := self minimumAllowableOrbit: aStar.

	adjacentStars := self starsAdjacentTo: aStar in: aSolarSystem.

	(adjacentStars anySatisfy: [ :star | star eccentricity > 0.2 ])
		ifTrue: [ maxOrbit := maxOrbit - 1 ].

	(adjacentStars anySatisfy: [ :star | star eccentricity > 0.5 ])
		ifTrue: [ maxOrbit := maxOrbit - 1 ].

	maxOrbit > mao ifTrue: [ orbits add: mao @ maxOrbit ].

	^ orbits
]

{ #category : 'orbit bans' }
WorldBuildersHandbook >> closeOrbitBand [

	^ OrbitBand label: #close from: 0.5 to: 5.5
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> colourForType: type [

	^ colours at: type

]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> createDefaultClassification [

	| sc table |
	table := StarTypeTable new.
	sc := SpectralClassification new
		spectralClass: 'V';
		spectralType: (table roll).
	^ sc
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> diameterForType: type subtype: subtype class: class [

	^ self
		  interpolatedLookup: diameters 
		  type: type
		  subtype: subtype
		  class: class
]

{ #category : 'orbit bans' }
WorldBuildersHandbook >> farOrbitBand [

	^ OrbitBand label: #far from: 11.5 to: 17
]

{ #category : 'generate star' }
WorldBuildersHandbook >> generateCompanionFor: star in: solarsystem [
	" wbh: 29"

	| result table companion dice |
	dice := DieRoller roller.
	table := CompanionStarDeterminationTable new.
	result := table rollFor: star.

	companion := self generateStarFromNonPrimaryResult: result for: star.
	companion orbit: ((dice floatBetween: 0.05 and: 0.65) roundTo: 0.01).
	self
		assignStarCharacteristicsTo: companion
		orbiting: star
		in: solarsystem.
	^ companion
]

{ #category : 'generate star' }
WorldBuildersHandbook >> generateLesserFor: aStar [

	| stellarType subtype |
	stellarType := aStar stellarType.
	subtype := aStar subtype.

	aStar stellarType = Star typeOrder last
		ifTrue: [
			subtype := MTypePrimarySubtypeTable new roll.
			subtype < aStar subtype ifTrue: [ stellarType := 'BD' ] ]
		ifFalse: [
			stellarType := aStar coolerType.
			subtype := StarSubtypeTable new roll ].

	stellarType = 'BD'
		ifTrue: [ ^ self generateNewBrownDwarf ]
		ifFalse: [
			^ Star
				  newWithType: stellarType
				  subtype: subtype
				  class: aStar stellarClass ]
]

{ #category : 'generate star' }
WorldBuildersHandbook >> generateNewBrownDwarf [
	"WBH: 226"

	| mass typeAndSubtypeTuple dice type subtype lower upper temperature diameter luminosity |
	dice := DieRoller roller.
	mass := (dice roll: 1 d: 6) / 100.0
	        + ((dice roll: 4 d: 6) - 1 / 1000).

	typeAndSubtypeTuple := Star brownDwarfTypeAndSubtypeFromMass: mass.
	type := typeAndSubtypeTuple at: 1.
	subtype := typeAndSubtypeTuple at: 2.

	lower := (Star brownDwarfTypes indexOf: type) * 2 - 1.
	subtype >= 5 ifTrue: [ lower := lower + 1 ].
	upper := lower + 1.

	temperature := self class
		               subtypeInterpolate: Star brownDwarfTemperature
		               lower: lower
		               upper: upper
		               subtype: subtype.

	luminosity := self class 
		              subtypeInterpolate: Star brownDwarfLuminosity
		              lower: lower
		              upper: upper
		              subtype: subtype.

	diameter := 0.1.

	type = 'L' ifTrue: [
		diameter := self class 
			            subtypeInterpolate: #( 0.08 0.06 )
			            lower: 1
			            upper: 2
			            subtype: subtype ].

	type = 'T' ifTrue: [
		diameter := self class
			            subtypeInterpolate: #( 0.05 0.04 )
			            lower: 1
			            upper: 2
			            subtype: subtype ].

	type = 'Y' ifTrue: [ diameter := 0.1 ].

	^ Star new
		  stellarType: type;
		  subtype: subtype;
		  mass: mass;
		  temperature: temperature;
		  luminosity: luminosity;
		  diameter: diameter;
		  yourself
]

{ #category : 'generate star' }
WorldBuildersHandbook >> generateNewWhiteDwarf [
	"WBH: 30, 227"

	| mass age finalAge dice diameter |
	dice := DieRoller roller.
	mass := (dice roll: 2 d: 6) - 1 / 10.0
	        + ((dice roll: 1 d: 10) / 100.0).
	diameter := 1 / mass * 0.01.

	age := mass * (2 + (dice roll: 1 d: 3)).

	finalAge := 10 / (mass raisedTo: 2.5)
	            * (1 + (1 / (4 + mass) + (1 / (mass raisedTo: 3 * 10)))).

	^ Star new
		  stellarType: 'D';
		  mass: mass;
		  age: age;
		  temperature: (self whiteDwarfTemperatureForMass: mass age: age);
		  diameter: diameter;
		  yourself
]

{ #category : 'generate star' }
WorldBuildersHandbook >> generateOtherStar [

	(DieRoller roller roll: 2 d: 6) < 8
		ifTrue: [ ^ self generateNewWhiteDwarf ]
		ifFalse: [ ^ self generateNewBrownDwarf ]
]

{ #category : 'generate star' }
WorldBuildersHandbook >> generatePrimaryStar [

	| star sc |
	sc := self primaryStarClassification.

	star := Star new.
	star
		spectralClassification: sc;
		orbit: 0.

	self assignStarCharacteristicsTo: star orbiting: nil in: nil.

	^ star
]

{ #category : 'generate star' }
WorldBuildersHandbook >> generateRandomFor: primary [
	"wbh: 29"

	| star |
	star := self generatePrimaryStar.
	(star isHotter: primary)
		ifTrue: [ ^ self generateLesserFor: primary ]
		ifFalse: [ ^ star ]
]

{ #category : 'generate star' }
WorldBuildersHandbook >> generateSecondaryFor: star in: solarSystem inBand: bandRange [
	" wbh: 29"

	| result dm table secondary companion |
	dm := (#( 'III' 'IV' ) includes: star stellarClass)
		      ifTrue: [ -1 ]
		      ifFalse: [ 0 ].
	table := SecondaryStarDeterminationTable new.
	result := table rollwithDM: dm.

	secondary := self generateStarFromNonPrimaryResult: result for: star.

	secondary orbit: bandRange random.

	self assignStarCharacteristicsTo: secondary orbiting: star in: solarSystem .

	self hasCompanion ifTrue: [
		companion := self generateCompanionFor: secondary in: solarSystem.
		secondary companion: star ].

	^ secondary
]

{ #category : 'generate star' }
WorldBuildersHandbook >> generateSecondaryFor: solarSystem inBand: bandRange [
	" wbh: 29"

	| star result table secondary companion |
	star := solarSystem primary.
	table := SecondaryStarDeterminationTable new.
	result := table rollFor: star.

	secondary := self generateStarFromNonPrimaryResult: result for: star.

	secondary orbit: bandRange random.

	secondary eccentricity: (self
			 calculateEccentricityFor: secondary
			 orbiting: star
			 in: solarSystem).

	self hasCompanion ifTrue: [
		companion := self generateCompanionFor: secondary in: solarSystem.
		secondary companion: star ].

	^ secondary
]

{ #category : 'generate star' }
WorldBuildersHandbook >> generateSiblingFor: aStar [

	| t s c r roller |
	t := aStar stellarType.
	s := aStar subtype.
	c := aStar stellarClass.

	roller := DieRoller roller.
	r := roller roll: 1 d: 6.
	r + s > 9
		ifTrue: [
			| coolerType |
			coolerType := aStar coolerType.
			coolerType = aStar stellarType
				ifTrue: [ s := 9 ]
				ifFalse: [
					t := coolerType.
					s := r + s \\ 10 ] ]
		ifFalse: [ s := s + r ].

	^ Star newWithType: t subtype: s class: c
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> generateSolarSystem [
	" Generate a complete solar system"

	| solarSystem star primary |
	solarSystem := SolarSystem new.

	primary := self generatePrimaryStar.
	solarSystem primary: primary.

	self hasCompanion ifTrue: [
		star := self generateCompanionFor: primary in: solarSystem.
		primary companion: star ].

	{
		self closeOrbitBand .
		self nearOrbitBand .
		self farOrbitBand } do: [ :orbitBand |
		self hasSecondary ifTrue: [
			star := self generateSecondaryFor: solarSystem inBand: orbitBand.
			solarSystem addStar: star ] ].

	self assignStellarObjects: solarSystem.

	^ solarSystem
]

{ #category : 'generate star' }
WorldBuildersHandbook >> generateStarFromNonPrimaryResult: result for: star [

	| messageMap |
	messageMap := Dictionary newFrom: {
			             (#Other -> [ self generateOtherStar ]).
			             (#Random -> [ self generateRandomFor: star ]).
			             (#Lesser -> [ self generateLesserFor: star ]).
			             (#Sibling -> [ self generateSiblingFor: star ]).
			             (#Twin -> [ self generateTwinFor: star ]) }.

	^ (messageMap
		  at: result
		  ifAbsent: [
		  Error signal: 'Unexpected non-primary type: ' , result asString ]) value
]

{ #category : 'generate star' }
WorldBuildersHandbook >> generateTwinFor: aStar [

	^ Star
		  newWithType: aStar stellarType
		  subtype: aStar subtype
		  class: aStar stellarClass
]

{ #category : 'testing' }
WorldBuildersHandbook >> hasAdjacentStarIn: aSolarSystem for: aStar [

	(self closeOrbitBand includes: aStar orbit) ifTrue: [
		^ self band: self nearOrbitBand HasStarIn: aSolarSystem ].

	(self farOrbitBand includes: aStar orbit) ifTrue: [
		^ self band: self nearOrbitBand HasStarIn: aSolarSystem ].

	(self nearOrbitBand includes: aStar orbit) ifTrue: [
		^ (self band: self closeOrbitBand HasStarIn: aSolarSystem) or:
			  (self band: self farOrbitBand HasStarIn: aSolarSystem) ].

	^ false
]

{ #category : 'testing' }
WorldBuildersHandbook >> hasCompanion [
	"wbh: 23"

	^ (DieRoller roller roll: 2 d: 6) >= 10
]

{ #category : 'testing' }
WorldBuildersHandbook >> hasSecondary [
	"wbh: 23"

	^ (DieRoller roller roll: 2 d: 6) >= 10
]

{ #category : 'initialization' }
WorldBuildersHandbook >> initialize [

	colours := Dictionary newFrom: {
			           ('O' -> 'Blue').
			           ('B' -> 'Blue White').
			           ('A' -> 'White').
			           ('F' -> 'Yellow White').
			           ('G' -> 'Yellow').
			           ('K' -> 'Light Orange').
			           ('M' -> 'Orange Red') }.

	classOrder := #( 'Ia' 'Ib' 'II' 'III' 'IV' 'V' 'VI' ).

	typeOrder := #( 'O' 'B' 'A' 'F' 'G' 'K' 'M' ).

	massData := #( #( 200 150 130 110 nil 90 2 )
	               #( 80 60 40 30 nil 60 1.5 )
	               #( 60 40 30 20 20 18 0.5 ) #( 30 25 20 10 10 5 0.4 )
	               #( 20 15 14 8 4 2.2 nil ) #( 15 13 11 6 2.3 1.8 nil )
	               #( 13 12 10 4 2 1.5 nil ) #( 12 10 8 3 1.5 1.3 nil )
	               #( 12 10 8 2.5 1.7 1.1 0.8 )
	               #( 13 11 10 2.4 1.2 0.9 0.7 )
	               #( 14 12 10 1.1 1.5 0.8 0.6 )
	               #( 18 13 12 1.5 nil 0.7 0.5 )
	               #( 20 15 14 1.8 nil 0.5 0.4 )
	               #( 25 20 16 2.4 nil 0.16 0.12 )
	               #( 30 25 18 8 nil 0.08 0.075 ) ).

	temperatures := #( 50000 40000 30000 15000 10000 8000 7500 6500 6000
	                   5600 5200 4400 3700 3000 2400 ).

	diameters := #( #( 25 24 22 21 nil 20 0.18 )
	                #( 22 20 18 15 nil 12 0.18 )
	                #( 20 14 12 10 8 7 0.2 ) #( 60 25 14 6 5 3.5 0.5 )
	                #( 120 50 30 5 4 2.2 nil ) #( 180 75 45 5 3 2 nil )
	                #( 210 85 50 5 3 1.7 nil ) #( 280 115 66 5 2 1.5 nil )
	                #( 330 135 77 10 3 1.1 0.8 )
	                #( 360 150 90 15 4 0.95 0.7 )
	                #( 420 180 110 20 6 0.9 0.6 )
	                #( 600 260 160 40 nil 0.8 0.5 )
	                #( 900 380 230 60 nil 0.7 0.4 )
	                #( 1200 600 350 100 nil 0.2 0.1 )
	                #( 1800 800 500 200 nil 0.1 0.08 ) ).

	luminosity := #( #( 3400000 3200000 2700000 2400000 nil 2200000
	                    180 )
	                 #( 1100000 900000 730000 510000 nil 330000 73 )
	                 #( 290000 140000 100000 72000 46000 35000 29 )
	                 #( 160000 28000 8800 1600 1100 550 11 )
	                 #( 130000 22000 8000 220 140 43 nil )
	                 #( 120000 20000 7300 90 33 15 nil )
	                 #( 120000 20000 7000 70 25 8.1 nil )
	                 #( 120000 20000 6900 39 6 3.5 nil )
	                 #( 120000 20000 6800 120 10 1.4 0.73 )
	                 #( 110000 20000 7000 200 14 0.78 0.43 )
	                 #( 110000 21000 7800 260 23 0.52 0.23 )
	                 #( 120000 22000 8400 530 nil 0.21 0.083 )
	                 #( 130000 24000 8800 600 nil 0.082 0.027 )
	                 #( 100000 26000 8800 720 nil 0.0029 0.00072 )
	                 #( 90000 19000 7300 1200 nil 0.00029 0.00019 ) ).

	minimumAllowableOrbit := #( #( 0.63 0.60 0.55 0.53 nil 0.5 0.01 )
	                            #( 0.55 0.50 0.45 0.38 nil 0.3 0.01 )
	                            #( 0.50 0.35 0.30 0.25 0.20 0.18 0.01 )
	                            #( 1.67 0.63 0.35 0.15 0.13 0.09 0.01 )
	                            #( 3.34 1.40 0.75 0.13 0.10 0.06 nil )
	                            #( 4.17 2.17 1.17 0.13 0.07 0.05 nil )
	                            #( 4.42 2.50 1.33 0.13 0.07 0.04 nil )
	                            #( 5.00 3.25 1.87 0.13 0.06 0.03 nil )
	                            #( 5.21 3.59 2.24 0.25 0.07 0.03 0.02 )
	                            #( 5.34 3.84 2.67 0.38 0.10 0.02 0.02 )
	                            #( 5.59 4.17 3.17 0.50 0.15 0.02 0.02 )
	                            #( 6.17 4.84 4.00 1.00 nil 0.02 0.01 )
	                            #( 6.80 5.42 4.59 1.68 nil 0.02 0.01 )
	                            #( 7.20 6.17 5.30 3.00 nil 0.01 0.01 )
	                            #( 7.80 6.59 5.92 4.34 nil 0.01 0.01 ) )
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> interpolate: vector lowerBound: lower upperBound: upper subtype: subtype [

	| lowerValue upperValue factor |
	lowerValue := vector at: lower.
	upperValue := vector at: upper.

	factor := subtype < 5
		          ifTrue: [ subtype / 5.0 ]
		          ifFalse: [ subtype - 5 / 5.0 ].

	^ lowerValue + (factor * (upperValue - lowerValue))
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> interpolatedLookup: table type: type subtype: subtype class: class [

	| typeIndex classIndex lowerBound upperBound lowerData upperData lowerValue upperValue factor |
	typeIndex := typeOrder indexOf: type.
	lowerBound := typeIndex * 2 + (subtype >= 5 ifTrue: [ 0 ] ifFalse: [ -1 ]).
	upperBound := lowerBound + 1.

	lowerData := table at: lowerBound.
	upperData := table at: upperBound.

	classIndex := classOrder indexOf: class.
	lowerValue := lowerData at: classIndex.
	upperValue := upperData at: classIndex.

	factor := subtype < 5 ifTrue: [ subtype / 5.0 ] ifFalse: [(subtype -5)/5.0].
	
	^ lowerValue + (factor * (upperValue - lowerValue))
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> luminosityForType: type subtype: subtype class: class [

	^ self
		  interpolatedLookup: luminosity 
		  type: type
		  subtype: subtype
		  class: class
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> massForType: type subtype: subtype class: class [
	"TODO : handle brown dwarfs, white dwarfs and post stellar objects"

	^ self
		  interpolatedLookup: massData
		  type: type
		  subtype: subtype
		  class: class
]

{ #category : 'accessing' }
WorldBuildersHandbook >> minimumAllowableOrbit: aStar [

	^ self
		  interpolatedLookup: minimumAllowableOrbit
		  type: aStar stellarType
		  subtype: aStar subtype
		  class: aStar stellarClass
]

{ #category : 'orbit bans' }
WorldBuildersHandbook >> nearOrbitBand [

	^ OrbitBand label: #near from: 5.5 to: 11.5
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> nonSpecialStarType [

	| t |
	t := StarTypeTable new rollWithDM: 1.

	t == #Hot ifTrue: [ t := HotStarTypeTable new roll ].
	^ t
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> nonSpecialStarTypeWithRoll: withRoll [

	| t starTypeTable |
	starTypeTable := StarTypeTable new.

	t := withRoll
		     ifNil: [ starTypeTable rollwithDM: 1 ]
		     ifNotNil: [ starTypeTable roll: withRoll dm: 1 ].

	t == #Hot ifTrue: [ t := HotStarTypeTable new roll ].
	^ t
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> numberOfGasGiantsFor: aSolarSystem [

	| r dice |
	dice := DieRoller roller.
	r := dice roll: 2 d: 6.
	r <= 9
		ifTrue: [
			| table |
			table := GasGiantQuantityTable new.
			^ table rollFor: aSolarSystem ]
		ifFalse: [ ^ 0 ]
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> numberOfPlanetoidBeltsFor: aSolarSystem gasGiants: gasGiants [

	| r dice |
	dice := DieRoller roller.
	r := dice roll: 2 d: 6.
	r <= 9
		ifTrue: [
			^ PlanetoidBeltQuantityTable new
				  rollFor: aSolarSystem
				  gasGiants: gasGiants ]
		ifFalse: [ ^ 0 ]
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> numberOfTerrestrialPlanetsFor: solarSystem [
	"wbh: page 38"

	| c dice |
	dice := DieRoller roller.
	c := (dice roll: 2 d: 6) - 2 - solarSystem postStellarCount.
	c < 3
		ifTrue: [ ^ (dice roll: 1 d: 3) + 2 ]
		ifFalse: [ ^ c + (dice roll: 1 d: 3) - 1 ]
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> primaryStarClassification [
	"wbh: 14
		
	Randomly generate the spectral classification  of the primary star"

	| sc table |
	table := StarSubtypeTable new.
	sc := self createDefaultClassification.

	sc spectralType == #Hot ifTrue: [ self assignHotStarTypeTo: sc ].

	sc spectralType == #Special ifTrue: [
		Transcript
			show: 'special';
			cr.
		self assignSpecialStarTypeTo: sc ].

	sc subtype: (table
			 rollForStellarType: sc spectralType
			 stellarClass: sc spectralClass).

	^ sc
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> starOrbitOffset: star [
	"wbh: page 38"

	| offset |
	offset := star eccentricity <= 0.2
		          ifTrue: [ 1 ]
		          ifFalse: [ 2 ].
	(self farOrbitBand includes: star orbit) ifFalse: [
		star eccentricity > 0.5 ifTrue: [ offset := offset + 1 ] ].
	^ offset
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> starsAdjacentTo: aStar in: aSolarSystem [

	| bandMap starBand |
	bandMap := Dictionary newFrom: {
			           (#close -> 0).
			           (#near -> 1).
			           (#far -> 2) }.
	starBand := bandMap at: (self bandFor: aStar).

	^ (aSolarSystem secondaryStars select: [ :star | star ~= aStar ])
		  select: [ :star |
			  | i |
			  i := bandMap at: (self bandFor: star).
			  (starBand - i) abs <= 1 ]
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> temperatureForType: type subtype: subtype [

	| typeIndex lowerBound upperBound lowerTemp upperTemp factor |
	typeIndex := typeOrder indexOf: type.
	lowerBound := typeIndex * 2 + (subtype >= 5 ifTrue: [ 0 ] ifFalse: [ -1 ]).
	upperBound := lowerBound + 1.

	lowerTemp := temperatures at: lowerBound.
	upperTemp := temperatures at: upperBound.

	factor := subtype < 5 ifTrue: [ subtype / 5.0 ] ifFalse: [(subtype -5)/5.0].
	
	^ lowerTemp + (factor * (upperTemp - lowerTemp))
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> whiteDwarfInterpolate: age values: values [
	"wbh: 227"

	| years lowerIndex upperIndex x0 x1 y0 y1 slope |
	years := #( 0.000 0.1 0.5 1 1.5 2.5 5 10 13 ).

	age > years last ifTrue: [
		x0 := years at: years size - 1.
		x1 := years last.
		y0 := values at: years size - 1.
		y1 := values last.

		slope := y1 - y0 / (x1 - x0).
		^ y1 + (slope * (age - x1)) ].


	lowerIndex := (years findLast: [ :year | year <= age ]) ifNil: [ 1 ].
	upperIndex := (years findFirst: [ :year | year >= age ]) ifNil: [
		              years size ].

	(years at: lowerIndex) = age ifTrue: [ ^ values at: lowerIndex ].
	(years at: upperIndex) = age ifTrue: [ ^ values at: upperIndex ].

	x0 := years at: lowerIndex.
	x1 := years at: upperIndex.
	y0 := values at: lowerIndex.
	y1 := values at: upperIndex.

	^ y0 + (age - x0 / (x1 - x0) * (y1 - y0))
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> whiteDwarfTemperature: age [
	"wbh: 227"

	^ self
		  whiteDwarfInterpolate: age
		  values: #( 100000 25000 10000 8000 7000 5500 5000 4000 3800 )
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> whiteDwarfTemperatureForMass: mass age: age [
	"wbh: 227"

	| t |
	t := self whiteDwarfTemperature: age.
	^ t * mass / 0.6
]
