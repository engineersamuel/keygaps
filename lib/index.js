var Keygaps, _;

_ = require('lodash');

Keygaps = {};

Keygaps.KEY_SEP = ':';

Keygaps.cartesianProduct = function() {
  var arg, helper, max, r;
  r = [];
  arg = arguments;
  max = arg.length - 1;
  helper = function(arr, i) {
    var a, j, l, results;
    j = 0;
    l = arg[i].length;
    results = [];
    while (j < l) {
      a = arr.slice(0);
      a.push(arg[i][j]);
      if (i === max) {
        r.push(a);
      } else {
        helper(a, i + 1);
      }
      results.push(j++);
    }
    return results;
  };
  helper([], 0);
  return r;
};

Keygaps.fillKeys = function(opts) {
  var computedHash, dimensionalHash, expectedValues, firstObj, keyFunction, missingObjects, valueFunction, yValue, yVariable;
  if (!opts) {
    throw new Error('Must pass in a hash of objects minimally containing { values: [ list of objects ] }');
  }
  if (!opts.values) {
    throw new Error('Must specify a values field containing an array of javascript objects');
  }
  if (!opts.keyFunction && !opts.values[0].x) {
    throw new Error('No keyFunction specified and there is no x value in the values.  Please specify an keyFunction or include x in the array of object values');
  }
  if (opts.keyFunction && !opts.valueFunction) {
    throw new Error('The keyFunction was given but no valueFunction; the valueFunction effectively de-serializes the result of the keyFunction');
  }
  yValue = opts.yValue || 0;
  yVariable = opts.yVariable || 'y';
  keyFunction = opts.keyFunction || function(obj) {
    return [obj['x']];
  };
  valueFunction = opts.valueFunction;
  firstObj = opts.refObj || _.first(opts.values);
  computedHash = _.object(_.map(opts.values, function(v) {
    return [keyFunction(v).join(Keygaps.KEY_SEP), keyFunction(v)];
  }));
  dimensionalHash = {};
  _.each(keyFunction(firstObj), function(key, i) {
    return dimensionalHash[i] = _.chain(_.values(computedHash)).pluck(i).unique().value();
  });
  expectedValues = Keygaps.cartesianProduct.apply(null, _.values(dimensionalHash));
  missingObjects = {};
  _.each(expectedValues, function(ev, i) {
    var yObj;
    if (!(_.has(computedHash, ev.join(Keygaps.KEY_SEP)))) {
      yObj = {};
      yObj[yVariable] = yValue;
      return missingObjects[ev.join(Keygaps.KEY_SEP)] = _.assign(valueFunction.call(Keygaps, ev), yObj);
    }
  });
  return {
    missingObjects: missingObjects,
    values: _.flatten([opts.values, _.values(missingObjects)])
  };
};

module.exports = Keygaps;
