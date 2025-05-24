"
WBH: pg 82

Generate taint for an atmosphere.
"
Class {
	#name : 'TaintGenerator',
	#superclass : 'Object',
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'generators' }
TaintGenerator >> assignTaint: atmosphere [

	| taint subtype |

	subtype := TaintTable new rollForAtmosphere: atmosphere.
	taint := AtmosphereTaint newWithSubtype: subtype.
	atmosphere taint: taint.
	taint severity: (TaintSeverityTable new rollFor: atmosphere).
	taint persistence: (TaintPersistenceTable new rollFor: atmosphere)
]
