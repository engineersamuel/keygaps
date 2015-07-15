fs                = require 'fs'
chai              = require 'chai'
sinon             = require 'sinon'
Keygaps           = require('../lib/index')
_                 = require('lodash')

expect = chai.expect
chai.use require 'sinon-chai'

describe 'Keygaps', ->

    it 'should error when null values given', ->
        expect(Keygaps.fillValues).to.throw('Must pass in a hash of objects minimally containing { values: [ list of objects ] }');

    it 'should error when no values given', ->
        expect(Keygaps.fillValues.bind(Keygaps, {})).to.throw('Must specify a values field containing an array of javascript objects');

    it 'should error when no values given', ->
        expect(Keygaps.fillValues.bind(Keygaps, {values: [{b: 1}]})).to.throw('No keyFunction specified and there is no x value in the values.  Please specify an keyFunction or include x in the array of object values');

    it 'should error when keyFunction given but no valueFunction given', ->
        options = {
            values: [{b: 1}],
            keyFunction: -> null
        }
        expect(Keygaps.fillValues.bind(Keygaps, options)).to.throw('The keyFunction was given but no valueFunction; the valueFunction effectively de-serializes the result of the keyFunction');

    it 'should default to the x field and find no gaps', ->
        data = [
            {url: 'a', x: 1, y: 10},
            {url: 'b', x: 1, y: 11},
            {url: 'a', x: 2, y: 10},
            {url: 'b', x: 2, y: 10},
        ]
        output = Keygaps.fillValues({
            values: data
        })
        expect(_.keys(output.missingValues).length).to.eql(0)

    it 'should allow overriding the key function and find gap b:2', ->
        data = [
            {url: 'a', x: 1, y: 10},
            {url: 'b', x: 1, y: 11},
            {url: 'a', x: 2, y: 10},
        ]
        # arguments[0] is the ev array passed below
        valueFunction = ->
            obj = {}
            obj['url'] = arguments[0][0]
            obj['x'] = arguments[0][1]
            obj
        output = Keygaps.fillValues({
            values: data,
            keyFunction: (input) -> [input.url, input.x],
            valueFunction: valueFunction
        })
        expect(_.keys(output.missingValues)).to.contain("b:2")
        expect(_.keys(output.missingValues)).to.not.contain("a:1")
        expect(output.missingValues['b:2'].y).to.eql(0)
        expect(output.values).to.contain({"url": "b", "x": 2, "y": 0})

    it 'should allow overriding the yVariable and yValue', ->
        data = [
            {url: 'a', a: 1, z: 10},
            {url: 'b', a: 1, z: 11},
            {url: 'a', a: 2, z: 10},
        ]
        # arguments[0] is the ev array passed below
        valueFunction = ->
          obj = {}
          obj['url'] = arguments[0][0]
          obj['a'] = arguments[0][1]
          obj

        output = Keygaps.fillValues({
            values: data,
            keyFunction: (input) -> [input.url, input.a],
            valueFunction: valueFunction,
            yValue: 99,
            yVariable: 'z'
        })
        expect(_.keys(output.missingValues)).to.contain("b:2")
        expect(_.keys(output.missingValues)).to.not.contain("a:1")
        expect(output.missingValues['b:2'].z).to.eql(99)

    it 'should work with data with 3x3 keys', ->
        data = [
            {category: 'a', x: 1, y: 10},
            {category: 'b', x: 2, y: 11},
            {category: 'c', x: 3, y: 10},
        ]
        # arguments[0] is the ev array passed below
        valueFunction = ->
            obj = {}
            obj['url'] = arguments[0][0]
            obj['x'] = arguments[0][1]
            obj
        output = Keygaps.fillValues({
            values: data,
            keyFunction: (input) -> [input.category, input.x],
            valueFunction: valueFunction
        })
        expect(_.keys(output.missingValues)).to.contain("a:2")
        expect(_.keys(output.missingValues)).to.contain("b:3")
        expect(_.keys(output.missingValues)).to.contain("c:1")

    it 'should work with data with 4x2 keys', ->
        data = [
            {category: 'a', x: 1, y: 10},
            {category: 'b', x: 2, y: 11},
            {category: 'c', x: 1, y: 10},
            {category: 'd', x: 2, y: 10},
        ]
        # arguments[0] is the ev array passed below
        valueFunction = ->
            obj = {}
            obj['category'] = arguments[0][0]
            obj['x'] = arguments[0][1]
            obj
        output = Keygaps.fillValues({
            values: data,
            keyFunction: (input) -> [input.category, input.x],
            valueFunction: valueFunction
        })
        expect(_.keys(output.missingValues)).to.contain("a:2")
        expect(_.keys(output.missingValues)).to.contain("b:1")
        expect(_.keys(output.missingValues)).to.contain("c:2")
        expect(_.keys(output.missingValues)).to.contain("d:1")

    it 'should work with data with irrelevant fields', ->
        data = [
            {irrelevant1: 0, category: 'a', x: 1, y: 10, irrelevant1: 0},
            {irrelevant1: 0, category: 'b', x: 2, y: 11, irrelevant1: 0},
            {irrelevant1: 0, category: 'c', x: 1, y: 10, irrelevant1: 0},
            {irrelevant1: 0, category: 'd', x: 2, y: 10, irrelevant1: 0},
        ]
        # arguments[0] is the ev array passed below
        valueFunction = ->
            obj = {}
            obj['category'] = arguments[0][0]
            obj['x'] = arguments[0][1]
            obj
        output = Keygaps.fillValues({
            values: data,
            keyFunction: (input) -> [input.category, input.x],
            valueFunction: valueFunction
        })
        expect(_.keys(output.missingValues)).to.contain("a:2")
        expect(_.keys(output.missingValues)).to.contain("b:1")
        expect(_.keys(output.missingValues)).to.contain("c:2")
        expect(_.keys(output.missingValues)).to.contain("d:1")
