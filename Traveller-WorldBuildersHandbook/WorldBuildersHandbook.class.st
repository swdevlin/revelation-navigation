"
Implement the rules that generate star systems.

wbh := WorldBuilderHandbook new.
solarSystem := wbh newSolarSystem.
star := wbh newStar.
primary := wbh generatePrimaryStar.

"
Class {
	#name : 'WorldBuildersHandbook',
	#superclass : 'Object',
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

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
WorldBuildersHandbook >> createDefaultClassification [

	| sc starTypeTable |
	starTypeTable := RollTable starType.
	sc := SpectralClassification new
		spectralClass: 'V';
		spectralType: (starTypeTable roll).
	^ sc
]

{ #category : 'generate star' }
WorldBuildersHandbook >> generateCompanionFor: star [
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

	star companion: companion
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
WorldBuildersHandbook >> generateSecondaryFor: star [
	" wbh: 29"

	| result dm table |
	dm := (#( 'III' 'IV' ) includes: star stellarClass)
		      ifTrue: [ -1 ]
		      ifFalse: [ 0 ].
	table := RollTable secondaryStarDetermination.
	table mod: dm.
	result := table roll.

	^ self generateStarFromNonPrimaryResult: result for: star
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
