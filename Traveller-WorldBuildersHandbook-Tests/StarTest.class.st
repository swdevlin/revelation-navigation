Class {
	#name : 'StarTest',
	#superclass : 'RollerBaseTest',
	#category : 'Traveller-WorldBuildersHandbook-Tests',
	#package : 'Traveller-WorldBuildersHandbook-Tests'
}

{ #category : 'tests' }
StarTest >> testAdditionalStarCheck [

	| primary |

	"Has DM of 0"
	primary := Star newWithType: 'K' subtype: 7 class: 'V'.
   
	"Check on 10+"
	roller queueD: 6 value: 	5.
	roller queueD: 6 value: 	4.
	self deny: (primary multipleStarCheck) .

	"Check on 10+"
	roller queueD: 6 value: 	5.
	roller queueD: 6 value: 	5.
	self assert: (primary multipleStarCheck) .

	"DM +1"
	primary := Star newWithType: 'O' subtype: 7 class: 'III'.

	"Make sure DM is applied"
	roller queueD: 6 value: 	5.
	roller queueD: 6 value: 	4.
   
	self assert: (primary multipleStarCheck) .

]

{ #category : 'tests' }
StarTest >> testAgeCalculatedOnce [

	| star first second |
	star := Star newWithType: 'K' subtype: 7 class: 'V'.

	first := star age.	
	second := star age.	

	self assert: first equals: second.

]

{ #category : 'tests' }
StarTest >> testCompanionCheck [

	| star |
	star := Star newWithType: 'K' subtype: 5 class: 'V'.
	roller queueD: 6 value: 5.
	roller queueD: 6 value: 4.
	self deny: star companionCheck
]

{ #category : 'tests' }
StarTest >> testCoolerType [

	| star |
	star := Star newWithType: 'G' subtype: 7 class: 'V'.
	self assert: star coolerType equals: 'K'.
	
	star := Star newWithType: 'M' subtype: 7 class: 'V'.
	self assert: star coolerType equals: 'M'
	
]

{ #category : 'tests' }
StarTest >> testGenerateCompanionForStar [

	| star companion wbh solarSystem|
	wbh := WorldBuildersHandbook new.
	solarSystem := SolarSystem new.
	star := Star newWithType: 'K' subtype: 5 class: 'V'.
	solarSystem primary: star.
 	companion := wbh generateCompanionFor: star in: solarSystem .
	self assert: companion isNotNil.
]

{ #category : 'tests' }
StarTest >> testGenerateCompanionIfPresent [
| star |
	roller queueD: 6 value: 5.
	roller queueD: 6 value: 3.

	star := Star newWithType: 'K' subtype: 5 class: 'V'.
	star generateCompanionIfPresent.
	
	self assert: star companion isNil
	

]

{ #category : 'tests' }
StarTest >> testGenerateLesserFor [

	| star lesser wbh |
	wbh := WorldBuildersHandbook new.
	star := Star newWithType: 'K' subtype: 6 class: 'V'.
	lesser := wbh generateLesserFor: star.
	self assert: lesser stellarType equals: 'M'.
	self assert: lesser stellarClass equals: star stellarClass.

	star := Star newWithType: 'M' subtype: 0 class: 'V'.
	roller queueD: 6 value: 1.
	roller queueD: 6 value: 3.
	lesser := wbh generateLesserFor: star.
	self assert: lesser stellarType equals: 'M'.
	self assert: lesser stellarClass equals: star stellarClass.
	self assert: lesser subtype equals: 5.

	"Creates a brown dwarf"
	star := Star newWithType: 'M' subtype: 8 class: 'V'.
	roller queueD: 6 value: 1.
	roller queueD: 6 value: 3.
	lesser := wbh generateLesserFor: star.
	self assert: (#( 'Y' 'L' 'T' ) includes: lesser stellarType).
	self assert: lesser stellarClass isNil
]

{ #category : 'tests' }
StarTest >> testGenerateNewBrownDwarf [

	| star wbh |
	wbh := WorldBuildersHandbook new.
	"Make mass of 0.053"
	roller queueD: 6 value: 5.
	roller queueD: 6 value: 1.
	roller queueD: 6 value: 1.
	roller queueD: 6 value: 1.
	roller queueD: 6 value: 1.

	star := wbh generateNewBrownDwarf.

	self assert: star mass - 0.053 < 0.00001.
	self assert: star stellarType equals: 'L'.
	self assert: star subtype equals: 9.
	self assert: star stellarClass isNil.
	self assert: star temperature equals: 1410.
	self assert: star luminosity - 0.0000292 < 0.000001.

]

{ #category : 'tests' }
StarTest >> testGenerateRandomFor [

	| star newStar wbh |
	wbh := WorldBuildersHandbook new.
	star := Star newWithType: 'K' subtype: 6 class: 'V'.
	newStar := wbh generateRandomFor: star.
	self assert: (star isHotter: newStar)
]

{ #category : 'tests' }
StarTest >> testGenerateSecondaryForStar [

	| star secondary wbh solarSystem |
	wbh := WorldBuildersHandbook new.
	solarSystem := SolarSystem new.
	star := Star newWithType: 'K' subtype: 5 class: 'V'.
	solarSystem primary: star.
 	secondary := wbh generateSecondaryFor: solarSystem inBand: (2.5 @ 5.5).
	self assert: secondary isNotNil.
]

{ #category : 'tests' }
StarTest >> testGenerateSiblingFor [

	| star sibling wbh |
	wbh := WorldBuildersHandbook new.
	star := Star newWithType: 'K' subtype: 6 class: 'V'.
	roller queueD: 6 value: 1.
	sibling := wbh generateSiblingFor: star.
	self assert: sibling subtype equals: star subtype + 1.
	self assert: sibling stellarType equals: star stellarType.
	self assert: sibling stellarClass equals: star stellarClass.

	"M star stays M"
	star := Star newWithType: 'M' subtype: 6 class: 'V'.
	roller queueD: 6 value: 6.
	sibling := wbh generateSiblingFor: star.
	self assert: sibling subtype equals: 9.
	self assert: sibling stellarType equals: star stellarType.
	self assert: sibling stellarClass equals: star stellarClass.

	"Tick over to cooler"
	star := Star newWithType: 'F' subtype: 6 class: 'V'.
	roller queueD: 6 value: 6.
	sibling := wbh generateSiblingFor: star.
	self assert: sibling subtype equals: 2.
	self assert: sibling stellarType equals: 'G'.
	self assert: sibling stellarClass equals: star stellarClass
]

{ #category : 'tests' }
StarTest >> testGenerateWhiteDwarf [

	| wbh star |
	roller queueD: 6 value: 5.
	roller queueD: 6 value: 3.
	roller queueD: 10 value: 3.
	roller queueD: 3 value: 3.

	wbh := WorldBuildersHandbook new.
	star := wbh generateNewWhiteDwarf.
	self assert: star stellarType equals: 'D'.
	self assert: star subtype isNil.
	self assert: star stellarClass isNil.
	self assert: star mass equals: 7 / 10.0 + (3 / 100.0).
	self assert: star age equals: ((star mass) * 5).
]

{ #category : 'tests' }
StarTest >> testHasCompanion [

	| wbh |
	wbh := WorldBuildersHandbook new.

	roller queueD: 6 value: 2.
	roller queueD: 6 value: 2.

	self deny: wbh hasCompanion.
	roller queueD: 6 value: 6.
	roller queueD: 6 value: 6.

	self assert: wbh hasCompanion
]

{ #category : 'tests' }
StarTest >> testHasSecondary [

	| wbh |
	wbh := WorldBuildersHandbook new.

	roller queueD: 6 value: 2.
	roller queueD: 6 value: 2.

	self deny: wbh hasSecondary.
	roller queueD: 6 value: 6.
	roller queueD: 6 value: 6.

	self assert: wbh hasSecondary
]

{ #category : 'tests' }
StarTest >> testIsHotter [

	| coolerStar hotterStar |
	coolerStar := Star newWithType: 'A' subtype: 5 class: 'V'.
	hotterStar := Star newWithType: 'A' subtype: 4 class: 'V'.

	self assert: (hotterStar isHotter: coolerStar).
	self deny: (coolerStar isHotter: hotterStar).

	coolerStar := Star newWithType: 'F' subtype: 5 class: 'V'.

	self assert: (hotterStar isHotter: coolerStar).
	self deny: (coolerStar isHotter: hotterStar).

	
]

{ #category : 'tests' }
StarTest >> testIsPrimordial [
	"wbh 225"

	| star |
	star := Star new.
	star stellarClass: 'Ia'.
	self assert: star isPrimordial.

	star := Star new.
	star stellarClass: 'Ib'.
	self assert: star isPrimordial.

	star := Star new.
	star stellarClass: 'II'.
	self assert: star isPrimordial.


	star := Star new.
	star stellarType: 'O'.
	self assert: star isPrimordial.

	star := Star new.
	star stellarClass: 'V'.
	self deny: star isPrimordial
	"
All stars of Class Ia, Ib and II and all O-type stars
(except O subdwarf stars) are automatically hosts to
primordial systems.

"
]

{ #category : 'tests' }
StarTest >> testMultipleStarDM [

	| primary |
	primary := Star new.

	primary stellarType: 'BD'.
	self assert: primary multipleStarDM equals: -1.

	
	primary stellarType: 'D'.
	self assert: primary multipleStarDM equals: -1.
	
	primary stellarType: 'PSR'.
	self assert: primary multipleStarDM equals: -1.

	
	primary stellarType: 'NS'.
	self assert: primary multipleStarDM equals: -1.
	
	primary stellarType: 'BH'.
	self assert: primary multipleStarDM equals: -1.

	primary stellarType: 'V'.

	primary stellarClass: 'Ia'.
	self assert: primary multipleStarDM equals: 1.

	primary stellarClass: 'Ib'.
	self assert: primary multipleStarDM equals: 1.

	primary stellarClass: 'II'.
	self assert: primary multipleStarDM equals: 1.

	primary stellarClass: 'III'.
	self assert: primary multipleStarDM equals: 1.

	primary stellarClass: 'IV'.
	self assert: primary multipleStarDM equals: 1.

	primary stellarClass: 'V'.
	self assert: primary multipleStarDM equals: 0.

	primary stellarType: 'M'.
	primary stellarClass: 'V'.
	self assert: primary multipleStarDM equals: -1.

	primary stellarClass: 'VI'.
	self assert: primary multipleStarDM equals: -1.

	#( 'V' 'VI' ) do: [ :class |
		#( 'O' 'B' 'A' 'F' ) do: [ :type |
			primary stellarType: type.
			primary stellarClass: class.
			self assert: primary multipleStarDM equals: 1 ] ].
	

]

{ #category : 'tests' }
StarTest >> testOtherNonPrimary [

	| wbh star |
	wbh := WorldBuildersHandbook new.

	roller queueD: 6 value: 3.
	roller queueD: 6 value: 4.
	star := wbh generateOtherStar.
	self assert: star stellarType equals: 'D'.

	roller queueD: 6 value: 5.
	roller queueD: 6 value: 4.
	star := wbh generateOtherStar.
	self assert: (Star brownDwarfTypes includes: star stellarType)
]

{ #category : 'tests' }
StarTest >> testWhiteDwarfTemperature [

	| wbh t |
	wbh := WorldBuildersHandbook new.
	t := wbh whiteDwarfTemperature: 2.5.
	self assert: t equals: 5500.

	t := wbh whiteDwarfTemperature: 0.
	self assert: t equals: 100000.

	t := wbh whiteDwarfTemperature: 13.2.
	self assert: ((t - 3786.6666) abs < 0.0001).

]

{ #category : 'tests' }
StarTest >> testWhiteDwarfTemperatureMassAdjusted [

	| wbh t |
	wbh := WorldBuildersHandbook new.
	t := wbh whiteDwarfTemperatureForMass: 0.8 age: 2.5.
	self assert: t equals: 5500 * 0.8 / 0.6
]

{ #category : 'tests' }
StarTest >> testbrownDwarfTypeAndSubtypeFromMass [

	self assert: (Star brownDwarfTypeAndSubtypeFromMass: 0.08) equals: {'L' . 0}.

	self assert: (Star brownDwarfTypeAndSubtypeFromMass: 0.076) equals: {'L' . 1}.
	
	self assert: (Star brownDwarfTypeAndSubtypeFromMass: 0.072) equals: {'L' . 2}.

	self assert: (Star brownDwarfTypeAndSubtypeFromMass: 0.06) equals: {'L' . 5}.

	self assert: (Star brownDwarfTypeAndSubtypeFromMass: 0.058) equals: {'L' . 6}.

	self assert: (Star brownDwarfTypeAndSubtypeFromMass: 0.05) equals: {'T' . 0}.

	self assert: (Star brownDwarfTypeAndSubtypeFromMass: 0.04) equals: {'T' . 5}.

	self assert: (Star brownDwarfTypeAndSubtypeFromMass: 0.037) equals: {'T' . 6}.

	self assert: (Star brownDwarfTypeAndSubtypeFromMass: 0.013) equals: {'Y' . 5}.

	self assert: (Star brownDwarfTypeAndSubtypeFromMass: 0.013) equals: {'Y' . 5}.

	self assert: (Star brownDwarfTypeAndSubtypeFromMass: 0.0082) equals: {'Y' . 7}.

]
