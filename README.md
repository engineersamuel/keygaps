# Keygaps

[![Dependency status](https://img.shields.io/david/engineersamuel/keygaps.svg?style=flat)](https://david-dm.org/engineersamuel/keygaps)
[![devDependency Status](https://img.shields.io/david/dev/engineersamuel/keygaps.svg?style=flat)](https://david-dm.org/engineersamuel/keygaps#info=devDependencies)
[![Build Status](https://img.shields.io/travis/engineersamuel/keygaps.svg?style=flat&branch=master)](https://travis-ci.org/engineersamuel/keygaps)

[![NPM](https://nodei.co/npm/keygaps.svg?style=flat)](https://npmjs.org/package/keygaps)

## What does this do?

The primary function of this library is to fill in the gaps in data for charting libraries.  Many charting libraries, d3 comes to mind,
does handle missing data well when dealing with multi-dimensional data.

By multi-dimensional data I simply mean where there are groups of data which should contain a consistent set of x values.

This may look like:

```
    [
        {company: 'acme', x: 1, y: 99},
        {company: 'acme', x: 2, y: 70},
        {company: 'acme', x: 4, y: 99},
        {company: 'foomaker', x: 1, y: 102},
        {company: 'foomaker', x: 2, y: 99},
        {company: 'foomaker', x: 3, y: 99}
    ]
```

In the above example the following data is missing:

```
    [
        {company: 'acme', x: 3, y: ?},
        {company: 'foomaker', x: 4, y: ?}
    ]
```

Keygaps comes to the rescue here and helps fill in the missing data. 

## Installation

### Node.js

    npm install keygaps
    
### Browser

I suggest using Webpack, Browserify, ect. to provide an environment with require.

## Usage

```coffeescript
fillValues = require('keygaps').fillValues
# Create data with missing keys
data = [
    {category: 'a', x: 1, y: 10},
    {category: 'b', x: 2, y: 11},
    {category: 'c', x: 1, y: 10},
    {category: 'd', x: 2, y: 10},
]
# Create a valueFunction to tell how to deserialize the key
# arguments[0] is the ev array passed below
valueFunction = ->
    obj = {}
    obj['category'] = arguments[0][0]
    obj['x'] = arguments[0][1]
    obj
output = Keygaps.fillValues({
    values: data,
    # Create a keyFunction to know how to group the data
    keyFunction: (input) -> [input.category, input.x],
    valueFunction: valueFunction
})

# object.missingValues
{
 "a:2": { "category": "a", "x": 2, "y": 0 },
 "b:1": { "category": "b", "x": 1, "y": 0 },
 "c:2": { "category": "c", "x": 2, "y": 0 },
 "d:1": { "category": "d", "x": 1, "y": 0 }
}
# output.values
[
 { "category": "a", "x": 1, "y": 10 },
 { "category": "b", "x": 2, "y": 11 },
 { "category": "c", "x": 1, "y": 10 },
 { "category": "d", "x": 2, "y": 10 },
 { "category": "a", "x": 2, "y": 0 },
 { "category": "b", "x": 1, "y": 0 },
 { "category": "c", "x": 2, "y": 0 },
 { "category": "d", "x": 1, "y": 0 }
]
```
    
## Testing

    npm run test
    
## Contributing

    npm run dev
    npm run test
    
### Release process

    npm run test
    gg c <msg>
    npm-release patch
    
gg represents git goodies, it's just nice.  The npm-release docs can be found @ https://github.com/phuu/npm-release

