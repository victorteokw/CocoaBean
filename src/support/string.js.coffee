String::capitalize = () ->
  length = this.length
  return '' if length == 0
  return this.toUpperCase() if length == 1
  result = this[0].toUpperCase()
  i = 1
  while i < this.length
    result += this[i].toLowerCase()
    i++
  return result

String::lines = () ->
  this.split /\r?\n/ # preserve \n or not?

# Actually, in javaScript string are immutable and seems always copied when assigns,
# just provide an consistent api. It's easy for use when enumerating through an array.
String::copy = () ->
  return this
