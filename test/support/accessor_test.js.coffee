class Person extends Object
  constructor: (@first, @last, gender) ->
    @_gender = gender
  @property "name",
    get: -> "#{@first} #{@last}"
    set: (name) -> [@first, @last] = name.split ' '
  @property "age"
  @property "readonly", "gender"

describe "Property accessor", ->
  person = null
  beforeEach ->
    person = new Person("First", "Last", "male")
    person.age = 12
  it "gets", ->
    expect(person.name).toBe("First Last")
  it "sets", ->
    person.name = "Frank Liest"
    expect(person.name).toBe("Frank Liest")
    expect(person.first).toBe("Frank")
    expect(person.last).toBe("Liest")
  it "generates automatically", ->
    expect(person._age).toBe(12)
    expect(person.age).toBe(12)
  it "reads for readonly property", ->
    expect(person.gender).toBe("male")
  it "throws error when attempting to set readonly property", ->
    expect(-> person.gender = "female").toThrow()
  it "can change readonly property by set private instance variable", ->
    person._gender = "female"
    expect(person.gender).toBe("female")
