describe "Array core extension:", ->
  describe "each:", ->
    it "should iterate all objects", ->
      a = [1, 2, 3]; b = 0
      a.each (o) => b += o
      expect(b).toEqual(6)
    it "does nothing if array is empty", ->
      a = []; b = 0
      a.each (o) => b += o
      expect(b).toEqual(0)
  describe "remove:", ->
    it "should remove all found objects from array", ->
      a = [1, 2, 3, 4, 5, 6, 1, 2, 3, 1, 1]
      a.remove(1)
      expect(a).toEqual([2, 3, 4, 5, 6, 2, 3])
    it "should return the object if found", ->
      a = [1, 2, 3]
      expect(a.remove(1)).toEqual(1)
    it "should return null if not found", ->
      a = ["a", "b"]
      expect(a.remove("c")).toBe(null)
  describe "delete:", ->
    it "should have same behavior with remove", ->
      a = [1, 2, 3]
      b = [1, 2, 3]
      expect(a.remove(1)).toEqual(b.delete(1))
      expect(a.remove(4)).toEqual(b.delete(4))
      expect(a).toEqual(b)
  describe "insert:", ->
    it "insert object into array at given index", ->
      a = ["a", "c", "d"]
      a.insert(1, "b")
      expect(a).toEqual(["a", "b", "c", "d"])
    it "works for multiple arguments", ->
      a = ["a", "d", "e"]
      a.insert(1, "b", "c")
      expect(a).toEqual(["a", "b", "c", "d", "e"])
    it "returns the array", ->
      a = [1, 2, 3]
      expect(a.insert(3, 4)).toBe(a)
      expect(a).toEqual([1, 2, 3, 4])
  describe "first:", ->
    a = [1, 2, 3]; f = a.first()
    it "returns the first object of array", ->
      expect(f).toEqual(1)
    it "doesn't not mutate the array itself", ->
      expect(a).toEqual([1, 2, 3])
    it "returns undefined if array is empty", ->
      a = []; b = a.first()
      expect(b).toBe(undefined)
    it "returns array if n is given", ->
      a = [1, 2, 3]
      f = a.first(2)
      expect(f).toEqual([1, 2])
      f = a.first(0)
      expect(f).toEqual([])
  describe "last:", ->
    a = [1, 2, 3]; l = a.last()
    it "returns the last object of array", ->
      expect(l).toEqual(3)
    it "doesn't not mutate the array itself", ->
      expect(a).toEqual([1, 2, 3])
    it "returns undefined if array is empty", ->
      a = []; b = a.last()
      expect(b).toBe(undefined)
    it "returns array if n is given", ->
      a = [1, 2, 3]
      f = a.last(2)
      expect(f).toEqual([2, 3])
      f = a.last(0)
      expect(f).toEqual([])
      f = a.last(10)
      expect(f).toEqual([1, 2, 3])
  describe "collect:", ->
    it "should return collected values", ->
      a = [1,2,3,4,5]
      b = a.collect (v) => v * 3
      expect(b).toEqual([3, 6, 9, 12, 15])
    it "should return empty array if array is empty", ->
      a = []; b = a.collect (v) => v * 3
      expect(b).toEqual([])
  for countMethod in ["count", "size"]
    describe countMethod + ":", ->
      it "should return length of array", ->
        a = [1, 2, 3]
        expect(a[countMethod]()).toEqual(3)
  for reduceMethod in ["reduce", "inject"]
    describe reduceMethod + ":", ->
      a = [10, 1, 2, 3]
      result = a[reduceMethod] (memo, number) => memo - number
      it "reduces correctly", ->
        expect(result).toEqual(4)
      it "doesn't change the array", ->
        expect(a).toEqual([10, 1, 2, 3])
      it "receives initial value", ->
        a = [10, 1, 2, 3]
        result = a[reduceMethod] 100, (memo, number) => memo - number
        expect(result).toEqual(84)
      it "works for string", ->
        a = ["a", "b", "c", "d", "e"]
        result = a[reduceMethod]("concat")
        expect(result).toEqual("abcde")
      it "receives initial value for string", ->
        a = ["a", "b", "c", "d", "e"]
        result = a[reduceMethod]("0", "concat")
        expect(result).toEqual("0abcde")
  describe "reject:", ->
    a = [1, 2, 3, 4, 5, 6]
    b = a.reject (v) => (v % 3 == 0)
    it "returns failed testing value", ->
      expect(b).toEqual([1, 2, 4, 5])
    it "doesn't change the original array", ->
      expect(a).toEqual([1, 2, 3, 4, 5, 6])
  for selectMethod in ["select", "findAll"]
    describe selectMethod + ":", ->
      a = [1, 2, 3, 4, 5, 6]
      b = a[selectMethod] (v) => (v % 3 == 0)
      it "returns passed testing value", ->
        expect(b).toEqual([3, 6])
      it "doesn't change the original array", ->
        expect(a).toEqual([1, 2, 3, 4, 5, 6])
  for includeMethod in ["includes", "contains"]
    describe includeMethod + ":", ->
      it "should return true if contains", ->
        a = [1, 2, 3]
        expect(a[includeMethod](1)).toBe(true)
      it "should return false if not contains", ->
        a = [1, 2, 3]
        expect(a[includeMethod](4)).toBe(false)
  describe "uniq:", ->
    it "uniqs", ->
      a = [1, 1, 2, 2, 2, 3, 3, 3, 4, 5, 6, 7, 7]
      expect(a.uniq()).toEqual([1, 2, 3, 4, 5, 6 ,7])
    it "works with iterator", ->
      a = ["a", "b", "ac", "bc", "ad", "bd", "cd"]
      b = a.uniq (v) => v[0]
      expect(b).toEqual(["a", "b", "cd"])
  for detectMethod in ["find", "detect"]
    describe detectMethod + ":", ->
      it "return the first value if found", ->
        a = ["a", "b", "ac", "d", "cde", "qwe", "asdf"]
        b = a[detectMethod] (v) => v[0] == "c"
        expect(b).toEqual("cde")
      it "returns null if no value found", ->
        a = ["a", "b", "ac", "d", "cde", "qwe", "asdf"]
        b = a[detectMethod] (v) => v[0] == "e"
        expect(b).toEqual(null)
      it "returns default value if provided and not found", ->
        a = ["a", "b", "ac", "d", "cde", "qwe", "asdf"]
        b = a[detectMethod] "hello", (v) => v[0] == "e"
        expect(b).toEqual("hello")
      it "returns found value if found even if default provided", ->
        a = ["a", "b", "ac", "d", "cde", "qwe", "asdf"]
        b = a[detectMethod] "hello", (v) => v[0] == "a"
        expect(b).toEqual("a")
  describe "withoutLast:", ->
    a = [1, 2, 3, 4]
    b = a.withoutLast()
    c = a.withoutLast(2)
    it "returns all value but last", ->
      expect(b).toEqual([1, 2, 3])
    it "doesn't change itself", ->
      expect(a).toEqual([1, 2, 3, 4])
    it "accepts index argument", ->
      expect(c).toEqual([1, 2])
    it "returns [] if index is more than length", ->
      expect([1, 2].withoutLast(3)).toEqual([])
  describe "withoutFirst:", ->
    a = [1, 2, 3, 4]
    b = a.withoutFirst()
    c = a.withoutFirst(2)
    it "returns all value but first", ->
      expect(b).toEqual([2, 3, 4])
    it "doesn't change itself", ->
      expect(a).toEqual([1, 2, 3, 4])
    it "accepts index argument", ->
      expect(c).toEqual([3, 4])
    it "returns [] if index is above length", ->
      expect([1,2].withoutFirst(3)).toEqual([])
  describe "flatten", ->
    it "pending", ->
      pending("to be implemented")
  describe "without", ->
    it "pending", ->
      pending("to be implemented")
  describe "compact", ->
    it "pending", ->
      pending("to be implemented")
  describe "zip", ->
    it "pending", ->
      pending("to be implemented")
  describe "unzip", ->
    it "pending", ->
      pending("to be implemented")
  describe "max", ->
    it "pending", ->
      pending("to be implemented")
  describe "min", ->
    it "pending", ->
      pending("to be implemented")
