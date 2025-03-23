Class {
	#name : 'StarCatalogTest',
	#superclass : 'TestCase',
	#category : 'Traveller-WorldBuildersHandbook-Tests',
	#package : 'Traveller-WorldBuildersHandbook-Tests'
}

{ #category : 'tests' }
StarCatalogTest >> testSubtypeInterpolate [

	| v l u subtype result expected |
	v := #( 2400 1850 1300 900 550 300 ).
	l := 1.
	u := 2.
	subtype := 0.
	expected := 2400.
	result := StarCatalog
		          subtypeInterpolate: v
		          lower: l
		          upper: u
		          subtype: subtype.
	self assert: result equals: expected.
	
	subtype := 1.
	expected := 2290.
	result := StarCatalog
		          subtypeInterpolate: v
		          lower: l
		          upper: u
		          subtype: subtype.
	self assert: result equals: expected.
	
	subtype := 4.
	expected := 1960.
	result := StarCatalog
		          subtypeInterpolate: v
		          lower: l
		          upper: u
		          subtype: subtype.
	self assert: result equals: expected.
	
	l := 2.
	u := 3.
	subtype := 5.
	expected := 1850.
	result := StarCatalog
		          subtypeInterpolate: v
		          lower: l
		          upper: u
		          subtype: subtype.
	self assert: result equals: expected.
	
	l := 2.
	u := 3.
	subtype := 6.
	expected := 1740.
	result := StarCatalog
		          subtypeInterpolate: v
		          lower: l
		          upper: u
		          subtype: subtype.
	self assert: result equals: expected.
	
	l := 2.
	u := 3.
	subtype := 9.
	expected := 1410.
	result := StarCatalog
		          subtypeInterpolate: v
		          lower: l
		          upper: u
		          subtype: subtype.
	self assert: result equals: expected.
	

]

{ #category : 'tests' }
StarCatalogTest >> testSubtypeInterpolatePastEnd [

	| v l u subtype result expected |
	v := #( 2400 1850 1300 900 550 300 ).
	
	l := 6.
	u := 7.
	subtype := 5.
	expected := 300.
	result := StarCatalog
		          subtypeInterpolate: v
		          lower: l
		          upper: u
		          subtype: subtype.
	self assert: result equals: expected.
	
	subtype := 6.
	expected := 250.
	result := StarCatalog
		          subtypeInterpolate: v
		          lower: l
		          upper: u
		          subtype: subtype.
	self assert: result equals: expected.
		
	subtype := 9.
	expected := 100.
	result := StarCatalog
		          subtypeInterpolate: v
		          lower: l
		          upper: u
		          subtype: subtype.
	self assert: result equals: expected.
	

]
