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
	primary := Star generateNewType: 'K' subtype: 7 class: 'V'.
   
	"Check on 10+"
	roller queueD: 6 value: 	5.
	roller queueD: 6 value: 	4.
	self deny: (primary multipleStarCheck) .

	"Check on 10+"
	roller queueD: 6 value: 	5.
	roller queueD: 6 value: 	5.
	self assert: (primary multipleStarCheck) .

	"DM +1"
	primary := Star generateNewType: 'O' subtype: 7 class: 'III'.

	"Make sure DM is applied"
	roller queueD: 6 value: 	5.
	roller queueD: 6 value: 	4.
   
	self assert: (primary multipleStarCheck) .

]

{ #category : 'tests' }
StarTest >> testAgeCalculatedOnce [

	| star first second |
	star := Star generateNewType: 'K' subtype: 7 class: 'V'.

	first := star age.	
	second := star age.	

	self assert: first equals: second.

]

{ #category : 'tests' }
StarTest >> testCompanionCheck [

	| star |
	star := Star generateNewType: 'K' subtype: 5 class: 'V'.
	roller queueD: 6 value: 5.
	roller queueD: 6 value: 4.
	self deny: star companionCheck
]

{ #category : 'tests' }
StarTest >> testCoolerType [

	| star |
	star := Star generateNewType: 'G' subtype: 7 class: 'V'.
	self assert: star coolerType equals: 'K'.
	
	star := Star generateNewType: 'M' subtype: 7 class: 'V'.
	self assert: star coolerType equals: 'M'
	
]

{ #category : 'tests' }
StarTest >> testGenerateCompanionForStar [

	| star companion|
	star := Star generateNewType: 'K' subtype: 5 class: 'V'.
 	companion := Star generateCompanionFor: star.
	self assert: companion isNotNil.
]

{ #category : 'tests' }
StarTest >> testGenerateCompanionIfPresent [
| star |
	roller queueD: 6 value: 5.
	roller queueD: 6 value: 3.

	star := Star generateNewType: 'K' subtype: 5 class: 'V'.
	star generateCompanionIfPresent.
	
	self assert: star companion isNil
	

]

{ #category : 'tests' }
StarTest >> testGenerateLesserFor [

	| star lesser |
	star := Star generateNewType: 'K' subtype: 6 class: 'V'.
	lesser := Star generateLesserFor: star.
	self assert: lesser stellarType equals: 'M'.
	self assert: lesser stellarClass equals: star stellarClass.

	star := Star generateNewType: 'M' subtype: 0 class: 'V'.
	roller queueD: 6 value: 1.
	roller queueD: 6 value: 3.
	lesser := Star generateLesserFor: star.
	self assert: lesser stellarType equals: 'M'.
	self assert: lesser stellarClass equals: star stellarClass.
	self assert: lesser subtype equals: 5.

	"Creates a brown dwarf"
	star := Star generateNewType: 'M' subtype: 8 class: 'V'.
	roller queueD: 6 value: 1.
	roller queueD: 6 value: 3.
	lesser := Star generateLesserFor: star.
	self assert:( #('Y' 'L' 'T' ) includes: lesser stellarType).
	self assert: lesser stellarClass isNil.



]

{ #category : 'tests' }
StarTest >> testGenerateNewBrownDwarf [

	| star |
	"Make mass of 0.053"
	roller queueD: 6 value: 5.
	roller queueD: 6 value: 1.
	roller queueD: 6 value: 1.
	roller queueD: 6 value: 1.
	roller queueD: 6 value: 1.

	star := Star generateNewBrownDwarf.

	self assert: star mass - 0.053 < 0.00001.
	self assert: star stellarType equals: 'L'.
	self assert: star subtype equals: 9.
	self assert: star stellarClass isNil.
	self assert: star temperature equals: 1410.
	self assert: star luminosity - 0.0000292 < 0.000001.

]

{ #category : 'tests' }
StarTest >> testGenerateSiblingFor [

	| star sibling |
	star := Star generateNewType: 'K' subtype: 6 class: 'V'.
	roller queueD: 6 value: 1.
	sibling := Star generateSiblingFor: star.
	self assert: sibling subtype equals: star subtype + 1.
	self assert: sibling stellarType equals: star stellarType.
	self assert: sibling stellarClass equals: star stellarClass.

	"M star stays M"
	star := Star generateNewType: 'M' subtype: 6 class: 'V'.
	roller queueD: 6 value: 6.
	sibling := Star generateSiblingFor: star.
	self assert: sibling subtype equals: 9.
	self assert: sibling stellarType equals: star stellarType.
	self assert: sibling stellarClass equals: star stellarClass.

	"Tick over to cooler"
	star := Star generateNewType: 'F' subtype: 6 class: 'V'.
	roller queueD: 6 value: 6.
	sibling := Star generateSiblingFor: star.
	self assert: sibling subtype equals: 2.
	self assert: sibling stellarType equals: 'G'.
	self assert: sibling stellarClass equals: star stellarClass
]

{ #category : 'tests' }
StarTest >> testIsHotter [

	| coolerStar hotterStar |
	coolerStar := Star generateNewType: 'A' subtype: 5 class: 'V'.
	hotterStar := Star generateNewType: 'A' subtype: 4 class: 'V'.

	self assert: (hotterStar isHotter: coolerStar).
	self deny: (coolerStar isHotter: hotterStar).

	coolerStar := Star generateNewType: 'F' subtype: 5 class: 'V'.

	self assert: (hotterStar isHotter: coolerStar).
	self deny: (coolerStar isHotter: hotterStar).

	
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
