Class {
	#name : 'OrbitTests',
	#superclass : 'TestCase',
	#category : 'Traveller-WorldBuildersHandbook-Tests',
	#package : 'Traveller-WorldBuildersHandbook-Tests'
}

{ #category : 'tests' }
OrbitTests >> testBands [

	| star wbh |
	wbh := WorldBuildersHandbook new.
	star := Star new.
	star orbit: wbh closeOrbitBand min.
	self assert: (wbh bandFor: star) equals: #close.
	
	star orbit: 0.001 + (wbh nearOrbitBand min).
	self assert: (wbh bandFor: star) equals: #near.
	
	star orbit: 0.002 + (wbh farOrbitBand min).
	self assert: (wbh bandFor: star) equals: #far.
	
]

{ #category : 'tests' }
OrbitTests >> testSecondaryOrbits [

	| star close near far solarSystem primary orbits wbh expected |
	wbh := WorldBuildersHandbook new.
	solarSystem := SolarSystem new.
	primary := Star newWithType: 'F' subtype: 5 class: 'V'.
	solarSystem primary: primary.
	wbh
		assignStarCharacteristicsTo: primary
		orbiting: nil
		in: solarSystem.

	"8. Close, Near or Far secondary stars have their own
centred orbits. These can extend up to an Orbit#
equal to their Orbit# minus 3, e.g., the Near star in
Orbit# 6.10 is allowed its own Orbit#s, centred on
itself, up to Orbit# 3.10."

	near := wbh
		        generateSecondaryFor: primary
		        in: solarSystem
		        inBand: wbh nearOrbitBand.
	solarSystem addStar: near.
	orbits := wbh calculateSecondaryAvailableOrbits: near in: solarSystem.
	expected := OrderedCollection new
		            add:
			            (wbh minimumAllowableOrbit: near) @ (near orbit - 3);
		            yourself.
	self assert: orbits equals: expected.

	"9. Reduce the allowed Orbit#s for each Close, Near
or Far secondary star by one Orbit# if the system
has stars in the adjacent zone, e.g., stars in Close
and Near, or in Near and Far, but not stars in
Close and Far only, so if the Near secondary star
mentioned above was in a system that also had a
Far star, it would only be able to use Orbit#s up to
2.10 from its centre. Note that the primary star does
not trigger this condition for any stars and that the
condition only triggers once, even if a Near star had
both Close and Far neighbours."
	close := wbh
		         generateSecondaryFor: primary
		         in: solarSystem
		         inBand: wbh closeOrbitBand.
	solarSystem addStar: close.

	orbits := wbh calculateSecondaryAvailableOrbits: near in: solarSystem.
	expected := OrderedCollection new
		            add:
			            (wbh minimumAllowableOrbit: near) @ (near orbit - 4);
		            yourself.
	self assert: orbits equals: expected.

	"10. Reduce the allowed Orbit#s for each Close, Near
or Far secondary star by one Orbit# if they or any
adjacent zone star has an eccentricity greater than
0.2, e.g., for the Near star if either it or the Far star
(or both) had an eccentricity of more than 0.2, then
the available orbits would be reduced to 1.10 for
the Near star and the Far star would also have its
available Orbit#s reduced by 1.00. As above, this
condition can only be triggered once per star."

	close eccentricity: 0.23.
	orbits := wbh calculateSecondaryAvailableOrbits: near in: solarSystem.
	expected := OrderedCollection new
		            add:
			            (wbh minimumAllowableOrbit: near) @ (near orbit - 5);
		            yourself.
	self assert: orbits equals: expected.

	"11"

	close eccentricity: 0.53.
	orbits := wbh calculateSecondaryAvailableOrbits: near in: solarSystem.
	expected := OrderedCollection new
		            add:
			            (wbh minimumAllowableOrbit: near) @ (near orbit - 6);
		            yourself.
	self assert: orbits equals: expected
]
