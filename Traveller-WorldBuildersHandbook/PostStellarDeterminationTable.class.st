Class {
	#name : 'PostStellarDeterminationTable',
	#superclass : 'RollTable',
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'initialization' }
PostStellarDeterminationTable >> initialize [

	super initialize.
	table := Dictionary newFrom: {
			         (2 -> #Other).
			         (3 -> #Other).
			         (4 -> #Random).
			         (5 -> #Random).
			         (6 -> #Random).
			         (7 -> #Random).
			         (8 -> #Random).
			         (9 -> #Lesser).
			         (10 -> #Lesser).
			         (11 -> #Twin).
			         (12 -> #Twin) }
]
