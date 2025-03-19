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
		'temperatures'
	],
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'as yet unclassified' }
StarCatalog >> colourForType: type [

	^ colours at: type

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
	                   5600 5200 4400 3700 3000 2400 )
]

{ #category : 'as yet unclassified' }
StarCatalog >> massForType: type subtype: subtype class: class [

	| typeIndex classIndex lowerBound upperBound lowerData upperData lowerMass upperMass factor |
	typeIndex := typeOrder indexOf: type.
	lowerBound := typeIndex * 2 + (subtype >= 5 ifTrue: [ 0 ] ifFalse: [ -1 ]).
	upperBound := lowerBound + 1.

	lowerData := massData at: lowerBound.
	upperData := massData at: upperBound.

	classIndex := classOrder indexOf: class.
	lowerMass := lowerData at: classIndex.
	upperMass := upperData at: classIndex.

	factor := subtype < 5 ifTrue: [ subtype / 5.0 ] ifFalse: [(subtype -5)/5.0].
	
	^ lowerMass + (factor * (upperMass - lowerMass))
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
