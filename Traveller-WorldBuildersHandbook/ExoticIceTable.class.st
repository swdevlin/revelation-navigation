"
wbh 71
"
Class {
	#name : 'ExoticIceTable',
	#superclass : 'RollTable',
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'initialization' }
ExoticIceTable >> initialize [
    super initialize.
    table := Dictionary newFrom: {
        (2 -> 0.03).
        (3 -> 0.06).
        (4 -> 0.09).
        (5 -> 0.12).
        (6 -> 0.15).
        (7 -> 0.18).
        (8 -> 0.21).
        (9 -> 0.24).
        (10 -> 0.27).
        (11 -> 0.30).
        (12 -> 0.33)
    }.
]
