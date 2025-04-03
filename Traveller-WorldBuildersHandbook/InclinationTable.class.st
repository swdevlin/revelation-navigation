"
wbh: 28
"
Class {
	#name : 'InclinationTable',
	#superclass : 'RollTable',
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'initialization' }
InclinationTable >> initialize [

	super initialize.
	table := Dictionary newFrom: {
			         (2 -> [ DieRoller roller floatBetween: 0.5 and: 3.0 ]).
			         (3 -> [ DieRoller roller floatBetween: 0.5 and: 3.0 ]).
			         (4 -> [ DieRoller roller floatBetween: 0.5 and: 3.0 ]).
			         (5 -> [ DieRoller roller floatBetween: 0.5 and: 3.0 ]).
			         (6 -> [ DieRoller roller floatBetween: 0.5 and: 3.0 ]).
			         (7 -> [ DieRoller roller floatBetween: 1.0 and: 6.0 ]).
			         (8 -> [ DieRoller roller roll: 2 d: 6 ]).
			         (9 -> [
			          (DieRoller roller roll: 2 d: 6) * 3
			          + (DieRoller roller roll: 1 d: 6) ]).
			         (10 -> [ (DieRoller roller roll: 1 d: 6) + 2 * 5 ]).
			         (11 -> [
			          (DieRoller roller roll: 3 d: 6) + 5
			          - (DieRoller roller roll: 1 d: 6) ]).
			         (12 -> [ 90 + self class new roll ]) }
]
