"
WBH: pg 102

Determine the possible list of liquids on a planet given average temperature of the planet.
"
Class {
	#name : 'ExoticLiquid',
	#superclass : 'Object',
	#instVars : [
		'name',
		'code',
		'boilingPoint',
		'meltingPoint',
		'relativeAbundance'
	],
	#classVars : [
		'Molecules'
	],
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'class initialization' }
ExoticLiquid class >> initialize [

	Molecules := OrderedCollection newFrom: {
			             (self new
				              name: 'Fluorine';
				              code: 'F2';
				              boilingPoint: 85;
				              meltingPoint: 53;
				              relativeAbundance: 2).
			             (self new
				              name: 'Oxygen';
				              code: 'O2';
				              boilingPoint: 90;
				              meltingPoint: 54;
				              relativeAbundance: 50).
			             (self new
				              name: 'Methane';
				              code: 'CH4';
				              boilingPoint: 113;
				              meltingPoint: 91;
				              relativeAbundance: 70).
			             (self new
				              name: 'Ethane';
				              code: 'C2H6';
				              boilingPoint: 184;
				              meltingPoint: 90;
				              relativeAbundance: 70).
			             (self new
				              name: 'Chlorine';
				              code: 'Cl2';
				              boilingPoint: 239;
				              meltingPoint: 171;
				              relativeAbundance: 1).
			             (self new
				              name: 'Ammonia';
				              code: 'NH3';
				              boilingPoint: 240;
				              meltingPoint: 195;
				              relativeAbundance: 30).
			             (self new
				              name: 'Sulphur Dioxide';
				              code: 'SO2';
				              boilingPoint: 263;
				              meltingPoint: 201;
				              relativeAbundance: 20).
			             (self new
				              name: 'Hydrofluoric Acid';
				              code: 'HF';
				              boilingPoint: 293;
				              meltingPoint: 190;
				              relativeAbundance: 2).
			             (self new
				              name: 'Hydrogen Cyanide';
				              code: 'HCN';
				              boilingPoint: 299;
				              meltingPoint: 260;
				              relativeAbundance: 30).
			             (self new
				              name: 'Hydrochloric Acid';
				              code: 'HCl';
				              boilingPoint: 321;
				              meltingPoint: 247;
				              relativeAbundance: 1).
			             (self new
				              name: 'Water';
				              code: 'H2O';
				              boilingPoint: 373;
				              meltingPoint: 273;
				              relativeAbundance: 100).
			             (self new
				              name: 'Formic Acid';
				              code: 'CH2O2';
				              boilingPoint: 374;
				              meltingPoint: 281;
				              relativeAbundance: 15).
			             (self new
				              name: 'Formamide';
				              code: 'CH3NO';
				              boilingPoint: 483;
				              meltingPoint: 275;
				              relativeAbundance: 15).
			             (self new
				              name: 'Carbonic Acid';
				              code: 'H2CO3';
				              boilingPoint: 607;
				              meltingPoint: 193;
				              relativeAbundance: 20).
			             (self new
				              name: 'Sulphuric Acid';
				              code: 'H2SO4';
				              boilingPoint: 718;
				              meltingPoint: 388;
				              relativeAbundance: 20) }
]

{ #category : 'accessing' }
ExoticLiquid class >> possibleLiquidsAt: temp [

	^ Molecules select: [ :molecule |
		  temp between: molecule meltingPoint and: molecule boilingPoint ]
]

{ #category : 'accessing' }
ExoticLiquid class >> randomLiquidAt: temp [

	| liquids totalWeight selection cumulative |
	liquids := self possibleLiquidsAt: temp.
	totalWeight := liquids sum: #relativeAbundance.
	selection := DieRoller roller randomInt: totalWeight.
	cumulative := 0.
	liquids do: [ :liquid |
		cumulative := cumulative + liquid relativeAbundance.
		cumulative > selection ifTrue: [ ^ liquid ] ]
]

{ #category : 'accessing' }
ExoticLiquid >> boilingPoint [

	^ boilingPoint
]

{ #category : 'accessing' }
ExoticLiquid >> boilingPoint: anObject [

	boilingPoint := anObject
]

{ #category : 'accessing' }
ExoticLiquid >> code [

	^ code
]

{ #category : 'accessing' }
ExoticLiquid >> code: anObject [

	code := anObject
]

{ #category : 'accessing' }
ExoticLiquid >> meltingPoint [

	^ meltingPoint
]

{ #category : 'accessing' }
ExoticLiquid >> meltingPoint: anObject [

	meltingPoint := anObject
]

{ #category : 'accessing' }
ExoticLiquid >> name [

	^ name
]

{ #category : 'accessing' }
ExoticLiquid >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
ExoticLiquid >> relativeAbundance [

	^ relativeAbundance
]

{ #category : 'accessing' }
ExoticLiquid >> relativeAbundance: anObject [

	relativeAbundance := anObject
]
