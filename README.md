# Keygaps

[![Dependency status](https://img.shields.io/david/engineersamuel/keygaps.svg?style=flat)](https://david-dm.org/engineersamuel/keygaps)
[![devDependency Status](https://img.shields.io/david/dev/engineersamuel/keygaps.svg?style=flat)](https://david-dm.org/engineersamuel/keygaps#info=devDependencies)
[![Build Status](https://img.shields.io/travis/engineersamuel/keygaps.svg?style=flat&branch=master)](https://travis-ci.org/engineersamuel/keygaps)

[![NPM](https://nodei.co/npm/keygaps.svg?style=flat)](https://npmjs.org/package/keygaps)

## Installation

### Node.js

    npm install keygaps
    
### Browser

I suggest using Webpack, Browserify, ect.. to provide an environment with require.

## Usage

```coffeescript
fillKeys = require('keygaps').fillKeys
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
output = Keygaps.fillKeys({
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

