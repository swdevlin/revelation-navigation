"
Implement the rules that generate star systems.

wbh := WorldBuilderHandbook new.
solarSystem := wbh newSolarSystem.
star := wbh newStar.

"
Class {
	#name : 'WorldBuildersHandbook',
	#superclass : 'Object',
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'generate star' }
WorldBuildersHandbook >> generateCompanionFor: star [

	| t dm table |
	dm := (#( 'III' 'IV' ) includes: star stellarClass)
		      ifTrue: [ -1 ]
		      ifFalse: [ 0 ].
	table := RollTable companionStarDetermination.
	table mod: dm.
	t := table roll.

	t
		caseOf: {
				(#Other -> [
				 (DieRoller roller roll: 2 d: 6) < 8
					 ifTrue: [ ^ self generateNewWhiteDwarf ]
					 ifFalse: [ ^ self generateNewBrownDwarf ] ]).
				(#Random -> [
				 | c |
				 c := self generateNew.
				 (c isHotter: star)
					 ifTrue: [ ^ self generateLesserFor: star ]
					 ifFalse: [ ^ c ] ]).
				(#Lesser -> [ ^ self generateLesserFor: star ]).
				(#Sibling -> [ ^ self generateSiblingFor: star ]).
				(#Twin -> [
				 ^ Star
					   newWithType: star stellarType
					   subtype: star subtype
					   class: star stellarClass ]) }
		otherwise: [ self notImplemented ]
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
WorldBuildersHandbook >> generateNew [

	| starTypeTable star type class subtype hotStarTable nonSpecialStarType catalog |
	starTypeTable := RollTable starType.
	hotStarTable := RollTable hotStarType.

	nonSpecialStarType := [ :withRoll |
	                      | t |
	                      starTypeTable mod: 1.
	                      withRoll
		                      ifNil: [ t := starTypeTable roll ]
		                      ifNotNil: [ t := starTypeTable roll: withRoll ].
	                      t == #Hot ifTrue: [
		                      t := RollTable hotStarType roll ].
	                      t ].

	class := 'V'.

	type := starTypeTable roll.
	type == #Hot ifTrue: [ type := RollTable hotStarType roll ].

	type == #Special ifTrue: [
		class := RollTable specialStarClass roll.
		class == #Giant
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

	subtype := RollTable starSubtype
		           rollForStellarClass: class
		           stellarType: type.

	catalog := StarCatalog new.
	star := self new.
	star
		stellarClass: class;
		subtype: subtype;
		stellarType: type;
		mass: (catalog massForType: type subtype: subtype class: class);
		temperature: (catalog temperatureForType: type subtype: subtype);
		diameter: (catalog diameterForType: type subtype: subtype class: class);
		colour: (catalog colourForType: type) .

	^ star
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

^ self whiteDwarfInterpolate: age values:  #( 100000 25000 10000 8000 7000 5500 5000 4000 3800 )

]

{ #category : 'as yet unclassified' }
WorldBuildersHandbook >> whiteDwarfTemperatureForMass: mass age: age [
	"wbh: 227"

	| t |
	t := self whiteDwarfTemperature: age.
	^ t * mass / 0.6
]
