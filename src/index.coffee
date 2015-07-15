_ = require('lodash')

Keygaps = {}

# Define the separator for how the key is joined
Keygaps.KEY_SEP = ':';

# http://stackoverflow.com/questions/12303989/cartesian-product-of-multiple-arrays-in-javascript
# Consider https://github.com/dankogai/js-combinatorics as an alternative
Keygaps.cartesianProduct = ->
  r = []
  arg = arguments
  max = arg.length - 1

  helper = (arr, i) ->
    j = 0
    l = arg[i].length
    while j < l
      a = arr.slice(0)
      # clone arr
      a.push arg[i][j]
      if i == max
        r.push a
      else
        helper a, i + 1
      j++

  helper [], 0
  r

# Accepts an array of objects, looks for missing keys based on a keyFunction, then inserts the missing objects
# based on a re-construction of a reference object in the array.
Keygaps.fillValues = (opts) ->
  if !opts
    throw new Error('Must pass in a hash of objects minimally containing { values: [ list of objects ] }')

  if !opts.values
    throw new Error('Must specify a values field containing an array of javascript objects')

  if !opts.keyFunction and !opts.values[0].x
    throw new Error('No keyFunction specified and there is no x value in the values.  Please specify an keyFunction or include x in the array of object values')

  if opts.keyFunction and !opts.valueFunction
    throw new Error('The keyFunction was given but no valueFunction; the valueFunction effectively de-serializes the result of the keyFunction')

  # By default the y value will be 0, or whatever the user passes in
  yValue = opts.yValue or 0

  # optional yVariable will allow overriding selecting what the y variable name is
  yVariable = opts.yVariable or 'y'

  # Optional allow a keyFunction which will determine how to create the keyHash for more complicated multi-
  # dimensional data.  I.e. data where the unique key/x value may comprise more than one field.  This must return
  # an array of values.  This let's unique values be calculated at each dimension
  keyFunction = opts.keyFunction or (obj) -> [ obj['x'] ]

  # If overriding the keyFunction must also override the valueFunction.  This is to effectively deserialize the key
  # which is an array, to an object.  This default valueFunction will really never be called, this is just an example
  # to show you how it's done
  valueFunction = opts.valueFunction # or ->
  #  obj = {}
  #  # arguments[0] is the ev array passed below
  #  obj['x'] = arguments[0][0]
  #  obj

  # Reference object
  firstObj = opts.refObj or _.first(opts.values)

  # Computed Hash - contains the x: value mapping where x is defined by the keyFunction
  computedHash = _.object(_.map(opts.values, (v) -> [keyFunction(v).join(Keygaps.KEY_SEP), keyFunction(v)] ))

  # Dimensional Hash - contains the dimensional hash as determined by the product of the keyFunction
  dimensionalHash = {}

  # Iterate over the keys a sample key given the firstObj, this will give an accurate representation of what a key
  # will look like so we can operate on the dimensions of that key and extract unique values
  _.each keyFunction(firstObj), (key, i) ->
    # Each dimension (column) of the hash will contain a unique subset of the values of that column
    dimensionalHash[i] = _.chain(_.values(computedHash)).pluck(i).unique().value()
    # Expected yield may be {1: [a, b], 2: [1, 2]}

  # This will compute the product of the unique values.  So given say [[a, b], [1, 2]] that would yield:
  # [[a, 1], [a, 2], [b, 1], [b, 2]]
  expectedValues = Keygaps.cartesianProduct.apply(null, _.values(dimensionalHash))

  # Iterate over the expected values, create keys, and look those up in the computed Hash
  missingValues = {}
  _.each expectedValues, (ev, i) ->
    if !(_.has(computedHash, ev.join(Keygaps.KEY_SEP)))
      # Create a {} to assign the y value to, this will look something like {'y': 0}
      yObj = {}
      yObj[yVariable] = yValue
      # Now create the main obj value which may be {'x': 1} and assign the y value, end result may be {'x': 1, 'y': 0}
      missingValues[ev.join(Keygaps.KEY_SEP)] = _.assign(valueFunction.call(Keygaps, ev), yObj)

  return {
    missingValues: missingValues,
    values: _.flatten([opts.values, _.values(missingValues)])
  }

module.exports = Keygaps

