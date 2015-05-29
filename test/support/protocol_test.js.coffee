root = exports ? this

describe "Protocol:", ->

  beforeAll ->
    protocol "Speakable", "speak"
    protocol "Understandable", "understand"
    protocol "MyDelegate", "iDidEat", "iDidDrink", Speakable, Understandable

  describe "declaring a protocol", ->

    beforeEach ->
      protocol "Testable", "test1", "test2"

    afterEach ->
      root.Testable = false

    it "with protocol fake keyword", ->
      expect( ->
        protocol "TestableTwo", "good_method", "required_method"
        ).not.toThrow()

    it "throws error if redeclaring", ->
      expect( ->
        protocol "Testable", "redeclaring"
        ).toThrow(new CB.ProtocolRedefinedError)

    describe "creates an object in global namespace:", ->

      it "the object should be found", ->
        expect(typeof root.Testable).toBe 'object'

      it "the object should be an instance of Protocol", ->
        expect(root.Testable.class).toBe Protocol

      it "the object should be accessible from any scope", ->
        expect(root.Testable).toBe Testable
        oneMoreScope = -> expect(root.Testable).toBe Testable
        oneMoreScope()

    it "assigns name of the object", ->
      expect(Testable.name).toBe "Testable"

    it "assigns methods of the object", ->
      expect(Testable.methods).toEqual ["test1", "test2"]

    it "assigns parents of the object", ->
      protocol "TestableThree", "test3", "test4"
      protocol "TestableFour", "test5", "test6", TestableThree, Testable
      expect(TestableFour.parents).toEqual [TestableThree, Testable]

  describe "Protocol objects:", ->

    describe "its methods can not be changed", ->

      it "by assign new value", ->
        expect( ->
          MyDelegate.methods = []
          ).toThrow()

      it "by manipulate the array", ->
        myMethods = MyDelegate.methods
        myMethods.push("badMethod")
        expect(MyDelegate.methods.length).toBe 2

    describe "its parents can not be changed", ->

      it "by assign new value", ->
        expect( ->
          MyDelegate.parents = []
          ).toThrow()

      it "by manipulate the array", ->
        mySuperProtocols = MyDelegate.parents
        mySuperProtocols.push("badSuper")
        expect(MyDelegate.parents.length).toBe 2

  describe "Protocol examine:", ->

    it "didn't throw if a class implements the required methods", ->
      expect( ->
        class MyFriend
          speak: () ->
          navigate: () ->
          @provided Speakable
        ).not.toThrow()

    it "throw error if a class doesn't implement the required methods", ->
      expect( ->
        class MyFriend
          cannotspeak: () ->
          navigate: () ->
          @provided Speakable
        ).toThrow(new CB.ProtocolNotCompletelyImplementedError)

    it "throw error if parent protocols are not satisfied", ->
      expect( ->
        class MyFriend
          iDidEat: () ->
          iDidDrink: () ->
          @provided MyDelegate
        ).toThrow(new CB.ProtocolNotCompletelyImplementedError)

    it "doesn't throw error if parent protocols and this protocol\
     are satisfied", ->
      expect( ->
        class MyFriend
          iDidEat: () ->
          iDidDrink: () ->
          speak: () ->
          understand: () ->
          @provided MyDelegate
        ).not.toThrow()

    it "add the protocol to the class' implementedProtocols", ->
      class MyFriend
        iDidEat: () ->
        iDidDrink: () ->
        speak: () ->
        understand: () ->
        @provided MyDelegate
      expect(MyFriend.implementedProtocols).toEqual [MyDelegate,
       Speakable, Understandable]
