class Person extends Object
  constructor: (@firstName, @lastName, gender) ->
    @_gender = gender
    @_familyMembers = ['dad', 'mom', 'brother', 'sister']
    @_handPhones = ['iPhone', 'Samsung']

  @property "readwrite", "firstName"

  @property "lastName"

  @property "strong", "age"

  @property "readonly", "gender"

  @property "writeonly", "reputation"

  @property "name",
    set: (newName) -> [@firstName, @lastName] = newName.split ' '
    get: -> "#{@firstName} #{@lastName}"

  @property "readwrite", "copy", "familyMembers"

  @property "readonly", "strong", "handPhones"

describe "Property accessor:", ->

  beforeEach ->
    @person = new Person("James", "Last", "male")

  describe "accessibility:", ->

    describe "readwrite property", ->

      it "can set new value", ->
        @person.firstName = "First"
        @person.lastName = "Love"
        expect(@person.firstName).toEqual "First"
        expect(@person.lastName).toEqual "Love"

      it "can get current value", ->
        expect(@person.firstName).toEqual "James"
        expect(@person.lastName).toEqual "Last"

    describe "readonly property", ->

      it "can get current value", ->
        expect(@person.gender).toEqual "male"

      it "cannot set new value", ->
        expect( ->
          @person.gender = "female"
          ).toThrow()

    describe "writeonly property", ->

      it "cannot get current value", ->
        expect( ->
          @person.reputation
          ).toThrow()

      it "can set current value", ->
        @person.reputation = "nice"
        expect(@person._reputation).toEqual "nice"

  describe "referencing:", ->

    describe "strong", ->

      it "returns itself when gets", ->
        handPhones = @person.handPhones
        handPhones.push('China Xiaomi')
        expect(@person.handPhones.length).toBe 3

    describe "copy", ->

      it "returns a copy of the object", ->
        familyMembers = @person.familyMembers
        familyMembers.push('monster')
        expect(@person.familyMembers.length).toBe 4

  describe "accessor functions:", ->

    describe "setter", ->

      it "is used when specified", ->
        @person.name = "Equal Humanity"
        expect(@person.lastName).toBe "Humanity"
        expect(@person.firstName).toBe "Equal"

      it "has default setter when not specified", ->
        @person.age = 30
        expect(@person.age).toBe 30

      xit "is not used if property is readonly", ->

    describe "getter", ->

      it "is used when specified", ->
        @person.firstName = "Jasmine"
        expect(@person.name).toBe "Jasmine Last"

      it "has default getter when not specified", ->
        @person.age = 40
        expect(@person.age).toBe 40

      xit "is not used if property is writeonly", ->

  it "throw errors on defining if argument count is less than 1", ->
    expect( ->
      Person.property()
      ).toThrow()
