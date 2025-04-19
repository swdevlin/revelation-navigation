"
The World Builder's Handbook implementation of a solar system.

You instantiate an instance by sending the generateSolarSystem message to a WorldBuildersHandbook instance.
"
Class {
	#name : 'WBHSolarSystem',
	#superclass : 'SolarSystem',
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'as yet unclassified' }
WBHSolarSystem >> stars [

	^ OrderedCollection new
		  add: primary;
		  addAll: self secondaryStars;
		  yourself
]

{ #category : 'accessing' }
WBHSolarSystem >> totalAvailableOrbits [

	| totalOrbits |
	totalOrbits := primary totalAvailableOrbits.
	^ self secondaryStars
		  inject: totalOrbits
		  into: [ :sum :star | sum + star totalAvailableOrbits ]
]
