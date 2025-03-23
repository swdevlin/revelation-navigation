"
Reference data for stars

Helper functions for calculating star data, such as mass or temperature.
"
Class {
	#name : 'StarCatalog',
	#superclass : 'Object',
	#instVars : [
		'massData',
		'typeOrder',
		'classOrder',
		'colours',
		'temperatures',
		'diameters',
		'luminosity'
	],
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'as yet unclassified' }
StarCatalog class >> subtypeInterpolate: vector lower: lower upper: upper subtype: subtype [

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
StarCatalog >> colourForType: type [

	^ colours at: type

]

{ #category : 'as yet unclassified' }
StarCatalog >> diameterForType: type subtype: subtype class: class [

	^ self
		  interpolatedLookup: diameters 
		  type: type
		  subtype: subtype
		  class: class
]

{ #category : 'initialization' }
StarCatalog >> initialize [

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
	                 #( 90000 19000 7300 1200 nil 0.00029 0.00019 ) )
]

{ #category : 'as yet unclassified' }
StarCatalog >> interpolate: vector lowerBound: lower upperBound: upper subtype: subtype [

	| lowerValue upperValue factor |
	lowerValue := vector at: lower.
	upperValue := vector at: upper.

	factor := subtype < 5
		          ifTrue: [ subtype / 5.0 ]
		          ifFalse: [ subtype - 5 / 5.0 ].

	^ lowerValue + (factor * (upperValue - lowerValue))
]

{ #category : 'as yet unclassified' }
StarCatalog >> interpolatedLookup: table type: type subtype: subtype class: class [

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
StarCatalog >> luminosityForType: type subtype: subtype class: class [

	^ self
		  interpolatedLookup: luminosity 
		  type: type
		  subtype: subtype
		  class: class
]

{ #category : 'as yet unclassified' }
StarCatalog >> massForType: type subtype: subtype class: class [

	^ self
		  interpolatedLookup: massData
		  type: type
		  subtype: subtype
		  class: class
]

{ #category : 'as yet unclassified' }
StarCatalog >> temperatureForType: type subtype: subtype [

	| typeIndex lowerBound upperBound lowerTemp upperTemp factor |
	typeIndex := typeOrder indexOf: type.
	lowerBound := typeIndex * 2 + (subtype >= 5 ifTrue: [ 0 ] ifFalse: [ -1 ]).
	upperBound := lowerBound + 1.

	lowerTemp := temperatures at: lowerBound.
	upperTemp := temperatures at: upperBound.

	factor := subtype < 5 ifTrue: [ subtype / 5.0 ] ifFalse: [(subtype -5)/5.0].
	
	^ lowerTemp + (factor * (upperTemp - lowerTemp))
]
