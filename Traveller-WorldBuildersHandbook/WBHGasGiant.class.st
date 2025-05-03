"
World Builder's Handbook implementation of a gas giant.
"
Class {
	#name : 'WBHGasGiant',
	#superclass : 'GasGiant',
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'as yet unclassified' }
WBHGasGiant >> hzcoOffset [

	^ orbit - orbiting hzco
]
