"
Mersenne Twister 19937 version
"
Class {
	#name : 'MersenneTwister',
	#superclass : 'Object',
	#instVars : [
		'mt',
		'index'
	],
	#classVars : [
		'LowerMask',
		'M',
		'MatrixA',
		'N',
		'UpperMask'
	],
	#category : 'Random-Dice',
	#package : 'Random-Dice'
}

{ #category : 'class initialization' }
MersenneTwister class >> initialize [

	N := 624.
	M := 397.
	MatrixA := 2567483615. " 0x9908b0df "
	UpperMask := 2147483648. " 0x80000000 "
	LowerMask := 2147483647 " 0x7fffffff "
]

{ #category : 'accessing' }
MersenneTwister class >> lowerMask [

	^ LowerMask
]

{ #category : 'accessing' }
MersenneTwister class >> lowerMask: anObject [

	LowerMask := anObject
]

{ #category : 'accessing' }
MersenneTwister class >> m [

	^ M
]

{ #category : 'accessing' }
MersenneTwister class >> m: anObject [

	M := anObject
]

{ #category : 'accessing' }
MersenneTwister class >> matrixA [

	^ MatrixA
]

{ #category : 'accessing' }
MersenneTwister class >> matrixA: anObject [

	MatrixA := anObject
]

{ #category : 'accessing' }
MersenneTwister class >> n [

	^ N
]

{ #category : 'accessing' }
MersenneTwister class >> n: anObject [

	N := anObject
]

{ #category : 'class initialization' }
MersenneTwister class >> newRandomSeeded [

	^ self newSeeded: Time millisecondClockValue
]

{ #category : 'class initialization' }
MersenneTwister class >> newSeeded: seed [

	^ self new initializeWithSeed: seed
]

{ #category : 'accessing' }
MersenneTwister class >> upperMask [

	^ UpperMask
]

{ #category : 'accessing' }
MersenneTwister class >> upperMask: anObject [

	UpperMask := anObject
]

{ #category : 'as yet unclassified' }
MersenneTwister >> extractNumber [
	" Extract a tempered value based on mt[index] "

	| y |
	(index >= self class n) ifTrue: [ self generateNumbers ].
	y := mt at: index.
	index := index + 1.

	" Tempering "
	y := y bitXor: y >> 11.
	y := y bitXor: (y << 7 bitAnd: 2636928640). " 0x9d2c5680 "
	y := y bitXor: (y << 15 bitAnd: 4022730752). " 0xefc60000 "
	y := y bitXor: y >> 18.

	^ y
]

{ #category : 'as yet unclassified' }
MersenneTwister >> generateNumbers [

	| y |
	1 to: self class n - self class m do: [ :k |
		y := ((mt at: k) bitAnd: self class upperMask)
		     + ((mt at: k + 1) bitAnd: self class lowerMask).
		mt at: k put: (y >> 1 bitXor: (y bitAnd: 1) * self class matrixA) ].
	self class n - self class m + 1 to: self class n - 1 do: [ :k |
		y := ((mt at: k) bitAnd: self class upperMask)
		     + ((mt at: k + 1) bitAnd: self class lowerMask).
		mt at: k put: (y >> 1 bitXor: (y bitAnd: 1) * self class matrixA) ].
	y := ((mt at: self class n) bitAnd: self class upperMask)
	     + ((mt at: 1) bitAnd: self class lowerMask).
	mt
		at: self class n
		put: (y >> 1 bitXor: (y bitAnd: 1) * self class matrixA).
	index := 1
]

{ #category : 'initialization' }
MersenneTwister >> initialize [ 
	mt := Array new: (self class n).
	index := (self class n).
]

{ #category : 'initialization' }
MersenneTwister >> initializeWithSeed: seed [
    | v |
    self initialize.
    mt at: 1 put: (seed bitAnd: 4294967295).

    2 to: (self class n) do: [:i |
	   v := ((1812433253 * ((mt at: i - 1) bitXor: ((mt at: i - 1) >> 30))) + i) bitAnd: 4294967295 .
      mt at: i put: v.
	].
]
