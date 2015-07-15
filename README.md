# Keygaps

[![Dependency status](https://img.shields.io/david/engineersamuel/keygaps.svg?style=flat)](https://david-dm.org/engineersamuel/keygaps)
[![devDependency Status](https://img.shields.io/david/dev/engineersamuel/keygaps.svg?style=flat)](https://david-dm.org/engineersamuel/keygaps#info=devDependencies)
[![Build Status](https://img.shields.io/travis/engineersamuel/keygaps.svg?style=flat&branch=master)](https://travis-ci.org/engineersamuel/keygaps)

[![NPM](https://nodei.co/npm/javahighcpu.svg?style=flat)](https://npmjs.org/package/javahighcpu)

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

expect(_.keys(output.missingObjects)).to.contain("a:2")
expect(_.keys(output.missingObjects)).to.contain("b:1")
expect(_.keys(output.missingObjects)).to.contain("c:2")
expect(_.keys(output.missingObjects)).to.contain("d:1")
```
    
## Testing

    npm test
    
## Contributing

    grunt dev
    node lib/cli.js -t 10 test/examples/std/high-cpu.out test/examples/std/high-cpu-tdumps.out
    
### Release process

https://github.com/phuu/npm-release

    npm run test
    gg c <msg>
    npm-release patch
    
gg represents git goodies, it's just nice.  The patch-release tags and publishes to npm.

