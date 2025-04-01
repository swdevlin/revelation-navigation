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
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'as yet unclassified' }
WorldBuildersHandbook class >> eccentricityTable [

	^ RollTable new
		  initializeWithDictionary: (Dictionary newFrom: {
					   (5 -> [ DieRoller roller floatBetween: 0.0 and: 0.005 ]).
					   (6 -> [ DieRoller roller floatBetween: 0.005 and: 0.035 ]).
					   (7 -> [ DieRoller roller floatBetween: 0.005 and: 0.035 ]).
					   (8 -> [ DieRoller roller floatBetween: 0.035 and: 0.095 ]).
					   (9 -> [ DieRoller roller floatBetween: 0.035 and: 0.095 ]).
					   (10 -> [ DieRoller roller floatBetween: 0.095 and: 0.35 ]).
					   (11 -> [ DieRoller roller floatBetween: 0.15 and: 0.65 ]).
					   (12 -> [ DieRoller roller floatBetween: 0.4 and: 0.9 ]) })
		  named: 'Eccentricity'
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook class >> gasGiantQuantityTable [

	^ RollTable new
		  initializeWithDictionary: (Dictionary newFrom: {
					   (4 -> 1).
					   (5 -> 2).
					   (6 -> 2).
					   (7 -> 3).
					   (8 -> 3).
					   (9 -> 4).
					   (10 -> 4).
					   (11 -> 4).
					   (12 -> 5).
					   (13 -> 6) })
		  named: 'GasGiantQuantity'
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook class >> inclinationTable [

	^ RollTable new
		  initializeWithDictionary: (Dictionary newFrom: {
					   (2 -> [ DieRoller roller floatBetween: 0.5 and: 3.0 ]).
					   (3 -> [ DieRoller roller floatBetween: 0.5 and: 3.0 ]).
					   (4 -> [ DieRoller roller floatBetween: 0.5 and: 3.0 ]).
					   (5 -> [ DieRoller roller floatBetween: 0.5 and: 3.0 ]).
					   (6 -> [ DieRoller roller floatBetween: 0.5 and: 3.0 ]).
					   (7 -> [ DieRoller roller floatBetween: 1.0 and: 6.0 ]).
					   (8 -> [ DieRoller roller roll: 2 d: 6 ]).
					   (9 -> [ (DieRoller roller roll: 2 d: 6) * 3 + (DieRoller roller roll: 1 d: 6) ]).
					   (10 -> [ (DieRoller roller roll: 1 d: 6) + 2 * 5 ]).
					   (11 -> [ (DieRoller roller roll: 3 d: 6) + 5 - (DieRoller roller roll: 1 d: 6)]).
					   (12 -> [ 90 + self class inclinationTable ]) })
		  named: 'Eccentricity'
]

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
WorldBuildersHandbook >> assignHotStarTypeTo: sc [

	sc spectralType: RollTable hotStarType roll.

]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> assignSpecialStarTypeTo: sc [
	"wbh: 15,16"

	| type |
	sc spectralClass: RollTable specialStarClass roll.

	sc spectralClass == #Giant ifTrue: [
		sc spectralClass: RollTable giantStarClass roll.
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

	| catalog |
	catalog := StarCatalog new.
	star
		eccentricity:
			(self
				 calculateEccentricityFor: star
				 orbiting: parent
				 in: solarSystem);
		inclination: self calculateInclination;
		mass: (catalog
				 massForType: star stellarType
				 subtype: star subtype
				 class: star stellarClass);
		colour: (catalog colourForType: star stellarType );
		diameter: (catalog
				 diameterForType: star stellarType 
				 subtype: star subtype
				 class: star stellarClass );
		temperature:
			(catalog
				 temperatureForType: star stellarType 
				 subtype: star subtype);
		age: (self calculateAgeFor: star)
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

	| r table dm modifierMap |
	
	modifierMap := Dictionary newFromPairs: {
			               (Star -> 2).
			               (Planetoid -> 1) }.

	dm := modifierMap at: stellarObject class ifAbsent: [ 0 ].
	star companion ifNotNil: [ dm := dm + 1 ].
	(stellarObject orbit < 1 and: solarSystem primary age > 1) ifTrue: [
		dm := dm - 1 ].
	table := self class eccentricityTable.

	table mod: dm.
	r := ((table roll max: 0) min: 0.999) roundTo: 0.001.

	^ r
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> calculateInclination [

	^ self class inclinationTable roll roundTo: 0.1
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> createDefaultClassification [

	| sc starTypeTable |
	starTypeTable := RollTable starType.
	sc := SpectralClassification new
		spectralClass: 'V';
		spectralType: (starTypeTable roll).
	^ sc
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> gasGiantQuantityDMFor: aSolarSystem [

	| dm |
	dm := 0.

	(aSolarSystem starCount = 1 and:
		 aSolarSystem primary stellarClass = 'V') ifTrue: [ dm := dm + 1 ].

	aSolarSystem primary isBrownDwarf ifTrue: [ dm := dm - 2 ].

	aSolarSystem primary isPostStellar ifTrue: [ dm := dm - 2 ].

	aSolarSystem starCount >= 4 ifTrue: [ dm := dm - 1 ].

	^ dm
]

{ #category : 'generate star' }
WorldBuildersHandbook >> generateCompanionFor: star in: solarsystem [
	" wbh: 29"

	| result dm table companion dice |
	dice := DieRoller roller.
	dm := (#( 'III' 'IV' ) includes: star stellarClass)
		      ifTrue: [ -1 ]
		      ifFalse: [ 0 ].
	table := RollTable companionStarDetermination.
	table mod: dm.
	result := table roll.

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
			subtype := RollTable mPrimarySubtype roll.
			subtype < aStar subtype ifTrue: [ stellarType := 'BD' ] ]
		ifFalse: [
			stellarType := aStar coolerType.
			subtype := RollTable starSubtype roll ].

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

	temperature := StarCatalog
		               subtypeInterpolate: Star brownDwarfTemperature
		               lower: lower
		               upper: upper
		               subtype: subtype.

	luminosity := StarCatalog
		              subtypeInterpolate: Star brownDwarfLuminosity
		              lower: lower
		              upper: upper
		              subtype: subtype.

	diameter := 0.1.

	type = 'L' ifTrue: [
		diameter := StarCatalog
			            subtypeInterpolate: #( 0.08 0.06 )
			            lower: 1
			            upper: 2
			            subtype: subtype ].

	type = 'T' ifTrue: [
		diameter := StarCatalog
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

	| star catalog sc |
	sc := self primaryStarClassification.

	catalog := StarCatalog new.
	star := Star new.
	star
		spectralClassification: sc;
		mass: (catalog
				 massForType: sc spectralType
				 subtype: sc subtype
				 class: sc spectralClass);
		temperature:
			(catalog temperatureForType: sc spectralType subtype: sc subtype);
		diameter: (catalog
				 diameterForType: sc spectralType
				 subtype: sc subtype
				 class: sc spectralClass);
		colour: (catalog colourForType: sc spectralType);
		age: (self calculateAgeFor: star);
		orbitPosition: 0 @ 0;
		inclination: 0;
		eccentricity: 0;
		orbit: 0.

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
WorldBuildersHandbook >> generateSecondaryFor: solarSystem inBand: bandRange [
	" wbh: 29"

	| primary result dm table secondary companion |
	primary := solarSystem primary.
	dm := (#( 'III' 'IV' ) includes: primary stellarClass)
		      ifTrue: [ -1 ]
		      ifFalse: [ 0 ].
	table := RollTable secondaryStarDetermination.
	table mod: dm.
	result := table roll.

	secondary := self generateStarFromNonPrimaryResult: result for: primary.

	secondary orbit:
		(DieRoller roller floatBetween: bandRange x and: bandRange y).

	secondary eccentricity: (self
			 calculateEccentricityFor: secondary
			 orbiting: primary
			 in: solarSystem).

	self hasCompanion ifTrue: [
		companion := self generateCompanionFor: secondary in: solarSystem.
		secondary companion: primary ].

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
		star := self generateCompanionFor: primary in: solarSystem .
		primary companion: star ].

	#( (0.5 @ 5.5) (5.5 @ 11.5) (11.5 @ 17) ) do: [ :orbitBand |
		self hasSecondary ifTrue: [
			star := self
				        generateSecondaryFor: solarSystem
				        inBand: orbitBand.
			solarSystem addStar: star ] ].

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
WorldBuildersHandbook >> hasCompanion [
	"wbh: 23"

	^ (DieRoller roller roll: 2 d: 6) >= 10
]

{ #category : 'testing' }
WorldBuildersHandbook >> hasSecondary [
	"wbh: 23"

	^ (DieRoller roller roll: 2 d: 6) >= 10
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> nonSpecialStarType [

	| t starTypeTable |
	starTypeTable := RollTable starType.
	starTypeTable mod: 1.

	t := starTypeTable roll.

	t == #Hot ifTrue: [ t := RollTable hotStarType roll ].
	^ t
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> nonSpecialStarTypeWithRoll: withRoll [

	| t starTypeTable |
	starTypeTable := RollTable starType.
	starTypeTable mod: 1.

	t := withRoll
		     ifNil: [ starTypeTable roll ]
		     ifNotNil: [ starTypeTable roll: withRoll ].

	t == #Hot ifTrue: [ t := RollTable hotStarType roll ].
	^ t
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> numberOfGasGiantsFor: aSolarSystem [

	| r dice |
	dice := DieRoller roller.
	r := dice roll: 2 d: 6.
	r <= 9
		ifTrue: [ ^ self class gasGiantQuantityTable roll ]
		ifFalse: [ ^ 0 ]
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> planetoidBeltQuantityDMFor: aSolarSystem gasGiants: gasGiants [

	| dm |
	dm := 0.
	gasGiants > 0 ifTrue: [ dm := dm + 1 ].
	aSolarSystem primary isProtoStar ifTrue: [ dm := dm + 3 ].
	aSolarSystem primary isPrimordial ifTrue: [ dm := dm + 2 ].
	aSolarSystem primary isPostStellar ifTrue: [ dm := dm + 1 ].
	aSolarSystem starCount >= 2 ifTrue: [ dm := dm + 1 ].
	dm := dm + aSolarSystem postStellarCount.
	^ dm
]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> primaryStarClassification [
	"wbh: 14
		
	Randomly generate the spectral classification  of the primary star"

	| sc |
	sc := self createDefaultClassification.

	sc spectralType == #Hot ifTrue: [ self assignHotStarTypeTo: sc ].

	sc spectralType == #Special ifTrue: [
		Transcript show: 'special'; cr.
		self assignSpecialStarTypeTo: sc ].

	sc subtype: (RollTable starSubtype
			 rollForStellarClass: sc spectralClass
			 stellarType: sc spectralType).

	^ sc



	"	| sc starTypeTable type class hotStarTable nonSpecialStarType |
	starTypeTable := RollTable starType.
	hotStarTable := RollTable hotStarType.

	sc := SpectralClassification
		      new;
		      spectralClass: 'V';
		      yourself.

	nonSpecialStarType := [ :withRoll |
	                      | t |
	                      starTypeTable mod: 1.
	                      withRoll
		                      ifNil: [ t := starTypeTable roll ]
		                      ifNotNil: [ t := starTypeTable roll: withRoll ].
	                      t == #Hot ifTrue: [
		                      t := RollTable hotStarType roll ].
	                      t ].

	sc spectralType: starTypeTable roll.

	sc spectralType == #Hot ifTrue: [
		sc spectralType: RollTable hotStarType roll ].

	sc spectralType == #Special ifTrue: [
		sc spectralClass: RollTable specialStarClass roll.
		sc spectralClass == #Giant
			ifTrue: [
				class := RollTable giantStarClass roll.
				type := nonSpecialStarType value: nil ]
			ifFalse: [
				type := nonSpecialStarType value: nil.
				class == 'IV' ifTrue: [
					type == 'M' ifTrue: [
						| r |
						r := 5 + starTypeTable lastRoll.
						type := nonSpecialStarType value: r.
						type == 'O' ifTrue: [ type := 'B' ] ] ].
				class == 'VI' ifTrue: [
					type == 'F' ifTrue: [ type := 'G' ].
					type == 'A' ifTrue: [ type := 'B' ] ] ] ].

	sc subtype: (RollTable starSubtype
			 rollForStellarClass: sc spectralClass
			 stellarType: sc spectralType).

	^ sc"
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
