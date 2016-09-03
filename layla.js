(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var lookup = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

;(function (exports) {
	'use strict';

  var Arr = (typeof Uint8Array !== 'undefined')
    ? Uint8Array
    : Array

	var PLUS   = '+'.charCodeAt(0)
	var SLASH  = '/'.charCodeAt(0)
	var NUMBER = '0'.charCodeAt(0)
	var LOWER  = 'a'.charCodeAt(0)
	var UPPER  = 'A'.charCodeAt(0)
	var PLUS_URL_SAFE = '-'.charCodeAt(0)
	var SLASH_URL_SAFE = '_'.charCodeAt(0)

	function decode (elt) {
		var code = elt.charCodeAt(0)
		if (code === PLUS ||
		    code === PLUS_URL_SAFE)
			return 62 // '+'
		if (code === SLASH ||
		    code === SLASH_URL_SAFE)
			return 63 // '/'
		if (code < NUMBER)
			return -1 //no match
		if (code < NUMBER + 10)
			return code - NUMBER + 26 + 26
		if (code < UPPER + 26)
			return code - UPPER
		if (code < LOWER + 26)
			return code - LOWER + 26
	}

	function b64ToByteArray (b64) {
		var i, j, l, tmp, placeHolders, arr

		if (b64.length % 4 > 0) {
			throw new Error('Invalid string. Length must be a multiple of 4')
		}

		// the number of equal signs (place holders)
		// if there are two placeholders, than the two characters before it
		// represent one byte
		// if there is only one, then the three characters before it represent 2 bytes
		// this is just a cheap hack to not do indexOf twice
		var len = b64.length
		placeHolders = '=' === b64.charAt(len - 2) ? 2 : '=' === b64.charAt(len - 1) ? 1 : 0

		// base64 is 4/3 + up to two characters of the original data
		arr = new Arr(b64.length * 3 / 4 - placeHolders)

		// if there are placeholders, only get up to the last complete 4 chars
		l = placeHolders > 0 ? b64.length - 4 : b64.length

		var L = 0

		function push (v) {
			arr[L++] = v
		}

		for (i = 0, j = 0; i < l; i += 4, j += 3) {
			tmp = (decode(b64.charAt(i)) << 18) | (decode(b64.charAt(i + 1)) << 12) | (decode(b64.charAt(i + 2)) << 6) | decode(b64.charAt(i + 3))
			push((tmp & 0xFF0000) >> 16)
			push((tmp & 0xFF00) >> 8)
			push(tmp & 0xFF)
		}

		if (placeHolders === 2) {
			tmp = (decode(b64.charAt(i)) << 2) | (decode(b64.charAt(i + 1)) >> 4)
			push(tmp & 0xFF)
		} else if (placeHolders === 1) {
			tmp = (decode(b64.charAt(i)) << 10) | (decode(b64.charAt(i + 1)) << 4) | (decode(b64.charAt(i + 2)) >> 2)
			push((tmp >> 8) & 0xFF)
			push(tmp & 0xFF)
		}

		return arr
	}

	function uint8ToBase64 (uint8) {
		var i,
			extraBytes = uint8.length % 3, // if we have 1 byte left, pad 2 bytes
			output = "",
			temp, length

		function encode (num) {
			return lookup.charAt(num)
		}

		function tripletToBase64 (num) {
			return encode(num >> 18 & 0x3F) + encode(num >> 12 & 0x3F) + encode(num >> 6 & 0x3F) + encode(num & 0x3F)
		}

		// go through the array every three bytes, we'll deal with trailing stuff later
		for (i = 0, length = uint8.length - extraBytes; i < length; i += 3) {
			temp = (uint8[i] << 16) + (uint8[i + 1] << 8) + (uint8[i + 2])
			output += tripletToBase64(temp)
		}

		// pad the end with zeros, but make sure to not forget the extra bytes
		switch (extraBytes) {
			case 1:
				temp = uint8[uint8.length - 1]
				output += encode(temp >> 2)
				output += encode((temp << 4) & 0x3F)
				output += '=='
				break
			case 2:
				temp = (uint8[uint8.length - 2] << 8) + (uint8[uint8.length - 1])
				output += encode(temp >> 10)
				output += encode((temp >> 4) & 0x3F)
				output += encode((temp << 2) & 0x3F)
				output += '='
				break
		}

		return output
	}

	exports.toByteArray = b64ToByteArray
	exports.fromByteArray = uint8ToBase64
}(typeof exports === 'undefined' ? (this.base64js = {}) : exports))

},{}],2:[function(require,module,exports){

},{}],3:[function(require,module,exports){
(function (global){
/*!
 * The buffer module from node.js, for the browser.
 *
 * @author   Feross Aboukhadijeh <feross@feross.org> <http://feross.org>
 * @license  MIT
 */
/* eslint-disable no-proto */

'use strict'

var base64 = require('base64-js')
var ieee754 = require('ieee754')
var isArray = require('isarray')

exports.Buffer = Buffer
exports.SlowBuffer = SlowBuffer
exports.INSPECT_MAX_BYTES = 50
Buffer.poolSize = 8192 // not used by this implementation

var rootParent = {}

/**
 * If `Buffer.TYPED_ARRAY_SUPPORT`:
 *   === true    Use Uint8Array implementation (fastest)
 *   === false   Use Object implementation (most compatible, even IE6)
 *
 * Browsers that support typed arrays are IE 10+, Firefox 4+, Chrome 7+, Safari 5.1+,
 * Opera 11.6+, iOS 4.2+.
 *
 * Due to various browser bugs, sometimes the Object implementation will be used even
 * when the browser supports typed arrays.
 *
 * Note:
 *
 *   - Firefox 4-29 lacks support for adding new properties to `Uint8Array` instances,
 *     See: https://bugzilla.mozilla.org/show_bug.cgi?id=695438.
 *
 *   - Safari 5-7 lacks support for changing the `Object.prototype.constructor` property
 *     on objects.
 *
 *   - Chrome 9-10 is missing the `TypedArray.prototype.subarray` function.
 *
 *   - IE10 has a broken `TypedArray.prototype.subarray` function which returns arrays of
 *     incorrect length in some situations.

 * We detect these buggy browsers and set `Buffer.TYPED_ARRAY_SUPPORT` to `false` so they
 * get the Object implementation, which is slower but behaves correctly.
 */
Buffer.TYPED_ARRAY_SUPPORT = global.TYPED_ARRAY_SUPPORT !== undefined
  ? global.TYPED_ARRAY_SUPPORT
  : typedArraySupport()

function typedArraySupport () {
  function Bar () {}
  try {
    var arr = new Uint8Array(1)
    arr.foo = function () { return 42 }
    arr.constructor = Bar
    return arr.foo() === 42 && // typed array instances can be augmented
        arr.constructor === Bar && // constructor can be set
        typeof arr.subarray === 'function' && // chrome 9-10 lack `subarray`
        arr.subarray(1, 1).byteLength === 0 // ie10 has broken `subarray`
  } catch (e) {
    return false
  }
}

function kMaxLength () {
  return Buffer.TYPED_ARRAY_SUPPORT
    ? 0x7fffffff
    : 0x3fffffff
}

/**
 * Class: Buffer
 * =============
 *
 * The Buffer constructor returns instances of `Uint8Array` that are augmented
 * with function properties for all the node `Buffer` API functions. We use
 * `Uint8Array` so that square bracket notation works as expected -- it returns
 * a single octet.
 *
 * By augmenting the instances, we can avoid modifying the `Uint8Array`
 * prototype.
 */
function Buffer (arg) {
  if (!(this instanceof Buffer)) {
    // Avoid going through an ArgumentsAdaptorTrampoline in the common case.
    if (arguments.length > 1) return new Buffer(arg, arguments[1])
    return new Buffer(arg)
  }

  if (!Buffer.TYPED_ARRAY_SUPPORT) {
    this.length = 0
    this.parent = undefined
  }

  // Common case.
  if (typeof arg === 'number') {
    return fromNumber(this, arg)
  }

  // Slightly less common case.
  if (typeof arg === 'string') {
    return fromString(this, arg, arguments.length > 1 ? arguments[1] : 'utf8')
  }

  // Unusual.
  return fromObject(this, arg)
}

function fromNumber (that, length) {
  that = allocate(that, length < 0 ? 0 : checked(length) | 0)
  if (!Buffer.TYPED_ARRAY_SUPPORT) {
    for (var i = 0; i < length; i++) {
      that[i] = 0
    }
  }
  return that
}

function fromString (that, string, encoding) {
  if (typeof encoding !== 'string' || encoding === '') encoding = 'utf8'

  // Assumption: byteLength() return value is always < kMaxLength.
  var length = byteLength(string, encoding) | 0
  that = allocate(that, length)

  that.write(string, encoding)
  return that
}

function fromObject (that, object) {
  if (Buffer.isBuffer(object)) return fromBuffer(that, object)

  if (isArray(object)) return fromArray(that, object)

  if (object == null) {
    throw new TypeError('must start with number, buffer, array or string')
  }

  if (typeof ArrayBuffer !== 'undefined') {
    if (object.buffer instanceof ArrayBuffer) {
      return fromTypedArray(that, object)
    }
    if (object instanceof ArrayBuffer) {
      return fromArrayBuffer(that, object)
    }
  }

  if (object.length) return fromArrayLike(that, object)

  return fromJsonObject(that, object)
}

function fromBuffer (that, buffer) {
  var length = checked(buffer.length) | 0
  that = allocate(that, length)
  buffer.copy(that, 0, 0, length)
  return that
}

function fromArray (that, array) {
  var length = checked(array.length) | 0
  that = allocate(that, length)
  for (var i = 0; i < length; i += 1) {
    that[i] = array[i] & 255
  }
  return that
}

// Duplicate of fromArray() to keep fromArray() monomorphic.
function fromTypedArray (that, array) {
  var length = checked(array.length) | 0
  that = allocate(that, length)
  // Truncating the elements is probably not what people expect from typed
  // arrays with BYTES_PER_ELEMENT > 1 but it's compatible with the behavior
  // of the old Buffer constructor.
  for (var i = 0; i < length; i += 1) {
    that[i] = array[i] & 255
  }
  return that
}

function fromArrayBuffer (that, array) {
  if (Buffer.TYPED_ARRAY_SUPPORT) {
    // Return an augmented `Uint8Array` instance, for best performance
    array.byteLength
    that = Buffer._augment(new Uint8Array(array))
  } else {
    // Fallback: Return an object instance of the Buffer class
    that = fromTypedArray(that, new Uint8Array(array))
  }
  return that
}

function fromArrayLike (that, array) {
  var length = checked(array.length) | 0
  that = allocate(that, length)
  for (var i = 0; i < length; i += 1) {
    that[i] = array[i] & 255
  }
  return that
}

// Deserialize { type: 'Buffer', data: [1,2,3,...] } into a Buffer object.
// Returns a zero-length buffer for inputs that don't conform to the spec.
function fromJsonObject (that, object) {
  var array
  var length = 0

  if (object.type === 'Buffer' && isArray(object.data)) {
    array = object.data
    length = checked(array.length) | 0
  }
  that = allocate(that, length)

  for (var i = 0; i < length; i += 1) {
    that[i] = array[i] & 255
  }
  return that
}

if (Buffer.TYPED_ARRAY_SUPPORT) {
  Buffer.prototype.__proto__ = Uint8Array.prototype
  Buffer.__proto__ = Uint8Array
} else {
  // pre-set for values that may exist in the future
  Buffer.prototype.length = undefined
  Buffer.prototype.parent = undefined
}

function allocate (that, length) {
  if (Buffer.TYPED_ARRAY_SUPPORT) {
    // Return an augmented `Uint8Array` instance, for best performance
    that = Buffer._augment(new Uint8Array(length))
    that.__proto__ = Buffer.prototype
  } else {
    // Fallback: Return an object instance of the Buffer class
    that.length = length
    that._isBuffer = true
  }

  var fromPool = length !== 0 && length <= Buffer.poolSize >>> 1
  if (fromPool) that.parent = rootParent

  return that
}

function checked (length) {
  // Note: cannot use `length < kMaxLength` here because that fails when
  // length is NaN (which is otherwise coerced to zero.)
  if (length >= kMaxLength()) {
    throw new RangeError('Attempt to allocate Buffer larger than maximum ' +
                         'size: 0x' + kMaxLength().toString(16) + ' bytes')
  }
  return length | 0
}

function SlowBuffer (subject, encoding) {
  if (!(this instanceof SlowBuffer)) return new SlowBuffer(subject, encoding)

  var buf = new Buffer(subject, encoding)
  delete buf.parent
  return buf
}

Buffer.isBuffer = function isBuffer (b) {
  return !!(b != null && b._isBuffer)
}

Buffer.compare = function compare (a, b) {
  if (!Buffer.isBuffer(a) || !Buffer.isBuffer(b)) {
    throw new TypeError('Arguments must be Buffers')
  }

  if (a === b) return 0

  var x = a.length
  var y = b.length

  var i = 0
  var len = Math.min(x, y)
  while (i < len) {
    if (a[i] !== b[i]) break

    ++i
  }

  if (i !== len) {
    x = a[i]
    y = b[i]
  }

  if (x < y) return -1
  if (y < x) return 1
  return 0
}

Buffer.isEncoding = function isEncoding (encoding) {
  switch (String(encoding).toLowerCase()) {
    case 'hex':
    case 'utf8':
    case 'utf-8':
    case 'ascii':
    case 'binary':
    case 'base64':
    case 'raw':
    case 'ucs2':
    case 'ucs-2':
    case 'utf16le':
    case 'utf-16le':
      return true
    default:
      return false
  }
}

Buffer.concat = function concat (list, length) {
  if (!isArray(list)) throw new TypeError('list argument must be an Array of Buffers.')

  if (list.length === 0) {
    return new Buffer(0)
  }

  var i
  if (length === undefined) {
    length = 0
    for (i = 0; i < list.length; i++) {
      length += list[i].length
    }
  }

  var buf = new Buffer(length)
  var pos = 0
  for (i = 0; i < list.length; i++) {
    var item = list[i]
    item.copy(buf, pos)
    pos += item.length
  }
  return buf
}

function byteLength (string, encoding) {
  if (typeof string !== 'string') string = '' + string

  var len = string.length
  if (len === 0) return 0

  // Use a for loop to avoid recursion
  var loweredCase = false
  for (;;) {
    switch (encoding) {
      case 'ascii':
      case 'binary':
      // Deprecated
      case 'raw':
      case 'raws':
        return len
      case 'utf8':
      case 'utf-8':
        return utf8ToBytes(string).length
      case 'ucs2':
      case 'ucs-2':
      case 'utf16le':
      case 'utf-16le':
        return len * 2
      case 'hex':
        return len >>> 1
      case 'base64':
        return base64ToBytes(string).length
      default:
        if (loweredCase) return utf8ToBytes(string).length // assume utf8
        encoding = ('' + encoding).toLowerCase()
        loweredCase = true
    }
  }
}
Buffer.byteLength = byteLength

function slowToString (encoding, start, end) {
  var loweredCase = false

  start = start | 0
  end = end === undefined || end === Infinity ? this.length : end | 0

  if (!encoding) encoding = 'utf8'
  if (start < 0) start = 0
  if (end > this.length) end = this.length
  if (end <= start) return ''

  while (true) {
    switch (encoding) {
      case 'hex':
        return hexSlice(this, start, end)

      case 'utf8':
      case 'utf-8':
        return utf8Slice(this, start, end)

      case 'ascii':
        return asciiSlice(this, start, end)

      case 'binary':
        return binarySlice(this, start, end)

      case 'base64':
        return base64Slice(this, start, end)

      case 'ucs2':
      case 'ucs-2':
      case 'utf16le':
      case 'utf-16le':
        return utf16leSlice(this, start, end)

      default:
        if (loweredCase) throw new TypeError('Unknown encoding: ' + encoding)
        encoding = (encoding + '').toLowerCase()
        loweredCase = true
    }
  }
}

Buffer.prototype.toString = function toString () {
  var length = this.length | 0
  if (length === 0) return ''
  if (arguments.length === 0) return utf8Slice(this, 0, length)
  return slowToString.apply(this, arguments)
}

Buffer.prototype.equals = function equals (b) {
  if (!Buffer.isBuffer(b)) throw new TypeError('Argument must be a Buffer')
  if (this === b) return true
  return Buffer.compare(this, b) === 0
}

Buffer.prototype.inspect = function inspect () {
  var str = ''
  var max = exports.INSPECT_MAX_BYTES
  if (this.length > 0) {
    str = this.toString('hex', 0, max).match(/.{2}/g).join(' ')
    if (this.length > max) str += ' ... '
  }
  return '<Buffer ' + str + '>'
}

Buffer.prototype.compare = function compare (b) {
  if (!Buffer.isBuffer(b)) throw new TypeError('Argument must be a Buffer')
  if (this === b) return 0
  return Buffer.compare(this, b)
}

Buffer.prototype.indexOf = function indexOf (val, byteOffset) {
  if (byteOffset > 0x7fffffff) byteOffset = 0x7fffffff
  else if (byteOffset < -0x80000000) byteOffset = -0x80000000
  byteOffset >>= 0

  if (this.length === 0) return -1
  if (byteOffset >= this.length) return -1

  // Negative offsets start from the end of the buffer
  if (byteOffset < 0) byteOffset = Math.max(this.length + byteOffset, 0)

  if (typeof val === 'string') {
    if (val.length === 0) return -1 // special case: looking for empty string always fails
    return String.prototype.indexOf.call(this, val, byteOffset)
  }
  if (Buffer.isBuffer(val)) {
    return arrayIndexOf(this, val, byteOffset)
  }
  if (typeof val === 'number') {
    if (Buffer.TYPED_ARRAY_SUPPORT && Uint8Array.prototype.indexOf === 'function') {
      return Uint8Array.prototype.indexOf.call(this, val, byteOffset)
    }
    return arrayIndexOf(this, [ val ], byteOffset)
  }

  function arrayIndexOf (arr, val, byteOffset) {
    var foundIndex = -1
    for (var i = 0; byteOffset + i < arr.length; i++) {
      if (arr[byteOffset + i] === val[foundIndex === -1 ? 0 : i - foundIndex]) {
        if (foundIndex === -1) foundIndex = i
        if (i - foundIndex + 1 === val.length) return byteOffset + foundIndex
      } else {
        foundIndex = -1
      }
    }
    return -1
  }

  throw new TypeError('val must be string, number or Buffer')
}

// `get` is deprecated
Buffer.prototype.get = function get (offset) {
  console.log('.get() is deprecated. Access using array indexes instead.')
  return this.readUInt8(offset)
}

// `set` is deprecated
Buffer.prototype.set = function set (v, offset) {
  console.log('.set() is deprecated. Access using array indexes instead.')
  return this.writeUInt8(v, offset)
}

function hexWrite (buf, string, offset, length) {
  offset = Number(offset) || 0
  var remaining = buf.length - offset
  if (!length) {
    length = remaining
  } else {
    length = Number(length)
    if (length > remaining) {
      length = remaining
    }
  }

  // must be an even number of digits
  var strLen = string.length
  if (strLen % 2 !== 0) throw new Error('Invalid hex string')

  if (length > strLen / 2) {
    length = strLen / 2
  }
  for (var i = 0; i < length; i++) {
    var parsed = parseInt(string.substr(i * 2, 2), 16)
    if (isNaN(parsed)) throw new Error('Invalid hex string')
    buf[offset + i] = parsed
  }
  return i
}

function utf8Write (buf, string, offset, length) {
  return blitBuffer(utf8ToBytes(string, buf.length - offset), buf, offset, length)
}

function asciiWrite (buf, string, offset, length) {
  return blitBuffer(asciiToBytes(string), buf, offset, length)
}

function binaryWrite (buf, string, offset, length) {
  return asciiWrite(buf, string, offset, length)
}

function base64Write (buf, string, offset, length) {
  return blitBuffer(base64ToBytes(string), buf, offset, length)
}

function ucs2Write (buf, string, offset, length) {
  return blitBuffer(utf16leToBytes(string, buf.length - offset), buf, offset, length)
}

Buffer.prototype.write = function write (string, offset, length, encoding) {
  // Buffer#write(string)
  if (offset === undefined) {
    encoding = 'utf8'
    length = this.length
    offset = 0
  // Buffer#write(string, encoding)
  } else if (length === undefined && typeof offset === 'string') {
    encoding = offset
    length = this.length
    offset = 0
  // Buffer#write(string, offset[, length][, encoding])
  } else if (isFinite(offset)) {
    offset = offset | 0
    if (isFinite(length)) {
      length = length | 0
      if (encoding === undefined) encoding = 'utf8'
    } else {
      encoding = length
      length = undefined
    }
  // legacy write(string, encoding, offset, length) - remove in v0.13
  } else {
    var swap = encoding
    encoding = offset
    offset = length | 0
    length = swap
  }

  var remaining = this.length - offset
  if (length === undefined || length > remaining) length = remaining

  if ((string.length > 0 && (length < 0 || offset < 0)) || offset > this.length) {
    throw new RangeError('attempt to write outside buffer bounds')
  }

  if (!encoding) encoding = 'utf8'

  var loweredCase = false
  for (;;) {
    switch (encoding) {
      case 'hex':
        return hexWrite(this, string, offset, length)

      case 'utf8':
      case 'utf-8':
        return utf8Write(this, string, offset, length)

      case 'ascii':
        return asciiWrite(this, string, offset, length)

      case 'binary':
        return binaryWrite(this, string, offset, length)

      case 'base64':
        // Warning: maxLength not taken into account in base64Write
        return base64Write(this, string, offset, length)

      case 'ucs2':
      case 'ucs-2':
      case 'utf16le':
      case 'utf-16le':
        return ucs2Write(this, string, offset, length)

      default:
        if (loweredCase) throw new TypeError('Unknown encoding: ' + encoding)
        encoding = ('' + encoding).toLowerCase()
        loweredCase = true
    }
  }
}

Buffer.prototype.toJSON = function toJSON () {
  return {
    type: 'Buffer',
    data: Array.prototype.slice.call(this._arr || this, 0)
  }
}

function base64Slice (buf, start, end) {
  if (start === 0 && end === buf.length) {
    return base64.fromByteArray(buf)
  } else {
    return base64.fromByteArray(buf.slice(start, end))
  }
}

function utf8Slice (buf, start, end) {
  end = Math.min(buf.length, end)
  var res = []

  var i = start
  while (i < end) {
    var firstByte = buf[i]
    var codePoint = null
    var bytesPerSequence = (firstByte > 0xEF) ? 4
      : (firstByte > 0xDF) ? 3
      : (firstByte > 0xBF) ? 2
      : 1

    if (i + bytesPerSequence <= end) {
      var secondByte, thirdByte, fourthByte, tempCodePoint

      switch (bytesPerSequence) {
        case 1:
          if (firstByte < 0x80) {
            codePoint = firstByte
          }
          break
        case 2:
          secondByte = buf[i + 1]
          if ((secondByte & 0xC0) === 0x80) {
            tempCodePoint = (firstByte & 0x1F) << 0x6 | (secondByte & 0x3F)
            if (tempCodePoint > 0x7F) {
              codePoint = tempCodePoint
            }
          }
          break
        case 3:
          secondByte = buf[i + 1]
          thirdByte = buf[i + 2]
          if ((secondByte & 0xC0) === 0x80 && (thirdByte & 0xC0) === 0x80) {
            tempCodePoint = (firstByte & 0xF) << 0xC | (secondByte & 0x3F) << 0x6 | (thirdByte & 0x3F)
            if (tempCodePoint > 0x7FF && (tempCodePoint < 0xD800 || tempCodePoint > 0xDFFF)) {
              codePoint = tempCodePoint
            }
          }
          break
        case 4:
          secondByte = buf[i + 1]
          thirdByte = buf[i + 2]
          fourthByte = buf[i + 3]
          if ((secondByte & 0xC0) === 0x80 && (thirdByte & 0xC0) === 0x80 && (fourthByte & 0xC0) === 0x80) {
            tempCodePoint = (firstByte & 0xF) << 0x12 | (secondByte & 0x3F) << 0xC | (thirdByte & 0x3F) << 0x6 | (fourthByte & 0x3F)
            if (tempCodePoint > 0xFFFF && tempCodePoint < 0x110000) {
              codePoint = tempCodePoint
            }
          }
      }
    }

    if (codePoint === null) {
      // we did not generate a valid codePoint so insert a
      // replacement char (U+FFFD) and advance only 1 byte
      codePoint = 0xFFFD
      bytesPerSequence = 1
    } else if (codePoint > 0xFFFF) {
      // encode to utf16 (surrogate pair dance)
      codePoint -= 0x10000
      res.push(codePoint >>> 10 & 0x3FF | 0xD800)
      codePoint = 0xDC00 | codePoint & 0x3FF
    }

    res.push(codePoint)
    i += bytesPerSequence
  }

  return decodeCodePointsArray(res)
}

// Based on http://stackoverflow.com/a/22747272/680742, the browser with
// the lowest limit is Chrome, with 0x10000 args.
// We go 1 magnitude less, for safety
var MAX_ARGUMENTS_LENGTH = 0x1000

function decodeCodePointsArray (codePoints) {
  var len = codePoints.length
  if (len <= MAX_ARGUMENTS_LENGTH) {
    return String.fromCharCode.apply(String, codePoints) // avoid extra slice()
  }

  // Decode in chunks to avoid "call stack size exceeded".
  var res = ''
  var i = 0
  while (i < len) {
    res += String.fromCharCode.apply(
      String,
      codePoints.slice(i, i += MAX_ARGUMENTS_LENGTH)
    )
  }
  return res
}

function asciiSlice (buf, start, end) {
  var ret = ''
  end = Math.min(buf.length, end)

  for (var i = start; i < end; i++) {
    ret += String.fromCharCode(buf[i] & 0x7F)
  }
  return ret
}

function binarySlice (buf, start, end) {
  var ret = ''
  end = Math.min(buf.length, end)

  for (var i = start; i < end; i++) {
    ret += String.fromCharCode(buf[i])
  }
  return ret
}

function hexSlice (buf, start, end) {
  var len = buf.length

  if (!start || start < 0) start = 0
  if (!end || end < 0 || end > len) end = len

  var out = ''
  for (var i = start; i < end; i++) {
    out += toHex(buf[i])
  }
  return out
}

function utf16leSlice (buf, start, end) {
  var bytes = buf.slice(start, end)
  var res = ''
  for (var i = 0; i < bytes.length; i += 2) {
    res += String.fromCharCode(bytes[i] + bytes[i + 1] * 256)
  }
  return res
}

Buffer.prototype.slice = function slice (start, end) {
  var len = this.length
  start = ~~start
  end = end === undefined ? len : ~~end

  if (start < 0) {
    start += len
    if (start < 0) start = 0
  } else if (start > len) {
    start = len
  }

  if (end < 0) {
    end += len
    if (end < 0) end = 0
  } else if (end > len) {
    end = len
  }

  if (end < start) end = start

  var newBuf
  if (Buffer.TYPED_ARRAY_SUPPORT) {
    newBuf = Buffer._augment(this.subarray(start, end))
  } else {
    var sliceLen = end - start
    newBuf = new Buffer(sliceLen, undefined)
    for (var i = 0; i < sliceLen; i++) {
      newBuf[i] = this[i + start]
    }
  }

  if (newBuf.length) newBuf.parent = this.parent || this

  return newBuf
}

/*
 * Need to make sure that buffer isn't trying to write out of bounds.
 */
function checkOffset (offset, ext, length) {
  if ((offset % 1) !== 0 || offset < 0) throw new RangeError('offset is not uint')
  if (offset + ext > length) throw new RangeError('Trying to access beyond buffer length')
}

Buffer.prototype.readUIntLE = function readUIntLE (offset, byteLength, noAssert) {
  offset = offset | 0
  byteLength = byteLength | 0
  if (!noAssert) checkOffset(offset, byteLength, this.length)

  var val = this[offset]
  var mul = 1
  var i = 0
  while (++i < byteLength && (mul *= 0x100)) {
    val += this[offset + i] * mul
  }

  return val
}

Buffer.prototype.readUIntBE = function readUIntBE (offset, byteLength, noAssert) {
  offset = offset | 0
  byteLength = byteLength | 0
  if (!noAssert) {
    checkOffset(offset, byteLength, this.length)
  }

  var val = this[offset + --byteLength]
  var mul = 1
  while (byteLength > 0 && (mul *= 0x100)) {
    val += this[offset + --byteLength] * mul
  }

  return val
}

Buffer.prototype.readUInt8 = function readUInt8 (offset, noAssert) {
  if (!noAssert) checkOffset(offset, 1, this.length)
  return this[offset]
}

Buffer.prototype.readUInt16LE = function readUInt16LE (offset, noAssert) {
  if (!noAssert) checkOffset(offset, 2, this.length)
  return this[offset] | (this[offset + 1] << 8)
}

Buffer.prototype.readUInt16BE = function readUInt16BE (offset, noAssert) {
  if (!noAssert) checkOffset(offset, 2, this.length)
  return (this[offset] << 8) | this[offset + 1]
}

Buffer.prototype.readUInt32LE = function readUInt32LE (offset, noAssert) {
  if (!noAssert) checkOffset(offset, 4, this.length)

  return ((this[offset]) |
      (this[offset + 1] << 8) |
      (this[offset + 2] << 16)) +
      (this[offset + 3] * 0x1000000)
}

Buffer.prototype.readUInt32BE = function readUInt32BE (offset, noAssert) {
  if (!noAssert) checkOffset(offset, 4, this.length)

  return (this[offset] * 0x1000000) +
    ((this[offset + 1] << 16) |
    (this[offset + 2] << 8) |
    this[offset + 3])
}

Buffer.prototype.readIntLE = function readIntLE (offset, byteLength, noAssert) {
  offset = offset | 0
  byteLength = byteLength | 0
  if (!noAssert) checkOffset(offset, byteLength, this.length)

  var val = this[offset]
  var mul = 1
  var i = 0
  while (++i < byteLength && (mul *= 0x100)) {
    val += this[offset + i] * mul
  }
  mul *= 0x80

  if (val >= mul) val -= Math.pow(2, 8 * byteLength)

  return val
}

Buffer.prototype.readIntBE = function readIntBE (offset, byteLength, noAssert) {
  offset = offset | 0
  byteLength = byteLength | 0
  if (!noAssert) checkOffset(offset, byteLength, this.length)

  var i = byteLength
  var mul = 1
  var val = this[offset + --i]
  while (i > 0 && (mul *= 0x100)) {
    val += this[offset + --i] * mul
  }
  mul *= 0x80

  if (val >= mul) val -= Math.pow(2, 8 * byteLength)

  return val
}

Buffer.prototype.readInt8 = function readInt8 (offset, noAssert) {
  if (!noAssert) checkOffset(offset, 1, this.length)
  if (!(this[offset] & 0x80)) return (this[offset])
  return ((0xff - this[offset] + 1) * -1)
}

Buffer.prototype.readInt16LE = function readInt16LE (offset, noAssert) {
  if (!noAssert) checkOffset(offset, 2, this.length)
  var val = this[offset] | (this[offset + 1] << 8)
  return (val & 0x8000) ? val | 0xFFFF0000 : val
}

Buffer.prototype.readInt16BE = function readInt16BE (offset, noAssert) {
  if (!noAssert) checkOffset(offset, 2, this.length)
  var val = this[offset + 1] | (this[offset] << 8)
  return (val & 0x8000) ? val | 0xFFFF0000 : val
}

Buffer.prototype.readInt32LE = function readInt32LE (offset, noAssert) {
  if (!noAssert) checkOffset(offset, 4, this.length)

  return (this[offset]) |
    (this[offset + 1] << 8) |
    (this[offset + 2] << 16) |
    (this[offset + 3] << 24)
}

Buffer.prototype.readInt32BE = function readInt32BE (offset, noAssert) {
  if (!noAssert) checkOffset(offset, 4, this.length)

  return (this[offset] << 24) |
    (this[offset + 1] << 16) |
    (this[offset + 2] << 8) |
    (this[offset + 3])
}

Buffer.prototype.readFloatLE = function readFloatLE (offset, noAssert) {
  if (!noAssert) checkOffset(offset, 4, this.length)
  return ieee754.read(this, offset, true, 23, 4)
}

Buffer.prototype.readFloatBE = function readFloatBE (offset, noAssert) {
  if (!noAssert) checkOffset(offset, 4, this.length)
  return ieee754.read(this, offset, false, 23, 4)
}

Buffer.prototype.readDoubleLE = function readDoubleLE (offset, noAssert) {
  if (!noAssert) checkOffset(offset, 8, this.length)
  return ieee754.read(this, offset, true, 52, 8)
}

Buffer.prototype.readDoubleBE = function readDoubleBE (offset, noAssert) {
  if (!noAssert) checkOffset(offset, 8, this.length)
  return ieee754.read(this, offset, false, 52, 8)
}

function checkInt (buf, value, offset, ext, max, min) {
  if (!Buffer.isBuffer(buf)) throw new TypeError('buffer must be a Buffer instance')
  if (value > max || value < min) throw new RangeError('value is out of bounds')
  if (offset + ext > buf.length) throw new RangeError('index out of range')
}

Buffer.prototype.writeUIntLE = function writeUIntLE (value, offset, byteLength, noAssert) {
  value = +value
  offset = offset | 0
  byteLength = byteLength | 0
  if (!noAssert) checkInt(this, value, offset, byteLength, Math.pow(2, 8 * byteLength), 0)

  var mul = 1
  var i = 0
  this[offset] = value & 0xFF
  while (++i < byteLength && (mul *= 0x100)) {
    this[offset + i] = (value / mul) & 0xFF
  }

  return offset + byteLength
}

Buffer.prototype.writeUIntBE = function writeUIntBE (value, offset, byteLength, noAssert) {
  value = +value
  offset = offset | 0
  byteLength = byteLength | 0
  if (!noAssert) checkInt(this, value, offset, byteLength, Math.pow(2, 8 * byteLength), 0)

  var i = byteLength - 1
  var mul = 1
  this[offset + i] = value & 0xFF
  while (--i >= 0 && (mul *= 0x100)) {
    this[offset + i] = (value / mul) & 0xFF
  }

  return offset + byteLength
}

Buffer.prototype.writeUInt8 = function writeUInt8 (value, offset, noAssert) {
  value = +value
  offset = offset | 0
  if (!noAssert) checkInt(this, value, offset, 1, 0xff, 0)
  if (!Buffer.TYPED_ARRAY_SUPPORT) value = Math.floor(value)
  this[offset] = (value & 0xff)
  return offset + 1
}

function objectWriteUInt16 (buf, value, offset, littleEndian) {
  if (value < 0) value = 0xffff + value + 1
  for (var i = 0, j = Math.min(buf.length - offset, 2); i < j; i++) {
    buf[offset + i] = (value & (0xff << (8 * (littleEndian ? i : 1 - i)))) >>>
      (littleEndian ? i : 1 - i) * 8
  }
}

Buffer.prototype.writeUInt16LE = function writeUInt16LE (value, offset, noAssert) {
  value = +value
  offset = offset | 0
  if (!noAssert) checkInt(this, value, offset, 2, 0xffff, 0)
  if (Buffer.TYPED_ARRAY_SUPPORT) {
    this[offset] = (value & 0xff)
    this[offset + 1] = (value >>> 8)
  } else {
    objectWriteUInt16(this, value, offset, true)
  }
  return offset + 2
}

Buffer.prototype.writeUInt16BE = function writeUInt16BE (value, offset, noAssert) {
  value = +value
  offset = offset | 0
  if (!noAssert) checkInt(this, value, offset, 2, 0xffff, 0)
  if (Buffer.TYPED_ARRAY_SUPPORT) {
    this[offset] = (value >>> 8)
    this[offset + 1] = (value & 0xff)
  } else {
    objectWriteUInt16(this, value, offset, false)
  }
  return offset + 2
}

function objectWriteUInt32 (buf, value, offset, littleEndian) {
  if (value < 0) value = 0xffffffff + value + 1
  for (var i = 0, j = Math.min(buf.length - offset, 4); i < j; i++) {
    buf[offset + i] = (value >>> (littleEndian ? i : 3 - i) * 8) & 0xff
  }
}

Buffer.prototype.writeUInt32LE = function writeUInt32LE (value, offset, noAssert) {
  value = +value
  offset = offset | 0
  if (!noAssert) checkInt(this, value, offset, 4, 0xffffffff, 0)
  if (Buffer.TYPED_ARRAY_SUPPORT) {
    this[offset + 3] = (value >>> 24)
    this[offset + 2] = (value >>> 16)
    this[offset + 1] = (value >>> 8)
    this[offset] = (value & 0xff)
  } else {
    objectWriteUInt32(this, value, offset, true)
  }
  return offset + 4
}

Buffer.prototype.writeUInt32BE = function writeUInt32BE (value, offset, noAssert) {
  value = +value
  offset = offset | 0
  if (!noAssert) checkInt(this, value, offset, 4, 0xffffffff, 0)
  if (Buffer.TYPED_ARRAY_SUPPORT) {
    this[offset] = (value >>> 24)
    this[offset + 1] = (value >>> 16)
    this[offset + 2] = (value >>> 8)
    this[offset + 3] = (value & 0xff)
  } else {
    objectWriteUInt32(this, value, offset, false)
  }
  return offset + 4
}

Buffer.prototype.writeIntLE = function writeIntLE (value, offset, byteLength, noAssert) {
  value = +value
  offset = offset | 0
  if (!noAssert) {
    var limit = Math.pow(2, 8 * byteLength - 1)

    checkInt(this, value, offset, byteLength, limit - 1, -limit)
  }

  var i = 0
  var mul = 1
  var sub = value < 0 ? 1 : 0
  this[offset] = value & 0xFF
  while (++i < byteLength && (mul *= 0x100)) {
    this[offset + i] = ((value / mul) >> 0) - sub & 0xFF
  }

  return offset + byteLength
}

Buffer.prototype.writeIntBE = function writeIntBE (value, offset, byteLength, noAssert) {
  value = +value
  offset = offset | 0
  if (!noAssert) {
    var limit = Math.pow(2, 8 * byteLength - 1)

    checkInt(this, value, offset, byteLength, limit - 1, -limit)
  }

  var i = byteLength - 1
  var mul = 1
  var sub = value < 0 ? 1 : 0
  this[offset + i] = value & 0xFF
  while (--i >= 0 && (mul *= 0x100)) {
    this[offset + i] = ((value / mul) >> 0) - sub & 0xFF
  }

  return offset + byteLength
}

Buffer.prototype.writeInt8 = function writeInt8 (value, offset, noAssert) {
  value = +value
  offset = offset | 0
  if (!noAssert) checkInt(this, value, offset, 1, 0x7f, -0x80)
  if (!Buffer.TYPED_ARRAY_SUPPORT) value = Math.floor(value)
  if (value < 0) value = 0xff + value + 1
  this[offset] = (value & 0xff)
  return offset + 1
}

Buffer.prototype.writeInt16LE = function writeInt16LE (value, offset, noAssert) {
  value = +value
  offset = offset | 0
  if (!noAssert) checkInt(this, value, offset, 2, 0x7fff, -0x8000)
  if (Buffer.TYPED_ARRAY_SUPPORT) {
    this[offset] = (value & 0xff)
    this[offset + 1] = (value >>> 8)
  } else {
    objectWriteUInt16(this, value, offset, true)
  }
  return offset + 2
}

Buffer.prototype.writeInt16BE = function writeInt16BE (value, offset, noAssert) {
  value = +value
  offset = offset | 0
  if (!noAssert) checkInt(this, value, offset, 2, 0x7fff, -0x8000)
  if (Buffer.TYPED_ARRAY_SUPPORT) {
    this[offset] = (value >>> 8)
    this[offset + 1] = (value & 0xff)
  } else {
    objectWriteUInt16(this, value, offset, false)
  }
  return offset + 2
}

Buffer.prototype.writeInt32LE = function writeInt32LE (value, offset, noAssert) {
  value = +value
  offset = offset | 0
  if (!noAssert) checkInt(this, value, offset, 4, 0x7fffffff, -0x80000000)
  if (Buffer.TYPED_ARRAY_SUPPORT) {
    this[offset] = (value & 0xff)
    this[offset + 1] = (value >>> 8)
    this[offset + 2] = (value >>> 16)
    this[offset + 3] = (value >>> 24)
  } else {
    objectWriteUInt32(this, value, offset, true)
  }
  return offset + 4
}

Buffer.prototype.writeInt32BE = function writeInt32BE (value, offset, noAssert) {
  value = +value
  offset = offset | 0
  if (!noAssert) checkInt(this, value, offset, 4, 0x7fffffff, -0x80000000)
  if (value < 0) value = 0xffffffff + value + 1
  if (Buffer.TYPED_ARRAY_SUPPORT) {
    this[offset] = (value >>> 24)
    this[offset + 1] = (value >>> 16)
    this[offset + 2] = (value >>> 8)
    this[offset + 3] = (value & 0xff)
  } else {
    objectWriteUInt32(this, value, offset, false)
  }
  return offset + 4
}

function checkIEEE754 (buf, value, offset, ext, max, min) {
  if (value > max || value < min) throw new RangeError('value is out of bounds')
  if (offset + ext > buf.length) throw new RangeError('index out of range')
  if (offset < 0) throw new RangeError('index out of range')
}

function writeFloat (buf, value, offset, littleEndian, noAssert) {
  if (!noAssert) {
    checkIEEE754(buf, value, offset, 4, 3.4028234663852886e+38, -3.4028234663852886e+38)
  }
  ieee754.write(buf, value, offset, littleEndian, 23, 4)
  return offset + 4
}

Buffer.prototype.writeFloatLE = function writeFloatLE (value, offset, noAssert) {
  return writeFloat(this, value, offset, true, noAssert)
}

Buffer.prototype.writeFloatBE = function writeFloatBE (value, offset, noAssert) {
  return writeFloat(this, value, offset, false, noAssert)
}

function writeDouble (buf, value, offset, littleEndian, noAssert) {
  if (!noAssert) {
    checkIEEE754(buf, value, offset, 8, 1.7976931348623157E+308, -1.7976931348623157E+308)
  }
  ieee754.write(buf, value, offset, littleEndian, 52, 8)
  return offset + 8
}

Buffer.prototype.writeDoubleLE = function writeDoubleLE (value, offset, noAssert) {
  return writeDouble(this, value, offset, true, noAssert)
}

Buffer.prototype.writeDoubleBE = function writeDoubleBE (value, offset, noAssert) {
  return writeDouble(this, value, offset, false, noAssert)
}

// copy(targetBuffer, targetStart=0, sourceStart=0, sourceEnd=buffer.length)
Buffer.prototype.copy = function copy (target, targetStart, start, end) {
  if (!start) start = 0
  if (!end && end !== 0) end = this.length
  if (targetStart >= target.length) targetStart = target.length
  if (!targetStart) targetStart = 0
  if (end > 0 && end < start) end = start

  // Copy 0 bytes; we're done
  if (end === start) return 0
  if (target.length === 0 || this.length === 0) return 0

  // Fatal error conditions
  if (targetStart < 0) {
    throw new RangeError('targetStart out of bounds')
  }
  if (start < 0 || start >= this.length) throw new RangeError('sourceStart out of bounds')
  if (end < 0) throw new RangeError('sourceEnd out of bounds')

  // Are we oob?
  if (end > this.length) end = this.length
  if (target.length - targetStart < end - start) {
    end = target.length - targetStart + start
  }

  var len = end - start
  var i

  if (this === target && start < targetStart && targetStart < end) {
    // descending copy from end
    for (i = len - 1; i >= 0; i--) {
      target[i + targetStart] = this[i + start]
    }
  } else if (len < 1000 || !Buffer.TYPED_ARRAY_SUPPORT) {
    // ascending copy from start
    for (i = 0; i < len; i++) {
      target[i + targetStart] = this[i + start]
    }
  } else {
    target._set(this.subarray(start, start + len), targetStart)
  }

  return len
}

// fill(value, start=0, end=buffer.length)
Buffer.prototype.fill = function fill (value, start, end) {
  if (!value) value = 0
  if (!start) start = 0
  if (!end) end = this.length

  if (end < start) throw new RangeError('end < start')

  // Fill 0 bytes; we're done
  if (end === start) return
  if (this.length === 0) return

  if (start < 0 || start >= this.length) throw new RangeError('start out of bounds')
  if (end < 0 || end > this.length) throw new RangeError('end out of bounds')

  var i
  if (typeof value === 'number') {
    for (i = start; i < end; i++) {
      this[i] = value
    }
  } else {
    var bytes = utf8ToBytes(value.toString())
    var len = bytes.length
    for (i = start; i < end; i++) {
      this[i] = bytes[i % len]
    }
  }

  return this
}

/**
 * Creates a new `ArrayBuffer` with the *copied* memory of the buffer instance.
 * Added in Node 0.12. Only available in browsers that support ArrayBuffer.
 */
Buffer.prototype.toArrayBuffer = function toArrayBuffer () {
  if (typeof Uint8Array !== 'undefined') {
    if (Buffer.TYPED_ARRAY_SUPPORT) {
      return (new Buffer(this)).buffer
    } else {
      var buf = new Uint8Array(this.length)
      for (var i = 0, len = buf.length; i < len; i += 1) {
        buf[i] = this[i]
      }
      return buf.buffer
    }
  } else {
    throw new TypeError('Buffer.toArrayBuffer not supported in this browser')
  }
}

// HELPER FUNCTIONS
// ================

var BP = Buffer.prototype

/**
 * Augment a Uint8Array *instance* (not the Uint8Array class!) with Buffer methods
 */
Buffer._augment = function _augment (arr) {
  arr.constructor = Buffer
  arr._isBuffer = true

  // save reference to original Uint8Array set method before overwriting
  arr._set = arr.set

  // deprecated
  arr.get = BP.get
  arr.set = BP.set

  arr.write = BP.write
  arr.toString = BP.toString
  arr.toLocaleString = BP.toString
  arr.toJSON = BP.toJSON
  arr.equals = BP.equals
  arr.compare = BP.compare
  arr.indexOf = BP.indexOf
  arr.copy = BP.copy
  arr.slice = BP.slice
  arr.readUIntLE = BP.readUIntLE
  arr.readUIntBE = BP.readUIntBE
  arr.readUInt8 = BP.readUInt8
  arr.readUInt16LE = BP.readUInt16LE
  arr.readUInt16BE = BP.readUInt16BE
  arr.readUInt32LE = BP.readUInt32LE
  arr.readUInt32BE = BP.readUInt32BE
  arr.readIntLE = BP.readIntLE
  arr.readIntBE = BP.readIntBE
  arr.readInt8 = BP.readInt8
  arr.readInt16LE = BP.readInt16LE
  arr.readInt16BE = BP.readInt16BE
  arr.readInt32LE = BP.readInt32LE
  arr.readInt32BE = BP.readInt32BE
  arr.readFloatLE = BP.readFloatLE
  arr.readFloatBE = BP.readFloatBE
  arr.readDoubleLE = BP.readDoubleLE
  arr.readDoubleBE = BP.readDoubleBE
  arr.writeUInt8 = BP.writeUInt8
  arr.writeUIntLE = BP.writeUIntLE
  arr.writeUIntBE = BP.writeUIntBE
  arr.writeUInt16LE = BP.writeUInt16LE
  arr.writeUInt16BE = BP.writeUInt16BE
  arr.writeUInt32LE = BP.writeUInt32LE
  arr.writeUInt32BE = BP.writeUInt32BE
  arr.writeIntLE = BP.writeIntLE
  arr.writeIntBE = BP.writeIntBE
  arr.writeInt8 = BP.writeInt8
  arr.writeInt16LE = BP.writeInt16LE
  arr.writeInt16BE = BP.writeInt16BE
  arr.writeInt32LE = BP.writeInt32LE
  arr.writeInt32BE = BP.writeInt32BE
  arr.writeFloatLE = BP.writeFloatLE
  arr.writeFloatBE = BP.writeFloatBE
  arr.writeDoubleLE = BP.writeDoubleLE
  arr.writeDoubleBE = BP.writeDoubleBE
  arr.fill = BP.fill
  arr.inspect = BP.inspect
  arr.toArrayBuffer = BP.toArrayBuffer

  return arr
}

var INVALID_BASE64_RE = /[^+\/0-9A-Za-z-_]/g

function base64clean (str) {
  // Node strips out invalid characters like \n and \t from the string, base64-js does not
  str = stringtrim(str).replace(INVALID_BASE64_RE, '')
  // Node converts strings with length < 2 to ''
  if (str.length < 2) return ''
  // Node allows for non-padded base64 strings (missing trailing ===), base64-js does not
  while (str.length % 4 !== 0) {
    str = str + '='
  }
  return str
}

function stringtrim (str) {
  if (str.trim) return str.trim()
  return str.replace(/^\s+|\s+$/g, '')
}

function toHex (n) {
  if (n < 16) return '0' + n.toString(16)
  return n.toString(16)
}

function utf8ToBytes (string, units) {
  units = units || Infinity
  var codePoint
  var length = string.length
  var leadSurrogate = null
  var bytes = []

  for (var i = 0; i < length; i++) {
    codePoint = string.charCodeAt(i)

    // is surrogate component
    if (codePoint > 0xD7FF && codePoint < 0xE000) {
      // last char was a lead
      if (!leadSurrogate) {
        // no lead yet
        if (codePoint > 0xDBFF) {
          // unexpected trail
          if ((units -= 3) > -1) bytes.push(0xEF, 0xBF, 0xBD)
          continue
        } else if (i + 1 === length) {
          // unpaired lead
          if ((units -= 3) > -1) bytes.push(0xEF, 0xBF, 0xBD)
          continue
        }

        // valid lead
        leadSurrogate = codePoint

        continue
      }

      // 2 leads in a row
      if (codePoint < 0xDC00) {
        if ((units -= 3) > -1) bytes.push(0xEF, 0xBF, 0xBD)
        leadSurrogate = codePoint
        continue
      }

      // valid surrogate pair
      codePoint = (leadSurrogate - 0xD800 << 10 | codePoint - 0xDC00) + 0x10000
    } else if (leadSurrogate) {
      // valid bmp char, but last char was a lead
      if ((units -= 3) > -1) bytes.push(0xEF, 0xBF, 0xBD)
    }

    leadSurrogate = null

    // encode utf8
    if (codePoint < 0x80) {
      if ((units -= 1) < 0) break
      bytes.push(codePoint)
    } else if (codePoint < 0x800) {
      if ((units -= 2) < 0) break
      bytes.push(
        codePoint >> 0x6 | 0xC0,
        codePoint & 0x3F | 0x80
      )
    } else if (codePoint < 0x10000) {
      if ((units -= 3) < 0) break
      bytes.push(
        codePoint >> 0xC | 0xE0,
        codePoint >> 0x6 & 0x3F | 0x80,
        codePoint & 0x3F | 0x80
      )
    } else if (codePoint < 0x110000) {
      if ((units -= 4) < 0) break
      bytes.push(
        codePoint >> 0x12 | 0xF0,
        codePoint >> 0xC & 0x3F | 0x80,
        codePoint >> 0x6 & 0x3F | 0x80,
        codePoint & 0x3F | 0x80
      )
    } else {
      throw new Error('Invalid code point')
    }
  }

  return bytes
}

function asciiToBytes (str) {
  var byteArray = []
  for (var i = 0; i < str.length; i++) {
    // Node's code seems to be doing this and not & 0x7F..
    byteArray.push(str.charCodeAt(i) & 0xFF)
  }
  return byteArray
}

function utf16leToBytes (str, units) {
  var c, hi, lo
  var byteArray = []
  for (var i = 0; i < str.length; i++) {
    if ((units -= 2) < 0) break

    c = str.charCodeAt(i)
    hi = c >> 8
    lo = c % 256
    byteArray.push(lo)
    byteArray.push(hi)
  }

  return byteArray
}

function base64ToBytes (str) {
  return base64.toByteArray(base64clean(str))
}

function blitBuffer (src, dst, offset, length) {
  for (var i = 0; i < length; i++) {
    if ((i + offset >= dst.length) || (i >= src.length)) break
    dst[i + offset] = src[i]
  }
  return i
}

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"base64-js":1,"ieee754":5,"isarray":4}],4:[function(require,module,exports){
var toString = {}.toString;

module.exports = Array.isArray || function (arr) {
  return toString.call(arr) == '[object Array]';
};

},{}],5:[function(require,module,exports){
exports.read = function (buffer, offset, isLE, mLen, nBytes) {
  var e, m
  var eLen = nBytes * 8 - mLen - 1
  var eMax = (1 << eLen) - 1
  var eBias = eMax >> 1
  var nBits = -7
  var i = isLE ? (nBytes - 1) : 0
  var d = isLE ? -1 : 1
  var s = buffer[offset + i]

  i += d

  e = s & ((1 << (-nBits)) - 1)
  s >>= (-nBits)
  nBits += eLen
  for (; nBits > 0; e = e * 256 + buffer[offset + i], i += d, nBits -= 8) {}

  m = e & ((1 << (-nBits)) - 1)
  e >>= (-nBits)
  nBits += mLen
  for (; nBits > 0; m = m * 256 + buffer[offset + i], i += d, nBits -= 8) {}

  if (e === 0) {
    e = 1 - eBias
  } else if (e === eMax) {
    return m ? NaN : ((s ? -1 : 1) * Infinity)
  } else {
    m = m + Math.pow(2, mLen)
    e = e - eBias
  }
  return (s ? -1 : 1) * m * Math.pow(2, e - mLen)
}

exports.write = function (buffer, value, offset, isLE, mLen, nBytes) {
  var e, m, c
  var eLen = nBytes * 8 - mLen - 1
  var eMax = (1 << eLen) - 1
  var eBias = eMax >> 1
  var rt = (mLen === 23 ? Math.pow(2, -24) - Math.pow(2, -77) : 0)
  var i = isLE ? 0 : (nBytes - 1)
  var d = isLE ? 1 : -1
  var s = value < 0 || (value === 0 && 1 / value < 0) ? 1 : 0

  value = Math.abs(value)

  if (isNaN(value) || value === Infinity) {
    m = isNaN(value) ? 1 : 0
    e = eMax
  } else {
    e = Math.floor(Math.log(value) / Math.LN2)
    if (value * (c = Math.pow(2, -e)) < 1) {
      e--
      c *= 2
    }
    if (e + eBias >= 1) {
      value += rt / c
    } else {
      value += rt * Math.pow(2, 1 - eBias)
    }
    if (value * c >= 2) {
      e++
      c /= 2
    }

    if (e + eBias >= eMax) {
      m = 0
      e = eMax
    } else if (e + eBias >= 1) {
      m = (value * c - 1) * Math.pow(2, mLen)
      e = e + eBias
    } else {
      m = value * Math.pow(2, eBias - 1) * Math.pow(2, mLen)
      e = 0
    }
  }

  for (; mLen >= 8; buffer[offset + i] = m & 0xff, i += d, m /= 256, mLen -= 8) {}

  e = (e << mLen) | m
  eLen += mLen
  for (; eLen > 0; buffer[offset + i] = e & 0xff, i += d, e /= 256, eLen -= 8) {}

  buffer[offset + i - d] |= s * 128
}

},{}],6:[function(require,module,exports){
(function (process){
// Copyright Joyent, Inc. and other Node contributors.
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to permit
// persons to whom the Software is furnished to do so, subject to the
// following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
// NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
// USE OR OTHER DEALINGS IN THE SOFTWARE.

// resolves . and .. elements in a path array with directory names there
// must be no slashes, empty elements, or device names (c:\) in the array
// (so also no leading and trailing slashes - it does not distinguish
// relative and absolute paths)
function normalizeArray(parts, allowAboveRoot) {
  // if the path tries to go above the root, `up` ends up > 0
  var up = 0;
  for (var i = parts.length - 1; i >= 0; i--) {
    var last = parts[i];
    if (last === '.') {
      parts.splice(i, 1);
    } else if (last === '..') {
      parts.splice(i, 1);
      up++;
    } else if (up) {
      parts.splice(i, 1);
      up--;
    }
  }

  // if the path is allowed to go above the root, restore leading ..s
  if (allowAboveRoot) {
    for (; up--; up) {
      parts.unshift('..');
    }
  }

  return parts;
}

// Split a filename into [root, dir, basename, ext], unix version
// 'root' is just a slash, or nothing.
var splitPathRe =
    /^(\/?|)([\s\S]*?)((?:\.{1,2}|[^\/]+?|)(\.[^.\/]*|))(?:[\/]*)$/;
var splitPath = function(filename) {
  return splitPathRe.exec(filename).slice(1);
};

// path.resolve([from ...], to)
// posix version
exports.resolve = function() {
  var resolvedPath = '',
      resolvedAbsolute = false;

  for (var i = arguments.length - 1; i >= -1 && !resolvedAbsolute; i--) {
    var path = (i >= 0) ? arguments[i] : process.cwd();

    // Skip empty and invalid entries
    if (typeof path !== 'string') {
      throw new TypeError('Arguments to path.resolve must be strings');
    } else if (!path) {
      continue;
    }

    resolvedPath = path + '/' + resolvedPath;
    resolvedAbsolute = path.charAt(0) === '/';
  }

  // At this point the path should be resolved to a full absolute path, but
  // handle relative paths to be safe (might happen when process.cwd() fails)

  // Normalize the path
  resolvedPath = normalizeArray(filter(resolvedPath.split('/'), function(p) {
    return !!p;
  }), !resolvedAbsolute).join('/');

  return ((resolvedAbsolute ? '/' : '') + resolvedPath) || '.';
};

// path.normalize(path)
// posix version
exports.normalize = function(path) {
  var isAbsolute = exports.isAbsolute(path),
      trailingSlash = substr(path, -1) === '/';

  // Normalize the path
  path = normalizeArray(filter(path.split('/'), function(p) {
    return !!p;
  }), !isAbsolute).join('/');

  if (!path && !isAbsolute) {
    path = '.';
  }
  if (path && trailingSlash) {
    path += '/';
  }

  return (isAbsolute ? '/' : '') + path;
};

// posix version
exports.isAbsolute = function(path) {
  return path.charAt(0) === '/';
};

// posix version
exports.join = function() {
  var paths = Array.prototype.slice.call(arguments, 0);
  return exports.normalize(filter(paths, function(p, index) {
    if (typeof p !== 'string') {
      throw new TypeError('Arguments to path.join must be strings');
    }
    return p;
  }).join('/'));
};


// path.relative(from, to)
// posix version
exports.relative = function(from, to) {
  from = exports.resolve(from).substr(1);
  to = exports.resolve(to).substr(1);

  function trim(arr) {
    var start = 0;
    for (; start < arr.length; start++) {
      if (arr[start] !== '') break;
    }

    var end = arr.length - 1;
    for (; end >= 0; end--) {
      if (arr[end] !== '') break;
    }

    if (start > end) return [];
    return arr.slice(start, end - start + 1);
  }

  var fromParts = trim(from.split('/'));
  var toParts = trim(to.split('/'));

  var length = Math.min(fromParts.length, toParts.length);
  var samePartsLength = length;
  for (var i = 0; i < length; i++) {
    if (fromParts[i] !== toParts[i]) {
      samePartsLength = i;
      break;
    }
  }

  var outputParts = [];
  for (var i = samePartsLength; i < fromParts.length; i++) {
    outputParts.push('..');
  }

  outputParts = outputParts.concat(toParts.slice(samePartsLength));

  return outputParts.join('/');
};

exports.sep = '/';
exports.delimiter = ':';

exports.dirname = function(path) {
  var result = splitPath(path),
      root = result[0],
      dir = result[1];

  if (!root && !dir) {
    // No dirname whatsoever
    return '.';
  }

  if (dir) {
    // It has a dirname, strip trailing slash
    dir = dir.substr(0, dir.length - 1);
  }

  return root + dir;
};


exports.basename = function(path, ext) {
  var f = splitPath(path)[2];
  // TODO: make this comparison case-insensitive on windows?
  if (ext && f.substr(-1 * ext.length) === ext) {
    f = f.substr(0, f.length - ext.length);
  }
  return f;
};


exports.extname = function(path) {
  return splitPath(path)[3];
};

function filter (xs, f) {
    if (xs.filter) return xs.filter(f);
    var res = [];
    for (var i = 0; i < xs.length; i++) {
        if (f(xs[i], i, xs)) res.push(xs[i]);
    }
    return res;
}

// String.prototype.substr - negative index don't work in IE8
var substr = 'ab'.substr(-1) === 'b'
    ? function (str, start, len) { return str.substr(start, len) }
    : function (str, start, len) {
        if (start < 0) start = str.length + start;
        return str.substr(start, len);
    }
;

}).call(this,require('_process'))
},{"_process":7}],7:[function(require,module,exports){
// shim for using process in browser

var process = module.exports = {};
var queue = [];
var draining = false;
var currentQueue;
var queueIndex = -1;

function cleanUpNextTick() {
    draining = false;
    if (currentQueue.length) {
        queue = currentQueue.concat(queue);
    } else {
        queueIndex = -1;
    }
    if (queue.length) {
        drainQueue();
    }
}

function drainQueue() {
    if (draining) {
        return;
    }
    var timeout = setTimeout(cleanUpNextTick);
    draining = true;

    var len = queue.length;
    while(len) {
        currentQueue = queue;
        queue = [];
        while (++queueIndex < len) {
            if (currentQueue) {
                currentQueue[queueIndex].run();
            }
        }
        queueIndex = -1;
        len = queue.length;
    }
    currentQueue = null;
    draining = false;
    clearTimeout(timeout);
}

process.nextTick = function (fun) {
    var args = new Array(arguments.length - 1);
    if (arguments.length > 1) {
        for (var i = 1; i < arguments.length; i++) {
            args[i - 1] = arguments[i];
        }
    }
    queue.push(new Item(fun, args));
    if (queue.length === 1 && !draining) {
        setTimeout(drainQueue, 0);
    }
};

// v8 likes predictible objects
function Item(fun, array) {
    this.fun = fun;
    this.array = array;
}
Item.prototype.run = function () {
    this.fun.apply(null, this.array);
};
process.title = 'browser';
process.browser = true;
process.env = {};
process.argv = [];
process.version = ''; // empty string to avoid regexp issues
process.versions = {};

function noop() {}

process.on = noop;
process.addListener = noop;
process.once = noop;
process.off = noop;
process.removeListener = noop;
process.removeAllListeners = noop;
process.emit = noop;

process.binding = function (name) {
    throw new Error('process.binding is not supported');
};

process.cwd = function () { return '/' };
process.chdir = function (dir) {
    throw new Error('process.chdir is not supported');
};
process.umask = function() { return 0; };

},{}],8:[function(require,module,exports){
(function (global){
/*! https://mths.be/punycode v1.4.1 by @mathias */
;(function(root) {

	/** Detect free variables */
	var freeExports = typeof exports == 'object' && exports &&
		!exports.nodeType && exports;
	var freeModule = typeof module == 'object' && module &&
		!module.nodeType && module;
	var freeGlobal = typeof global == 'object' && global;
	if (
		freeGlobal.global === freeGlobal ||
		freeGlobal.window === freeGlobal ||
		freeGlobal.self === freeGlobal
	) {
		root = freeGlobal;
	}

	/**
	 * The `punycode` object.
	 * @name punycode
	 * @type Object
	 */
	var punycode,

	/** Highest positive signed 32-bit float value */
	maxInt = 2147483647, // aka. 0x7FFFFFFF or 2^31-1

	/** Bootstring parameters */
	base = 36,
	tMin = 1,
	tMax = 26,
	skew = 38,
	damp = 700,
	initialBias = 72,
	initialN = 128, // 0x80
	delimiter = '-', // '\x2D'

	/** Regular expressions */
	regexPunycode = /^xn--/,
	regexNonASCII = /[^\x20-\x7E]/, // unprintable ASCII chars + non-ASCII chars
	regexSeparators = /[\x2E\u3002\uFF0E\uFF61]/g, // RFC 3490 separators

	/** Error messages */
	errors = {
		'overflow': 'Overflow: input needs wider integers to process',
		'not-basic': 'Illegal input >= 0x80 (not a basic code point)',
		'invalid-input': 'Invalid input'
	},

	/** Convenience shortcuts */
	baseMinusTMin = base - tMin,
	floor = Math.floor,
	stringFromCharCode = String.fromCharCode,

	/** Temporary variable */
	key;

	/*--------------------------------------------------------------------------*/

	/**
	 * A generic error utility function.
	 * @private
	 * @param {String} type The error type.
	 * @returns {Error} Throws a `RangeError` with the applicable error message.
	 */
	function error(type) {
		throw new RangeError(errors[type]);
	}

	/**
	 * A generic `Array#map` utility function.
	 * @private
	 * @param {Array} array The array to iterate over.
	 * @param {Function} callback The function that gets called for every array
	 * item.
	 * @returns {Array} A new array of values returned by the callback function.
	 */
	function map(array, fn) {
		var length = array.length;
		var result = [];
		while (length--) {
			result[length] = fn(array[length]);
		}
		return result;
	}

	/**
	 * A simple `Array#map`-like wrapper to work with domain name strings or email
	 * addresses.
	 * @private
	 * @param {String} domain The domain name or email address.
	 * @param {Function} callback The function that gets called for every
	 * character.
	 * @returns {Array} A new string of characters returned by the callback
	 * function.
	 */
	function mapDomain(string, fn) {
		var parts = string.split('@');
		var result = '';
		if (parts.length > 1) {
			// In email addresses, only the domain name should be punycoded. Leave
			// the local part (i.e. everything up to `@`) intact.
			result = parts[0] + '@';
			string = parts[1];
		}
		// Avoid `split(regex)` for IE8 compatibility. See #17.
		string = string.replace(regexSeparators, '\x2E');
		var labels = string.split('.');
		var encoded = map(labels, fn).join('.');
		return result + encoded;
	}

	/**
	 * Creates an array containing the numeric code points of each Unicode
	 * character in the string. While JavaScript uses UCS-2 internally,
	 * this function will convert a pair of surrogate halves (each of which
	 * UCS-2 exposes as separate characters) into a single code point,
	 * matching UTF-16.
	 * @see `punycode.ucs2.encode`
	 * @see <https://mathiasbynens.be/notes/javascript-encoding>
	 * @memberOf punycode.ucs2
	 * @name decode
	 * @param {String} string The Unicode input string (UCS-2).
	 * @returns {Array} The new array of code points.
	 */
	function ucs2decode(string) {
		var output = [],
		    counter = 0,
		    length = string.length,
		    value,
		    extra;
		while (counter < length) {
			value = string.charCodeAt(counter++);
			if (value >= 0xD800 && value <= 0xDBFF && counter < length) {
				// high surrogate, and there is a next character
				extra = string.charCodeAt(counter++);
				if ((extra & 0xFC00) == 0xDC00) { // low surrogate
					output.push(((value & 0x3FF) << 10) + (extra & 0x3FF) + 0x10000);
				} else {
					// unmatched surrogate; only append this code unit, in case the next
					// code unit is the high surrogate of a surrogate pair
					output.push(value);
					counter--;
				}
			} else {
				output.push(value);
			}
		}
		return output;
	}

	/**
	 * Creates a string based on an array of numeric code points.
	 * @see `punycode.ucs2.decode`
	 * @memberOf punycode.ucs2
	 * @name encode
	 * @param {Array} codePoints The array of numeric code points.
	 * @returns {String} The new Unicode string (UCS-2).
	 */
	function ucs2encode(array) {
		return map(array, function(value) {
			var output = '';
			if (value > 0xFFFF) {
				value -= 0x10000;
				output += stringFromCharCode(value >>> 10 & 0x3FF | 0xD800);
				value = 0xDC00 | value & 0x3FF;
			}
			output += stringFromCharCode(value);
			return output;
		}).join('');
	}

	/**
	 * Converts a basic code point into a digit/integer.
	 * @see `digitToBasic()`
	 * @private
	 * @param {Number} codePoint The basic numeric code point value.
	 * @returns {Number} The numeric value of a basic code point (for use in
	 * representing integers) in the range `0` to `base - 1`, or `base` if
	 * the code point does not represent a value.
	 */
	function basicToDigit(codePoint) {
		if (codePoint - 48 < 10) {
			return codePoint - 22;
		}
		if (codePoint - 65 < 26) {
			return codePoint - 65;
		}
		if (codePoint - 97 < 26) {
			return codePoint - 97;
		}
		return base;
	}

	/**
	 * Converts a digit/integer into a basic code point.
	 * @see `basicToDigit()`
	 * @private
	 * @param {Number} digit The numeric value of a basic code point.
	 * @returns {Number} The basic code point whose value (when used for
	 * representing integers) is `digit`, which needs to be in the range
	 * `0` to `base - 1`. If `flag` is non-zero, the uppercase form is
	 * used; else, the lowercase form is used. The behavior is undefined
	 * if `flag` is non-zero and `digit` has no uppercase form.
	 */
	function digitToBasic(digit, flag) {
		//  0..25 map to ASCII a..z or A..Z
		// 26..35 map to ASCII 0..9
		return digit + 22 + 75 * (digit < 26) - ((flag != 0) << 5);
	}

	/**
	 * Bias adaptation function as per section 3.4 of RFC 3492.
	 * https://tools.ietf.org/html/rfc3492#section-3.4
	 * @private
	 */
	function adapt(delta, numPoints, firstTime) {
		var k = 0;
		delta = firstTime ? floor(delta / damp) : delta >> 1;
		delta += floor(delta / numPoints);
		for (/* no initialization */; delta > baseMinusTMin * tMax >> 1; k += base) {
			delta = floor(delta / baseMinusTMin);
		}
		return floor(k + (baseMinusTMin + 1) * delta / (delta + skew));
	}

	/**
	 * Converts a Punycode string of ASCII-only symbols to a string of Unicode
	 * symbols.
	 * @memberOf punycode
	 * @param {String} input The Punycode string of ASCII-only symbols.
	 * @returns {String} The resulting string of Unicode symbols.
	 */
	function decode(input) {
		// Don't use UCS-2
		var output = [],
		    inputLength = input.length,
		    out,
		    i = 0,
		    n = initialN,
		    bias = initialBias,
		    basic,
		    j,
		    index,
		    oldi,
		    w,
		    k,
		    digit,
		    t,
		    /** Cached calculation results */
		    baseMinusT;

		// Handle the basic code points: let `basic` be the number of input code
		// points before the last delimiter, or `0` if there is none, then copy
		// the first basic code points to the output.

		basic = input.lastIndexOf(delimiter);
		if (basic < 0) {
			basic = 0;
		}

		for (j = 0; j < basic; ++j) {
			// if it's not a basic code point
			if (input.charCodeAt(j) >= 0x80) {
				error('not-basic');
			}
			output.push(input.charCodeAt(j));
		}

		// Main decoding loop: start just after the last delimiter if any basic code
		// points were copied; start at the beginning otherwise.

		for (index = basic > 0 ? basic + 1 : 0; index < inputLength; /* no final expression */) {

			// `index` is the index of the next character to be consumed.
			// Decode a generalized variable-length integer into `delta`,
			// which gets added to `i`. The overflow checking is easier
			// if we increase `i` as we go, then subtract off its starting
			// value at the end to obtain `delta`.
			for (oldi = i, w = 1, k = base; /* no condition */; k += base) {

				if (index >= inputLength) {
					error('invalid-input');
				}

				digit = basicToDigit(input.charCodeAt(index++));

				if (digit >= base || digit > floor((maxInt - i) / w)) {
					error('overflow');
				}

				i += digit * w;
				t = k <= bias ? tMin : (k >= bias + tMax ? tMax : k - bias);

				if (digit < t) {
					break;
				}

				baseMinusT = base - t;
				if (w > floor(maxInt / baseMinusT)) {
					error('overflow');
				}

				w *= baseMinusT;

			}

			out = output.length + 1;
			bias = adapt(i - oldi, out, oldi == 0);

			// `i` was supposed to wrap around from `out` to `0`,
			// incrementing `n` each time, so we'll fix that now:
			if (floor(i / out) > maxInt - n) {
				error('overflow');
			}

			n += floor(i / out);
			i %= out;

			// Insert `n` at position `i` of the output
			output.splice(i++, 0, n);

		}

		return ucs2encode(output);
	}

	/**
	 * Converts a string of Unicode symbols (e.g. a domain name label) to a
	 * Punycode string of ASCII-only symbols.
	 * @memberOf punycode
	 * @param {String} input The string of Unicode symbols.
	 * @returns {String} The resulting Punycode string of ASCII-only symbols.
	 */
	function encode(input) {
		var n,
		    delta,
		    handledCPCount,
		    basicLength,
		    bias,
		    j,
		    m,
		    q,
		    k,
		    t,
		    currentValue,
		    output = [],
		    /** `inputLength` will hold the number of code points in `input`. */
		    inputLength,
		    /** Cached calculation results */
		    handledCPCountPlusOne,
		    baseMinusT,
		    qMinusT;

		// Convert the input in UCS-2 to Unicode
		input = ucs2decode(input);

		// Cache the length
		inputLength = input.length;

		// Initialize the state
		n = initialN;
		delta = 0;
		bias = initialBias;

		// Handle the basic code points
		for (j = 0; j < inputLength; ++j) {
			currentValue = input[j];
			if (currentValue < 0x80) {
				output.push(stringFromCharCode(currentValue));
			}
		}

		handledCPCount = basicLength = output.length;

		// `handledCPCount` is the number of code points that have been handled;
		// `basicLength` is the number of basic code points.

		// Finish the basic string - if it is not empty - with a delimiter
		if (basicLength) {
			output.push(delimiter);
		}

		// Main encoding loop:
		while (handledCPCount < inputLength) {

			// All non-basic code points < n have been handled already. Find the next
			// larger one:
			for (m = maxInt, j = 0; j < inputLength; ++j) {
				currentValue = input[j];
				if (currentValue >= n && currentValue < m) {
					m = currentValue;
				}
			}

			// Increase `delta` enough to advance the decoder's <n,i> state to <m,0>,
			// but guard against overflow
			handledCPCountPlusOne = handledCPCount + 1;
			if (m - n > floor((maxInt - delta) / handledCPCountPlusOne)) {
				error('overflow');
			}

			delta += (m - n) * handledCPCountPlusOne;
			n = m;

			for (j = 0; j < inputLength; ++j) {
				currentValue = input[j];

				if (currentValue < n && ++delta > maxInt) {
					error('overflow');
				}

				if (currentValue == n) {
					// Represent delta as a generalized variable-length integer
					for (q = delta, k = base; /* no condition */; k += base) {
						t = k <= bias ? tMin : (k >= bias + tMax ? tMax : k - bias);
						if (q < t) {
							break;
						}
						qMinusT = q - t;
						baseMinusT = base - t;
						output.push(
							stringFromCharCode(digitToBasic(t + qMinusT % baseMinusT, 0))
						);
						q = floor(qMinusT / baseMinusT);
					}

					output.push(stringFromCharCode(digitToBasic(q, 0)));
					bias = adapt(delta, handledCPCountPlusOne, handledCPCount == basicLength);
					delta = 0;
					++handledCPCount;
				}
			}

			++delta;
			++n;

		}
		return output.join('');
	}

	/**
	 * Converts a Punycode string representing a domain name or an email address
	 * to Unicode. Only the Punycoded parts of the input will be converted, i.e.
	 * it doesn't matter if you call it on a string that has already been
	 * converted to Unicode.
	 * @memberOf punycode
	 * @param {String} input The Punycoded domain name or email address to
	 * convert to Unicode.
	 * @returns {String} The Unicode representation of the given Punycode
	 * string.
	 */
	function toUnicode(input) {
		return mapDomain(input, function(string) {
			return regexPunycode.test(string)
				? decode(string.slice(4).toLowerCase())
				: string;
		});
	}

	/**
	 * Converts a Unicode string representing a domain name or an email address to
	 * Punycode. Only the non-ASCII parts of the domain name will be converted,
	 * i.e. it doesn't matter if you call it with a domain that's already in
	 * ASCII.
	 * @memberOf punycode
	 * @param {String} input The domain name or email address to convert, as a
	 * Unicode string.
	 * @returns {String} The Punycode representation of the given domain name or
	 * email address.
	 */
	function toASCII(input) {
		return mapDomain(input, function(string) {
			return regexNonASCII.test(string)
				? 'xn--' + encode(string)
				: string;
		});
	}

	/*--------------------------------------------------------------------------*/

	/** Define the public API */
	punycode = {
		/**
		 * A string representing the current Punycode.js version number.
		 * @memberOf punycode
		 * @type String
		 */
		'version': '1.4.1',
		/**
		 * An object of methods to convert from JavaScript's internal character
		 * representation (UCS-2) to Unicode code points, and back.
		 * @see <https://mathiasbynens.be/notes/javascript-encoding>
		 * @memberOf punycode
		 * @type Object
		 */
		'ucs2': {
			'decode': ucs2decode,
			'encode': ucs2encode
		},
		'decode': decode,
		'encode': encode,
		'toASCII': toASCII,
		'toUnicode': toUnicode
	};

	/** Expose `punycode` */
	// Some AMD build optimizers, like r.js, check for specific condition patterns
	// like the following:
	if (
		typeof define == 'function' &&
		typeof define.amd == 'object' &&
		define.amd
	) {
		define('punycode', function() {
			return punycode;
		});
	} else if (freeExports && freeModule) {
		if (module.exports == freeExports) {
			// in Node.js, io.js, or RingoJS v0.8.0+
			freeModule.exports = punycode;
		} else {
			// in Narwhal or RingoJS v0.7.0-
			for (key in punycode) {
				punycode.hasOwnProperty(key) && (freeExports[key] = punycode[key]);
			}
		}
	} else {
		// in Rhino or a web browser
		root.punycode = punycode;
	}

}(this));

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{}],9:[function(require,module,exports){
// Copyright Joyent, Inc. and other Node contributors.
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to permit
// persons to whom the Software is furnished to do so, subject to the
// following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
// NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
// USE OR OTHER DEALINGS IN THE SOFTWARE.

'use strict';

// If obj.hasOwnProperty has been overridden, then calling
// obj.hasOwnProperty(prop) will break.
// See: https://github.com/joyent/node/issues/1707
function hasOwnProperty(obj, prop) {
  return Object.prototype.hasOwnProperty.call(obj, prop);
}

module.exports = function(qs, sep, eq, options) {
  sep = sep || '&';
  eq = eq || '=';
  var obj = {};

  if (typeof qs !== 'string' || qs.length === 0) {
    return obj;
  }

  var regexp = /\+/g;
  qs = qs.split(sep);

  var maxKeys = 1000;
  if (options && typeof options.maxKeys === 'number') {
    maxKeys = options.maxKeys;
  }

  var len = qs.length;
  // maxKeys <= 0 means that we should not limit keys count
  if (maxKeys > 0 && len > maxKeys) {
    len = maxKeys;
  }

  for (var i = 0; i < len; ++i) {
    var x = qs[i].replace(regexp, '%20'),
        idx = x.indexOf(eq),
        kstr, vstr, k, v;

    if (idx >= 0) {
      kstr = x.substr(0, idx);
      vstr = x.substr(idx + 1);
    } else {
      kstr = x;
      vstr = '';
    }

    k = decodeURIComponent(kstr);
    v = decodeURIComponent(vstr);

    if (!hasOwnProperty(obj, k)) {
      obj[k] = v;
    } else if (isArray(obj[k])) {
      obj[k].push(v);
    } else {
      obj[k] = [obj[k], v];
    }
  }

  return obj;
};

var isArray = Array.isArray || function (xs) {
  return Object.prototype.toString.call(xs) === '[object Array]';
};

},{}],10:[function(require,module,exports){
// Copyright Joyent, Inc. and other Node contributors.
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to permit
// persons to whom the Software is furnished to do so, subject to the
// following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
// NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
// USE OR OTHER DEALINGS IN THE SOFTWARE.

'use strict';

var stringifyPrimitive = function(v) {
  switch (typeof v) {
    case 'string':
      return v;

    case 'boolean':
      return v ? 'true' : 'false';

    case 'number':
      return isFinite(v) ? v : '';

    default:
      return '';
  }
};

module.exports = function(obj, sep, eq, name) {
  sep = sep || '&';
  eq = eq || '=';
  if (obj === null) {
    obj = undefined;
  }

  if (typeof obj === 'object') {
    return map(objectKeys(obj), function(k) {
      var ks = encodeURIComponent(stringifyPrimitive(k)) + eq;
      if (isArray(obj[k])) {
        return map(obj[k], function(v) {
          return ks + encodeURIComponent(stringifyPrimitive(v));
        }).join(sep);
      } else {
        return ks + encodeURIComponent(stringifyPrimitive(obj[k]));
      }
    }).join(sep);

  }

  if (!name) return '';
  return encodeURIComponent(stringifyPrimitive(name)) + eq +
         encodeURIComponent(stringifyPrimitive(obj));
};

var isArray = Array.isArray || function (xs) {
  return Object.prototype.toString.call(xs) === '[object Array]';
};

function map (xs, f) {
  if (xs.map) return xs.map(f);
  var res = [];
  for (var i = 0; i < xs.length; i++) {
    res.push(f(xs[i], i));
  }
  return res;
}

var objectKeys = Object.keys || function (obj) {
  var res = [];
  for (var key in obj) {
    if (Object.prototype.hasOwnProperty.call(obj, key)) res.push(key);
  }
  return res;
};

},{}],11:[function(require,module,exports){
'use strict';

exports.decode = exports.parse = require('./decode');
exports.encode = exports.stringify = require('./encode');

},{"./decode":9,"./encode":10}],12:[function(require,module,exports){
// Copyright Joyent, Inc. and other Node contributors.
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to permit
// persons to whom the Software is furnished to do so, subject to the
// following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
// NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
// USE OR OTHER DEALINGS IN THE SOFTWARE.

var punycode = require('punycode');

exports.parse = urlParse;
exports.resolve = urlResolve;
exports.resolveObject = urlResolveObject;
exports.format = urlFormat;

exports.Url = Url;

function Url() {
  this.protocol = null;
  this.slashes = null;
  this.auth = null;
  this.host = null;
  this.port = null;
  this.hostname = null;
  this.hash = null;
  this.search = null;
  this.query = null;
  this.pathname = null;
  this.path = null;
  this.href = null;
}

// Reference: RFC 3986, RFC 1808, RFC 2396

// define these here so at least they only have to be
// compiled once on the first module load.
var protocolPattern = /^([a-z0-9.+-]+:)/i,
    portPattern = /:[0-9]*$/,

    // RFC 2396: characters reserved for delimiting URLs.
    // We actually just auto-escape these.
    delims = ['<', '>', '"', '`', ' ', '\r', '\n', '\t'],

    // RFC 2396: characters not allowed for various reasons.
    unwise = ['{', '}', '|', '\\', '^', '`'].concat(delims),

    // Allowed by RFCs, but cause of XSS attacks.  Always escape these.
    autoEscape = ['\''].concat(unwise),
    // Characters that are never ever allowed in a hostname.
    // Note that any invalid chars are also handled, but these
    // are the ones that are *expected* to be seen, so we fast-path
    // them.
    nonHostChars = ['%', '/', '?', ';', '#'].concat(autoEscape),
    hostEndingChars = ['/', '?', '#'],
    hostnameMaxLen = 255,
    hostnamePartPattern = /^[a-z0-9A-Z_-]{0,63}$/,
    hostnamePartStart = /^([a-z0-9A-Z_-]{0,63})(.*)$/,
    // protocols that can allow "unsafe" and "unwise" chars.
    unsafeProtocol = {
      'javascript': true,
      'javascript:': true
    },
    // protocols that never have a hostname.
    hostlessProtocol = {
      'javascript': true,
      'javascript:': true
    },
    // protocols that always contain a // bit.
    slashedProtocol = {
      'http': true,
      'https': true,
      'ftp': true,
      'gopher': true,
      'file': true,
      'http:': true,
      'https:': true,
      'ftp:': true,
      'gopher:': true,
      'file:': true
    },
    querystring = require('querystring');

function urlParse(url, parseQueryString, slashesDenoteHost) {
  if (url && isObject(url) && url instanceof Url) return url;

  var u = new Url;
  u.parse(url, parseQueryString, slashesDenoteHost);
  return u;
}

Url.prototype.parse = function(url, parseQueryString, slashesDenoteHost) {
  if (!isString(url)) {
    throw new TypeError("Parameter 'url' must be a string, not " + typeof url);
  }

  var rest = url;

  // trim before proceeding.
  // This is to support parse stuff like "  http://foo.com  \n"
  rest = rest.trim();

  var proto = protocolPattern.exec(rest);
  if (proto) {
    proto = proto[0];
    var lowerProto = proto.toLowerCase();
    this.protocol = lowerProto;
    rest = rest.substr(proto.length);
  }

  // figure out if it's got a host
  // user@server is *always* interpreted as a hostname, and url
  // resolution will treat //foo/bar as host=foo,path=bar because that's
  // how the browser resolves relative URLs.
  if (slashesDenoteHost || proto || rest.match(/^\/\/[^@\/]+@[^@\/]+/)) {
    var slashes = rest.substr(0, 2) === '//';
    if (slashes && !(proto && hostlessProtocol[proto])) {
      rest = rest.substr(2);
      this.slashes = true;
    }
  }

  if (!hostlessProtocol[proto] &&
      (slashes || (proto && !slashedProtocol[proto]))) {

    // there's a hostname.
    // the first instance of /, ?, ;, or # ends the host.
    //
    // If there is an @ in the hostname, then non-host chars *are* allowed
    // to the left of the last @ sign, unless some host-ending character
    // comes *before* the @-sign.
    // URLs are obnoxious.
    //
    // ex:
    // http://a@b@c/ => user:a@b host:c
    // http://a@b?@c => user:a host:c path:/?@c

    // v0.12 TODO(isaacs): This is not quite how Chrome does things.
    // Review our test case against browsers more comprehensively.

    // find the first instance of any hostEndingChars
    var hostEnd = -1;
    for (var i = 0; i < hostEndingChars.length; i++) {
      var hec = rest.indexOf(hostEndingChars[i]);
      if (hec !== -1 && (hostEnd === -1 || hec < hostEnd))
        hostEnd = hec;
    }

    // at this point, either we have an explicit point where the
    // auth portion cannot go past, or the last @ char is the decider.
    var auth, atSign;
    if (hostEnd === -1) {
      // atSign can be anywhere.
      atSign = rest.lastIndexOf('@');
    } else {
      // atSign must be in auth portion.
      // http://a@b/c@d => host:b auth:a path:/c@d
      atSign = rest.lastIndexOf('@', hostEnd);
    }

    // Now we have a portion which is definitely the auth.
    // Pull that off.
    if (atSign !== -1) {
      auth = rest.slice(0, atSign);
      rest = rest.slice(atSign + 1);
      this.auth = decodeURIComponent(auth);
    }

    // the host is the remaining to the left of the first non-host char
    hostEnd = -1;
    for (var i = 0; i < nonHostChars.length; i++) {
      var hec = rest.indexOf(nonHostChars[i]);
      if (hec !== -1 && (hostEnd === -1 || hec < hostEnd))
        hostEnd = hec;
    }
    // if we still have not hit it, then the entire thing is a host.
    if (hostEnd === -1)
      hostEnd = rest.length;

    this.host = rest.slice(0, hostEnd);
    rest = rest.slice(hostEnd);

    // pull out port.
    this.parseHost();

    // we've indicated that there is a hostname,
    // so even if it's empty, it has to be present.
    this.hostname = this.hostname || '';

    // if hostname begins with [ and ends with ]
    // assume that it's an IPv6 address.
    var ipv6Hostname = this.hostname[0] === '[' &&
        this.hostname[this.hostname.length - 1] === ']';

    // validate a little.
    if (!ipv6Hostname) {
      var hostparts = this.hostname.split(/\./);
      for (var i = 0, l = hostparts.length; i < l; i++) {
        var part = hostparts[i];
        if (!part) continue;
        if (!part.match(hostnamePartPattern)) {
          var newpart = '';
          for (var j = 0, k = part.length; j < k; j++) {
            if (part.charCodeAt(j) > 127) {
              // we replace non-ASCII char with a temporary placeholder
              // we need this to make sure size of hostname is not
              // broken by replacing non-ASCII by nothing
              newpart += 'x';
            } else {
              newpart += part[j];
            }
          }
          // we test again with ASCII char only
          if (!newpart.match(hostnamePartPattern)) {
            var validParts = hostparts.slice(0, i);
            var notHost = hostparts.slice(i + 1);
            var bit = part.match(hostnamePartStart);
            if (bit) {
              validParts.push(bit[1]);
              notHost.unshift(bit[2]);
            }
            if (notHost.length) {
              rest = '/' + notHost.join('.') + rest;
            }
            this.hostname = validParts.join('.');
            break;
          }
        }
      }
    }

    if (this.hostname.length > hostnameMaxLen) {
      this.hostname = '';
    } else {
      // hostnames are always lower case.
      this.hostname = this.hostname.toLowerCase();
    }

    if (!ipv6Hostname) {
      // IDNA Support: Returns a puny coded representation of "domain".
      // It only converts the part of the domain name that
      // has non ASCII characters. I.e. it dosent matter if
      // you call it with a domain that already is in ASCII.
      var domainArray = this.hostname.split('.');
      var newOut = [];
      for (var i = 0; i < domainArray.length; ++i) {
        var s = domainArray[i];
        newOut.push(s.match(/[^A-Za-z0-9_-]/) ?
            'xn--' + punycode.encode(s) : s);
      }
      this.hostname = newOut.join('.');
    }

    var p = this.port ? ':' + this.port : '';
    var h = this.hostname || '';
    this.host = h + p;
    this.href += this.host;

    // strip [ and ] from the hostname
    // the host field still retains them, though
    if (ipv6Hostname) {
      this.hostname = this.hostname.substr(1, this.hostname.length - 2);
      if (rest[0] !== '/') {
        rest = '/' + rest;
      }
    }
  }

  // now rest is set to the post-host stuff.
  // chop off any delim chars.
  if (!unsafeProtocol[lowerProto]) {

    // First, make 100% sure that any "autoEscape" chars get
    // escaped, even if encodeURIComponent doesn't think they
    // need to be.
    for (var i = 0, l = autoEscape.length; i < l; i++) {
      var ae = autoEscape[i];
      var esc = encodeURIComponent(ae);
      if (esc === ae) {
        esc = escape(ae);
      }
      rest = rest.split(ae).join(esc);
    }
  }


  // chop off from the tail first.
  var hash = rest.indexOf('#');
  if (hash !== -1) {
    // got a fragment string.
    this.hash = rest.substr(hash);
    rest = rest.slice(0, hash);
  }
  var qm = rest.indexOf('?');
  if (qm !== -1) {
    this.search = rest.substr(qm);
    this.query = rest.substr(qm + 1);
    if (parseQueryString) {
      this.query = querystring.parse(this.query);
    }
    rest = rest.slice(0, qm);
  } else if (parseQueryString) {
    // no query string, but parseQueryString still requested
    this.search = '';
    this.query = {};
  }
  if (rest) this.pathname = rest;
  if (slashedProtocol[lowerProto] &&
      this.hostname && !this.pathname) {
    this.pathname = '/';
  }

  //to support http.request
  if (this.pathname || this.search) {
    var p = this.pathname || '';
    var s = this.search || '';
    this.path = p + s;
  }

  // finally, reconstruct the href based on what has been validated.
  this.href = this.format();
  return this;
};

// format a parsed object into a url string
function urlFormat(obj) {
  // ensure it's an object, and not a string url.
  // If it's an obj, this is a no-op.
  // this way, you can call url_format() on strings
  // to clean up potentially wonky urls.
  if (isString(obj)) obj = urlParse(obj);
  if (!(obj instanceof Url)) return Url.prototype.format.call(obj);
  return obj.format();
}

Url.prototype.format = function() {
  var auth = this.auth || '';
  if (auth) {
    auth = encodeURIComponent(auth);
    auth = auth.replace(/%3A/i, ':');
    auth += '@';
  }

  var protocol = this.protocol || '',
      pathname = this.pathname || '',
      hash = this.hash || '',
      host = false,
      query = '';

  if (this.host) {
    host = auth + this.host;
  } else if (this.hostname) {
    host = auth + (this.hostname.indexOf(':') === -1 ?
        this.hostname :
        '[' + this.hostname + ']');
    if (this.port) {
      host += ':' + this.port;
    }
  }

  if (this.query &&
      isObject(this.query) &&
      Object.keys(this.query).length) {
    query = querystring.stringify(this.query);
  }

  var search = this.search || (query && ('?' + query)) || '';

  if (protocol && protocol.substr(-1) !== ':') protocol += ':';

  // only the slashedProtocols get the //.  Not mailto:, xmpp:, etc.
  // unless they had them to begin with.
  if (this.slashes ||
      (!protocol || slashedProtocol[protocol]) && host !== false) {
    host = '//' + (host || '');
    if (pathname && pathname.charAt(0) !== '/') pathname = '/' + pathname;
  } else if (!host) {
    host = '';
  }

  if (hash && hash.charAt(0) !== '#') hash = '#' + hash;
  if (search && search.charAt(0) !== '?') search = '?' + search;

  pathname = pathname.replace(/[?#]/g, function(match) {
    return encodeURIComponent(match);
  });
  search = search.replace('#', '%23');

  return protocol + host + pathname + search + hash;
};

function urlResolve(source, relative) {
  return urlParse(source, false, true).resolve(relative);
}

Url.prototype.resolve = function(relative) {
  return this.resolveObject(urlParse(relative, false, true)).format();
};

function urlResolveObject(source, relative) {
  if (!source) return relative;
  return urlParse(source, false, true).resolveObject(relative);
}

Url.prototype.resolveObject = function(relative) {
  if (isString(relative)) {
    var rel = new Url();
    rel.parse(relative, false, true);
    relative = rel;
  }

  var result = new Url();
  Object.keys(this).forEach(function(k) {
    result[k] = this[k];
  }, this);

  // hash is always overridden, no matter what.
  // even href="" will remove it.
  result.hash = relative.hash;

  // if the relative url is empty, then there's nothing left to do here.
  if (relative.href === '') {
    result.href = result.format();
    return result;
  }

  // hrefs like //foo/bar always cut to the protocol.
  if (relative.slashes && !relative.protocol) {
    // take everything except the protocol from relative
    Object.keys(relative).forEach(function(k) {
      if (k !== 'protocol')
        result[k] = relative[k];
    });

    //urlParse appends trailing / to urls like http://www.example.com
    if (slashedProtocol[result.protocol] &&
        result.hostname && !result.pathname) {
      result.path = result.pathname = '/';
    }

    result.href = result.format();
    return result;
  }

  if (relative.protocol && relative.protocol !== result.protocol) {
    // if it's a known url protocol, then changing
    // the protocol does weird things
    // first, if it's not file:, then we MUST have a host,
    // and if there was a path
    // to begin with, then we MUST have a path.
    // if it is file:, then the host is dropped,
    // because that's known to be hostless.
    // anything else is assumed to be absolute.
    if (!slashedProtocol[relative.protocol]) {
      Object.keys(relative).forEach(function(k) {
        result[k] = relative[k];
      });
      result.href = result.format();
      return result;
    }

    result.protocol = relative.protocol;
    if (!relative.host && !hostlessProtocol[relative.protocol]) {
      var relPath = (relative.pathname || '').split('/');
      while (relPath.length && !(relative.host = relPath.shift()));
      if (!relative.host) relative.host = '';
      if (!relative.hostname) relative.hostname = '';
      if (relPath[0] !== '') relPath.unshift('');
      if (relPath.length < 2) relPath.unshift('');
      result.pathname = relPath.join('/');
    } else {
      result.pathname = relative.pathname;
    }
    result.search = relative.search;
    result.query = relative.query;
    result.host = relative.host || '';
    result.auth = relative.auth;
    result.hostname = relative.hostname || relative.host;
    result.port = relative.port;
    // to support http.request
    if (result.pathname || result.search) {
      var p = result.pathname || '';
      var s = result.search || '';
      result.path = p + s;
    }
    result.slashes = result.slashes || relative.slashes;
    result.href = result.format();
    return result;
  }

  var isSourceAbs = (result.pathname && result.pathname.charAt(0) === '/'),
      isRelAbs = (
          relative.host ||
          relative.pathname && relative.pathname.charAt(0) === '/'
      ),
      mustEndAbs = (isRelAbs || isSourceAbs ||
                    (result.host && relative.pathname)),
      removeAllDots = mustEndAbs,
      srcPath = result.pathname && result.pathname.split('/') || [],
      relPath = relative.pathname && relative.pathname.split('/') || [],
      psychotic = result.protocol && !slashedProtocol[result.protocol];

  // if the url is a non-slashed url, then relative
  // links like ../.. should be able
  // to crawl up to the hostname, as well.  This is strange.
  // result.protocol has already been set by now.
  // Later on, put the first path part into the host field.
  if (psychotic) {
    result.hostname = '';
    result.port = null;
    if (result.host) {
      if (srcPath[0] === '') srcPath[0] = result.host;
      else srcPath.unshift(result.host);
    }
    result.host = '';
    if (relative.protocol) {
      relative.hostname = null;
      relative.port = null;
      if (relative.host) {
        if (relPath[0] === '') relPath[0] = relative.host;
        else relPath.unshift(relative.host);
      }
      relative.host = null;
    }
    mustEndAbs = mustEndAbs && (relPath[0] === '' || srcPath[0] === '');
  }

  if (isRelAbs) {
    // it's absolute.
    result.host = (relative.host || relative.host === '') ?
                  relative.host : result.host;
    result.hostname = (relative.hostname || relative.hostname === '') ?
                      relative.hostname : result.hostname;
    result.search = relative.search;
    result.query = relative.query;
    srcPath = relPath;
    // fall through to the dot-handling below.
  } else if (relPath.length) {
    // it's relative
    // throw away the existing file, and take the new path instead.
    if (!srcPath) srcPath = [];
    srcPath.pop();
    srcPath = srcPath.concat(relPath);
    result.search = relative.search;
    result.query = relative.query;
  } else if (!isNullOrUndefined(relative.search)) {
    // just pull out the search.
    // like href='?foo'.
    // Put this after the other two cases because it simplifies the booleans
    if (psychotic) {
      result.hostname = result.host = srcPath.shift();
      //occationaly the auth can get stuck only in host
      //this especialy happens in cases like
      //url.resolveObject('mailto:local1@domain1', 'local2@domain2')
      var authInHost = result.host && result.host.indexOf('@') > 0 ?
                       result.host.split('@') : false;
      if (authInHost) {
        result.auth = authInHost.shift();
        result.host = result.hostname = authInHost.shift();
      }
    }
    result.search = relative.search;
    result.query = relative.query;
    //to support http.request
    if (!isNull(result.pathname) || !isNull(result.search)) {
      result.path = (result.pathname ? result.pathname : '') +
                    (result.search ? result.search : '');
    }
    result.href = result.format();
    return result;
  }

  if (!srcPath.length) {
    // no path at all.  easy.
    // we've already handled the other stuff above.
    result.pathname = null;
    //to support http.request
    if (result.search) {
      result.path = '/' + result.search;
    } else {
      result.path = null;
    }
    result.href = result.format();
    return result;
  }

  // if a url ENDs in . or .., then it must get a trailing slash.
  // however, if it ends in anything else non-slashy,
  // then it must NOT get a trailing slash.
  var last = srcPath.slice(-1)[0];
  var hasTrailingSlash = (
      (result.host || relative.host) && (last === '.' || last === '..') ||
      last === '');

  // strip single dots, resolve double dots to parent dir
  // if the path tries to go above the root, `up` ends up > 0
  var up = 0;
  for (var i = srcPath.length; i >= 0; i--) {
    last = srcPath[i];
    if (last == '.') {
      srcPath.splice(i, 1);
    } else if (last === '..') {
      srcPath.splice(i, 1);
      up++;
    } else if (up) {
      srcPath.splice(i, 1);
      up--;
    }
  }

  // if the path is allowed to go above the root, restore leading ..s
  if (!mustEndAbs && !removeAllDots) {
    for (; up--; up) {
      srcPath.unshift('..');
    }
  }

  if (mustEndAbs && srcPath[0] !== '' &&
      (!srcPath[0] || srcPath[0].charAt(0) !== '/')) {
    srcPath.unshift('');
  }

  if (hasTrailingSlash && (srcPath.join('/').substr(-1) !== '/')) {
    srcPath.push('');
  }

  var isAbsolute = srcPath[0] === '' ||
      (srcPath[0] && srcPath[0].charAt(0) === '/');

  // put the host back
  if (psychotic) {
    result.hostname = result.host = isAbsolute ? '' :
                                    srcPath.length ? srcPath.shift() : '';
    //occationaly the auth can get stuck only in host
    //this especialy happens in cases like
    //url.resolveObject('mailto:local1@domain1', 'local2@domain2')
    var authInHost = result.host && result.host.indexOf('@') > 0 ?
                     result.host.split('@') : false;
    if (authInHost) {
      result.auth = authInHost.shift();
      result.host = result.hostname = authInHost.shift();
    }
  }

  mustEndAbs = mustEndAbs || (result.host && srcPath.length);

  if (mustEndAbs && !isAbsolute) {
    srcPath.unshift('');
  }

  if (!srcPath.length) {
    result.pathname = null;
    result.path = null;
  } else {
    result.pathname = srcPath.join('/');
  }

  //to support request.http
  if (!isNull(result.pathname) || !isNull(result.search)) {
    result.path = (result.pathname ? result.pathname : '') +
                  (result.search ? result.search : '');
  }
  result.auth = relative.auth || result.auth;
  result.slashes = result.slashes || relative.slashes;
  result.href = result.format();
  return result;
};

Url.prototype.parseHost = function() {
  var host = this.host;
  var port = portPattern.exec(host);
  if (port) {
    port = port[0];
    if (port !== ':') {
      this.port = port.substr(1);
    }
    host = host.substr(0, host.length - port.length);
  }
  if (host) this.hostname = host;
};

function isString(arg) {
  return typeof arg === "string";
}

function isObject(arg) {
  return typeof arg === 'object' && arg !== null;
}

function isNull(arg) {
  return arg === null;
}
function isNullOrUndefined(arg) {
  return  arg == null;
}

},{"punycode":8,"querystring":11}],13:[function(require,module,exports){
module.exports={
  "name": "layla",
  "version": "0.0.0",
  "description": "",
  "author": "Jaume Alemany <jaume@krokis.com>",
  "contributors": [],
  "license": "BSD-3-Clause",
  "readmeFilename": "Readme.md",
  "keywords": [
    "css"
  ],
  "repository": {
    "type": "git",
    "url": "https://github.com/krokis/layla.git"
  },
  "directories": {},
  "main": "./index.js",
  "scripts": {
    "test": "cake --verbose build test",
    "start": "node ./bin/layla -i"
  },
  "bin": {
    "layla": "./bin/layla"
  },
  "dependencies": {
    "supports-color": "^3.1.2"
  },
  "devDependencies": {
    "browserify": "^10.2.1",
    "chai": "^3.5.0",
    "coffee-script": "^1.9.2",
    "coffeeify": "^1.1.0",
    "coffeelint": "^1.9.3",
    "commonmark": "~0.12.0",
    "express": "^4.13.4",
    "fs-extra": "^0.18.2",
    "glob": "^5.0.5",
    "mocha": "~2.2.0",
    "phantomjs-prebuilt": "^2.1.7",
    "selenium-webdriver": "^2.53.2",
    "uglify-js": "^2.4.17",
    "which": "^1.0.9"
  }
}

},{}],14:[function(require,module,exports){
(function (global){
var BrowserContext;

global.Layla = require('../lib/layla');

BrowserContext = require('../lib/context/browser');

if ((new Function('return this === window'))()) {
  document.addEventListener("DOMContentLoaded", function() {
    var URL, base_url, css, i, layla, len, source, style, tag, tags, uri;
    tags = document.querySelectorAll('[type="text/lay"]');
    if (tags.length) {
      URL = require('url');
      source = '';
      for (i = 0, len = tags.length; i < len; i++) {
        tag = tags[i];
        switch (tag.nodeName) {
          case 'STYLE':
            source += tag.textContent + "\n;\n";
            break;
          case 'LINK':
            if (tag.hasAttribute('href')) {
              uri = tag.getAttribute('href');
              source += ("import url('" + uri + "')") + "\n;\n";
            }
            break;
          default:
            continue;
        }
      }
      if (source.trim()) {
        base_url = URL.resolve(document.location.href, './');
        console.log(source);
        layla = new Layla;
        layla.context = new BrowserContext;
        layla.context.pushPath(base_url);
        css = layla.compile(source);
        style = document.createElement('style');
        style.setAttribute('rel', 'stylesheet');
        style.setAttribute('type', 'text/css');
        style.textContent = css;
        return document.head.appendChild(style);
      }
    }
  });
}


}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../lib/context/browser":18,"../lib/layla":37,"url":12}],15:[function(require,module,exports){

/*
The base for all Layla classes (except for the core `Layla` class itself).
 */
var Class,
  slice = [].slice;

Class = (function() {
  var defineProperty, getOwnPropertyDescriptor;

  function Class() {}

  Class.NOT_IMPLEMENTED = function(name) {
    throw new NotImplementedError;
  };

  getOwnPropertyDescriptor = Object.getOwnPropertyDescriptor, defineProperty = Object.defineProperty;


  /*
  Simple property support. Allows subclasses to define their own property
  accessors.
   */

  Class.property = function(name, desc) {
    var current, k, target, v;
    if ('@' === name.charAt(0)) {
      name = name.substr(1);
      target = this;
    } else {
      target = this.prototype;
    }
    if (desc.enumerable == null) {
      desc.enumerable = true;
    }
    if (desc.configurable == null) {
      desc.configurable = true;
    }
    if (target.hasOwnProperty(name)) {
      current = getOwnPropertyDescriptor(target, name);
      for (k in current) {
        v = current[k];
        if (desc[k] == null) {
          desc[k] = v;
        }
      }
    }
    return defineProperty(target, name, desc);
  };

  Class.property('class', {
    get: function() {
      return this.constructor;
    }
  });

  Class.property('type', {
    get: function() {
      return this.constructor.name;
    }
  });

  Class.prototype.clone = function() {
    var etc;
    etc = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    return (function(func, args, ctor) {
      ctor.prototype = func.prototype;
      var child = new ctor, result = func.apply(child, args);
      return Object(result) === result ? result : child;
    })(this.constructor, etc, function(){});
  };

  Class.prototype.toJSON = function() {
    return {
      type: this.type
    };
  };

  return Class;

})();

module.exports = Class;


},{}],16:[function(require,module,exports){
var Class, Context, Document, Evaluator, Function, ImportError, Null, Path, URL,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty,
  slice = [].slice,
  indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

Path = require('path');

URL = require('url');

Class = require('./class');

Document = require('./object/document');

Null = require('./object/null');

Function = require('./object/function');

Evaluator = require('./evaluator');

ImportError = require('./error/import');

Context = (function(superClass) {
  extend(Context, superClass);

  Context.prototype.uri = null;

  function Context(_parent, block1) {
    this._parent = _parent != null ? _parent : null;
    this.block = block1 != null ? block1 : new Document;
    this._scope = {};
    this._plugins = [];
    this._importers = [];
    this._loaders = [];
    this._paths = [];
    this._visitors = [];
  }

  Context.property('parent', {
    get: function() {
      return this._parent;
    }
  });

  Context.property('plugins', {
    get: function() {
      return (this.parent ? this.parent.plugins : []).concat(this._plugins);
    }
  });

  Context.property('importers', {
    get: function() {
      return (this.parent ? this.parent.importers : []).concat(this._importers);
    }
  });

  Context.property('loaders', {
    get: function() {
      return (this.parent ? this.parent.loaders : []).concat(this._loaders);
    }
  });

  Context.property('paths', {
    get: function() {
      return (this.parent ? this.parent.paths : []).concat(this._paths);
    }
  });

  Context.prototype.has = function(name) {
    var ref;
    return (name in this._scope) || ((ref = this.parent) != null ? ref.has(name) : void 0) || false;
  };

  Context.prototype.get = function() {
    var args, name, ref;
    name = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
    if (name in this._scope) {
      return this._scope[name];
    } else if (this.parent) {
      return (ref = this.parent).get.apply(ref, [name].concat(slice.call(args)));
    } else {
      return Null["null"];
    }
  };

  Context.prototype.set = function(name, value) {
    return this._scope[name] = value.clone();
  };

  Context.prototype.useLoader = function(loader) {
    return this._loaders.push(loader);
  };

  Context.prototype.pushPath = function(uri) {
    var ref;
    uri = uri.trim();
    if ((ref = uri.slice(-1)) !== '/' && ref !== '\\') {
      uri += Path.sep;
    }
    return this._paths.push(uri);
  };

  Context.prototype.popPath = function() {
    return this._paths.pop();
  };

  Context.prototype.canLoad = function(uri) {
    return this.loaders.some((function(_this) {
      return function(loader) {
        return loader.canLoad(uri, _this);
      };
    })(this));
  };

  Context.prototype.load = function(uri) {
    var i, len, loader, ref;
    ref = this.loaders;
    for (i = 0, len = ref.length; i < len; i++) {
      loader = ref[i];
      if (loader.canLoad(uri, this)) {
        return loader.load(uri, this);
      }
    }
    throw new ImportError("Could not load \"" + uri + "\"");
  };

  Context.prototype.useImporter = function(importer) {
    return this._importers.push(importer);
  };

  Context.prototype.canImport = function(uri) {
    return this.importers.some((function(_this) {
      return function(importer) {
        return importer.canImport(uri, _this);
      };
    })(this));
  };

  Context.prototype.resolveURI = function(uri) {};

  Context.prototype["import"] = function(uri) {
    var auri, e, error, i, importer, j, len, path, ref, ref1;
    ref = this.paths;
    for (i = ref.length - 1; i >= 0; i += -1) {
      path = ref[i];
      auri = URL.resolve(path, uri);
      ref1 = this.importers;
      for (j = 0, len = ref1.length; j < len; j++) {
        importer = ref1[j];
        if (importer.canImport(auri, this)) {
          try {
            return importer["import"](auri, this);
          } catch (error) {
            e = error;
            if (e instanceof ImportError) {
              continue;
            }
            throw e;
          }
        }
      }
      break;
    }
    throw new ImportError("Could not import \"" + uri + "\"");
  };

  Context.prototype.useVisitor = function(visitor) {
    return this._visitors.push(visitor);
  };

  Context.prototype.uses = function(plugin) {
    return (indexOf.call(this._plugins, plugin) >= 0) || (this.parent && this.parent.uses(plugin)) || false;
  };

  Context.prototype.use = function() {
    var i, len, plugin, plugins, results;
    plugins = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    results = [];
    for (i = 0, len = plugins.length; i < len; i++) {
      plugin = plugins[i];
      if (!this.uses(plugin)) {
        this._plugins.push(plugin);
        results.push(plugin.use(this));
      } else {
        results.push(void 0);
      }
    }
    return results;
  };

  Context.prototype.evaluate = function(node, context) {
    if (context == null) {
      context = this;
    }
    return (new Evaluator).evaluateNode(node, context);
  };

  Context.prototype.fork = function(block) {
    if (block == null) {
      block = this.block;
    }
    return this.clone(this, block);
  };

  return Context;

})(Class);

module.exports = Context;


},{"./class":15,"./error/import":25,"./evaluator":33,"./object/document":78,"./object/function":80,"./object/null":83,"path":6,"url":12}],17:[function(require,module,exports){
var BaseContext, Context, LayImporter, Number, String, VERSION,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty,
  slice = [].slice;

Context = require('../context');

LayImporter = require('../importer/lay');

String = require('../object/string');

Number = require('../object/number');

VERSION = require('../version');

BaseContext = (function(superClass) {
  extend(BaseContext, superClass);

  function BaseContext() {
    var etc, parent;
    parent = arguments[0], etc = 2 <= arguments.length ? slice.call(arguments, 1) : [];
    BaseContext.__super__.constructor.apply(this, [parent].concat(slice.call(etc)));
    if (!parent) {
      this.use(new LayImporter);
      this.set('LAYLA-VERSION', new String(VERSION));
      this.set('PI', new Number(Math.PI));
      this.set('π', new Number(Math.PI));
      this.set('E', new Number(Math.E));
    }
  }

  return BaseContext;

})(Context);

module.exports = BaseContext;


},{"../context":16,"../importer/lay":35,"../object/number":84,"../object/string":90,"../version":95}],18:[function(require,module,exports){
var BaseContext, BrowserContext, XHRLoader,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

BaseContext = require('./base');

XHRLoader = require('../loader/xhr');

BrowserContext = (function(superClass) {
  extend(BrowserContext, superClass);

  function BrowserContext() {
    BrowserContext.__super__.constructor.apply(this, arguments);
    this.use(new XHRLoader);
  }

  return BrowserContext;

})(BaseContext);

module.exports = BrowserContext;


},{"../loader/xhr":40,"./base":17}],19:[function(require,module,exports){
var AtRule, Block, InternalError, Normalizer, Null, Property, Rule, RuleSet, Visitor,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Visitor = require('../visitor');

Block = require('../object/block');

Rule = require('../object/rule');

RuleSet = require('../object/rule-set');

AtRule = require('../object/at-rule');

Property = require('../object/property');

Null = require('../object/null');

InternalError = require('../error/internal');


/*
 */

Normalizer = (function(superClass) {
  extend(Normalizer, superClass);

  Normalizer.prototype.options = null;

  Normalizer.prototype.indentation = 0;

  function Normalizer(options) {
    var defaults, name;
    this.options = options != null ? options : {};
    defaults = {
      flatten_block_properties: true,
      strip_root_properties: false,
      strip_empty_blocks: false,
      strip_null_properties: false,
      strip_empty_properties: false,
      strip_empty_rule_sets: true,
      strip_empty_at_rules: false,
      strip_empty_media_at_rules: true,
      hoist_rule_sets: true,
      hoist_at_rules: false,
      hoist_media_at_rules: true,
      convert_unknown_units: true
    };
    for (name in defaults) {
      if (!(name in this.options)) {
        this.options[name] = defaults[name];
      }
    }
  }


  /*
   */

  Normalizer.prototype.normalize = function(node) {
    var method;
    method = "normalize" + node.type;
    if (method in this) {
      return this[method].call(this, node);
    } else {
      return node;
    }
  };

  Normalizer.prototype.normalizeRule = function(node, root) {
    return node;
  };

  Normalizer.prototype.isEmptyProperty = function(node) {
    return node.value instanceof Null;
  };

  Normalizer.prototype.normalizeBlock = function(node, root) {
    var body, child, grandchild, hoist, i, len, name, ref, strip, value;
    if (body = node.items) {
      if (root == null) {
        root = node;
      }
      node.items = [];
      while (body.length) {
        child = body.shift();
        if (child instanceof Rule) {
          hoist = (this.options.hoist_rule_sets && (child instanceof RuleSet) && (node instanceof RuleSet)) || (child instanceof AtRule && (this.options.hoist_at_rules || this.options["hoist_" + child.name + "_at_rules"]));
          (hoist ? root : node).items.push(child);
          this.normalizeBlock(child, root);
          strip = !child.items.length && (this.options.strip_empty_blocks || (child instanceof RuleSet && this.options.strip_empty_rule_sets) || (child instanceof RuleSet && (this.options.strip_empty_rule_sets || this.options["strip_empty_" + child.name + "_at_rules"])));
          if (strip) {
            root.items.splice(root.items.indexOf(child), 1);
          }
        } else if (child instanceof Property) {
          if (this.options.strip_empty_properties && this.isEmptyProperty(child)) {
            continue;
          }
          if (this.options.flatten_block_properties && child.value instanceof Block) {
            ref = child.value.items;
            for (i = 0, len = ref.length; i < len; i++) {
              grandchild = ref[i];
              if (grandchild instanceof Property) {
                name = child.name + "-" + grandchild.name;
                value = grandchild.value;
                node.items.push(new Property(name, value));
              }
            }
          } else {
            node.items.push(child);
          }
        } else {
          throw new InternalError;
        }
      }
    }
    return node;
  };


  /*
   */

  Normalizer.prototype.normalizeDocument = function(node) {
    return this.normalizeBlock(node);
  };

  return Normalizer;

})(Visitor);

module.exports = Normalizer;


},{"../error/internal":26,"../object/at-rule":73,"../object/block":74,"../object/null":83,"../object/property":85,"../object/rule":89,"../object/rule-set":88,"../visitor":96}],20:[function(require,module,exports){
var Class, Emitter,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Class = require('./class');

Emitter = (function(superClass) {
  extend(Emitter, superClass);

  function Emitter() {
    return Emitter.__super__.constructor.apply(this, arguments);
  }

  Emitter.prototype.emit = function(node) {
    var method;
    if (node !== void 0) {
      method = "emit" + node.type;
      if (!(method in this)) {
        throw new Error("Don't know how to emit node of type " + node.type);
      }
      return this[method].call(this, node);
    }
  };

  return Emitter;

})(Class);

module.exports = Emitter;


},{"./class":15}],21:[function(require,module,exports){
var CLIEmitter, CSSEmitter,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty,
  slice = [].slice;

CSSEmitter = require('./css');

CLIEmitter = (function(superClass) {
  var BLUE, BOLD, CYAN, ESC, GREEN, GREY, MAGENTA, RED, RESET, YELLOW;

  extend(CLIEmitter, superClass);

  ESC = '\u001b';

  RESET = 0;

  BOLD = 1;

  RED = 31;

  GREEN = 32;

  YELLOW = 33;

  BLUE = 34;

  MAGENTA = 35;

  CYAN = 36;

  GREY = 37;

  function CLIEmitter(options) {
    var defaults, name;
    if (options == null) {
      options = {};
    }
    defaults = {
      colors: true,
      decimal_places: -1
    };
    for (name in defaults) {
      if (!(name in options)) {
        options[name] = defaults[name];
      }
    }
    CLIEmitter.__super__.constructor.call(this, options);
  }

  CLIEmitter.prototype.format = function() {
    var code, codes, i, len, ret, str;
    str = arguments[0], codes = 2 <= arguments.length ? slice.call(arguments, 1) : [];
    if (this.options.colors) {
      ret = '';
      for (i = 0, len = codes.length; i < len; i++) {
        code = codes[i];
        ret += ESC + "[" + code + "m";
      }
      ret += str;
      return ret += ESC + "[" + RESET + "m";
    } else {
      return str;
    }
  };

  CLIEmitter.prototype.emitNull = function(nil) {
    return this.format(CLIEmitter.__super__.emitNull.call(this, nil), BOLD);
  };

  CLIEmitter.prototype.emitBoolean = function(bool) {
    return this.format(CLIEmitter.__super__.emitBoolean.call(this, bool), BOLD);
  };

  CLIEmitter.prototype.emitFunction = function(func) {
    return this.format(func.repr(), BOLD);
  };

  CLIEmitter.prototype.emitNumber = function(num) {
    return this.format(CLIEmitter.__super__.emitNumber.call(this, num), YELLOW);
  };

  CLIEmitter.prototype.emitRegExp = function(reg) {
    return this.format("/" + reg.source + "/" + reg.flags, YELLOW);
  };

  CLIEmitter.prototype.emitColor = function(str) {
    return this.format(CLIEmitter.__super__.emitColor.call(this, str), YELLOW);
  };

  CLIEmitter.prototype.emitString = function(str) {
    return this.format(CLIEmitter.__super__.emitString.call(this, str), YELLOW);
  };

  CLIEmitter.prototype.emitSelector = function(sel) {
    return this.format(CLIEmitter.__super__.emitSelector.call(this, sel), BOLD, GREEN);
  };

  CLIEmitter.prototype.emitAtRuleName = function(sel) {
    return this.format(CLIEmitter.__super__.emitAtRuleName.call(this, sel), BOLD, MAGENTA);
  };

  CLIEmitter.prototype.emitAtRuleArguments = function(sel) {
    return this.format(CLIEmitter.__super__.emitAtRuleArguments.call(this, sel), MAGENTA);
  };

  CLIEmitter.prototype.emitPropertyName = function(property) {
    return this.format(CLIEmitter.__super__.emitPropertyName.call(this, property), BOLD, CYAN);
  };

  return CLIEmitter;

})(CSSEmitter);

module.exports = CLIEmitter;


},{"./css":22}],22:[function(require,module,exports){
var Block, CSSEmitter, Comment, Emitter, Property, Rule,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Emitter = require('../emitter');

Block = require('../object/block');

Rule = require('../object/rule');

Property = require('../object/property');

Comment = require('../node/comment');

CSSEmitter = (function(superClass) {
  extend(CSSEmitter, superClass);

  CSSEmitter.prototype.options = null;

  function CSSEmitter(options) {
    var defaults, name;
    this.options = options != null ? options : {};
    defaults = {
      bom: 'preserve',
      new_line: '\n',
      final_newline: true,
      tab: '  ',
      comments: true,
      before_opening_brace: ' ',
      after_opening_brace: '\n',
      before_statement: '\t',
      after_statement: '\n',
      align_declarations: false,
      align_prefixed_declarations: false,
      after_declaration_property: '',
      before_declaration_value: ' ',
      after_declaration_value: '',
      preferred_string_quote: null,
      force_string_quote: null,
      decimal_places: 2
    };
    for (name in defaults) {
      if (!(name in this.options)) {
        this.options[name] = defaults[name];
      }
    }
  }


  /*
  TODO :S Please refactor this
   */

  CSSEmitter.prototype.indent = function(str) {
    var lines;
    lines = str.split('\n');
    lines = lines.map(function(line) {
      if (line.trim() === '') {
        return line;
      } else {
        return "  " + line;
      }
    });
    return (lines.join('\n')).replace(/((?:(?:\\\\)*\\)\n)  /g, "$1");
  };

  CSSEmitter.prototype.emitBody = function(body) {
    var lines, stmt, str;
    lines = (function() {
      var i, len, ref, results;
      results = [];
      for (i = 0, len = body.length; i < len; i++) {
        stmt = body[i];
        switch (true) {
          case stmt instanceof Rule:
            results.push((this.emit(stmt)) + (((ref = stmt.items) != null ? ref.length : void 0) ? '' : ';') + '\n');
            break;
          case stmt instanceof Property:
            results.push((this.emitProperty(stmt)) + ';');
            break;
          case stmt instanceof Comment:
            results.push(this.emitComment(stmt));
            break;
          default:
            throw new Error("Cannot emit a (" + stmt.type + ") as CSS");
        }
      }
      return results;
    }).call(this);
    str = lines.join('\n');
    if ('\n' === str.substr(-1)) {
      str = str.substr(0, str.length - 1);
    }
    return str;
  };

  CSSEmitter.prototype.emitList = function(list) {
    var sep;
    sep = (list.separator.trim()) + " ";
    return (list.items.map((function(_this) {
      return function(item) {
        return _this.emit(item);
      };
    })(this))).join(sep);
  };

  CSSEmitter.prototype.emitRange = function(range) {
    return (range.items.map((function(_this) {
      return function(item) {
        return _this.emit(item);
      };
    })(this))).join(' ');
  };

  CSSEmitter.prototype.emitBlock = function(block) {
    var css;
    css = "{\n" + (this.indent(this.emitBody(block.items))) + "\n}";
    return css;
  };

  CSSEmitter.prototype.escapeString = function(val, quotes) {
    if (quotes == null) {
      quotes = '\'"';
    }
    val = val.replace(/(^|(?:[^\\])|(?:(?:\\\\)+))(\r\n|\r|\n)/gm, '$1\\A');
    val = val.replace(/(|[^\\]|(\\\\)+)\t/g, '$1\\9');
    return val = val.replace(RegExp("(^|[^\\\\]|(?:\\\\(?:\\\\\\\\)*))([" + quotes + "])", "gm"), '$1\\$2');
  };

  CSSEmitter.prototype.quoteString = function(str) {
    var quote;
    if (str.quote === null) {
      if (str.value.match(/(^|[^\\]|(\\(\\\\)*))'/)) {
        quote = '"';
      } else {
        quote = "'";
      }
    } else {
      quote = str.quote;
    }
    return "" + quote + (this.escapeString(str.value, quote)) + quote;
  };


  /*
   */

  CSSEmitter.prototype.emitString = function(str, quoted) {
    var val;
    if (quoted == null) {
      quoted = str.quote != null;
    }
    val = str.value;
    if (quoted) {
      return this.quoteString(str);
    } else {
      return this.escapeString(str.value);
    }
  };

  CSSEmitter.prototype.emitNumberValue = function(num) {
    var m, value;
    value = num.value;
    if (value % 1 !== 0) {
      if (this.options.decimal_places >= 0) {
        m = Math.pow(10, this.options.decimal_places);
        value = (Math.round(value * m)) / m;
      }
    }
    return '' + value;
  };

  CSSEmitter.prototype.emitNumberUnit = function(num) {
    return num.unit || '';
  };

  CSSEmitter.prototype.emitNumber = function(num) {
    var value;
    value = this.emitNumberValue(num);
    if (value !== '0') {
      value += this.emitNumberUnit(num);
    }
    return value;
  };

  CSSEmitter.prototype.emitBoolean = function(bool) {
    var ref;
    return (ref = bool.value) != null ? ref : {
      'true': 'false'
    };
  };

  CSSEmitter.prototype.emitNull = function(node) {
    return 'null';
  };

  CSSEmitter.prototype.emitColor = function(color) {
    return color.toString();
  };

  CSSEmitter.prototype.emitURL = function(url) {
    return "url(" + (this.emitString(url, url.quote != null)) + ")";
  };

  CSSEmitter.prototype.emitPropertyName = function(property) {
    return property.name;
  };

  CSSEmitter.prototype.emitPropertyValue = function(property) {
    return this.emit(property.value);
  };

  CSSEmitter.prototype.emitProperty = function(property) {
    return (this.emitPropertyName(property)) + ": " + (this.emitPropertyValue(property));
  };

  CSSEmitter.prototype.emitSelector = function(selector) {
    return selector;
  };

  CSSEmitter.prototype.emitSelectorList = function(rule) {
    return (rule.selector.map((function(_this) {
      return function(sel) {
        return _this.emitSelector(sel);
      };
    })(this))).join(',\n');
  };

  CSSEmitter.prototype.emitRuleSet = function(rule) {
    return (this.emitSelectorList(rule)) + " " + (this.emitBlock(rule));
  };

  CSSEmitter.prototype.emitAtRuleName = function(rule) {
    return "@" + rule.name;
  };

  CSSEmitter.prototype.emitAtRuleArguments = function(rule) {
    return rule["arguments"];
  };

  CSSEmitter.prototype.emitAtRule = function(rule) {
    var css, ref;
    css = this.emitAtRuleName(rule);
    if (rule["arguments"] != null) {
      css += " " + (this.emitAtRuleArguments(rule));
    }
    if ((ref = rule.items) != null ? ref.length : void 0) {
      css += " " + (this.emitBlock(rule));
    }
    return css;
  };

  CSSEmitter.prototype.emitDocument = function(doc) {
    var css;
    css = '';
    if ((this.options.bom === true) || (doc.bom && this.options.bom === 'preserve')) {
      css += '\uFEFF';
    }
    css += this.emitBody(doc.items, doc);
    if (this.options.final_newline && (css !== '')) {
      css += '\n';
    }
    return css;
  };

  return CSSEmitter;

})(Emitter);

module.exports = CSSEmitter;


},{"../emitter":20,"../node/comment":42,"../object/block":74,"../object/property":85,"../object/rule":89}],23:[function(require,module,exports){
var Class, Error,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Class = require('./class');


/*
 */

Error = (function(superClass) {
  extend(Error, superClass);

  Error.property('name', {
    get: function() {
      return this.type;
    }
  });

  Error.property('file', {
    get: function() {
      var ref;
      return (ref = this.location) != null ? ref.file : void 0;
    }
  });

  Error.property('line', {
    get: function() {
      var ref;
      return (ref = this.location) != null ? ref.line : void 0;
    }
  });

  Error.property('column', {
    get: function() {
      var ref;
      return (ref = this.location) != null ? ref.line : void 0;
    }
  });

  function Error(message, location, stack) {
    this.message = message;
    this.location = location != null ? location : null;
    this.stack = stack != null ? stack : null;
  }

  Error.prototype.toString = function() {
    var str;
    str = this.type + " - " + this.message;
    if (this.file != null) {
      str += " at " + this.file;
      if (this.line != null) {
        str += ":" + this.line;
        if (this.column != null) {
          str += "," + column;
        }
      }
    }
    return str;
  };

  return Error;

})(Class);

module.exports = Error;


},{"./class":15}],24:[function(require,module,exports){
var EOTError, SyntaxError,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

SyntaxError = require('./syntax');

EOTError = (function(superClass) {
  extend(EOTError, superClass);

  function EOTError() {
    return EOTError.__super__.constructor.apply(this, arguments);
  }

  return EOTError;

})(SyntaxError);

module.exports = EOTError;


},{"./syntax":30}],25:[function(require,module,exports){
var ImportError, ValueError,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ValueError = require('./type');

ImportError = (function(superClass) {
  extend(ImportError, superClass);

  function ImportError() {
    return ImportError.__super__.constructor.apply(this, arguments);
  }

  return ImportError;

})(ValueError);

module.exports = ImportError;


},{"./type":31}],26:[function(require,module,exports){
var Error, InternalError,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Error = require('../error');

InternalError = (function(superClass) {
  extend(InternalError, superClass);

  function InternalError() {
    return InternalError.__super__.constructor.apply(this, arguments);
  }

  return InternalError;

})(Error);

module.exports = InternalError;


},{"../error":23}],27:[function(require,module,exports){
var Error, NotImplementedError,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty,
  slice = [].slice;

Error = require('../error');

NotImplementedError = (function(superClass) {
  var message;

  extend(NotImplementedError, superClass);

  message = "Not implemented";

  function NotImplementedError() {
    var etc, message1;
    message1 = arguments[0], etc = 2 <= arguments.length ? slice.call(arguments, 1) : [];
    this.message = message1 != null ? message1 : this.message;
    NotImplementedError.__super__.constructor.apply(this, arguments);
  }

  return NotImplementedError;

})(Error);

module.exports = NotImplementedError;


},{"../error":23}],28:[function(require,module,exports){
var Error, ParseError,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Error = require('../error');

ParseError = (function(superClass) {
  extend(ParseError, superClass);

  function ParseError() {
    return ParseError.__super__.constructor.apply(this, arguments);
  }

  return ParseError;

})(Error);

module.exports = ParseError;


},{"../error":23}],29:[function(require,module,exports){
var Error, RuntimeError,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Error = require('../error');

RuntimeError = (function(superClass) {
  extend(RuntimeError, superClass);

  function RuntimeError() {
    return RuntimeError.__super__.constructor.apply(this, arguments);
  }

  return RuntimeError;

})(Error);

module.exports = RuntimeError;


},{"../error":23}],30:[function(require,module,exports){
var ParseError, SyntaxError,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ParseError = require('./parse');

SyntaxError = (function(superClass) {
  extend(SyntaxError, superClass);

  function SyntaxError() {
    return SyntaxError.__super__.constructor.apply(this, arguments);
  }

  return SyntaxError;

})(ParseError);

module.exports = SyntaxError;


},{"./parse":28}],31:[function(require,module,exports){
var RuntimeError, TypeError,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

RuntimeError = require('./runtime');

TypeError = (function(superClass) {
  extend(TypeError, superClass);

  function TypeError() {
    return TypeError.__super__.constructor.apply(this, arguments);
  }

  return TypeError;

})(RuntimeError);

module.exports = TypeError;


},{"./runtime":29}],32:[function(require,module,exports){
var RuntimeError, ValueError,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

RuntimeError = require('./runtime');

ValueError = (function(superClass) {
  extend(ValueError, superClass);

  function ValueError() {
    return ValueError.__super__.constructor.apply(this, arguments);
  }

  return ValueError;

})(RuntimeError);

module.exports = ValueError;


},{"./runtime":29}],33:[function(require,module,exports){
var AtRule, Block, Boolean, Class, Color, Context, Directive, Document, Evaluator, Expression, Function, Ident, InternalError, List, LiteralNumber, Null, Number, Object, Operation, Parser, Plugin, Property, Range, RegExp, RuleSet, RuntimeError, String, TypeError, URL, fs, path,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty,
  slice = [].slice;

fs = require('fs');

path = require('path');

Class = require('./class');

Parser = require('./parser');

Plugin = require('./plugin');

Context = require('./context');

Expression = require('./node/expression');

Operation = require('./node/expression/operation');

Ident = require('./node/expression/ident');

LiteralNumber = require('./node/expression/literal/number');

Directive = require('./node/statement/directive');

Object = require('./object');

Document = require('./object/document');

List = require('./object/list');

Block = require('./object/block');

Number = require('./object/number');

RegExp = require('./object/regexp');

Boolean = require('./object/boolean');

String = require('./object/string');

Null = require('./object/null');

Range = require('./object/range');

Function = require('./object/function');

URL = require('./object/url');

Color = require('./object/color');

Property = require('./object/property');

RuleSet = require('./object/rule-set');

AtRule = require('./object/at-rule');

TypeError = require('./error/type');

RuntimeError = require('./error/runtime');

InternalError = require('./error/internal');

Evaluator = (function(superClass) {
  extend(Evaluator, superClass);

  function Evaluator() {
    return Evaluator.__super__.constructor.apply(this, arguments);
  }


  /*
   */

  Evaluator.prototype.evaluateNode = function(node, context) {
    var method;
    if (node) {
      method = "evaluate" + node.type;
      if (method in this) {
        return this[method].call(this, node, context);
      }
    }
    if (!(node instanceof Object)) {
      throw new InternalError("Don't know how to evaluate node " + node.type);
    }
    return node;
  };


  /*
   */

  Evaluator.prototype.evaluateLiteralColor = function(node, context) {
    return new Color(node.value);
  };


  /*
   */

  Evaluator.prototype.evaluateLiteralString = function(node, context) {
    var chunk, j, len, ref1, val, value;
    value = '';
    ref1 = [].concat(node.value);
    for (j = 0, len = ref1.length; j < len; j++) {
      chunk = ref1[j];
      if (typeof chunk === 'string') {
        value += chunk;
      } else {
        val = this.evaluateNode(chunk, context);
        value += val.toString();
      }
    }
    return new String(value, node.quote);
  };


  /*
   */

  Evaluator.prototype.evaluateLiteralThis = function(node, context) {
    return context.block;
  };


  /*
   */

  Evaluator.prototype.evaluateLiteralUnicodeRange = function(node, context) {
    return new String(node.value.toUpperCase(), '');
  };


  /*
   */

  Evaluator.prototype.evaluateLiteralURL = function(node, context) {
    var val;
    val = this.evaluateNode(node.value, context);
    return new URL(val.value, val.quote);
  };


  /*
   */

  Evaluator.prototype.evaluateIdent = function(node, context) {
    var arg, args, val;
    switch (node.value) {
      case 'true':
        return Boolean["true"];
      case 'false':
        return Boolean["false"];
      case 'null':
        return Null["null"];
      default:
        if (context.has(node.value)) {
          if (node["arguments"] != null) {
            args = (function() {
              var j, len, ref1, results;
              ref1 = node["arguments"];
              results = [];
              for (j = 0, len = ref1.length; j < len; j++) {
                arg = ref1[j];
                results.push(this.evaluateNode(arg, context));
              }
              return results;
            }).call(this);
          } else {
            args = [];
          }
          val = context.get.apply(context, [node.value].concat(slice.call(args)));
          if (val instanceof Function) {
            val = val.invoke.apply(val, [context.block].concat(slice.call(args)));
          }
        } else {
          val = new String(node.value, null);
        }
        return val;
    }
  };


  /*
   */

  Evaluator.prototype.evaluateLiteralNumber = function(node) {
    var ref1;
    return new Number(node.value, (ref1 = node.unit) != null ? ref1.value : void 0);
  };


  /*
   */

  Evaluator.prototype.evaluateLiteralRegExp = function(node, context) {
    return new RegExp(node.value, node.flags);
  };


  /*
   */

  Evaluator.prototype.evaluateLiteralFunction = function(node, context) {
    var body, in_args;
    body = node.block.body;
    in_args = node["arguments"];
    return new Function((function(_this) {
      return function() {
        var arg, args, block, ctx, d, e, error, i, j, k, l, len, ref1, ref2, value;
        block = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
        try {
          ctx = context.fork(block);
          l = in_args.length;
          for (i = j = 0, len = args.length; j < len; i = ++j) {
            arg = args[i];
            if (i < l) {
              ctx.set(in_args[i].name, arg);
            } else {
              break;
            }
          }
          for (d = k = ref1 = i, ref2 = in_args.length; ref1 <= ref2 ? k < ref2 : k > ref2; d = ref1 <= ref2 ? ++k : --k) {
            if (in_args[d].value) {
              value = _this.evaluateNode(in_args[d].value, ctx);
            } else {
              value = Null["null"];
            }
            ctx.set(in_args[d].name, value);
          }
          _this.evaluateBody(body, ctx);
        } catch (error) {
          e = error;
          if (e instanceof Object) {
            return e;
          } else {
            throw e;
          }
        }
      };
    })(this));
  };


  /*
   */

  Evaluator.prototype.evaluateGroup = function(node, context) {
    return this.evaluateNode(node.expression, context);
  };


  /*
   */

  Evaluator.prototype.evaluateLiteralList = function(node, context) {
    var item, items;
    items = (function() {
      var j, len, ref1, results;
      ref1 = node.body;
      results = [];
      for (j = 0, len = ref1.length; j < len; j++) {
        item = ref1[j];
        results.push(this.evaluateNode(item, context));
      }
      return results;
    }).call(this);
    return new List(items, node.separator);
  };


  /*
   */

  Evaluator.prototype.evaluateUnaryOperation = function(node, context) {
    return (this.evaluateNode(node.right, context)).operate(node.operator + "@");
  };


  /*
  TODO Reimplement this mess as a Node methods
   */

  Evaluator.prototype.evaluateBinaryOperation = function(node, context) {
    var arg, args, left, ref1, ret, right;
    switch (node.operator) {
      case '=':
      case '|=':
        return this.evaluateAssignment(node, context);
      case '.':
        left = this.evaluateNode(node.left, context);
        if (node.right instanceof Ident) {
          if (node.right["arguments"] != null) {
            args = (function() {
              var j, len, ref1, results;
              ref1 = node.right["arguments"];
              results = [];
              for (j = 0, len = ref1.length; j < len; j++) {
                arg = ref1[j];
                results.push(this.evaluateNode(arg, context));
              }
              return results;
            }).call(this);
          } else {
            args = [];
          }
          return (left['.'].apply(left, [node.right.name].concat(slice.call(args)))) || Null["null"];
        } else {
          throw new Error("Bad right side of `.` operation");
        }
        break;
      case '::':
        left = this.evaluateNode(node.left, context);
        if (node.right instanceof Ident) {
          if (node.right["arguments"] != null) {
            throw new Error("Bad right side of `::` operation");
          }
          right = new String(node.right.value);
        } else {
          right = this.evaluateNode(node.right, context);
        }
        return (left['.::'](right)) || Null["null"];
      case '(':
        left = this.evaluateNode(node.left, context);
        if (!(left instanceof Function)) {
          throw new ReferenceError("Call to non-function");
        }
        args = (function() {
          var j, len, ref1, results;
          ref1 = node.right;
          results = [];
          for (j = 0, len = ref1.length; j < len; j++) {
            arg = ref1[j];
            results.push(this.evaluateNode(arg, context));
          }
          return results;
        }).call(this);
        ret = (ref1 = left.invoke).call.apply(ref1, [left, context.block].concat(slice.call(args)));
        return ret || Null["null"];
      default:
        left = this.evaluateNode(node.left, context);
        right = this.evaluateNode(node.right, context);
        return left.operate(node.operator, right);
    }
  };

  Evaluator.prototype.evaluateOperation = function(node, context) {
    if (node.right && node.left) {
      return this.evaluateBinaryOperation(node, context);
    } else {
      return this.evaluateUnaryOperation(node, context);
    }
  };

  Evaluator.prototype.isReference = function(node) {
    return (node instanceof Operation) && node.binary && (node.operator === '.' || node.operator === '::');
  };


  /*
  TODO Refactor!
  Maybe the left node SHOULD be evaluated, but maybe in a new scope,
  so existing defined factors on current scope are not applied
   */

  Evaluator.prototype.evaluateUnitAssignment = function(node, context) {
    var left, right, unit, value;
    value = parseFloat(node.left.value);
    unit = node.left.unit.value;
    if (!(unit && value !== 0)) {
      throw new Error("Bad unit definition");
    }
    if (!(node.operator === '|=' && Number.isDefined(unit))) {
      right = this.evaluateNode(node.right, context);
      if (!(right.unit && right.value !== 0)) {
        throw new Error("Bad unit definition");
      }
      left = new Number(value);
      left.unit = unit;
      Number.define(left, right, true);
    }
    return this.evaluateNode(node.left, context);
  };


  /*
   */

  Evaluator.prototype.evaluateAssignment = function(node, context) {
    var curr, getter, left, name, ref, right, setter, value;
    getter = setter = null;
    left = node.left, right = node.right;
    if (left instanceof LiteralNumber) {
      return this.evaluateUnitAssignment(node, context);
    }
    if (left instanceof Ident) {
      name = left.value;
      getter = context.get.bind(context, name);
      setter = context.set.bind(context, name);
    } else if (this.isReference(left)) {
      name = this.evaluateNode(left.right, context);
      ref = this.evaluateNode(left.left, context);
      if (left.operator === '.') {
        getter = ref['.'].bind(ref, name);
        setter = ref['.='].bind(ref, name);
      } else {
        getter = ref['.::'].bind(ref, name);
        setter = ref['.::='].bind(ref, name);
      }
    }
    if (!setter) {
      throw new TypeError("Bad left side of assignment");
    }
    if (node.operator === '|=') {
      if (getter) {
        curr = getter();
        if (!curr.isNull()) {
          return curr;
        }
      }
    }
    value = this.evaluateNode(right, context);
    setter(value);
    return value;
  };


  /*
   */

  Evaluator.prototype.evaluateConditional = function(node, context) {
    var els, j, len, met, ref1;
    met = !node.condition || (this.evaluateNode(node.condition, context)).toBoolean();
    if (met !== node.negate) {
      this.evaluateBody(node.block.body, context);
    } else if (node.elses) {
      ref1 = node.elses;
      for (j = 0, len = ref1.length; j < len; j++) {
        els = ref1[j];
        met = !els.condition || (this.evaluateNode(els.condition, context)).toBoolean();
        if (met !== els.negate) {
          this.evaluateBody(els.block.body, context);
          break;
        }
      }
    }
  };

  Evaluator.prototype.evaluateControlFlowDirective = function(node, context) {
    var depth;
    switch (node["arguments"].length) {
      case 0:
        depth = 1;
        break;
      case 1:
        depth = this.evaluateNode(node["arguments"][0], context);
        if (!((depth instanceof Number) && depth > 0)) {
          throw new Error("Bad argument for a `" + node.name + "`");
        }
        depth = parseInt(depth.value, 10);
        break;
      default:
        throw new TypeError("Too many arguments for a `" + node.name + "`");
    }
    node.depth = depth;
    throw node;
  };

  Evaluator.prototype.evaluateContinue = function(node, context) {
    return this.evaluateControlFlowDirective(node, context);
  };

  Evaluator.prototype.evaluateBreak = function(node, context) {
    return this.evaluateControlFlowDirective(node, context);
  };

  Evaluator.prototype.evaluateReturn = function(node, context) {
    if (node["arguments"].length === 0) {
      throw Null["null"];
    } else if (node["arguments"].length > 1) {
      throw new TypeError("Too many arguments for a `return`");
    }
    throw this.evaluateNode(node["arguments"][0], context);
  };


  /*
   */

  Evaluator.prototype.evaluateFor = function(node, context) {
    var expression;
    expression = this.evaluateNode(node.expression, context);
    expression.each((function(_this) {
      return function(key, value) {
        var e, error;
        context.set(node.value.value, value);
        if (node.key != null) {
          context.set(node.key.value, key);
        }
        try {
          return _this.evaluateBody(node.block.body, context);
        } catch (error) {
          e = error;
          if (e instanceof Directive) {
            if (e.name === 'break') {
              if (!(--e.depth > 0)) {
                return false;
              }
            } else if (e.name === 'continue') {
              if (!(--e.depth > 0)) {
                return;
              }
            }
          }
          throw e;
        }
      };
    })(this));
  };


  /*
   */

  Evaluator.prototype.evaluateLoop = function(node, context) {
    var e, error, met;
    while (true) {
      try {
        if (node.condition) {
          met = (this.evaluateNode(node.condition, context)).toBoolean();
          if (met === node.negate) {
            break;
          }
        }
        this.evaluateBody(node.block.body, context);
      } catch (error) {
        e = error;
        if (e instanceof Directive) {
          if (e.name === 'break') {
            if (!(--e.depth > 0)) {
              break;
            }
          } else if (e.name === 'continue') {
            if (!(--e.depth > 0)) {
              continue;
            }
          }
        }
        throw e;
      }
    }
  };


  /*
   */

  Evaluator.prototype.evaluateImport = function(node, context) {
    var arg, file, j, len, ref1;
    ref1 = node["arguments"];
    for (j = 0, len = ref1.length; j < len; j++) {
      arg = ref1[j];
      file = this.evaluateNode(arg, context);
      if (!(file instanceof URL || file instanceof String)) {
        throw new Error("Bad argument for `import`");
      }
      path = file.value;
      context["import"](path);
    }
    return Null["null"];
  };


  /*
   */

  Evaluator.prototype.evaluateUse = function(node, context) {
    var arg, j, len, name, ref1;
    ref1 = node["arguments"];
    for (j = 0, len = ref1.length; j < len; j++) {
      arg = ref1[j];
      name = this.evaluateNode(arg);
      if (!(name instanceof String)) {
        throw new Error("Bad argument for `use`");
      }
      this.layla.use(name.value);
    }
    return Null["null"];
  };

  Evaluator.prototype.evaluateDirective = function(node, context) {
    switch (node.name) {
      case 'use':
        return this.evaluateUse(node, context);
      case 'import':
        return this.evaluateImport(node, context);
      case 'return':
        return this.evaluateReturn(node, context);
      case 'break':
        return this.evaluateBreak(node, context);
      case 'continue':
        return this.evaluateContinue(node, context);
    }
  };


  /*
   */

  Evaluator.prototype.evaluatePropertyDeclaration = function(node, context) {
    var j, len, name, property, ref1, value;
    value = (this.evaluateNode(node.value, context)).clone();
    ref1 = node.names;
    for (j = 0, len = ref1.length; j < len; j++) {
      name = ref1[j];
      name = this.evaluateNode(name, context);
      if (node.conditional && context.block.hasProperty(name.value)) {
        continue;
      }
      property = new Property(name.value, value);
      context.block.items.push(property);
    }
    return property;
  };


  /*
   */

  Evaluator.prototype.evaluateBody = function(body, context) {
    var j, len, node, results;
    results = [];
    for (j = 0, len = body.length; j < len; j++) {
      node = body[j];
      results.push(this.evaluateNode(node, context));
    }
    return results;
  };


  /*
   */

  Evaluator.prototype.evaluateLiteralBlock = function(node, context) {
    var block, ctx;
    block = new Block;
    ctx = context.fork(block);
    this.evaluateBody(node.body, ctx);
    return block;
  };

  Evaluator.prototype.evaluateSelector = function(selector, context) {
    var j, k, len, len1, len2, m, psel, ref1, results, ret, sel;
    if (context.block instanceof RuleSet) {
      ret = [];
      for (j = 0, len = selector.length; j < len; j++) {
        sel = selector[j];
        if (0 > sel.indexOf('&')) {
          sel = "& " + sel;
        }
        ref1 = context.block.selector;
        for (k = 0, len1 = ref1.length; k < len1; k++) {
          psel = ref1[k];
          ret.push(sel.replace(/&/g, psel));
        }
      }
      return ret;
    } else {
      results = [];
      for (m = 0, len2 = selector.length; m < len2; m++) {
        sel = selector[m];
        results.push(sel);
      }
      return results;
    }
  };


  /*
   */

  Evaluator.prototype.evaluateRuleSetDeclaration = function(node, context) {
    var ctx, rule;
    rule = new RuleSet;
    context.block.items.push(rule);
    rule.selector = this.evaluateSelector(node.selector, context);
    ctx = context.fork(rule);
    this.evaluateBody(node.block.body, ctx);
    return rule;
  };


  /*
   */

  Evaluator.prototype.evaluateAtRuleDeclaration = function(node, context) {
    var ctx, rule;
    rule = new AtRule;
    context.block.items.push(rule);
    rule.name = (this.evaluateLiteralString(node.name, context)).value;
    rule["arguments"] = node["arguments"];
    ctx = context.fork(rule);
    if (node.block) {
      this.evaluateBody(node.block.body, ctx);
    } else {
      rule.block = null;
    }
    return rule;
  };


  /*
   */

  Evaluator.prototype.evaluateRoot = function(node, context) {
    if (context == null) {
      context = new Context;
    }
    this.evaluateBody(node.body, context);
    return context.block;
  };

  return Evaluator;

})(Class);

module.exports = Evaluator;


},{"./class":15,"./context":16,"./error/internal":26,"./error/runtime":29,"./error/type":31,"./node/expression":45,"./node/expression/ident":47,"./node/expression/literal/number":53,"./node/expression/operation":59,"./node/statement/directive":68,"./object":72,"./object/at-rule":73,"./object/block":74,"./object/boolean":75,"./object/color":77,"./object/document":78,"./object/function":80,"./object/list":82,"./object/null":83,"./object/number":84,"./object/property":85,"./object/range":86,"./object/regexp":87,"./object/rule-set":88,"./object/string":90,"./object/url":91,"./parser":92,"./plugin":93,"fs":2,"path":6}],34:[function(require,module,exports){
var ImportError, Importer, Plugin,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Plugin = require('./plugin');

ImportError = './error/import';

Importer = (function(superClass) {
  extend(Importer, superClass);

  function Importer() {
    return Importer.__super__.constructor.apply(this, arguments);
  }

  Importer.prototype.canImport = function(uri, context) {
    return false;
  };

  Importer.prototype["import"] = function(uri, context) {
    throw new ImportError("Cannot import \"" + uri + "\"");
  };

  Importer.prototype.use = function(context) {
    return context.useImporter(this);
  };

  return Importer;

})(Plugin);

module.exports = Importer;


},{"./plugin":93}],35:[function(require,module,exports){
var Evaluator, LayImporter, LayParser, SourceImporter,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

SourceImporter = require('./source');

LayParser = require('../parser');

Evaluator = require('../evaluator');

LayImporter = (function(superClass) {
  extend(LayImporter, superClass);

  function LayImporter() {
    return LayImporter.__super__.constructor.apply(this, arguments);
  }

  LayImporter.prototype.parse = function(source) {
    var parser;
    parser = new LayParser;
    return parser.parse(source);
  };

  return LayImporter;

})(SourceImporter);

module.exports = LayImporter;


},{"../evaluator":33,"../parser":92,"./source":36}],36:[function(require,module,exports){
var ImportError, Importer, Path, SourceImporter,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Path = require('path');

Importer = require('../importer');

ImportError = '../error/import';

SourceImporter = (function(superClass) {
  extend(SourceImporter, superClass);

  function SourceImporter() {
    return SourceImporter.__super__.constructor.apply(this, arguments);
  }

  SourceImporter.prototype.parse = function(source) {
    throw new ImportError("Don't know how to parse");
  };

  SourceImporter.prototype.canImport = function(uri, context) {
    return context.canLoad(uri);
  };

  SourceImporter.prototype["import"] = function(uri, context) {
    var ast, source;
    source = context.load(uri);
    ast = this.parse(source);
    context.pushPath(Path.dirname(uri));
    context.evaluate(ast, context);
    return context.popPath();
  };

  return SourceImporter;

})(Importer);

module.exports = SourceImporter;


},{"../importer":34,"path":6}],37:[function(require,module,exports){
var CLIEmitter, CSSEmitter, Class, Context, Document, Emitter, Error, Evaluator, Layla, Node, Normalizer, Object, Parser, String, VERSION;

VERSION = require('./version');

Class = require('./class');

Parser = require('./parser');

Context = require('./context');

Evaluator = require('./evaluator');

Emitter = require('./emitter');

CSSEmitter = require('./emitter/css');

CLIEmitter = require('./emitter/cli');

Node = require('./node');

Object = require('./object');

Document = require('./object/document');

String = require('./object/string');

Error = require('./error');

Normalizer = require('./css/normalizer');

Layla = (function() {
  Layla.version = VERSION;

  Layla.Class = Class;

  Layla.Node = Node;

  Layla.Object = Object;

  Layla.Document = Document;

  Layla.String = String;

  Layla.Parser = Parser;

  Layla.Evaluator = Evaluator;

  Layla.Emitter = Emitter;

  Layla.Normalizer = Normalizer;

  Layla.Context = Context;

  Layla.Error = Error;


  /*
   */

  function Layla(context1) {
    this.context = context1 != null ? context1 : new Context;
    this.parser = new Parser;
    this.evaluator = new Evaluator;
    this.normalizer = new Normalizer;
    this.emitter = new CSSEmitter;
  }

  Layla.prototype.parse = function(source) {
    return this.parser.parse(source);
  };

  Layla.prototype.evaluate = function(node, context) {
    if (context == null) {
      context = this.context;
    }
    if (!(node instanceof Node)) {
      node = this.parse(node);
    }
    return this.evaluator.evaluateRoot(node, context);
  };

  Layla.prototype.normalize = function(node) {
    return this.normalizer.normalize(node);
  };

  Layla.prototype.emit = function(node) {
    return this.emitter.emit(node);
  };

  Layla.prototype.compile = function(source) {
    return this.emit(this.normalize(this.evaluate(this.parse(source))));
  };

  return Layla;

})();

module.exports = Layla;


},{"./class":15,"./context":16,"./css/normalizer":19,"./emitter":20,"./emitter/cli":21,"./emitter/css":22,"./error":23,"./evaluator":33,"./node":41,"./object":72,"./object/document":78,"./object/string":90,"./parser":92,"./version":95}],38:[function(require,module,exports){
(function (global){
var AT_IDENT, BINARY_OPERATOR, BOM, COLOR, COMBINATOR, Class, EOT, EOTError, IDENT, InternalError, Lexer, NUMBER, PUNC, REGEXP, SELECTOR, SIMPLE_SELECTOR, STRING, SyntaxError, Token, UNARY_OPERATOR, UNICODE_RANGE, UNIT, WHITESPACE,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Class = require('./class');

Token = require('./token');

SyntaxError = require('./error/syntax');

EOTError = require('./error/eot');

InternalError = require('./error/internal');

PUNC = Token.PUNC, UNARY_OPERATOR = Token.UNARY_OPERATOR, BINARY_OPERATOR = Token.BINARY_OPERATOR, IDENT = Token.IDENT, UNIT = Token.UNIT, AT_IDENT = Token.AT_IDENT, STRING = Token.STRING, SELECTOR = Token.SELECTOR, SIMPLE_SELECTOR = Token.SIMPLE_SELECTOR, COMBINATOR = Token.COMBINATOR, NUMBER = Token.NUMBER, COLOR = Token.COLOR, REGEXP = Token.REGEXP, UNICODE_RANGE = Token.UNICODE_RANGE, WHITESPACE = Token.WHITESPACE, EOT = Token.EOT, BOM = Token.BOM;


/*
 */

Lexer = (function(superClass) {
  var RE_ALL_WHITESPACE, RE_ATTRIBUTE_NAME, RE_ATTRIBUTE_OPERATOR, RE_BINARY_OPERATOR, RE_CLASS_SELECTOR, RE_COLOR, RE_COMBINATOR, RE_ELEMENTAL_SELECTOR, RE_ESCAPE, RE_HORIZONTAL_WHITESPACE, RE_IDENT_CHAR, RE_IDENT_START, RE_ID_SELECTOR, RE_NON_ASCII, RE_NUMBER, RE_PUNCTUATION, RE_REGEXP, RE_TRAILING_WHITESPACE, RE_UNARY_OPERATOR, RE_UNICODE_ESCAPE, RE_UNICODE_ESCAPE_CHAR, RE_UNICODE_RANGE, RE_UNIT;

  extend(Lexer, superClass);

  RE_NON_ASCII = /[^\x00-\x80]/;

  RE_UNICODE_ESCAPE_CHAR = /[0-9a-fA-F]/;

  RE_UNICODE_ESCAPE = RegExp("\\\\((?:" + RE_UNICODE_ESCAPE_CHAR.source + "){1,6})(\\r\\n|[\\x20\\n\\r\\t\\f])?");

  RE_ESCAPE = RegExp(RE_UNICODE_ESCAPE.source + "|(\\\\[^\\n\\r])");

  RE_IDENT_START = RegExp("(" + RE_NON_ASCII.source + ")|(([!\\?_\\$-]+)?(?=[a-zA-Z]|" + RE_ESCAPE.source + "))");

  RE_IDENT_CHAR = RegExp("([a-zA-Z\\d!\\$\\?_-])|(" + RE_NON_ASCII.source + ")|(" + RE_ESCAPE.source + ")");

  RE_NUMBER = /(?:\d*\.)?\d+/i;

  RE_UNIT = RegExp("(%|([a-z]+))|(" + RE_NON_ASCII.source + ")|(" + RE_ESCAPE.source + ")", "i");

  RE_REGEXP = /\/([^\s](?:(?:\\.)|[^\\\/\n\r])+)\/([a-z]+)?/i;

  RE_UNICODE_RANGE = /^u\+[0-9a-f?]{1,6}(-[0-9a-f?]{1,6})?/i;

  RE_COLOR = /#([a-f\d]{1,2}){1,4}/i;

  RE_PUNCTUATION = /[\{\}\(\),;:=&"'`\|]/;

  RE_ALL_WHITESPACE = /\s+/;

  RE_HORIZONTAL_WHITESPACE = /[ \t]+/;

  RE_TRAILING_WHITESPACE = /[ \t]*(\n|$)/;

  RE_UNARY_OPERATOR = /\-|\+|not/;

  RE_BINARY_OPERATOR = /(::|\.\.|\.|\()|(([\t ]*)(\,|\|?=|~|\*|\/|(?:[\+\-](?!(?:\d|(?:(?:[\!\?\_\-\$]+)?[a-z]))))|>>|<<|>=|>|<=|<|and|or|isnt|is|in|hasnt|has|if|unless))|([\t ]+)/;

  RE_ID_SELECTOR = /#[a-z][a-z\d_-]*/i;

  RE_CLASS_SELECTOR = /\.[a-z][a-z\d_-]*/i;

  RE_ELEMENTAL_SELECTOR = /((([a-z]+)|(\*))?\|)?(\*|&|([a-z][a-z\d_-]*))/i;

  RE_ATTRIBUTE_NAME = /((([a-z]+)|(\*))?\|)?([a-z]+\|)?[a-z][a-z\d_-]*/i;

  RE_ATTRIBUTE_OPERATOR = /[\~\^\$\*\|]?=/i;

  RE_COMBINATOR = /\>|\~|\+/i;

  function Lexer() {
    this.prepare();
  }

  Lexer.prototype.prepare = function(source) {
    if (source == null) {
      source = '';
    }
    if ('\uFEFF' === source.charAt(0)) {
      source = source.substr(1);
    }
    source = source.replace(/\r/g, '\n');
    source = source.replace(/\\(\\\\)+[\n$]/, '');
    this.source = source;
    this.length = source.length;
    return this.moveTo(this.position = 0);
  };


  /*
   */

  Lexer.prototype.isEndOfText = function() {
    return this.position >= this.length;
  };


  /*
   */

  Lexer.prototype.isStartOfLine = function() {
    return this.position === 0 || this.source[this.position - 1] === '\n';
  };


  /*
  Returns `yes` if there's nothing but horizontal whitespace (`[\n\t ]` between
  current character and the end of the line.
   */

  Lexer.prototype.isEndOfLine = function() {
    return !!(this.match(RE_TRAILING_WHITESPACE));
  };


  /*
  Skip all whitespace, including new lines.
   */

  Lexer.prototype.skipWhitespace = function() {
    var match;
    if (match = this.match(RE_ALL_WHITESPACE)) {
      this.move(match[0].length);
      return match[0];
    }
  };

  Lexer.prototype.skipSpaces = function() {
    var match;
    if (match = this.match(/[ \t]/)) {
      this.move(match[0].length);
      return match[0];
    }
  };


  /*
   */

  Lexer.prototype.chars = function(length, start) {
    if (start == null) {
      start = this.position;
    }
    return this.source.substr(start, length);
  };


  /*
  Find the `boundary` expression starting from current position and return the
  slice of source til that boundary or the end of text, whatever comes first.
   */

  Lexer.prototype.charsUntil = function(boundary) {
    var i;
    i = this.position + 1;
    while (++i < this.length) {
      if ((boundary.indexOf(this.source[i])) >= 0) {
        break;
      }
    }
    return this.source.substring(this.position, i);
  };


  /*
  Advance until a character that matches `boundary` or the end of the document
  is found.
   */

  Lexer.prototype.skipCharsUntil = function(boundary) {
    var chars;
    chars = this.charsUntil(boundary);
    this.move(chars.length);
    return chars;
  };


  /*
  Matches remaining slice of source against a regular `expression` and returns
  the match or `null` if there's no match.
   */

  Lexer.prototype.match = function(expression, offset) {
    var matches;
    if (offset == null) {
      offset = 0;
    }
    matches = (this.source.substring(this.position + offset)).match(expression);
    if ((matches != null ? matches.index : void 0) === 0) {
      return matches;
    } else {
      return null;
    }
  };


  /*
   */

  Lexer.prototype.moveTo = function(position) {
    if (!((0 <= position && position <= this.length))) {
      throw new InternalError("Cannot move to position " + position);
    }
    this.position = position;
    this.char = position < this.length ? this.source[position] : null;
  };


  /*
  Move `n` positions.
   */

  Lexer.prototype.move = function(n) {
    if (n == null) {
      n = 1;
    }
    return this.moveTo(this.position + n);
  };


  /*
  Token maker.
   */

  Lexer.prototype.makeToken = function(type, func) {
    var e, error, start, token;
    token = new Token(type);
    start = token.start = this.position;
    if (func) {
      try {
        if (false === (func.call(this, token))) {
          this.moveTo(start);
          return;
        }
      } catch (error) {
        e = error;
        throw e;
      }
    }
    if (!this.isEndOfText() && this.position === token.start) {
      this.move();
    }
    if (token.end == null) {
      token.end = this.position;
    }
    if (token.value == null) {
      token.value = this.source.substring(token.start, token.end);
    }
    return token;
  };

  Lexer.prototype.readBOM = function() {
    if (this.char === '\uFEFF') {
      return this.makeToken(BOM, function() {
        return this.move();
      });
    }
  };

  Lexer.prototype.readEOT = function() {
    if (this.isEndOfText()) {
      return this.makeToken(EOT);
    }
  };


  /*
   */

  Lexer.prototype.readLineComment = function() {
    if ('//' === this.chars(2)) {
      return this.makeToken(LINE_COMMENT, function() {
        return this.skipCharsUntil('\n');
      });
    }
  };


  /*
   */

  Lexer.prototype.readBlockComment = function() {
    if ('/*' === this.chars(2)) {
      return this.makeToken(BLOCK_COMMENT, function() {
        var end;
        end = this.source.indexOf('*/', this.position + 2);
        if (end < 0) {
          throw new EOTError('Unterminated /* block comment */');
        }
        return this.move(2);
      });
    }
  };

  Lexer.prototype.readEscape = function() {
    var char, code, match;
    if (match = this.match(RE_UNICODE_ESCAPE)) {
      code = parseInt(match[1], 16);
      this.move(match[0].length);
      return global.String.fromCharCode(code);
    } else {
      this.move();
      char = (function() {
        switch (this.char) {
          case 'n':
            return '\n';
          case 'r':
            return '\r';
          case 't':
            return '\t';
          case null:
          case '\n':
            return '';
          default:
            return this.char;
        }
      }).call(this);
      this.move();
      return char;
    }
  };


  /*
  TODO: Interpolation
   */

  Lexer.prototype.readStringContent = function(boundary) {
    var value;
    value = '';
    while (this.char !== boundary) {
      if (this.isEndOfText()) {
        throw new EOTError("Text termined before boundary ('" + boundary + "')");
      }
      if (this.char === '\\') {
        if (this.isEndOfText()) {
          throw new EOTError("Unexpected end of text before boundary ('" + boundary + "')");
        }
        value += this.readEscape();
      } else {
        value += this.char;
        this.move();
      }
    }
    return value;
  };


  /*
   */

  Lexer.prototype.readIdent = function() {
    if (this.match(RE_IDENT_START)) {
      return this.makeToken(IDENT, function(idnt) {
        var m, name;
        name = '';
        while (m = this.match(RE_IDENT_CHAR)) {
          if (this.char === '\\') {
            name += this.readEscape();
          } else {
            name += m[0];
            this.move(m[0].length);
          }
        }
        return idnt.value = name;
      });
    }
  };


  /*
  At-idents may have interpolation too, but they have to start with an `@`.
   */

  Lexer.prototype.readAtIdent = function() {
    if (this.char === '@') {
      return this.makeToken(AT_IDENT, function(at) {
        this.move();
        if (!(at.name = this.readIdent())) {
          throw new SyntaxError("Unfinished at-ident");
        }
      });
    }
  };


  /*
   */

  Lexer.prototype.readPunc = function() {
    var match;
    if (match = this.match(RE_PUNCTUATION)) {
      return this.makeToken(PUNC, function() {
        return this.move(match[0].length);
      });
    }
  };


  /*
  TODO Refactor this
   */

  Lexer.prototype.readBinaryOperator = function() {
    var match;
    if (match = this.match(RE_BINARY_OPERATOR)) {
      if (match[3] != null) {
        this.move(match[3].length);
      }
      return this.makeToken(BINARY_OPERATOR, function(op) {
        if (match[1] != null) {
          return this.move(match[1].length);
        } else if (match[4] != null) {
          if (match[4] === '/' && this.match(RE_REGEXP)) {
            if (match[3] != null) {
              op.start = this.position - match[3].length;
              return op.value = ' ';
            } else {
              return false;
            }
          } else {
            return this.move(match[4].length);
          }
        } else {
          op.value = ' ';
          return this.move(match[5].length);
        }
      });
    }
  };


  /*
   */

  Lexer.prototype.readUnaryOperator = function() {
    var op;
    if (op = this.match(RE_UNARY_OPERATOR)) {
      return this.makeToken(UNARY_OPERATOR, function() {
        return this.move(op[0].length);
      });
    }
  };

  Lexer.prototype.readUnit = function() {
    var match;
    if (this.char === '`') {
      return this.readString();
    } else if (match = this.match(RE_UNIT)) {
      return this.makeToken(UNIT, function() {
        return this.move(match[0].length);
      });
    }
  };


  /*
   */

  Lexer.prototype.readNumber = function() {
    var match;
    if (match = this.match(RE_NUMBER)) {
      return this.makeToken(NUMBER, function(number) {
        this.move(match[0].length);
        number.value = match[0];
        return number.unit = (this.read(UNIT, null, false)) || null;
      });
    }
  };


  /*
   */

  Lexer.prototype.readString = function() {
    var quote, ref;
    if ((ref = this.char) === '"' || ref === "'" || ref === '`') {
      quote = this.char;
      return this.makeToken(STRING, function(str) {
        str.quote = quote;
        this.move();
        str.value = this.readStringContent(quote);
        return this.move();
      });
    }
  };


  /*
   */

  Lexer.prototype.readHexColor = function() {
    var match;
    if (match = this.match(RE_COLOR)) {
      return this.makeToken(COLOR, function() {
        return this.move(match[0].length);
      });
    }
  };


  /*
   */

  Lexer.prototype.readColor = function() {
    return this.readHexColor();
  };


  /*
   */

  Lexer.prototype.readUnicodeRange = function() {
    var match;
    if (match = this.match(RE_UNICODE_RANGE)) {
      return this.makeToken(UNICODE_RANGE, function() {
        return this.move(match[0].length);
      });
    }
  };


  /*
  /regular expression/options
   */

  Lexer.prototype.readRegExp = function() {
    var match;
    if (match = this.match(RE_REGEXP)) {
      return this.makeToken(REGEXP, function(reg) {
        reg.value = match[1];
        reg.flags = match[2];
        return this.move(match[0].length);
      });
    }
  };

  Lexer.prototype.readAtRuleProperty = function() {
    var id, sc, start, val;
    start = this.position;
    if (id = this.peek(IDENT)) {
      this.moveTo(id.end);
      if (sc = this.read(PUNC, ':')) {
        if (val = this.readAtRuleIdent() || this.readAtRuleString() || (this.read(NUMBER))) {
          return true;
        } else {
          throw new SyntaxError(":( " + this.position);
        }
      }
    }
    this.moveTo(start);
  };

  Lexer.prototype.readAtRuleGroup = function() {
    var tok;
    if (tok = this.peek(PUNC, '(')) {
      return this.makeToken(IDENT, function(group) {
        var arg;
        group.start = tok.start;
        this.moveTo(tok.end);
        while (true) {
          if (!(arg = this.readAtRuleArgument())) {
            break;
          }
        }
        return this.expect(PUNC, ')');
      });
    }
  };

  Lexer.prototype.readAtRuleString = function() {
    return this.read(STRING);
  };

  Lexer.prototype.readAtRuleIdent = function() {
    return this.read(IDENT);
  };

  Lexer.prototype.readAtRuleFunction = function() {
    var name;
    if (name = this.peek(IDENT)) {
      return this.makeToken(IDENT, function(fun) {
        var parens;
        this.moveTo(name.end);
        if (this.eat(PUNC, '(', false)) {
          parens = 1;
          while (parens) {
            if (this.isEndOfText()) {
              throw new EOTError("Unterminated at-rule function call");
            }
            if (this.char === ')') {
              parens--;
            } else if (this.char === '(') {
              parens++;
            }
            this.move();
          }
          return true;
        }
        return false;
      });
    }
  };

  Lexer.prototype.readAtRulePseudo = function() {
    var tok;
    if (tok = this.peek(PUNC, ':')) {
      this.moveTo(tok.start);
      return this.makeToken(IDENT, function() {
        this.eat(PUNC, ':', false);
        if (!this.read(IDENT, null, false)) {
          return false;
        }
      });
    }
  };

  Lexer.prototype.readAtRuleArgument = function() {
    var tok;
    tok = this.readAtRuleFunction() || (tok = this.readAtRuleProperty() || this.readAtRuleString() || this.readAtRuleGroup() || this.readAtRulePseudo() || this.readAtRuleIdent());
    if (tok) {
      return tok;
    }
  };


  /*
  TODO do a real parsing of arguments.
   */

  Lexer.prototype.readAtRuleArguments = function() {
    var start, yeah;
    start = this.position;
    yeah = false;
    this.skipWhitespace();
    while (!this.isEndOfLine()) {
      if (!this.readAtRuleArgument()) {
        break;
      }
      if (this.eat(PUNC, ',')) {
        this.skipWhitespace();
      }
      yeah = true;
    }
    if (yeah) {
      return (this.source.substring(start, this.position)).trim();
    } else {
      this.moveTo(start);
    }
  };


  /*
  foo
  *
  &
   */

  Lexer.prototype.readElementalSelector = function() {
    var match;
    if (match = this.match(RE_ELEMENTAL_SELECTOR)) {
      return this.makeToken(SIMPLE_SELECTOR, function() {
        return this.move(match[0].length);
      });
    }
  };


  /*
  #foo
   */

  Lexer.prototype.readIdSelector = function() {
    var match;
    if (match = this.match(RE_ID_SELECTOR)) {
      return this.makeToken(SIMPLE_SELECTOR, function() {
        return this.move(match[0].length);
      });
    }
  };


  /*
  .foo
   */

  Lexer.prototype.readClassSelector = function() {
    var match;
    if (match = this.match(RE_CLASS_SELECTOR)) {
      return this.makeToken(SIMPLE_SELECTOR, function() {
        return this.move(match[0].length);
      });
    }
  };

  Lexer.prototype.readComplementarySelector = function() {
    return this.readIdSelector() || this.readClassSelector() || this.readAttributeSelector() || this.readPseudoSelector();
  };


  /*
   */

  Lexer.prototype.readKeyFramesSelector = function() {
    var number, ref, ref1;
    if (((ref = (number = this.peek(NUMBER))) != null ? (ref1 = ref.unit) != null ? ref1.value : void 0 : void 0) === '%') {
      this.moveTo(number.start);
      return this.makeToken(Number, function() {
        return this.moveTo(number.end);
      });
    }
  };


  /*
   */

  Lexer.prototype.readSimpleSelector = function() {
    return this.readKeyFramesSelector() || this.makeToken(SIMPLE_SELECTOR, function() {
      var elem, sel, sp;
      this.skipSpaces();
      elem = this.readElementalSelector();
      sel = elem ? elem.value : '';
      while (sp = this.readComplementarySelector()) {
        sel += sp.value;
      }
      if (sel === '') {
        return false;
      }
    });
  };


  /*
  [foo...]
   */

  Lexer.prototype.readAttributeSelector = function() {
    if (this.char === '[') {
      return this.makeToken(SIMPLE_SELECTOR, function(sel) {
        var c, match, name;
        this.move();
        this.skipWhitespace();
        if (name = this.match(RE_ATTRIBUTE_NAME)) {
          this.move(name[0].length);
          this.skipWhitespace();
          if (match = this.match(RE_ATTRIBUTE_OPERATOR)) {
            this.move(match[0].length);
            this.readString() || this.readIdent() || this.readNumber();
          }
          if (c = this.eat(IDENT, 'i')) {
            sel["case"] = c.value;
          } else {
            sel["case"] = null;
          }
          if (this.char === ']') {
            this.move();
            return true;
          }
        }
        return false;
      });
    }
  };


  /*
  :foo
  ::foo
   */

  Lexer.prototype.readPseudoSelector = function() {
    if (this.char === ':') {
      return this.makeToken(SIMPLE_SELECTOR, function() {
        var parens, tok;
        this.move();
        if (this.char === ':') {
          this.move();
        }
        if (!this.readIdent()) {
          return false;
        }
        if (tok = this.peek(PUNC, '(')) {
          this.moveTo(tok.end);
          parens = 1;
          while (parens) {
            if (this.isEndOfLine()) {
              return false;
            }
            if (this.char === ')') {
              parens--;
            }
            if (this.char === '(') {
              parens++;
            }
            this.move();
          }
        }
      });
    }
  };


  /*
   */

  Lexer.prototype.readCombinator = function() {
    return this.makeToken(COMBINATOR, function() {
      var match;
      this.skipWhitespace();
      if (match = this.match(RE_COMBINATOR)) {
        return this.move(match[0].length);
      } else {
        return false;
      }
    });
  };


  /*
   */

  Lexer.prototype.readSelector = function() {
    return this.makeToken(SELECTOR, function(sel) {
      var i;
      this.readCombinator();
      i = 0;
      while (true) {
        if (this.readSimpleSelector()) {
          i++;
          this.readCombinator();
        } else {
          return i > 0;
        }
      }
    });
  };

  Lexer.prototype.readSelectorList = function() {
    var selector, selectors;
    selectors = [];
    while (selector = this.readSelector()) {
      selectors.push(selector);
      if (!this.read(PUNC, ',')) {
        break;
      }
      this.skipWhitespace();
    }
    if (selectors.length) {
      return selectors;
    }
  };


  /*
   */

  Lexer.prototype.readWhitespace = function() {
    var match;
    if (match = this.match(RE_HORIZONTAL_WHITESPACE)) {
      return this.makeToken(WHITESPACE, function() {
        return this.move(match[0].length);
      });
    }
  };


  /*
  Generic `read*`. Try to read a token of given `type` with optional `value`.
  
  This will have a token cache which should make it a lot faster.
   */

  Lexer.prototype.read = function(type, value, ignore) {
    var token;
    if (ignore == null) {
      ignore = /\s*/;
    }
    if (token = this.peek(type, value, ignore)) {
      this.moveTo(token.end);
      return token;
    }
  };

  Lexer.prototype.peek = function(type, value, ignore) {
    var m, start, token;
    if (ignore == null) {
      ignore = /\s*/;
    }
    start = this.position;
    if ((ignore != null) && (m = this.match(ignore))) {
      this.move(m[0].length);
    }
    if (token = this["read" + type]()) {
      if ((value == null) || (([].concat(value)).indexOf(token.value)) >= 0) {
        this.moveTo(start);
        return token;
      }
    }
    this.moveTo(start);
  };


  /*
   */

  Lexer.prototype.expect = function(type, value, ignore) {
    var token;
    if (ignore == null) {
      ignore = /\s*/;
    }
    if (token = this.read(type, value, ignore)) {
      return token;
    }
    if (this.peek(EOT)) {
      throw new EOTError("Unexpected EOT");
    } else {
      throw new SyntaxError("\"Unexpected `don't know what` type or value. Expected `" + type + "` (" + value + ")  at " + this.position + "\"");
    }
  };


  /*
   */

  Lexer.prototype.eat = Lexer.prototype.read;


  /*
   */

  Lexer.prototype.eatAll = function(type, value, ignore) {
    var results;
    if (ignore == null) {
      ignore = /\s*/;
    }
    results = [];
    while (true) {
      if (!this.eat(type, value, ignore)) {
        break;
      } else {
        results.push(void 0);
      }
    }
    return results;
  };

  return Lexer;

})(Class);

module.exports = Lexer;


}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"./class":15,"./error/eot":24,"./error/internal":26,"./error/syntax":30,"./token":94}],39:[function(require,module,exports){
var ImportError, Loader, Plugin,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Plugin = require('./plugin');

ImportError = './error/import';

Loader = (function(superClass) {
  extend(Loader, superClass);

  function Loader() {
    return Loader.__super__.constructor.apply(this, arguments);
  }

  Loader.prototype.canLoad = function(uri, context) {
    return false;
  };

  Loader.prototype.load = function(uri, context) {
    throw new ImportError("Cannot load \"" + uri + "\"");
  };

  Loader.prototype.use = function(context) {
    return context.useLoader(this);
  };

  return Loader;

})(Plugin);

module.exports = Loader;


},{"./plugin":93}],40:[function(require,module,exports){
var Loader, URL, XHRLoader,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

URL = require('url');

Loader = require('../loader');

XHRLoader = (function(superClass) {
  extend(XHRLoader, superClass);

  function XHRLoader() {
    return XHRLoader.__super__.constructor.apply(this, arguments);
  }

  XHRLoader.prototype.canLoad = function(uri, context) {
    var ref, url;
    url = URL.parse(uri);
    return (ref = url.protocol) === 'http:' || ref === 'https:';
  };

  XHRLoader.prototype.load = function(uri, context) {
    var xhr;
    xhr = new XMLHttpRequest;
    xhr.addEventListener('load', function() {});
    xhr.open('GET', uri, false);
    xhr.send();
    if (xhr.status === 200) {
      return xhr.responseText;
    } else {
      throw new ImportError("Could not import URL: \"" + uri + "\"");
    }
  };

  return XHRLoader;

})(Loader);

module.exports = XHRLoader;


},{"../loader":39,"url":12}],41:[function(require,module,exports){
var Class, Node,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Class = require('./class');

Node = (function(superClass) {
  extend(Node, superClass);

  function Node() {
    return Node.__super__.constructor.apply(this, arguments);
  }

  Node.prototype.parent = null;

  Node.property('root', {
    get: function() {
      var p;
      p = this;
      while (p.parent) {
        p = p.parent;
      }
      return p;
    }
  });

  Node.prototype.start = null;

  Node.prototype.end = null;

  Node.prototype.toJSON = function() {
    var json;
    json = Node.__super__.toJSON.apply(this, arguments);
    json.start = this.start;
    json.end = this.end;
    return json;
  };

  return Node;

})(Class);

module.exports = Node;


},{"./class":15}],42:[function(require,module,exports){
var Comment, Node,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Node = require('../node');

Comment = (function(superClass) {
  extend(Comment, superClass);

  function Comment() {
    return Comment.__super__.constructor.apply(this, arguments);
  }

  Comment.prototype.value = null;

  Comment.prototype.inline = false;

  return Comment;

})(Node);

module.exports = Comment;


},{"../node":41}],43:[function(require,module,exports){
var BlockComment, Comment,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Comment = require('../comment');

BlockComment = (function(superClass) {
  extend(BlockComment, superClass);

  function BlockComment() {
    return BlockComment.__super__.constructor.apply(this, arguments);
  }

  return BlockComment;

})(Comment);

module.exports = BlockComment;


},{"../comment":42}],44:[function(require,module,exports){
var Comment, LineComment,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Comment = require('../comment');

LineComment = (function(superClass) {
  extend(LineComment, superClass);

  function LineComment() {
    return LineComment.__super__.constructor.apply(this, arguments);
  }

  return LineComment;

})(Comment);

module.exports = LineComment;


},{"../comment":42}],45:[function(require,module,exports){
var Expression, Node,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Node = require('../node');

Expression = (function(superClass) {
  extend(Expression, superClass);

  function Expression() {
    return Expression.__super__.constructor.apply(this, arguments);
  }

  return Expression;

})(Node);

module.exports = Expression;


},{"../node":41}],46:[function(require,module,exports){
var Expression, Group,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Expression = require('../expression');

Group = (function(superClass) {
  extend(Group, superClass);

  function Group(expression) {
    this.expression = expression;
  }

  Group.prototype.toJSON = function() {
    var json;
    json = Group.__super__.toJSON.apply(this, arguments);
    json.expression = this.expression;
    return json;
  };

  return Group;

})(Expression);

module.exports = Group;


},{"../expression":45}],47:[function(require,module,exports){
var Expression, Ident,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Expression = require('../expression');

Ident = (function(superClass) {
  extend(Ident, superClass);

  function Ident() {
    return Ident.__super__.constructor.apply(this, arguments);
  }

  Ident.prototype.value = null;

  Ident.prototype.name = null;

  Ident.prototype["arguments"] = null;

  Ident.prototype.toJSON = function() {
    var json;
    json = Ident.__super__.toJSON.apply(this, arguments);
    json.name = this.name;
    json["arguments"] = this["arguments"];
    return json;
  };

  return Ident;

})(Expression);

module.exports = Ident;


},{"../expression":45}],48:[function(require,module,exports){
var Expression, Literal,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Expression = require('../expression');

Literal = (function(superClass) {
  extend(Literal, superClass);

  function Literal() {
    return Literal.__super__.constructor.apply(this, arguments);
  }

  return Literal;

})(Expression);

module.exports = Literal;


},{"../expression":45}],49:[function(require,module,exports){
var Literal, LiteralBlock,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Literal = require('../literal');

LiteralBlock = (function(superClass) {
  extend(LiteralBlock, superClass);

  function LiteralBlock() {
    return LiteralBlock.__super__.constructor.apply(this, arguments);
  }

  LiteralBlock.prototype.body = null;

  LiteralBlock.prototype.toJSON = function() {
    var json;
    json = LiteralBlock.__super__.toJSON.apply(this, arguments);
    json.body = this.body;
    return json;
  };

  return LiteralBlock;

})(Literal);

module.exports = LiteralBlock;


},{"../literal":48}],50:[function(require,module,exports){
var Literal, LiteralColor,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Literal = require('../literal');

LiteralColor = (function(superClass) {
  extend(LiteralColor, superClass);

  function LiteralColor() {
    return LiteralColor.__super__.constructor.apply(this, arguments);
  }

  LiteralColor.prototype.value = null;

  return LiteralColor;

})(Literal);

module.exports = LiteralColor;


},{"../literal":48}],51:[function(require,module,exports){
var Literal, LiteralFunction,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Literal = require('../literal');

LiteralFunction = (function(superClass) {
  extend(LiteralFunction, superClass);

  function LiteralFunction() {
    return LiteralFunction.__super__.constructor.apply(this, arguments);
  }

  LiteralFunction.prototype["arguments"] = null;

  LiteralFunction.prototype.block = null;

  LiteralFunction.prototype.toJSON = function() {
    var json;
    json = LiteralFunction.__super__.toJSON.apply(this, arguments);
    json.block = this.block;
    json["arguments"] = this["arguments"];
    return json;
  };

  return LiteralFunction;

})(Literal);

module.exports = LiteralFunction;


},{"../literal":48}],52:[function(require,module,exports){
var Literal, LiteralList,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Literal = require('../literal');

LiteralList = (function(superClass) {
  extend(LiteralList, superClass);

  function LiteralList(body, separator) {
    this.body = body != null ? body : [];
    this.separator = separator != null ? separator : ' ';
    LiteralList.__super__.constructor.apply(this, arguments);
  }

  LiteralList.prototype.toJSON = function() {
    var json;
    json = LiteralList.__super__.toJSON.apply(this, arguments);
    json.body = this.block;
    return json;
  };

  return LiteralList;

})(Literal);

module.exports = LiteralList;


},{"../literal":48}],53:[function(require,module,exports){
var Literal, LiteralNumber,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Literal = require('../literal');

LiteralNumber = (function(superClass) {
  extend(LiteralNumber, superClass);

  function LiteralNumber(value, unit) {
    this.value = value;
    this.unit = unit != null ? unit : null;
    LiteralNumber.__super__.constructor.call(this);
  }

  LiteralNumber.prototype.toJSON = function() {
    var json;
    json = LiteralNumber.__super__.toJSON.apply(this, arguments);
    json.value = this.value;
    json.unit = this.unit;
    return json;
  };

  return LiteralNumber;

})(Literal);

module.exports = LiteralNumber;


},{"../literal":48}],54:[function(require,module,exports){
var Literal, LiteralRegExp,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Literal = require('../literal');

LiteralRegExp = (function(superClass) {
  extend(LiteralRegExp, superClass);

  function LiteralRegExp() {
    return LiteralRegExp.__super__.constructor.apply(this, arguments);
  }

  LiteralRegExp.prototype.value = null;

  LiteralRegExp.prototype.flags = null;

  LiteralRegExp.prototype.toJSON = function() {
    var json;
    json = LiteralRegExp.__super__.toJSON.apply(this, arguments);
    json.value = this.value;
    json.flags = this.flags;
    return json;
  };

  return LiteralRegExp;

})(Literal);

module.exports = LiteralRegExp;


},{"../literal":48}],55:[function(require,module,exports){
var Literal, LiteralString,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Literal = require('../literal');

LiteralString = (function(superClass) {
  extend(LiteralString, superClass);

  function LiteralString(value, quote) {
    this.value = value != null ? value : '';
    this.quote = quote != null ? quote : null;
  }

  LiteralString.prototype.toJSON = function() {
    var json;
    json = LiteralString.__super__.toJSON.apply(this, arguments);
    json.quote = this.quote;
    json.value = this.value;
    return json;
  };

  return LiteralString;

})(Literal);

module.exports = LiteralString;


},{"../literal":48}],56:[function(require,module,exports){
var Literal, LiteralThis,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Literal = require('../literal');

LiteralThis = (function(superClass) {
  extend(LiteralThis, superClass);

  function LiteralThis() {
    return LiteralThis.__super__.constructor.apply(this, arguments);
  }

  return LiteralThis;

})(Literal);

module.exports = LiteralThis;


},{"../literal":48}],57:[function(require,module,exports){
var Literal, LiteralUnicodeRange,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Literal = require('../literal');

LiteralUnicodeRange = (function(superClass) {
  extend(LiteralUnicodeRange, superClass);

  function LiteralUnicodeRange(value) {
    this.value = value != null ? value : '';
  }

  return LiteralUnicodeRange;

})(Literal);

module.exports = LiteralUnicodeRange;


},{"../literal":48}],58:[function(require,module,exports){
var Literal, LiteralURL,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Literal = require('../literal');

LiteralURL = (function(superClass) {
  extend(LiteralURL, superClass);

  function LiteralURL() {
    return LiteralURL.__super__.constructor.apply(this, arguments);
  }

  LiteralURL.prototype.value = null;

  LiteralURL.prototype.toJSON = function() {
    var json;
    json = LiteralURL.__super__.toJSON.apply(this, arguments);
    json.value = this.value;
    json.unit = this.unit;
    return json;
  };

  return LiteralURL;

})(Literal);

module.exports = LiteralURL;


},{"../literal":48}],59:[function(require,module,exports){
var Expression, Operation,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Expression = require('../expression');

Operation = (function(superClass) {
  extend(Operation, superClass);

  function Operation(operator, left, right) {
    this.operator = operator;
    this.left = left != null ? left : null;
    this.right = right != null ? right : null;
  }

  Operation.property('unary', {
    get: function() {
      return !(this.left && this.right);
    }
  });

  Operation.property('binary', {
    get: function() {
      return this.left && this.right && true;
    }
  });

  Operation.prototype.toJSON = function() {
    var json;
    json = Operation.__super__.toJSON.apply(this, arguments);
    json.left = this.left;
    json.right = this.right;
    json.operator = this.operator;
    return json;
  };

  return Operation;

})(Expression);

module.exports = Operation;


},{"../expression":45}],60:[function(require,module,exports){
var Node, Root,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Node = require('../node');

Root = (function(superClass) {
  extend(Root, superClass);

  function Root() {
    return Root.__super__.constructor.apply(this, arguments);
  }

  Root.prototype.bom = false;

  Root.prototype.toJSON = function() {
    var json;
    json = Root.__super__.toJSON.apply(this, arguments);
    json.bom = this.bom;
    json.body = this.body;
    return json;
  };

  return Root;

})(Node);

module.exports = Root;


},{"../node":41}],61:[function(require,module,exports){
var Node, Statement,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Node = require('../node');

Statement = (function(superClass) {
  extend(Statement, superClass);

  function Statement() {
    return Statement.__super__.constructor.apply(this, arguments);
  }

  return Statement;

})(Node);

module.exports = Statement;


},{"../node":41}],62:[function(require,module,exports){
var Conditional, Statement,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Statement = require('../statement');

Conditional = (function(superClass) {
  extend(Conditional, superClass);

  Conditional.prototype.condition = null;

  Conditional.prototype.block = null;

  Conditional.prototype.elses = null;

  Conditional.prototype.negate = false;

  function Conditional() {
    this.elses = [];
  }

  Conditional.prototype.toJSON = function() {
    var json;
    json = Conditional.__super__.toJSON.apply(this, arguments);
    json.condition = this.condition;
    json.block = this.block;
    json.elses = this.elses;
    json.negate = this.negate;
    return json;
  };

  Conditional.prototype.clone = function() {
    return this;
  };

  return Conditional;

})(Statement);

module.exports = Conditional;


},{"../statement":61}],63:[function(require,module,exports){
var Declaration, Statement,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Statement = require('../statement');

Declaration = (function(superClass) {
  extend(Declaration, superClass);

  function Declaration() {
    return Declaration.__super__.constructor.apply(this, arguments);
  }

  return Declaration;

})(Statement);

module.exports = Declaration;


},{"../statement":61}],64:[function(require,module,exports){
var Declaration, PropertyDeclaration,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Declaration = require('../declaration');

PropertyDeclaration = (function(superClass) {
  extend(PropertyDeclaration, superClass);

  PropertyDeclaration.prototype.value = null;

  PropertyDeclaration.prototype.conditional = false;

  function PropertyDeclaration() {
    this.names = [];
  }

  PropertyDeclaration.prototype.toJSON = function() {
    var json;
    json = PropertyDeclaration.__super__.toJSON.apply(this, arguments);
    json.names = this.names;
    json.value = this.value;
    return json;
  };

  return PropertyDeclaration;

})(Declaration);

module.exports = PropertyDeclaration;


},{"../declaration":63}],65:[function(require,module,exports){
var Declaration, RuleDeclaration,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Declaration = require('../declaration');

RuleDeclaration = (function(superClass) {
  extend(RuleDeclaration, superClass);

  function RuleDeclaration() {
    return RuleDeclaration.__super__.constructor.apply(this, arguments);
  }

  RuleDeclaration.prototype.toJSON = function() {
    var json;
    json = RuleDeclaration.__super__.toJSON.apply(this, arguments);
    json.block = this.block;
    return json;
  };

  return RuleDeclaration;

})(Declaration);

module.exports = RuleDeclaration;


},{"../declaration":63}],66:[function(require,module,exports){
var AtRuleDeclaration, RuleDeclaration,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

RuleDeclaration = require('../rule');

AtRuleDeclaration = (function(superClass) {
  extend(AtRuleDeclaration, superClass);

  function AtRuleDeclaration() {
    return AtRuleDeclaration.__super__.constructor.apply(this, arguments);
  }

  AtRuleDeclaration.prototype.toJSON = function() {
    var json;
    json = AtRuleDeclaration.__super__.toJSON.apply(this, arguments);
    json.name = this.name;
    json["arguments"] = this["arguments"];
    return json;
  };

  return AtRuleDeclaration;

})(RuleDeclaration);

module.exports = AtRuleDeclaration;


},{"../rule":65}],67:[function(require,module,exports){
var RuleDeclaration, RuleSetDeclaration,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

RuleDeclaration = require('../rule');

RuleSetDeclaration = (function(superClass) {
  extend(RuleSetDeclaration, superClass);

  function RuleSetDeclaration() {
    return RuleSetDeclaration.__super__.constructor.apply(this, arguments);
  }

  RuleSetDeclaration.prototype.toJSON = function() {
    var json;
    json = RuleSetDeclaration.__super__.toJSON.apply(this, arguments);
    json.selector = this.selector;
    return json;
  };

  return RuleSetDeclaration;

})(RuleDeclaration);

module.exports = RuleSetDeclaration;


},{"../rule":65}],68:[function(require,module,exports){
var Directive, Statement,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Statement = require('../statement');

Directive = (function(superClass) {
  extend(Directive, superClass);

  function Directive() {
    return Directive.__super__.constructor.apply(this, arguments);
  }

  Directive.prototype.toJSON = function() {
    var json;
    json = Directive.__super__.toJSON.apply(this, arguments);
    json.name = this.name;
    return json["arguments"] = this["arguments"];
  };

  return Directive;

})(Statement);

module.exports = Directive;


},{"../statement":61}],69:[function(require,module,exports){
var For, Statement,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Statement = require('../statement');

For = (function(superClass) {
  extend(For, superClass);

  function For() {
    return For.__super__.constructor.apply(this, arguments);
  }

  return For;

})(Statement);

module.exports = For;


},{"../statement":61}],70:[function(require,module,exports){
var Import, Statement,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Statement = require('../statement');

Import = (function(superClass) {
  extend(Import, superClass);

  function Import() {
    return Import.__super__.constructor.apply(this, arguments);
  }

  Import.prototype.toJSON = function() {
    var json;
    return json = Import.__super__.toJSON.apply(this, arguments);
  };

  return Import;

})(Statement);

module.exports = Import;


},{"../statement":61}],71:[function(require,module,exports){
var Loop, Statement,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Statement = require('../statement');

Loop = (function(superClass) {
  extend(Loop, superClass);

  function Loop() {
    return Loop.__super__.constructor.apply(this, arguments);
  }

  Loop.prototype.condition = null;

  Loop.prototype.negate = false;

  Loop.prototype.block = null;

  Loop.prototype.toJSON = function() {
    var json;
    json = Loop.__super__.toJSON.apply(this, arguments);
    json.condition = this.condition;
    json.negate = this.negate;
    json.block = this.block;
    return json;
  };

  Loop.prototype.clone = function() {
    return this;
  };

  return Loop;

})(Statement);

module.exports = Loop;


},{"../statement":61}],72:[function(require,module,exports){
var Class, NotImplementedError, Object, TypeError,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty,
  slice = [].slice;

Class = require('./class');

TypeError = require('./error/type');

NotImplementedError = require('./error/not-implemented');

Object = (function(superClass) {
  extend(Object, superClass);

  function Object() {
    return Object.__super__.constructor.apply(this, arguments);
  }

  Object["new"] = function() {
    var args;
    args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    return new (this.bind.apply(this, args));
  };

  Object.reprType = function() {
    return this.name;
  };

  Object.repr = function() {
    return "[" + (this.reprType()) + "]";
  };

  Object.clone = function() {
    return this;
  };

  Object.prototype.hasMethod = function(name) {
    return typeof this["." + name] === 'function';
  };

  Object.prototype.operate = function() {
    var etc, operator, other, repr;
    operator = arguments[0], other = arguments[1], etc = 3 <= arguments.length ? slice.call(arguments, 2) : [];
    if (this.hasMethod(operator)) {
      return this['.'].apply(this, [operator, other].concat(slice.call(etc)));
    } else {
      repr = other ? (this.repr()) + " " + operator + " " + (other.repr()) : "" + operator + (this.repr());
      throw new TypeError("Cannot perform " + repr + ": " + (this["class"].repr()) + " has no method [." + operator + "]");
    }
  };

  Object.prototype.reprValue = function() {
    return '';
  };

  Object.prototype.reprType = function() {
    return this["class"].reprType();
  };

  Object.prototype.repr = function() {
    return "[" + (((this.reprType()) + " " + (this.reprValue())).trim()) + "]";
  };

  Object.prototype.toString = function() {
    throw new Error("Cannot convert " + (this.repr()) + " to string");
  };

  Object.prototype['.'] = function() {
    var etc, method, name;
    name = arguments[0], etc = 2 <= arguments.length ? slice.call(arguments, 1) : [];
    method = this["." + name];
    if (typeof method === 'function') {
      return method.call.apply(method, [this].concat(slice.call(etc)));
    } else {
      throw new TypeError("Call to undefined method: [" + this.type + "." + name + "]");
    }
  };

  Object.prototype['.='] = function() {
    var etc, name;
    name = arguments[0], etc = 2 <= arguments.length ? slice.call(arguments, 1) : [];
    return this['.'].apply(this, [name + "="].concat(slice.call(etc)));
  };

  Object.prototype['.copy'] = function() {
    return this.clone();
  };

  return Object;

})(Class);

module.exports = Object;


},{"./class":15,"./error/not-implemented":27,"./error/type":31}],73:[function(require,module,exports){
var AtRule, Rule, String,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Rule = require('./rule');

String = require('./string');

AtRule = (function(superClass) {
  extend(AtRule, superClass);

  function AtRule(name) {
    this.name = name;
    AtRule.__super__.constructor.apply(this, arguments);
    this["arguments"] = [];
  }

  AtRule.prototype.clone = function() {
    var that;
    that = AtRule.__super__.clone.apply(this, arguments);
    that.name = this.name;
    that["arguments"] = this["arguments"];
    return that;
  };

  AtRule.prototype['.name'] = function() {
    return new String(this.name);
  };

  return AtRule;

})(Rule);

module.exports = AtRule;


},{"./rule":89,"./string":90}],74:[function(require,module,exports){
var Block, Boolean, Collection, List, Null, Property, String,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty,
  slice = [].slice;

Collection = require('./collection');

List = require('./list');

Property = require('./property');

Boolean = require('./boolean');

String = require('./string');

Null = require('./null');


/*
 */

Block = (function(superClass) {
  extend(Block, superClass);

  function Block() {
    return Block.__super__.constructor.apply(this, arguments);
  }


  /*
   */

  Block.prototype.push = function() {
    var elements;
    elements = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    return Block.__super__.push.apply(this, elements);
  };

  Block.prototype.hasProperty = function(name) {
    return this.items.some(function(item) {
      return (item instanceof Property) && (item.name === name) && (!item.value.isNull());
    });
  };

  Block.prototype['.::'] = function(other) {
    var i, len, node, ref, val;
    if (other instanceof String) {
      val = Null["null"];
      ref = this.items;
      for (i = 0, len = ref.length; i < len; i++) {
        node = ref[i];
        if (node instanceof Property && node.name === other.value) {
          val = node.value;
        }
      }
      return val;
    } else {
      return Block.__super__['.::'].apply(this, arguments);
    }
  };

  Block.prototype['.::='] = function(key, value) {
    var i, len, name, node, prop, ref;
    if (key instanceof String) {
      name = key.value;
      prop = null;
      ref = this.items;
      for (i = 0, len = ref.length; i < len; i++) {
        node = ref[i];
        if (node instanceof Property && node.name === name) {
          prop = node;
        }
      }
      if (prop) {
        prop.value = value;
      } else {
        this.push(new Property(name, value));
      }
      return value;
    } else {
      return Block.__super__['.::='].apply(this, arguments);
    }
  };

  Block.prototype['.properties'] = function() {
    return new Block(this.items.filter(function(obj) {
      return obj instanceof Property;
    }));
  };

  Block.prototype['.has-property?'] = function(name) {
    return Boolean["new"](this.hasProperty(name.value));
  };

  return Block;

})(Collection);

module.exports = Block;


},{"./boolean":75,"./collection":76,"./list":82,"./null":83,"./property":85,"./string":90}],75:[function(require,module,exports){
var Boolean, Object,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Object = require('../object');

Boolean = (function(superClass) {
  extend(Boolean, superClass);

  function Boolean(value1) {
    this.value = value1 != null ? value1 : false;
    this.value = !!this.value;
  }

  Boolean["true"] = new Boolean(true);

  Boolean["false"] = new Boolean(false);

  Boolean["new"] = function(value) {
    if (value == null) {
      value = false;
    }
    return value && this["true"] || this["false"];
  };

  Boolean.prototype.isEqual = function(other) {
    return other instanceof Boolean && this.value === other.value;
  };

  Boolean.prototype.toBoolean = function() {
    return this.value;
  };

  Boolean.prototype.isEmpty = function() {
    return !this.value;
  };

  Boolean.prototype.toString = function() {
    if (this.value) {
      return 'true';
    } else {
      return 'false';
    }
  };

  Boolean.prototype.toJSON = function() {
    var json;
    json = Boolean.__super__.toJSON.apply(this, arguments);
    json.value = this.value;
    return json;
  };

  Boolean.prototype.clone = function() {
    return this;
  };

  return Boolean;

})(Object);

Object.prototype.toBoolean = function() {
  return true;
};

Object.prototype['.is'] = function(other) {
  return Boolean["new"](this.isEqual(other));
};

Object.prototype['.isnt'] = function(other) {
  return Boolean["new"](!this.isEqual(other));
};

Object.prototype['.not@'] = function(other) {
  return Boolean["new"](!this.toBoolean());
};

Object.prototype['.and'] = function(other) {
  if (this.toBoolean()) {
    return other;
  } else {
    return this;
  }
};

Object.prototype['.or'] = function(other) {
  if (this.toBoolean()) {
    return this;
  } else {
    return other;
  }
};

Object.prototype['.>'] = function(other) {
  return Boolean["new"]((this.compare(other)) < 0);
};

Object.prototype['.>='] = function(other) {
  return Boolean["new"]((this.compare(other)) <= 0);
};

Object.prototype['.<'] = function(other) {
  return Boolean["new"]((this.compare(other)) > 0);
};

Object.prototype['.<='] = function(other) {
  return Boolean["new"]((this.compare(other)) >= 0);
};

Object.prototype['.contains?'] = function(other) {
  return Boolean["new"](this.contains(other));
};

Object.prototype['.has'] = function(other) {
  return Boolean["new"](this.contains(other));
};

Object.prototype['.hasnt'] = function(other) {
  return Boolean["new"](!this.contains(other));
};

Object.prototype['.in'] = function(other) {
  return Boolean["new"](other.contains(this));
};

Object.prototype['.enumerable?'] = function() {
  return Boolean["new"](this.isEnumerable());
};

Object.prototype['.boolean'] = function() {
  return Boolean["new"](this.toBoolean());
};

Object.prototype['.true?'] = Object.prototype['.boolean'];

Object.prototype['.false?'] = function() {
  return Boolean["new"](!this.toBoolean());
};

Object.prototype['.empty?'] = function() {
  return Boolean["new"](this.isEmpty());
};

module.exports = Boolean;


},{"../object":72}],76:[function(require,module,exports){
var Boolean, Collection, Indexed, Null, Number, Object, TypeError,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty,
  slice1 = [].slice;

Object = require('../object');

Indexed = require('./indexed');

Boolean = require('./boolean');

Number = require('./number');

Null = require('./null');

TypeError = require('../error/type');

Collection = (function(superClass) {
  extend(Collection, superClass);

  Collection.prototype.length = function() {
    return this.items.length;
  };

  Collection.prototype.getByIndex = function(index) {
    return this.items[index];
  };

  function Collection(items1) {
    this.items = items1 != null ? items1 : [];
    Collection.__super__.constructor.apply(this, arguments);
  }

  Collection.prototype.push = function() {
    var j, len, obj, objs, results;
    objs = 1 <= arguments.length ? slice1.call(arguments, 0) : [];
    results = [];
    for (j = 0, len = objs.length; j < len; j++) {
      obj = objs[j];
      results.push(this.items.push(obj.clone()));
    }
    return results;
  };

  Collection.prototype.slice = function(start, end) {
    if (start == null) {
      start = 0;
    } else if (!(start instanceof Number)) {
      throw new Error("Bad arguments for `.slice`");
      start = start.value;
    }
    if (end != null) {
      if (!(end instanceof Number)) {
        throw new Error("Bad arguments for `.slice`");
      }
      end = end.value;
    } else {
      end = this.items.length;
    }
    return this.items.slice(start, end);
  };

  Collection.prototype.contains = function(other) {
    var j, len, ref, value;
    ref = this.items;
    for (j = 0, len = ref.length; j < len; j++) {
      value = ref[j];
      if (value.isEqual(other)) {
        return true;
      }
    }
    return false;
  };

  Collection.prototype.isUnique = function() {
    var a, b, j, k, len, len1, ref, ref1;
    ref = this.items;
    for (j = 0, len = ref.length; j < len; j++) {
      a = ref[j];
      ref1 = this.items;
      for (k = 0, len1 = ref1.length; k < len1; k++) {
        b = ref1[k];
        if (a !== b && a.isEqual(b)) {
          return false;
        }
      }
    }
    return true;
  };

  Collection.prototype.isEqual = function(other) {
    var i, j, ref;
    if (other instanceof Collection) {
      if (other.items.length === this.items.length) {
        for (i = j = 0, ref = this.items.length; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
          if (!this.items[i].isEqual(other.items[i])) {
            return false;
          }
        }
        return true;
      }
    }
    return false;
  };

  Collection.prototype.toJSON = function() {
    var json;
    json = Collection.__super__.toJSON.apply(this, arguments);
    json.separator = this.separator;
    json.items = this.items;
    return json;
  };

  Collection.prototype.clone = function() {
    var etc, items, obj;
    items = arguments[0], etc = 2 <= arguments.length ? slice1.call(arguments, 1) : [];
    if (items == null) {
      items = this.items;
    }
    return Collection.__super__.clone.apply(this, [(function() {
      var j, len, results;
      results = [];
      for (j = 0, len = items.length; j < len; j++) {
        obj = items[j];
        results.push(obj.clone());
      }
      return results;
    })()].concat(slice1.call(etc)));
  };

  Collection.prototype['.+'] = function(other) {
    if (other instanceof Collection) {
      return this.clone(this.items.concat(other.items));
    }
    throw new TypeError("Cannot sum collection with that");
  };

  Collection.prototype['.<<'] = function(other) {
    this.push(other);
    return this;
  };

  Collection.prototype['.::'] = function(other) {
    var idx, j, len, ref, slice;
    if (other instanceof Number) {
      idx = other.value;
      if (idx < 0) {
        idx += this.items.length;
      }
      if ((0 <= idx && idx < this.items.length)) {
        return this.items[idx];
      } else {
        return Null["null"];
      }
    } else if (other instanceof Collection) {
      slice = this.clone([]);
      ref = other.items;
      for (j = 0, len = ref.length; j < len; j++) {
        idx = ref[j];
        slice.items.push(this['.::'](idx));
      }
      return slice;
    } else {
      throw new TypeError("Bad member: " + other.type);
    }
  };

  Collection.prototype['.::='] = function(key, value) {
    var idx;
    if (key instanceof Number) {
      idx = key.value;
      if (idx < 0) {
        idx += this.items.length;
      }
      if ((0 <= idx && idx <= this.items.length)) {
        return this.items[idx] = value;
      } else {
        throw new TypeError;
      }
    } else {
      throw new TypeError;
    }
  };

  Collection.prototype['.length'] = function() {
    return new Number(this.length());
  };

  Collection.prototype['.push'] = function() {
    var args;
    args = 1 <= arguments.length ? slice1.call(arguments, 0) : [];
    this.push.apply(this, args);
    return this;
  };

  Collection.prototype['.pop'] = function() {
    return this.items.pop() || Null["null"];
  };

  Collection.prototype['.shift'] = function() {
    return this.items.shift() || Null["null"];
  };

  Collection.prototype['.unshift'] = function() {
    var obj, objs, ref;
    objs = 1 <= arguments.length ? slice1.call(arguments, 0) : [];
    (ref = this.items).unshift.apply(ref, (function() {
      var j, len, results;
      results = [];
      for (j = 0, len = objs.length; j < len; j++) {
        obj = objs[j];
        results.push(obj.clone());
      }
      return results;
    })());
    return this;
  };

  Collection.prototype['.slice'] = function(start, end) {
    return this.clone(this.slice(start, end));
  };

  Collection.prototype['.empty'] = function() {
    this.items = [];
    return this;
  };

  Collection.prototype['.first'] = function() {
    return this.items[0] || Null["null"];
  };

  Collection.prototype['.last'] = function() {
    return this.items[this.items.length - 1] || Null["null"];
  };

  Collection.prototype['.unique?'] = function() {
    return Boolean["new"](this.isUnique());
  };

  Collection.prototype['.unique'] = function() {
    var unique;
    unique = [];
    this.items.filter(function(item) {
      var j, len, val;
      for (j = 0, len = unique.length; j < len; j++) {
        val = unique[j];
        if (val.isEqual(item)) {
          return false;
        }
      }
      unique.push(item);
      return true;
    });
    return this.clone(unique, this.separator);
  };

  return Collection;

})(Indexed);

Object.prototype['.>>'] = function(other) {
  return other['.<<'](this);
};

module.exports = Collection;


},{"../error/type":31,"../object":72,"./boolean":75,"./indexed":81,"./null":83,"./number":84}],77:[function(require,module,exports){
var Boolean, Color, Null, Number, Object, String, TypeError, ValueError,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty,
  slice = [].slice;

Object = require('../object');

Null = require('./null');

Boolean = require('./boolean');

Number = require('./number');

String = require('./string');

TypeError = require('../error/type');

ValueError = require('../error/value');

Color = (function(superClass) {
  var BLACK, BLACKNESS, BLEND_METHODS, BLUE, CONVERTORS, CYAN, GREEN, HUE, LIGHTNESS, MAGENTA, RED, RE_FUNC_COLOR, RE_HEX_COLOR, SATURATION, SPACES, WHITENESS, YELLOW, abs, max, min, pow, round, sqrt;

  extend(Color, superClass);

  round = Math.round, max = Math.max, min = Math.min, abs = Math.abs, sqrt = Math.sqrt, pow = Math.pow;

  RED = {
    name: 'red',
    max: 255,
    unit: null
  };

  GREEN = {
    name: 'green',
    max: 255,
    unit: null
  };

  BLUE = {
    name: 'blue',
    max: 255,
    unit: null
  };

  HUE = {
    name: 'hue',
    max: 360,
    unit: 'deg'
  };

  SATURATION = {
    name: 'saturation',
    max: 100,
    unit: '%'
  };

  LIGHTNESS = {
    name: 'lightness',
    max: 100,
    unit: '%'
  };

  WHITENESS = {
    name: 'whiteness',
    max: 100,
    unit: '%'
  };

  BLACKNESS = {
    name: 'blackness',
    max: 100,
    unit: '%'
  };

  CYAN = {
    name: 'cyan',
    max: 100,
    unit: '%'
  };

  MAGENTA = {
    name: 'magenta',
    max: 100,
    unit: '%'
  };

  YELLOW = {
    name: 'yellow',
    max: 100,
    unit: '%'
  };

  BLACK = {
    name: 'black',
    max: 100,
    unit: '%'
  };

  SPACES = {
    rgb: [RED, GREEN, BLUE],
    hsl: [HUE, SATURATION, LIGHTNESS],
    hwb: [HUE, WHITENESS, BLACKNESS],
    cmyk: [CYAN, MAGENTA, YELLOW, BLACK]
  };

  RE_HEX_COLOR = /#([\da-f]+)/i;

  RE_FUNC_COLOR = /([a-z_-][a-z\d_-]*)\s*\((.*)\)/i;

  CONVERTORS = {

    /*
    http://git.io/ot_KMg
    http://stackoverflow.com/questions/2353211/
     */
    rgb2hsl: function(rgb) {
      var M, b, d, g, h, l, m, r, s;
      r = rgb[0] / 255;
      g = rgb[1] / 255;
      b = rgb[2] / 255;
      M = max(r, g, b);
      m = min(r, g, b);
      l = (M + m) / 2;
      if (m === M) {
        h = s = 0;
      } else {
        d = M - m;
        s = l > .5 ? d / (2 - M - m) : d / (M + m);
        h = ((function() {
          switch (M) {
            case r:
              return (g - b) / d + (g < b ? 6 : 0);
            case g:
              return (b - r) / d + 2;
            case b:
              return (r - g) / d + 4;
          }
        })()) / 6;
      }
      return [h * 360, s * 100, l * 100];
    },

    /*
    https://git.io/vVWUt
     */
    rgb2hwb: function(rgb) {
      var b, h, w;
      h = (this.rgb2hsl(rgb))[0];
      w = min.apply(null, rgb);
      b = 255 - (max.apply(null, rgb));
      return [h, 100 * w / 255, 100 * b / 255];
    },

    /*
    https://drafts.csswg.org/css-color/#cmyk-rgb
     */
    rgb2cmyk: function(rgb) {
      var b, c, g, k, m, r, w, y;
      r = rgb[0] / 255;
      g = rgb[1] / 255;
      b = rgb[2] / 255;
      k = 1 - max(r, g, b);
      if (k === 1) {
        c = m = y = 0;
      } else {
        w = 1 - k;
        c = (1 - r - k) / w;
        m = (1 - g - k) / w;
        y = (1 - b - k) / w;
      }
      return [c * 100, m * 100, y * 100, k * 100];
    },

    /*
     */
    hsl2rgb: function(hsl) {
      var b, g, h, h2rgb, l, p, q, r, s;
      s = hsl[1] / 100;
      l = hsl[2] / 100;
      if (s === 0) {
        r = g = b = l;
      } else {
        h = hsl[0] / 360;
        q = l <= .5 ? l * (1 + s) : l + s - l * s;
        p = 2 * l - q;
        h2rgb = function(t) {
          if (t < 0) {
            t++;
          } else if (t > 1) {
            t--;
          }
          if (t * 6 < 1) {
            return p + (q - p) * 6 * t;
          } else if (t * 2 < 1) {
            return q;
          } else if (t * 3 < 2) {
            return p + (q - p) * (2 / 3 - t) * 6;
          } else {
            return p;
          }
        };
        r = h2rgb(h + 1 / 3);
        g = h2rgb(h);
        b = h2rgb(h - 1 / 3);
      }
      return [r * 255, g * 255, b * 255];
    },

    /*
    https://drafts.csswg.org/css-color/#cmyk-rgb
     */
    cmyk2rgb: function(cmyk) {
      var b, c, g, k, m, r, w, y;
      c = cmyk[0] / 100;
      m = cmyk[1] / 100;
      y = cmyk[2] / 100;
      k = cmyk[3] / 100;
      w = 1 - k;
      r = 1 - min(1, c * w + k);
      g = 1 - min(1, m * w + k);
      b = 1 - min(1, y * w + k);
      return [r * 255, g * 255, b * 255];
    },

    /*
    https://drafts.csswg.org/css-color/#hwb-to-rgb
     */
    hwb2rgb: function(hwb) {
      var b, h, i, j, r, rgb, w;
      h = hwb[0], w = hwb[1], b = hwb[2];
      r = w / 100 + b / 100;
      if (r > 1) {
        w /= r;
        b /= r;
      }
      rgb = this.hsl2rgb([h, 100, 50]);
      for (i = j = 0; j <= 2; i = ++j) {
        rgb[i] *= 1 - w / 100 - b / 100;
        rgb[i] += 255 * w / 100;
      }
      return rgb;
    }
  };

  BLEND_METHODS = {

    /*
    The no-blending mode. This simply selects the source color.
     */
    'normal': function(source, backdrop) {
      return source;
    },

    /*
    The source color is multiplied by the backdrop.
    
    The result color is always at least as dark as either the source or backdrop
    color. Multiplying any color with black produces black. Multiplying any color
    with white leaves the color unchanged.
     */
    'multiply': function(source, backdrop) {
      return source * backdrop;
    },

    /*
    Multiplies the complements of the backdrop and source color values, then
    complements the result.
    
    The result color is always at least as light as either of the two constituent
    colors. Screening any color with white produces white; screening with black
    leaves the original color unchanged. The effect is similar to projecting
    multiple photographic slides simultaneously onto a single screen.
     */
    'screen': function(source, backdrop) {
      return backdrop + source - backdrop * source;
    },

    /*
    Multiplies or screens the colors, depending on the backdrop color value.
    Source colors overlay the backdrop while preserving its highlights and
    shadows. The backdrop color is not replaced but is mixed with the source
    color to reflect the lightness or darkness of the backdrop.
    
    Overlay is the inverse of the `hard-light` blend mode.
     */
    'overlay': function(source, backdrop) {
      return this['hard-light'](backdrop, source);
    },

    /*
    Multiplies or screens the colors, depending on the source color value. The
    effect is similar to shining a harsh spotlight on the backdrop.
     */
    'hard-light': function(source, backdrop) {
      if (source <= .5) {
        return this.multiply(backdrop, 2 * source);
      } else {
        return this.screen(backdrop, 2 * source - 1);
      }
    },

    /*
    Darkens or lightens the colors, depending on the source color value. The
    effect is similar to shining a diffused spotlight on the backdrop
     */
    'soft-light': function(source, backdrop) {
      var d;
      if (source <= .5) {
        return backdrop - (1 - 2 * source) * backdrop * (1 - backdrop);
      } else {
        if (backdrop <= .25) {
          d = ((16 * backdrop - 12) * backdrop + 4) * backdrop;
        } else {
          d = sqrt(backdrop);
        }
        return backdrop + (2 * source - 1) * (d - backdrop);
      }
    },

    /*
    Selects the darker of the backdrop and source colors.
    
    The backdrop is replaced with the source where the source is darker;
    otherwise, it is left unchanged.
     */
    'darken': function(source, backdrop) {
      return min(source, backdrop);
    },

    /*
    Selects the lighter of the backdrop and source colors.
    
    The backdrop is replaced with the source where the source is lighter;
    otherwise, it is left unchanged.
     */
    'lighten': function(source, backdrop) {
      return max(backdrop, source);
    },

    /*
    Subtracts the darker of the two constituent colors from the lighter color.
    
    Painting with white inverts the backdrop color; painting with black produces
    no change.
     */
    'difference': function(source, backdrop) {
      return abs(backdrop - source);
    },

    /*
    Produces an effect similar to that of the `difference` mode but lower in
    contrast. Painting with white inverts the backdrop color; painting with black
    produces no change.
     */
    'exclusion': function(source, backdrop) {
      return source + backdrop - 2 * source * backdrop;
    }
  };

  Color.blend = function(source, backdrop, mode) {
    var alpha, blent, brgb, i, srgb, that;
    if (mode == null) {
      mode = 'normal';
    }
    if (mode in BLEND_METHODS) {
      srgb = source.rgb.map(function(ch) {
        return ch / 255;
      });
      brgb = backdrop.rgb.map(function(ch) {
        return ch / 255;
      });
      blent = (function() {
        var results;
        results = [];
        for (i in srgb) {
          results.push(BLEND_METHODS[mode](srgb[i], brgb[i]));
        }
        return results;
      })();
      blent = blent.map(function(ch, i) {
        ch = (1 - backdrop.alpha) * (source.rgb[i] / 255) + backdrop.alpha * ch;
        ch = source.alpha * ch + (1 - source.alpha) * backdrop.alpha * (backdrop.rgb[i] / 255);
        return ch *= 255;
      });
      alpha = source.alpha + backdrop.alpha * (1 - source.alpha);
      that = source.clone();
      that.rgb = blent;
      that.alpha = alpha;
      return that;
    } else {
      throw new ValueError("Bad mode for Color.blend: " + mode);
    }
  };

  Color.prototype.parseHexString = function(str) {
    var blue, green, l, m, red;
    if (m = str.match(RE_HEX_COLOR)) {
      str = m[1];
      l = str.length;
      switch (l) {
        case 1:
          red = green = blue = 17 * parseInt(str, 16);
          break;
        case 2:
          red = green = blue = parseInt(str, 16);
          break;
        case 3:
        case 4:
          red = 17 * parseInt(str[0], 16);
          green = 17 * parseInt(str[1], 16);
          blue = 17 * parseInt(str[2], 16);
          if (l > 3) {
            this.alpha = (17 * parseInt(str[3], 16)) / 255;
          }
          break;
        case 6:
        case 8:
          red = parseInt(str.slice(0, 2), 16);
          green = parseInt(str.slice(2, 4), 16);
          blue = parseInt(str.slice(4, 6), 16);
          if (l > 6) {
            this.alpha = (parseInt(str.slice(6, 8), 16)) / 255;
          }
          break;
        default:
          throw new Error("Bad hex color: " + str);
      }
      this.space = 'rgb';
      return this.spaces['rgb'] = [red, green, blue];
    }
  };

  Color.prototype.parseFuncString = function(str) {
    var args, channel, channels, j, len, m, ref, space;
    if (m = str.match(RE_FUNC_COLOR)) {
      space = m[1].toLowerCase();
      if (space.slice(-1) === 'a') {
        space = space.slice(0, -1);
      }
      args = m[2].toLowerCase().split(/(?:\s*,\s*)+/);
      if (space in SPACES) {
        channels = [];
        ref = SPACES[space];
        for (j = 0, len = ref.length; j < len; j++) {
          channel = ref[j];
          channels.push(parseFloat(args.shift()));
        }
        if (args.length) {
          this.alpha = parseFloat(args.shift());
        }
        if (args.length) {
          throw new Error("Too many values passed to `" + space + "()`");
        }
        this.space = space;
        return this.spaces[space] = channels;
      } else {
        throw new Error("Bad color space: " + space);
      }
    }
  };

  function Color(color) {
    if (color == null) {
      color = '#0000';
    }
    this.spaces = {};
    this.alpha = 1;
    this.parseHexString(color) || this.parseFuncString(color) || (function() {
      throw new Error("Bad color string: " + color);
    })();
  }

  (function() {
    var channel, index, make_channel_accessors, make_space_accessors, results, space;
    make_space_accessors = function(space) {
      return Color.property(space, {
        get: function() {
          var convertor, other;
          if (!this.spaces[space]) {
            convertor = null;
            if (this.space !== space) {
              if ((convertor = this.space + "2" + space) in CONVERTORS) {
                other = this.space;
              }
            }
            if (!convertor) {
              for (other in this.spaces) {
                if (other !== space && other !== this.space) {
                  if ((convertor = this.space + "2" + space) in CONVERTORS) {
                    break;
                  }
                }
              }
            }
            if (!convertor) {
              throw new Error("No convertor to " + space + " :(");
            }
            this.spaces[space] = CONVERTORS[convertor](this.spaces[other]);
          }
          return this.spaces[space];
        },
        set: function(values) {
          this.space = space;
          this.spaces = {};
          return this.spaces[space] = values;
        }
      });
    };
    make_channel_accessors = function(space, index, name) {
      if (!(name in Color.prototype)) {
        return Color.property(name, {
          get: function() {
            return this[space][index];
          },
          set: function(value) {
            space = this[space];
            space[index] = value;
            return this[space] = space;
          }
        });
      }
    };
    results = [];
    for (space in SPACES) {
      make_space_accessors(space);
      results.push((function() {
        var j, len, ref, results1;
        ref = SPACES[space];
        results1 = [];
        for (index = j = 0, len = ref.length; j < len; index = ++j) {
          channel = ref[index];
          results1.push(make_channel_accessors(space, index, channel.name));
        }
        return results1;
      })());
    }
    return results;
  })();

  Color.prototype.getChannel = function(space, channel) {
    return this[space][channel];
  };

  Color.prototype.clampChannel = function(space, channel, value) {
    if (SPACES[space][channel].unit === 'deg') {
      value %= SPACES[space][channel].max;
      if (value < 0) {
        value += SPACES[space][channel].max;
      }
    } else {
      value = min(value, SPACES[space][channel].max);
      value = max(value, 0);
    }
    return value;
  };

  Color.prototype.setChannel = function(space, channel, value) {
    var channels;
    channels = this[space];
    channels[channel] = this.clampChannel(space, channel, value);
    return this[space] = channels;
  };

  Color.prototype.adjustChannel = function(space, channel, amount, unit) {
    if (unit === '%') {
      amount = SPACES[space][channel].max * amount / 100;
    } else if (unit && unit !== SPACES[space][channel].unit) {
      throw new Error("Bad value for " + space + " " + channel + ": " + amount + unit);
    }
    this.setChannel(space, channel, amount + this.getChannel(space, channel));
    return this;
  };

  Color.property('luminance', {
    get: function() {
      var b, g, r, ref;
      ref = [this.red, this.green, this.blue].map(function(channel, i) {
        channel /= 255;
        if (channel <= .03928) {
          return channel / 12.92;
        } else {
          return pow((channel + .055) / 1.055, 2.4);
        }
      }), r = ref[0], g = ref[1], b = ref[2];
      return .2126 * r + .7152 * g + .0722 * b;
    }
  });

  Color.prototype.blend = function(backdrop, mode) {
    return this["class"].blend(this, backdrop, mode);
  };

  Color.prototype.isEqual = function(other) {
    var channel;
    if (other instanceof Color) {
      for (channel in this.spaces[this.space]) {
        if (this.spaces[this.space][channel] !== other[this.space][channel]) {
          return false;
        }
      }
      return this.alpha === other.alpha;
    }
    return false;
  };

  Color.prototype.isEmpty = function() {
    return this.alpha === 0;
  };

  Color.prototype.toRGBAString = function() {
    var comps;
    comps = this['rgb'].map(function(c) {
      return round(c);
    });
    if (this.alpha < 1) {
      comps.push((round(this.alpha * 100)) / 100);
    }
    return "rgba(" + (comps.join(', ')) + ')';
  };

  Color.prototype.toHexString = function() {
    var c, comps, hex, j, len;
    comps = [].concat(this['rgb']);
    if (this.alpha < 1) {
      comps.push(this.alpha * 255);
    }
    hex = '#';
    for (j = 0, len = comps.length; j < len; j++) {
      c = comps[j];
      c = (round(c)).toString(16);
      if (c.length < 2) {
        hex += '0';
      }
      hex += c;
    }
    return hex;
  };

  Color.prototype.toString = function() {
    if (this.alpha < 1) {
      return this.toRGBAString();
    } else {
      return this.toHexString();
    }
  };

  Color.prototype.clone = function() {
    var color, etc;
    color = arguments[0], etc = 2 <= arguments.length ? slice.call(arguments, 1) : [];
    if (color == null) {
      color = this.toString();
    }
    return Color.__super__.clone.apply(this, [color].concat(slice.call(etc)));
  };

  Color.prototype['.transparent?'] = function() {
    return Boolean["new"](this.isEmpty());
  };

  Color.prototype['.transparent'] = function() {
    var that;
    that = this.clone();
    that.alpha = 0;
    return that;
  };

  Color.prototype['.opaque?'] = function() {
    return Boolean["new"](this.alpha === 1);
  };

  Color.prototype['.opaque'] = function() {
    var that;
    that = this.clone();
    that.alpha = 1;
    return that;
  };

  Color.prototype['.saturate'] = function(amount) {
    if (amount instanceof Number) {
      return this.clone().adjustChannel('hsl', 1, amount.value, amount.unit);
    } else {
      throw new TypeError("Bad argument for " + (this.reprType()) + ".saturate");
    }
  };

  Color.prototype['.desaturate'] = function(amount) {
    if (amount == null) {
      amount = Number.ONE_HUNDRED_PERCENT;
    }
    if (amount instanceof Number) {
      return this.clone().adjustChannel('hsl', 1, -1 * amount.value, amount.unit);
    } else {
      throw new TypeError("Bad argument for " + (this.reprType()) + ".saturate");
    }
  };

  Color.prototype['.grey'] = function() {
    return this['.desaturate']();
  };

  Color.prototype['.whiten'] = function(amount) {
    if (amount == null) {
      amount = Number.FIFTY_PERCENT;
    }
    if (amount instanceof Number) {
      return this.clone().adjustChannel('hwb', 1, amount.value, amount.unit);
    } else {
      throw new TypeError("Bad argument for " + (this.reprType()) + ".whiten");
    }
  };

  Color.prototype['.blacken'] = function(amount) {
    if (amount == null) {
      amount = Number.FIFTY_PERCENT;
    }
    if (amount instanceof Number) {
      return this.clone().adjustChannel('hwb', 2, amount.value, amount.unit);
    } else {
      throw new TypeError("Bad argument for " + (this.reprType()) + ".blacken");
    }
  };

  Color.prototype['.darken'] = function(amount) {
    if (amount == null) {
      amount = Number.TEN_PERCENT;
    }
    if (amount instanceof Number) {
      return this.clone().adjustChannel('hsl', 2, -1 * amount.value, amount.unit);
    } else {
      throw new TypeError("Bad argument for " + (this.reprType()) + ".darken");
    }
  };

  Color.prototype['.lighten'] = function(amount) {
    if (amount == null) {
      amount = Number.TEN_PERCENT;
    }
    if (amount instanceof Number) {
      return this.clone().adjustChannel('hsl', 2, amount.value, amount.unit);
    } else {
      throw new TypeError("Bad argument for " + (this.reprType()) + ".lighten");
    }
  };

  Color.prototype['.light?'] = function() {
    return Boolean["new"](this.lightness >= 50);
  };

  Color.prototype['.dark?'] = function() {
    return Boolean["new"](this.lightness < 50);
  };

  Color.prototype['.gray'] = Color.prototype['.grey'];

  Color.prototype['.grey?'] = function() {
    return Boolean["new"](this.red === this.blue && this.blue === this.green);
  };

  Color.prototype['.gray?'] = Color.prototype['.grey?'];

  Color.prototype['.rotate'] = function(amount) {
    if (amount instanceof Number) {
      amount = amount.convert('deg');
      return this.clone().adjustChannel('hsl', 0, amount.value, amount.unit);
    } else {
      throw new TypeError("Bad argument for " + (this.reprType()) + ".rotate");
    }
  };

  Color.prototype['.spin'] = Color.prototype['.rotate'];

  Color.prototype['.opposite'] = function() {
    return this.clone().adjustChannel('hsl', 0, 180);
  };

  Color.prototype['.luminance'] = function() {
    return new Number(100 * this.luminance, '%');
  };

  Color.prototype['.luminance?'] = function() {
    return Boolean["new"](this.luminance > 0);
  };

  Color.prototype['.invert'] = function() {
    var channel, that;
    that = this.clone();
    that.rgb = (function() {
      var j, len, ref, results;
      ref = that.rgb;
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        channel = ref[j];
        results.push(255 - channel);
      }
      return results;
    })();
    return that;
  };

  Color.prototype['.tint'] = function(amount) {
    var white;
    if (amount == null) {
      amount = Number.FIFTY_PERCENT;
    }
    white = new Color('#fff');
    white.alpha = amount.value / 100;
    return white.blend(this);
  };

  Color.prototype['.shade'] = function(amount) {
    var black;
    if (amount == null) {
      amount = Number.FIFTY_PERCENT;
    }
    black = new Color('#000');
    black.alpha = amount.value / 100;
    return black.blend(this);
  };

  Color.prototype['.contrast'] = function(another) {};

  Color.prototype['.blend'] = function(backdrop, mode) {
    if (mode == null) {
      mode = null;
    }
    if (mode !== null) {
      if (mode instanceof String) {
        mode = mode.value;
      } else {
        throw new TypeError("Bad `mode` argument for [" + (this.reprType()) + ".blend]");
      }
    }
    if (!(backdrop instanceof Color)) {
      throw new TypeError("Bad `mode` argument for [" + (this.reprType()) + ".blend]");
    }
    return this.blend(backdrop, mode);
  };

  Color.prototype['.safe?'] = function() {
    var channel, j, len, ref;
    if (this.alpha < 1) {
      return Boolean["false"];
    }
    ref = this.rgb;
    for (j = 0, len = ref.length; j < len; j++) {
      channel = ref[j];
      if (channel % 51) {
        return Boolean["false"];
      }
    }
    return Boolean["true"];
  };

  Color.prototype['.safe'] = function() {
    var safe;
    if (this.alpha < 1) {
      throw new Error("Cannot make safe a non-opaque color");
    }
    safe = this.clone();
    safe.rgb = safe.rgb.map(function(channel) {
      return 51 * (round(channel / 51));
    });
    return safe;
  };

  Color.prototype['.alpha'] = function() {
    return new Number(this.alpha);
  };

  Color.prototype['.alpha='] = function(value) {
    if (value instanceof Number) {
      if (value.unit === '%') {
        value = value.value / 100;
      } else if (value.isPure()) {
        value = value.value;
      } else {
        throw new Error("Bad alpha value: " + value);
      }
      value = min(1, max(value, 0));
      return this.alpha = value;
    } else {
      throw new Error("Bad alpha value: " + value);
    }
  };

  (function() {
    var channel, index, make_accessors, results, space;
    make_accessors = function(space, index, channel) {
      var base, base1, name, name1, name2;
      name = channel.name;
      if ((base = Color.prototype)[name1 = "." + name] == null) {
        base[name1] = function() {
          return new Number(this[space][index], channel.unit);
        };
      }
      return (base1 = Color.prototype)[name2 = "." + name + "="] != null ? base1[name2] : base1[name2] = function(value) {
        var channels;
        if (value instanceof Number) {
          if (value.unit === '%') {
            value = channel.max * value.value / 100;
          } else {
            if (channel.unit && !value.isPure()) {
              value = value.convert(channel.unit);
            }
            value = this.clampChannel(space, index, value.value);
          }
          channels = this[space];
          channels[index] = value;
          return this[space] = channels;
        } else {
          throw new Error("Bad " + name + " channel value: " + (value.repr()));
        }
      };
    };
    results = [];
    for (space in SPACES) {
      results.push((function() {
        var j, len, ref, results1;
        ref = SPACES[space];
        results1 = [];
        for (index = j = 0, len = ref.length; j < len; index = ++j) {
          channel = ref[index];
          results1.push(make_accessors(space, index, channel));
        }
        return results1;
      })());
    }
    return results;
  })();

  return Color;

})(Object);

module.exports = Color;


},{"../error/type":31,"../error/value":32,"../object":72,"./boolean":75,"./null":83,"./number":84,"./string":90}],78:[function(require,module,exports){
var Block, Document,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Block = require('./block');


/*
TODO Maybe this should not extend Block or Node, so we can make Object
extend Class instead of being a Node (the parser only uses *this* Object
subclass).
 */

Document = (function(superClass) {
  extend(Document, superClass);

  function Document() {
    return Document.__super__.constructor.apply(this, arguments);
  }

  Document.prototype.toJSON = function() {
    var json;
    json = Document.__super__.toJSON.apply(this, arguments);
    json.body = this.body;
    return json;
  };

  return Document;

})(Block);

module.exports = Document;


},{"./block":74}],79:[function(require,module,exports){
var Enumerable, Null, Number, Object,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Object = require('../object');

Null = require('./null');

Number = require('./number');

Enumerable = (function(superClass) {
  extend(Enumerable, superClass);

  function Enumerable() {
    return Enumerable.__super__.constructor.apply(this, arguments);
  }

  Enumerable.prototype.length = function() {
    return this.NOT_IMPLEMENTED;
  };

  Enumerable.prototype.get = function(key) {
    return this.NOT_IMPLEMENTED;
  };

  Enumerable.prototype.reset = function() {
    return this.NOT_IMPLEMENTED;
  };

  Enumerable.prototype.next = function() {
    return this.NOT_IMPLEMENTED;
  };

  Enumerable.prototype.currentValue = function() {
    return this.get(this.currentKey());
  };

  Enumerable.prototype.currentKey = function() {
    return this.NOT_IMPLEMENTED;
  };

  Enumerable.prototype.firstKey = function() {
    return this.NOT_IMPLEMENTED;
  };

  Enumerable.prototype.lastKey = function() {
    return this.NOT_IMPLEMENTED;
  };

  Enumerable.prototype.randomKey = function() {
    return this.NOT_IMPLEMENTED;
  };

  Enumerable.prototype.each = function() {
    return this.NOT_IMPLEMENTED;
  };

  Enumerable.prototype.firstValue = function() {
    return this.get(this.firstKey());
  };

  Enumerable.prototype.lastValue = function() {
    return this.get(this.lastKey());
  };

  Enumerable.prototype.randomValue = function() {
    return this.get(this.randomKey());
  };

  Enumerable.prototype.minValue = function() {
    var min;
    min = null;
    this.each(function(i, item) {
      if (min === null || (item.compare(min)) === 1) {
        return min = item;
      }
    });
    return min;
  };

  Enumerable.prototype.maxValue = function() {
    var max;
    max = null;
    this.each(function(i, item) {
      if (max === null || (item.compare(max)) === -1) {
        return max = item;
      }
    });
    return max;
  };

  Enumerable.prototype.isEmpty = function() {
    return this.length() === 0;
  };

  Enumerable.prototype['.::'] = Enumerable.prototype.get;

  Enumerable.prototype['.length'] = function() {
    return new Number(this.length());
  };

  Enumerable.prototype['.first'] = function() {
    return this.firstValue() || Null["null"];
  };

  Enumerable.prototype['.last'] = function() {
    return this.lastValue() || Null["null"];
  };

  Enumerable.prototype['.random'] = function() {
    return this.randomValue() || Null["null"];
  };

  Enumerable.prototype['.min'] = function() {
    return this.minValue() || Null["null"];
  };

  Enumerable.prototype['.max'] = function() {
    return this.maxValue() || Null["null"];
  };

  return Enumerable;

})(Object);

module.exports = Enumerable;


},{"../object":72,"./null":83,"./number":84}],80:[function(require,module,exports){
var Function, Null, Object,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty,
  slice = [].slice;

Object = require('../object');

Null = require('./null');

Function = (function(superClass) {
  extend(Function, superClass);

  function Function(func1) {
    this.func = func1 != null ? func1 : function() {};
  }

  Function.prototype.invoke = function() {
    var args, block, ref;
    block = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
    return ((ref = this.func).call.apply(ref, [this, block].concat(slice.call(args)))) || Null["null"];
  };

  Function.prototype.toString = function() {
    return 'function';
  };

  Function.prototype.isEqual = function(other) {
    return (other instanceof Function) && (other.func === this.func) && (other.block === this.block);
  };

  Function.prototype.clone = function() {
    var etc, func;
    func = arguments[0], etc = 2 <= arguments.length ? slice.call(arguments, 1) : [];
    if (func == null) {
      func = this.func;
    }
    return Function.__super__.clone.apply(this, [func].concat(slice.call(etc)));
  };

  Function.prototype['.invoke'] = function() {
    var args;
    args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    return this.invoke.apply(this, [this.block].concat(slice.call(args)));
  };

  return Function;

})(Object);

module.exports = Function;


},{"../object":72,"./null":83}],81:[function(require,module,exports){
var Enumerable, Indexed, Null, Number,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Enumerable = require('./enumerable');

Null = require('./null');

Number = require('./number');

Indexed = (function(superClass) {
  extend(Indexed, superClass);

  function Indexed() {
    return Indexed.__super__.constructor.apply(this, arguments);
  }

  Indexed.prototype.reset = function() {
    return this.index = 0;
  };

  Indexed.prototype.firstKey = function() {
    if (this.length()) {
      return 0;
    } else {
      return null;
    }
  };

  Indexed.prototype.lastKey = function() {
    var length;
    if (0 < (length = this.length())) {
      return length - 1;
    } else {
      return null;
    }
  };

  Indexed.prototype.currentKey = function() {
    var ref;
    if ((0 <= (ref = this.index) && ref < this.length())) {
      return this.index;
    } else {
      return null;
    }
  };

  Indexed.prototype.randomKey = function() {
    var length;
    length = this.length();
    if (length > 0) {
      return Math.floor(Math.random() * length);
    } else {
      return null;
    }
  };

  Indexed.prototype.next = function() {
    var ref;
    if ((0 <= (ref = this.index) && ref <= this.length())) {
      return this.index++;
    }
  };

  Indexed.prototype.getByIndex = Indexed.NOT_IMPLEMENTED;

  Indexed.prototype.get = function(key) {
    if (('number' === typeof (key + 0)) && ((0 <= key && key < this.length()))) {
      return this.getByIndex(key);
    } else {
      return null;
    }
  };

  Indexed.prototype.each = function(cb) {
    var index, key, value;
    this.reset();
    while (null !== (key = this.currentKey())) {
      index = new Number(key);
      value = (this.get(key)) || Null["null"];
      if (false === cb.call(this, index, value)) {
        return false;
      }
      this.next();
    }
  };

  Indexed.prototype['.index'] = function() {
    return Null.ifNull(this.currentKey());
  };

  Indexed.prototype['.first-index'] = function() {
    return Null.ifNull(this.firstKey());
  };

  Indexed.prototype['.last-index'] = function() {
    return Null.ifNull(this.lastKey());
  };

  Indexed.prototype['.::'] = function(other) {
    var idx, len;
    if (other instanceof Number) {
      len = this.length();
      idx = other.value;
      if (idx < 0) {
        idx += len;
      }
      return (this.get(idx)) || Null["null"];
    } else {
      throw new TypeError;
    }
  };

  return Indexed;

})(Enumerable);

module.exports = Indexed;


},{"./enumerable":79,"./null":83,"./number":84}],82:[function(require,module,exports){
var Boolean, Collection, List, Number, Object, String,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty,
  slice = [].slice;

Collection = require('./collection');

Object = require('../object');

Boolean = require('./boolean');

String = require('./string');

Number = require('./number');

List = (function(superClass) {
  extend(List, superClass);

  function List(items, separator1) {
    this.separator = separator1 != null ? separator1 : ' ';
    List.__super__.constructor.call(this, items);
  }

  List.prototype.flatten = function() {
    var flat, i, item, len, ref;
    flat = [];
    ref = this.items;
    for (i = 0, len = ref.length; i < len; i++) {
      item = ref[i];
      if (item instanceof List) {
        flat.push.apply(flat, item.flatten());
      } else {
        flat.push(item);
      }
    }
    return flat;
  };

  List.prototype.clone = function() {
    var etc, items, separator;
    items = arguments[0], separator = arguments[1], etc = 3 <= arguments.length ? slice.call(arguments, 2) : [];
    if (separator == null) {
      separator = this.separator;
    }
    return List.__super__.clone.apply(this, [items, separator].concat(slice.call(etc)));
  };

  List.prototype.toJSON = function() {
    var json;
    json = List.__super__.toJSON.apply(this, arguments);
    json.separator = this.separator;
    return json;
  };

  List.prototype['.commas'] = function() {
    return this.clone(null, ',');
  };

  List.prototype['.spaces'] = function() {
    return this.clone(null, ' ');
  };

  List.prototype['.list'] = function() {
    return this;
  };

  List.prototype['.flatten'] = function() {
    return this.clone(this.flatten());
  };

  return List;

})(Collection);

Object.prototype['.list'] = function() {
  if (this instanceof Collection) {
    return new List(this.items);
  } else {
    return new List([this]);
  }
};

module.exports = List;


},{"../object":72,"./boolean":75,"./collection":76,"./number":84,"./string":90}],83:[function(require,module,exports){
var Boolean, Null, Object,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Object = require('../object');

Boolean = require('./boolean');

Null = (function(superClass) {
  extend(Null, superClass);

  function Null() {
    return Null.__super__.constructor.apply(this, arguments);
  }

  Null["null"] = new Null;

  Null["new"] = function() {
    return this["null"];
  };

  Null.prototype.toString = function() {
    return '';
  };

  Null.prototype.ifNull = function(value) {
    if ((value === null) || (value instanceof Null)) {
      return Null["null"];
    } else {
      return value;
    }
  };

  Null.prototype.isEqual = function(other) {
    return other.isNull();
  };

  Null.prototype.isNull = function() {
    return true;
  };

  Null.prototype.isEmpty = function() {
    return true;
  };

  Null.prototype.toBoolean = function() {
    return false;
  };

  Null.prototype.clone = function() {
    return this;
  };

  return Null;

})(Object);

Object.prototype.isNull = function() {
  return false;
};

Object.prototype['.null?'] = function() {
  return Boolean["new"](this.isNull());
};

module.exports = Null;


},{"../object":72,"./boolean":75}],84:[function(require,module,exports){
var Boolean, FACTORS, Null, Number, Object, TypeError, from, ref, to,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty,
  indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
  slice = [].slice;

Object = require('../object');

Null = require('./null');

Boolean = require('./boolean');

TypeError = require('../error/type');

FACTORS = {};


/*
 */

Number = (function(superClass) {
  var FIFTY_PERCENT, ONE_HUNDRED_PERCENT, RE_NUMERIC, TEN, TEN_PERCENT, TWO, ZERO, abs, acos, asin, atan, ceil, cos, floor, pow, round, sin, tan;

  extend(Number, superClass);

  round = Math.round, ceil = Math.ceil, floor = Math.floor, abs = Math.abs, pow = Math.pow, sin = Math.sin, cos = Math.cos, tan = Math.tan, asin = Math.asin, acos = Math.acos, atan = Math.atan;

  RE_NUMERIC = /^\s*([\+-]?(?:\d*\.)?\d+)\s*(%|(?:[a-z]+))?\s*$/i;

  Number.define = function(from, to) {
    var name, name1;
    if (!(from instanceof Number)) {
      from = this.fromString(from);
    }
    if (!(to instanceof Number)) {
      to = this.fromString(to);
    }
    if (from.unit && to.unit) {
      if (from.unit !== to.unit) {
        if (FACTORS[name = from.unit] == null) {
          FACTORS[name] = {};
        }
        FACTORS[from.unit][to.unit] = to.value / from.value;
        if (FACTORS[name1 = to.unit] == null) {
          FACTORS[name1] = {};
        }
        FACTORS[to.unit][from.unit] = from.value / to.value;
      } else if (from.value !== to.value) {
        throw new TypeError("Bad unit definition");
      }
      return to;
    }
    throw new TypeError("Bad unit definition");
  };

  Number.isDefined = function(unit) {
    return unit in FACTORS;
  };

  Number.fromString = function(str) {
    var match;
    try {
      str = str.toString();
      if (match = RE_NUMERIC.exec(str)) {
        return new Number(parseFloat(match[1]), match[2]);
      }
    } catch (undefined) {}
    throw new TypeError("Could not convert \"" + str + "\" to " + (this.reprType()));
  };

  function Number(value, unit1) {
    if (value == null) {
      value = 0;
    }
    this.unit = unit1 != null ? unit1 : null;
    this.value = parseFloat(value.toString());
  }

  Number.convert = function(value, from_unit, to_unit, stack) {
    var u, val;
    if (to_unit == null) {
      to_unit = '';
    }
    if (stack == null) {
      stack = [];
    }
    if (to_unit === from_unit || (to_unit && !from_unit)) {
      return value;
    } else if (!to_unit) {
      return value;
    } else if (to_unit in FACTORS) {
      if (from_unit in FACTORS[from_unit]) {
        return value * FACTORS[from_unit][to_unit];
      } else {
        stack.push(from_unit);
        for (u in FACTORS[from_unit]) {
          if (indexOf.call(stack, u) < 0) {
            stack.push(u);
            val = FACTORS[from_unit][u] * value;
            try {
              return this.convert(val, u, to_unit, stack);
            } catch (undefined) {}
            stack.pop();
          }
        }
        stack.pop();
      }
    }
    throw new TypeError("Cannot convert " + value + from_unit + " to " + to_unit);
  };


  /*
   */

  Number.prototype.convert = function(unit) {
    var value;
    if (unit == null) {
      unit = null;
    }
    if (unit) {
      unit = unit.toString().trim();
    }
    value = this["class"].convert(this.value, this.unit, unit);
    return this.clone(value, unit || '');
  };


  /*
   */

  Number.prototype.isEqual = function(other) {
    return other instanceof Number && (function() {
      try {
        return (round((other.convert(this.unit)).value, 10)) === (round(this.value, 10));
      } catch (undefined) {}
    }).call(this);
  };

  Number.prototype.compare = function(other) {
    if (other instanceof Number) {
      other = other.convert(this.unit);
      if (other.value === this.value) {
        return 0;
      } else if (other.value > this.value) {
        return 1;
      } else {
        return -1;
      }
    } else {
      throw new TypeError("Cannot compare " + (this.repr()) + " with " + (other.repr()) + ": that's not a [Number]");
    }
  };

  Number.prototype.isPure = function() {
    return !this.unit;
  };

  Number.prototype.isEmpty = function() {
    return this.value === 0;
  };

  Number.prototype.isPrime = function() {
    var i, m, n;
    n = this.value;
    if ((n < 2) || (n % 1)) {
      return false;
    }
    if (!(n % 2)) {
      return n === 2;
    }
    if (!(n % 3)) {
      return n === 3;
    }
    i = 5;
    m = Math.sqrt(n);
    while (i <= m) {
      if (!(n % 1)) {
        return false;
      }
      if (!(n % (i + 2))) {
        return false;
      }
    }
    return true;
  };

  Number.prototype.toNumber = function() {
    return this.clone();
  };

  Number.prototype.toString = function() {
    var str;
    str = "" + this.value;
    if (this.unit) {
      str += this.unit;
    }
    return str;
  };

  Number.prototype.toJSON = function() {
    var json;
    json = Number.__super__.toJSON.apply(this, arguments);
    json.value = this.value;
    json.unit = this.unit;
    return json;
  };

  Number.prototype.reprValue = function() {
    return "" + this.value + (this.unit || '');
  };

  Number.prototype.clone = function() {
    var etc, unit, value;
    value = arguments[0], unit = arguments[1], etc = 3 <= arguments.length ? slice.call(arguments, 2) : [];
    if (value == null) {
      value = this.value;
    }
    if (unit == null) {
      unit = this.unit;
    }
    return Number.__super__.clone.apply(this, [value, unit].concat(slice.call(etc)));
  };

  ZERO = Number.ZERO = new Number(0);

  TWO = Number.TWO = new Number(2);

  TEN = Number.TEN = new Number(10);

  ONE_HUNDRED_PERCENT = Number.ONE_HUNDRED_PERCENT = new Number(100, '%');

  FIFTY_PERCENT = Number.FIFTY_PERCENT = new Number(50, '%');

  TEN_PERCENT = Number.TEN_PERCENT = new Number(10, '%');

  Number.prototype['.+@'] = function() {
    return this.clone();
  };

  Number.prototype['.-@'] = function() {
    return this.clone(-this.value);
  };

  Number.prototype['.+'] = function(other) {
    if (other instanceof Number) {
      return this.clone((this.convert(other.unit)).value + other.value, other.unit || this.unit);
    } else {
      throw new TypeError("Cannot perform " + (this.repr()) + " + " + (other.repr()) + ": right side must be a " + (Number.repr()));
    }
  };

  Number.prototype['.-'] = function(other) {
    if (other instanceof Number) {
      return this.clone((this.convert(other.unit)).value - other.value, other.unit || this.unit);
    } else {
      throw new TypeError("Cannot perform " + (this.repr()) + " - " + (other.repr()) + ": right side must be a " + (Number.repr()));
    }
  };

  Number.prototype['.*'] = function(other) {
    if (other instanceof Number) {
      if (this.isPure() || other.isPure()) {
        return this.clone(other.value * this.value, other.unit || this.unit);
      } else {
        throw new TypeError("Cannot perform " + (this.repr()) + " * " + (other.repr()));
      }
    } else {
      throw new TypeError("Cannot perform " + (this.repr()) + " * " + (other.repr()) + ": right side must be a " + (Number.repr()));
    }
  };

  Number.prototype['./'] = function(other) {
    if (other instanceof Number) {
      if (other.value === 0) {
        throw new TypeError('Cannot divide by 0');
      }
      if (!this.isPure() && !other.isPure()) {
        return this.clone(this.value / (other.convert(this.unit)).value, '');
      } else {
        return this.clone(this.value / other.value, this.unit || other.unit);
      }
    } else {
      throw new TypeError("Cannot perform " + (this.repr()) + " / " + (other.repr()) + ": right side must be a " + (Number.repr()));
    }
  };

  Number.prototype['.unit?'] = function() {
    return Boolean["new"](this.unit);
  };

  Number.prototype['.pure?'] = function() {
    return Boolean["new"](this.isPure());
  };

  Number.prototype['.pure'] = function() {
    return new Number(this.value);
  };

  Number.prototype['.zero?'] = function() {
    return Boolean["new"](this.value === 0);
  };

  Number.prototype['.integer?'] = function() {
    return Boolean["new"](this.value % 1 === 0);
  };

  Number.prototype['.decimal?'] = function() {
    return Boolean["new"](this.value % 1 !== 0);
  };

  Number.prototype['.divisible-by?'] = function(other) {
    var div, error;
    if (!other.isPure()) {
      try {
        other = other.convert(this.unit);
      } catch (error) {
        return Boolean["false"];
      }
    }
    div = this.value / other.value;
    return Boolean["new"](div === floor(div));
  };

  Number.prototype['.even?'] = function() {
    return Boolean["new"](this.value % 2 === 0);
  };

  Number.prototype['.odd?'] = function() {
    return Boolean["new"](this.value % 2 !== 0);
  };

  Number.prototype['.positive?'] = function() {
    return Boolean["new"](this.value > 0);
  };

  Number.prototype['.positive'] = function() {
    return this.clone(abs(this.value));
  };

  Number.prototype['.negative'] = function() {
    return this.clone(-1 * (abs(this.value)));
  };

  Number.prototype['.negate'] = function() {
    return this.clone(-1 * this.value);
  };

  Number.prototype['.negative?'] = function() {
    return Boolean["new"](this.value < 0);
  };

  Number.prototype['.round'] = function(places) {
    var m;
    if (places == null) {
      places = ZERO;
    }
    m = pow(10, places.value);
    return this.clone((round(this.value * m)) / m);
  };

  Number.prototype['.ceil'] = function() {
    return this.clone(ceil(this.value));
  };

  Number.prototype['.floor'] = function() {
    return this.clone(floor(this.value));
  };

  Number.prototype['.abs'] = function() {
    return this.clone(abs(this.value));
  };

  Number.prototype['.pow'] = function(exp) {
    if (exp == null) {
      exp = TWO;
    }
    return this.clone(pow(this.value, exp.value));
  };

  Number.prototype['.sq'] = function() {
    return this['.pow'](TWO);
  };

  Number.prototype['.root'] = function(deg) {
    if (deg == null) {
      deg = TWO;
    }
    if (this.value < 0) {
      throw new TypeError("Cannot make " + deg.value + "th root of " + (this.repr()) + ": Base cannot be negative");
    }
    return this.clone(pow(this.value, 1 / deg.value));
  };

  Number.prototype['.sqrt'] = function() {
    return this['.root'](TWO);
  };

  Number.prototype['.mod'] = function(other) {
    if (other.value === 0) {
      throw new TypeError('Cannot divide by 0');
    }
    return this.clone(this.value % other.value);
  };

  Number.prototype['.sin'] = function() {
    return this.clone(sin(this.value));
  };

  Number.prototype['.cos'] = function() {
    return this.clone(cos(this.value));
  };

  Number.prototype['.tan'] = function() {
    return this.clone(tan(this.value));
  };

  Number.prototype['.asin'] = function() {
    return this.clone(asin(this.value));
  };

  Number.prototype['.acos'] = function() {
    return this.clone(acos(this.value));
  };

  Number.prototype['.atan'] = function() {
    return this.clone(atan(this.value));
  };

  Number.prototype['.prime?'] = function() {
    return Boolean["new"](this.isPrime());
  };

  Number.prototype['.convert'] = function(unit) {
    if (unit.isNull()) {
      unit = null;
    } else {
      unit = unit.toString();
    }
    return this.convert(unit);
  };

  return Number;

})(Object);

Object.prototype.toNumber = function() {
  throw new Error("Cannot convert " + (this.repr()) + " to number");
};

Boolean.prototype.toNumber = function() {
  return new Number((this.value ? 1 : 0));
};

Object.prototype['.number'] = function() {
  return this.toNumber();
};


/*
TODO: This should go to the `css-units` module.
 */

ref = {
  '1cm': '10mm',
  '40q': '1cm',
  '1in': '25.4mm',
  '96px': '1in',
  '72pt': '1in',
  '1pc': '12pt',
  '180deg': Math.PI + "rad",
  '1turn': '360deg',
  '400grad': '1turn',
  '1s': '1000ms',
  '1kHz': '1000Hz',
  '1dppx': '96dpi',
  '1dpcm': '2.54dpi'
};
for (from in ref) {
  to = ref[from];
  Number.define(from, to);
}

module.exports = Number;


},{"../error/type":31,"../object":72,"./boolean":75,"./null":83}],85:[function(require,module,exports){
var Null, Object, Property, String,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty,
  slice = [].slice;

Object = require('../object');

Null = require('./null');

String = require('./string');

Property = (function(superClass) {
  extend(Property, superClass);

  function Property(name1, value1) {
    this.name = name1;
    this.value = value1 != null ? value1 : Null["null"];
  }

  Property.prototype.isEmpty = function() {
    return this.value.isNull();
  };

  Property.prototype.isEqual = function(other) {
    return (other instanceof Property) && (other.name === this.name) && (other.value.isEqual(this.value));
  };

  Property.prototype.toJSON = function() {
    var json;
    json = Property.__super__.toJSON.apply(this, arguments);
    json.name = this.name;
    json.value = this.value;
    return json;
  };

  Property.prototype.clone = function() {
    var etc, name, value;
    name = arguments[0], value = arguments[1], etc = 3 <= arguments.length ? slice.call(arguments, 2) : [];
    if (name == null) {
      name = this.name;
    }
    if (value == null) {
      value = this.value;
    }
    return Property.__super__.clone.apply(this, [name, value.clone()].concat(slice.call(etc)));
  };

  Property.prototype.reprValue = function() {
    return this.name + ": " + (this.value.repr());
  };

  Property.prototype['.name'] = function() {
    return new String(this.name);
  };

  Property.prototype['.value'] = function() {
    return this.value;
  };

  return Property;

})(Object);

module.exports = Property;


},{"../object":72,"./null":83,"./string":90}],86:[function(require,module,exports){
var Boolean, Indexed, List, Null, Number, Range, String, TypeError,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty,
  slice1 = [].slice;

Indexed = require('./indexed');

Null = require('./null');

Boolean = require('./boolean');

List = require('./list');

Number = require('./number');

String = require('./string');

TypeError = require('../error/type');

Range = (function(superClass) {
  var abs, floor, max, min;

  extend(Range, superClass);

  min = Math.min, max = Math.max, abs = Math.abs, floor = Math.floor;

  Range.property('items', {
    get: function() {
      var i, items, j, ref;
      items = [];
      for (i = j = 0, ref = this.length(); 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
        items.push(new Number(this.getByIndex(i), this.unit));
      }
      return items;
    }
  });

  Range.prototype.isReverse = function() {
    return this.first > this.last;
  };

  Range.prototype.length = function() {
    return 1 + floor((abs(this.last - this.first)) / this.step);
  };

  Range.prototype.minValue = function() {
    return new Number(min(this.first, this.last));
  };

  Range.prototype.maxValue = function() {
    return new Number(max(this.first, this.last));
  };

  Range.prototype.getByIndex = function(index) {
    var step;
    step = this.step;
    if (this.isReverse()) {
      step *= -1;
    }
    return new Number(this.first + index * step);
  };

  function Range(first1, last1, unit1, step1) {
    this.first = first1 != null ? first1 : 0;
    this.last = last1 != null ? last1 : 0;
    this.unit = unit1 != null ? unit1 : null;
    this.step = step1 != null ? step1 : 1;
    Range.__super__.constructor.apply(this, arguments);
  }

  Range.prototype.convert = function(unit) {
    var first, last, step;
    unit = unit.toString();
    if (unit !== '') {
      first = Number.convert(this.first, this.unit, unit);
      last = Number.convert(this.last, this.unit, unit);
      step = Number.convert(this.step, this.unit, unit);
    } else {
      unit = '';
    }
    return this.clone(first, last, unit, step);
  };


  /*
  TODO this is buggy
   */

  Range.prototype.contains = function(other) {
    var error, ref;
    try {
      other = other.convert(this.unit);
      return (this.minValue() <= (ref = other.value) && ref <= this.maxValue());
    } catch (error) {
      return false;
    }
  };

  Range.prototype.isPure = function() {
    return !this.unit;
  };

  Range.prototype.clone = function() {
    var etc, first, last, step, unit;
    first = arguments[0], last = arguments[1], unit = arguments[2], step = arguments[3], etc = 5 <= arguments.length ? slice1.call(arguments, 4) : [];
    if (first == null) {
      first = this.first;
    }
    if (last == null) {
      last = this.last;
    }
    if (unit == null) {
      unit = this.unit;
    }
    if (step == null) {
      step = this.step;
    }
    return Range.__super__.clone.apply(this, [first, last, unit, step].concat(slice1.call(etc)));
  };

  Range.prototype.reprValue = function() {
    return this.first + ".." + this.last;
  };

  Range.prototype['./'] = function(step) {
    if (step instanceof Number) {
      step = (step.convert(this.unit)).value;
      return this.clone(null, null, null, step);
    } else {
      throw new TypeError("Cannot divide a range by " + (step.repr()));
    }
  };


  /*
  TODO this is buggy
   */

  Range.prototype['.<<'] = function() {
    var arg, args, j, len1, vals;
    args = 1 <= arguments.length ? slice1.call(arguments, 0) : [];
    vals = [];
    for (j = 0, len1 = args.length; j < len1; j++) {
      arg = args[j];
      if (!(arg instanceof Number)) {
        throw new TypeError("Cannot add that to a range");
      }
      if (arg.unit && !this.unit) {
        this.unit = arg.unit;
      } else {
        arg = arg.convert(this.unit);
      }
      vals.push(arg.value);
    }
    this.first = Math.min.apply(Math, [this.first].concat(slice1.call(vals)));
    this.last = Math.max.apply(Math, [this.last].concat(slice1.call(vals)));
    return this;
  };

  Range.prototype['.unit'] = function() {
    if (this.unit) {
      return new String(this.unit);
    } else {
      return Null["null"];
    }
  };

  Range.prototype['.unit?'] = function() {
    return Boolean["new"](this.unit);
  };

  Range.prototype['.pure?'] = function() {
    return Boolean["new"](this.isPure());
  };

  Range.prototype['.pure'] = function() {
    return this.clone(null, null, '');
  };

  Range.prototype['.step'] = function() {
    return new Number(this.step, this.unit);
  };

  Range.prototype['.step='] = function(step) {
    if (step instanceof Number) {
      return this.step = (step.convert(this.unit)).value;
    } else {
      throw new TypeError("Bad `step` value for a range: " + (step.repr()));
    }
  };

  Range.prototype['.convert'] = function() {
    var args;
    args = 1 <= arguments.length ? slice1.call(arguments, 0) : [];
    return this.convert.apply(this, args);
  };

  Range.prototype['.reverse?'] = function() {
    return Boolean["new"](this.isReverse());
  };

  Range.prototype['.reverse'] = function() {
    return this.clone(this.last, this.first);
  };

  Range.prototype['.list'] = function() {
    return new List(this.items);
  };

  return Range;

})(Indexed);

Number.prototype['...'] = function(other) {
  var unit;
  if (other instanceof Number) {
    if (this.unit) {
      other = other.convert(this.unit);
      unit = this.unit;
    } else if (other.unit) {
      unit = other.unit;
    } else {
      unit = null;
    }
    return new Range(this.value, other.value, unit);
  }
  throw new TypeError("Cannot make a range with that: " + other.type);
};

(function() {
  var supah;
  supah = List.prototype['.::'];
  return List.prototype['.::'] = function() {
    var etc, idx, j, len1, other, ref, slice;
    other = arguments[0], etc = 2 <= arguments.length ? slice1.call(arguments, 1) : [];
    if (other instanceof Range) {
      slice = this.clone([]);
      ref = other.items;
      for (j = 0, len1 = ref.length; j < len1; j++) {
        idx = ref[j];
        slice.items.push(this['.::'](idx));
      }
      return slice;
    } else {
      return supah.call.apply(supah, [this, other].concat(slice1.call(etc)));
    }
  };
})();

(function() {
  var max, min, supah;
  min = Math.min, max = Math.max;
  supah = String.prototype['.::'];
  return String.prototype['.::'] = function() {
    var end, etc, idx, len, other, str;
    other = arguments[0], etc = 2 <= arguments.length ? slice1.call(arguments, 1) : [];
    if (other instanceof Range) {
      str = '';
      if (this.value !== '') {
        len = this.value.length;
        end = other.last + 1;
        if (end < 0) {
          end += len;
        }
        end = min(end, len - 1);
        idx = other.first;
        if (idx < 0) {
          idx += len;
        }
        idx = max(-len, idx);
        while (idx !== end) {
          str += this.value.charAt(idx);
          idx = (idx + 1) % len;
        }
      }
      return this.clone(str);
    } else {
      return supah.call.apply(supah, [this, other].concat(slice1.call(etc)));
    }
  };
})();

module.exports = Range;


},{"../error/type":31,"./boolean":75,"./indexed":81,"./list":82,"./null":83,"./number":84,"./string":90}],87:[function(require,module,exports){
(function (global){
var Boolean, List, Null, Number, Object, RegExp, String, TypeError,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty,
  slice = [].slice;

Object = require('../object');

Boolean = require('./boolean');

Null = require('./null');

String = require('./string');

Number = require('./number');

List = require('./list');

TypeError = require('../error/type');

RegExp = (function(superClass) {
  extend(RegExp, superClass);

  RegExp.prototype._value = null;

  RegExp.prototype.source = null;

  RegExp.prototype.global = false;

  RegExp.prototype.multiline = false;

  RegExp.prototype.insensitive = false;

  RegExp.escape = function(str) {
    return str.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&');
  };

  function RegExp(source1, flags1) {
    this.source = source1;
    this.flags = flags1;
    this.build();
  }

  RegExp.property('value', {
    get: function() {
      if (!(this._value && this._value.source === this.source && this._value.ignoreCase === this.insensitive && this._value.global === this.global && this._value.multiline === this.multiline)) {
        this.build();
      }
      return this._value;
    }
  });

  RegExp.property('flags', {
    get: function() {
      var flags;
      flags = '';
      if (this.multiline) {
        flags += 'm';
      }
      if (this.insensitive) {
        flags += 'i';
      }
      if (this.global) {
        flags += 'g';
      }
      return flags;
    },
    set: function(flags) {
      var flag, i, len, results;
      this.multiline = false;
      this.global = false;
      this.insensitive = false;
      if (flags != null ? flags.length : void 0) {
        results = [];
        for (i = 0, len = flags.length; i < len; i++) {
          flag = flags[i];
          results.push(this.setFlag(flag, true));
        }
        return results;
      }
    }
  });

  RegExp.prototype.setFlag = function(flag, value) {
    switch (flag) {
      case 'm':
        this.multiline = value;
        break;
      case 'g':
        this.global = value;
        break;
      case 'i':
        this.insensitive = value;
        break;
      default:
        throw new TypeError("Bad flag for RegExp: \"" + flag + "\"");
    }
    return this;
  };

  RegExp.prototype.build = function() {
    var e, error;
    try {
      return this._value = new global.RegExp(this.source, this.flags);
    } catch (error) {
      e = error;
      throw new TypeError(e.message);
    }
  };

  RegExp.prototype.isEqual = function(other) {
    return (other instanceof RegExp) && (other.source === this.source) && (other.flags === this.flags);
  };

  RegExp.prototype.toString = function() {
    return this.source;
  };

  RegExp.prototype.clone = function() {
    var etc, flags, source;
    source = arguments[0], flags = arguments[1], etc = 3 <= arguments.length ? slice.call(arguments, 2) : [];
    if (source == null) {
      source = this.source;
    }
    if (flags == null) {
      flags = this.flags;
    }
    return RegExp.__super__.clone.apply(this, [source, flags].concat(slice.call(etc)));
  };

  RegExp.prototype.reprValue = function() {
    return "/" + (this["class"].escape(this.source)) + "/" + this.flags;
  };


  /*
  TODO: convert any object to string with `.string`?
   */

  RegExp.prototype['.~'] = function(other) {
    var m;
    if (other instanceof String) {
      if (m = other.value.match(this.value)) {
        return new List(m.map(function(str) {
          return other.clone(str);
        }));
      }
      return Null["null"];
    }
    throw new Error("Cannot match that!");
  };

  RegExp.prototype['.global?'] = function() {
    return Boolean["new"](this.global);
  };

  RegExp.prototype['.global'] = function() {
    return this.clone().setFlag('g', true);
  };

  RegExp.prototype['.sensitive?'] = function() {
    return Boolean["new"](!this.insensitive);
  };

  RegExp.prototype['.sensitive'] = function() {
    return this.clone().setFlag('i', false);
  };

  RegExp.prototype['.insensitive?'] = function() {
    return Boolean["new"](this.insensitive);
  };

  RegExp.prototype['.insensitive'] = function() {
    return this.clone().setFlag('i', true);
  };

  RegExp.prototype['.multiline?'] = function() {
    return Boolean["new"](this.multiline);
  };

  RegExp.prototype['.multiline'] = function() {
    return this.clone().setFlag('m', true);
  };

  return RegExp;

})(Object);

(function() {
  var supah;
  supah = String.prototype.match;
  return String.prototype['.~'] = function() {
    var etc, other;
    other = arguments[0], etc = 2 <= arguments.length ? slice.call(arguments, 1) : [];
    if (other instanceof RegExp) {
      return other['.~'](this);
    } else {
      return supah.call.apply(supah, [this, other].concat(slice.call(etc)));
    }
  };
})();

String.prototype['.split'] = function(separator, limit) {
  var chunks, reg;
  if (limit == null) {
    limit = Null["null"];
  }
  if (separator instanceof RegExp) {
    reg = separator.value;
  } else if (separator instanceof String) {
    reg = RegExp.escape(separator.value);
    reg = new global.RegExp(reg + "+");
  } else {
    throw new TypeError('Bad `separator` argument for `String.split`');
  }
  if (limit instanceof Null) {
    limit = -1;
  } else if (limit instanceof Number) {
    limit = limit.value;
  } else {
    throw new TypeError('Bad `limit` argument for `String.split`');
  }
  chunks = (this.value.split(reg, limit)).filter(function(str) {
    return str !== '';
  }).map((function(_this) {
    return function(str) {
      return _this.clone(str);
    };
  })(this));
  return new List(chunks);
};

(function() {
  var supah;
  supah = String.prototype['./'];
  return String.prototype['./'] = function(separator) {
    var reg;
    if (separator instanceof RegExp) {
      reg = separator.value;
    } else if (separator instanceof String) {
      reg = RegExp.escape(separator.value);
      reg = new global.RegExp(reg + "+");
    } else {
      return supah.apply(this, arguments);
    }
    return this['.split'](separator);
  };
})();

String.prototype['.characters'] = function(limit) {
  if (limit == null) {
    limit = Null["null"];
  }
  return new List((this.value.split('')).map((function(_this) {
    return function(char) {
      return _this.clone(char);
    };
  })(this)));
};

String.prototype['.words'] = function() {
  return new List(((this.value.match(/\w+/g)) || []).map((function(_this) {
    return function(word) {
      return _this.clone(word);
    };
  })(this)));
};

String.prototype['.lines'] = function() {
  return new List(((this.value.match(/[^\s](.+)[^\s]/g)) || []).map((function(_this) {
    return function(line) {
      return _this.clone(line);
    };
  })(this)));
};

String.prototype['.replace'] = function(search, replacement) {
  if (search instanceof RegExp) {
    search = search.value;
  } else {
    search = new global.RegExp(RegExp.escape(search.toString()), 'g');
  }
  replacement = replacement.toString();
  return this.clone(this.value.replace(search, replacement));
};

module.exports = RegExp;


}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../error/type":31,"../object":72,"./boolean":75,"./list":82,"./null":83,"./number":84,"./string":90}],88:[function(require,module,exports){
var Rule, RuleSet, String,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Rule = require('./rule');

String = require('./string');

RuleSet = (function(superClass) {
  extend(RuleSet, superClass);

  RuleSet.prototype.selector = null;

  function RuleSet() {
    RuleSet.__super__.constructor.apply(this, arguments);
    this.selector = [];
  }

  RuleSet.prototype.toJSON = function() {
    var json;
    json = RuleSet.__super__.toJSON.apply(this, arguments);
    json.selector = this.selector;
    return json;
  };

  RuleSet.prototype.clone = function() {
    var that;
    that = RuleSet.__super__.clone.apply(this, arguments);
    that.selector = [].concat(this.selector);
    return that;
  };

  RuleSet.prototype['.selector'] = function() {
    return new String(this.selector.join(',\n'));
  };

  return RuleSet;

})(Rule);

module.exports = RuleSet;


},{"./rule":89,"./string":90}],89:[function(require,module,exports){
var Block, List, Rule,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Block = require('./block');

List = require('./list');

Rule = (function(superClass) {
  extend(Rule, superClass);

  function Rule() {
    return Rule.__super__.constructor.apply(this, arguments);
  }

  return Rule;

})(Block);

Block.prototype['.rules'] = function() {
  return new List(this.items.filter(function(obj) {
    return obj instanceof Rule;
  }));
};

module.exports = Rule;


},{"./block":74,"./list":82}],90:[function(require,module,exports){
(function (Buffer){
var Boolean, Null, Number, Object, String, TypeError,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty,
  slice = [].slice;

Object = require('../object');

Null = require('./null');

Boolean = require('./boolean');

Number = require('./number');

TypeError = require('../error/type');

String = (function(superClass) {
  var QUOTE_REGEXP;

  extend(String, superClass);

  QUOTE_REGEXP = function(str) {
    return str.replace(/[.?*+^$[\]\\(){}|-]/g, "\\$&");
  };

  function String(value1, quote1) {
    this.value = value1 != null ? value1 : '';
    this.quote = quote1 != null ? quote1 : null;
  }

  String.property('length', {
    get: function() {
      return this.value.length;
    }
  });

  String.prototype.isEmpty = function() {
    return this.length === 0;
  };

  String.prototype.isEqual = function(other) {
    return other instanceof String && other.value === this.value;
  };

  String.prototype.isPalindrome = function() {
    var letters;
    letters = this.value.toLowerCase().replace(/[\W]+/g, '');
    return letters === (letters.split('')).reverse().join('');
  };

  String.prototype.toNumber = function() {
    return Number.fromString(this.value);
  };

  String.prototype.isNumeric = function() {
    return !!((function() {
      try {
        return this.toNumber();
      } catch (undefined) {}
    }).call(this));
  };

  String.prototype.toBase64 = function() {
    return new Buffer(this.value).toString('base64');
  };

  String.prototype.toString = function() {
    return this.value;
  };

  String.prototype.append = function() {
    var j, len1, other, others;
    others = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    for (j = 0, len1 = others.length; j < len1; j++) {
      other = others[j];
      if (other instanceof String) {
        this.value += other.value;
        this.quote || (this.quote = other.quote);
      } else {
        throw new TypeError("Cannot append that to a string");
      }
    }
    return this;
  };

  String.prototype.compare = function(other) {
    if (other instanceof String) {
      if (other.value === this.value) {
        return 0;
      } else if (other.value > this.value) {
        return 1;
      } else {
        return -1;
      }
    } else {
      throw new Error("Cannot compare " + (this.reprType()) + " with " + (other.reprType()));
    }
  };

  String.prototype.contains = function(other) {
    return (other instanceof String) && (this.value.indexOf(other.value)) >= 0;
  };

  String.prototype.toJSON = function() {
    var json;
    json = String.__super__.toJSON.apply(this, arguments);
    json.quote = this.quote;
    json.value = this.value;
    return json;
  };

  String.prototype.clone = function(value, quote) {
    if (value == null) {
      value = this.value;
    }
    if (quote == null) {
      quote = this.quote;
    }
    return String.__super__.clone.call(this, value, quote);
  };

  String.prototype.reprValue = function() {
    return '"' + this.value + '"';
  };

  String.prototype['.+'] = function(other) {
    if (other instanceof String) {
      return new String("" + this.value + other.value, this.quote || other.quote);
    } else {
      throw new TypeError("Cannot perform " + (this.repr()) + " + " + (other.repr()) + ": right side must be a " + (String.repr()));
    }
  };

  String.prototype['.*'] = function(other) {
    if (other instanceof Number) {
      if (other.value >= 0) {
        if (!other.unit) {
          return this.clone((Array(other.value + 1)).join(this.value));
        } else {
          throw new TypeError("Cannot perform " + (this.repr()) + " * " + (other.repr()) + ": that's not a [Number]");
        }
      } else {
        throw new TypeError;
      }
    } else {
      throw new TypeError("Cannot perform " + (this.repr()) + " * " + (other.repr()) + ": that's not a [Number]");
    }
  };

  String.prototype['.<<'] = String.prototype.append;

  String.prototype['.::'] = function(other) {
    var char, idx, len;
    if (other instanceof Number) {
      len = this.length;
      idx = other.value;
      if (idx < 0) {
        idx += len;
      }
      char = this.value.charAt(idx);
      if (char === '') {
        return Null["null"];
      } else {
        return new String(char, this.quote);
      }
    } else {
      throw new TypeError;
    }
  };

  String.prototype['.length'] = function() {
    return new Number(this.length);
  };

  String.prototype['.blank?'] = function() {
    return Boolean["new"](this.value.trim() === '');
  };

  String.prototype['.quoted?'] = function() {
    return Boolean["new"](this.quote != null);
  };

  String.prototype['.quote'] = function() {
    return new String(this.value, '"');
  };

  String.prototype['.quoted'] = String.prototype['.quote'];

  String.prototype['.unquote'] = function() {
    return new String(this.value, null);
  };

  String.prototype['.unquoted'] = String.prototype['.unquote'];

  String.prototype['.unquoted?'] = function() {
    return Boolean["new"](this.quote == null);
  };

  String.prototype['.append'] = String.prototype.append;

  String.prototype['.trim'] = function(chars) {
    if (chars instanceof String) {
      chars = QUOTE_REGEXP(chars.value);
    } else {
      chars = '\\s';
    }
    return this.clone(this.value.replace(RegExp("^[" + chars + "]+|[" + chars + "]+$", "g"), ''));
  };

  String.prototype['.ltrim'] = function(chars) {
    if (chars instanceof String) {
      chars = QUOTE_REGEXP(chars.value);
    } else {
      chars = '\\s';
    }
    return this.clone(this.value.replace(RegExp("^[" + chars + "]+", "g"), ''));
  };

  String.prototype['.rtrim'] = function(chars) {
    if (chars instanceof String) {
      chars = QUOTE_REGEXP(chars.value);
    } else {
      chars = '\\s';
    }
    return this.clone(this.value.replace(RegExp("[" + chars + "]+$", "g"), ''));
  };

  String.prototype['.starts-with?'] = function(str) {
    return Boolean["new"](str instanceof String && (this.value.length >= str.value.length) && (this.value.substr(0, str.value.length)) === str.value);
  };

  String.prototype['.ends-with?'] = function(str) {
    return Boolean["new"](str instanceof String && (this.value.length >= str.value.length) && (this.value.substr(-str.value.length, str.value.length)) === str.value);
  };

  String.prototype['.lower-case'] = function() {
    return this.clone(this.value.toLowerCase());
  };

  String.prototype['.upper-case'] = function() {
    return this.clone(this.value.toUpperCase());
  };

  String.prototype['.string'] = function() {
    return this.clone();
  };

  String.prototype['.numeric?'] = function() {
    return Boolean["new"](this.isNumeric());
  };

  String.prototype['.reverse'] = function() {
    return this.clone((this.value.split('')).reverse().join(''));
  };

  String.prototype['.palindrome?'] = function() {
    return Boolean["new"](this.isPalindrome());
  };

  String.prototype['.base64'] = function() {
    return this.clone(this.toBase64());
  };

  return String;

})(Object);

Number.prototype['.base'] = function(base) {
  var ref, str;
  if (base == null) {
    base = Number.TEN;
  }
  base = base.toNumber();
  if (base.value !== Math.round(base.value)) {
    throw new TypeError("Cannot convert number to base `" + base.value + "`: base must be integer");
  }
  if (!((2 <= (ref = base.value) && ref <= 16))) {
    throw new TypeError("Cannot convert number to base `" + base.value + "`: base must be between 2 and 16");
  }
  str = this.value.toString(base.value);
  if (this.unit) {
    str += this.unit;
  }
  return new String(str);
};

(function() {

  /*
  http://blog.stevenlevithan.com/archives/javascript-roman-numeral-converter#comment-16107
   */
  var ROMANS;
  ROMANS = {
    M: 1000,
    CM: 900,
    D: 500,
    CD: 400,
    C: 100,
    XC: 90,
    L: 50,
    XL: 40,
    X: 10,
    IX: 9,
    V: 5,
    IV: 4,
    I: 1
  };
  return Number.prototype['.roman'] = function() {
    var i, ref, roman, val;
    if (!this.unit && this.value % 1 === 0 && (0 < (ref = this.value) && ref <= 3000)) {
      val = this.value;
      roman = '';
      for (i in ROMANS) {
        while (val >= ROMANS[i]) {
          roman += i;
          val -= ROMANS[i];
        }
      }
      return new String(roman);
    } else {
      throw new TypeError;
    }
  };
})();

(function() {
  var supah;
  supah = Number.prototype['.*'];
  return Number.prototype['.*'] = function() {
    var etc, other;
    other = arguments[0], etc = 2 <= arguments.length ? slice.call(arguments, 1) : [];
    if (other instanceof String) {
      return other['.*'](this);
    } else {
      return supah.call.apply(supah, [this, other].concat(slice.call(etc)));
    }
  };
})();

Number.prototype['.unit'] = function() {
  if (this.unit) {
    return new String(this.unit);
  } else {
    return Null["null"];
  }
};

Object.prototype['.unquoted'] = function() {
  return new String(this.toString());
};

Object.prototype['.quoted'] = function() {
  return new String(this.toString(), '"');
};

Object.prototype['.string'] = Object.prototype['.quoted'];

Object.prototype['.repr'] = function() {
  return new String(this.repr(), '"');
};

module.exports = String;


}).call(this,require("buffer").Buffer)
},{"../error/type":31,"../object":72,"./boolean":75,"./null":83,"./number":84,"buffer":3}],91:[function(require,module,exports){
var Boolean, Error, Null, Number, Object, String, TypeError, URL, parseURL,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty,
  slice = [].slice;

parseURL = require('url');

Object = require('../object');

Boolean = require('./boolean');

Null = require('./null');

String = require('./string');

Number = require('./number');

Error = require('../error');

TypeError = require('../error/type');

URL = (function(superClass) {
  extend(URL, superClass);

  URL.property('value', {
    get: function() {
      return this.toString();
    },
    set: function(value) {
      var e, error, fake_scheme, parsed;
      value = value.trim();
      if ('//' === value.substr(0, 2)) {
        value = 'fake:' + value;
        fake_scheme = true;
      } else {
        fake_scheme = false;
      }
      try {
        parsed = parseURL.parse(value);
      } catch (error) {
        e = error;
        throw e;
      }
      this.scheme = !fake_scheme && (parsed.protocol != null) ? parsed.protocol.substr(0, parsed.protocol.length - 1) : null;
      this.host = parsed.hostname;
      this.port = parsed.port;
      this.path = parsed.pathname;
      this.query = parsed.query;
      return this.fragment = parsed.hash != null ? parsed.hash.substr(1) : null;
    }
  });

  function URL(value1, quote1) {
    this.value = value1 != null ? value1 : '';
    this.quote = quote1 != null ? quote1 : null;
  }

  URL.prototype.clone = function(value, quote) {
    if (value == null) {
      value = this.value;
    }
    if (quote == null) {
      quote = this.quote;
    }
    return URL.__super__.clone.call(this, value, quote);
  };

  URL.prototype.toJSON = function() {
    var json;
    json = URL.__super__.toJSON.apply(this, arguments);
    json.value = this.value;
    json.quote = this.quote;
    return json;
  };


  /*
  Resolves another URL or string with this as the base
   */

  URL.prototype['.+'] = function(other) {
    if (other instanceof URL || other instanceof String) {
      return this.clone(parseURL.resolve(this.value, other.value));
    } else {
      return URL.__super__['.+'].apply(this, arguments);
    }
  };

  URL.prototype['.scheme'] = function() {
    if (this.scheme) {
      return new String(this.scheme, this.quote);
    }
  };

  URL.prototype['.scheme='] = function(sch) {
    if (sch instanceof Null) {
      return this.scheme = null;
    } else if (sch instanceof String) {
      return this.scheme = sch.value;
    } else {
      throw new Error("Bad URL scheme");
    }
  };

  URL.prototype['.protocol'] = URL.prototype['.scheme'];

  URL.prototype['.protocol='] = URL.prototype['.scheme='];

  URL.prototype['.absolute?'] = function() {
    return Boolean["new"](this.scheme != null);
  };

  URL.prototype['.relative?'] = function() {
    return Boolean["new"](this.scheme == null);
  };

  URL.prototype['.http?'] = function() {
    return Boolean["new"](this.scheme === 'http');
  };

  URL.prototype['.http'] = function() {
    var http;
    http = this.clone();
    http.scheme = 'http';
    return http;
  };

  URL.prototype['.https?'] = function() {
    return Boolean["new"](this.scheme === 'https');
  };

  URL.prototype['.https'] = function() {
    var http;
    http = this.clone();
    http.scheme = 'https';
    return http;
  };

  URL.prototype['.host'] = function() {
    if (this.host != null) {
      return new String(this.host, this.quote);
    } else {
      return Null["null"];
    }
  };

  URL.prototype['.host='] = function(host) {
    if (host instanceof Null) {
      return this.host = null;
    } else if (host instanceof String) {
      return this.host = host.value;
    } else {
      throw new Error("Bad URL host");
    }
  };

  URL.prototype['.domain'] = function() {
    var domain;
    domain = this.host;
    if (domain != null) {
      if (domain.match(/^www\./i)) {
        domain = domain.substr(4);
      }
      return new String(domain, this.quote);
    } else {
      return Null["null"];
    }
  };

  URL.prototype['.port'] = function() {
    if (this.port != null) {
      return new String(this.port, this.quote);
    }
  };

  URL.prototype['.port='] = function(port) {
    var p;
    if (port instanceof Null) {
      this.port = null;
      return;
    }
    if (port instanceof String && port.isNumeric()) {
      port = port.toNumber();
    } else if (!(port instanceof Number)) {
      throw new TypeError("Cannot set URL port to non-numeric value: " + (port.repr()));
    }
    p = port.value;
    if (p % 1 !== 0) {
      throw new TypeError("Cannot set URL port to non integer number: " + (port.reprValue()));
    }
    if ((1 <= p && p <= 65535)) {
      return this.port = p;
    } else {
      throw new TypeError("Port number out of 1..65535 range: " + p);
    }
  };

  URL.prototype['.path'] = function() {
    if (this.path != null) {
      return new String(this.path, this.quote);
    }
  };

  URL.prototype['.query'] = function() {
    if (this.query != null) {
      return new String(this.query, this.quote);
    }
  };

  URL.prototype['.query='] = function(query) {
    if (query instanceof Null) {
      return this.query = null;
    } else if (query instanceof String) {
      return this.query = query.value.trim();
    } else {
      throw new Error("Bad URL query");
    }
  };

  URL.prototype['.fragment'] = function() {
    if (this.fragment != null) {
      return new String(this.fragment, this.quote);
    }
  };

  URL.prototype['.fragment='] = function(frag) {
    if (frag instanceof Null) {
      return this.fragment = null;
    } else if (frag instanceof String) {
      return this.fragment = frag.value.trim();
    } else {
      throw new Error("Bad URL fragment");
    }
  };

  URL.prototype['.hash'] = URL.prototype['.fragment'];

  URL.prototype['.hash='] = URL.prototype['.fragment='];

  URL.prototype.toString = function() {
    var str;
    str = '';
    if (this.fragment != null) {
      str = "#" + this.fragment + str;
    }
    if (this.query != null) {
      str = "?" + this.query + str;
    }
    if (this.path != null) {
      str = "" + this.path + str;
    }
    if (this.host) {
      if (this.port != null) {
        str = ":" + this.port + str;
      }
      str = "//" + this.host + str;
      if (this.scheme != null) {
        str = this.scheme + ":" + str;
      }
    }
    return str;
  };

  URL.prototype['.string'] = function() {
    return new String(this.toString(), this.quote);
  };

  (function() {
    var supah;
    supah = String.prototype['.+'];
    return String.prototype['.+'] = function() {
      var etc, other;
      other = arguments[0], etc = 2 <= arguments.length ? slice.call(arguments, 1) : [];
      if (other instanceof URL) {
        return other.clone(parseURL.resolve(this.value, other.value));
      } else {
        return supah.call.apply(supah, [this, other].concat(slice.call(etc)));
      }
    };
  })();

  return URL;

})(Object);

module.exports = URL;


},{"../error":23,"../error/type":31,"../object":72,"./boolean":75,"./null":83,"./number":84,"./string":90,"url":12}],92:[function(require,module,exports){
var AT_IDENT, AtRule, BINARY_OPERATOR, BOM, Block, BlockComment, COLOR, Color, Conditional, Directive, EOT, EOTError, Expression, For, Function, Group, IDENT, Ident, Import, Lexer, LineComment, List, Loop, NUMBER, Number, Operation, PUNC, Parser, Property, REGEXP, RegExp, Root, RuleSet, String, SyntaxError, This, Token, UNARY_OPERATOR, UNICODE_RANGE, UNIT, URL, UnicodeRange,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Lexer = require('./lexer');

Token = require('./token');

Expression = require('./node/expression');

Operation = require('./node/expression/operation');

Group = require('./node/expression/group');

Ident = require('./node/expression/ident');

String = require('./node/expression/literal/string');

URL = require('./node/expression/literal/url');

Color = require('./node/expression/literal/color');

Number = require('./node/expression/literal/number');

RegExp = require('./node/expression/literal/regexp');

Function = require('./node/expression/literal/function');

List = require('./node/expression/literal/list');

Block = require('./node/expression/literal/block');

This = require('./node/expression/literal/this');

UnicodeRange = require('./node/expression/literal/unicode-range');

Directive = require('./node/statement/directive');

Import = require('./node/statement/import');

Conditional = require('./node/statement/conditional');

Loop = require('./node/statement/loop');

For = require('./node/statement/for');

Property = require('./node/statement/declaration/property');

AtRule = require('./node/statement/declaration/rule/at-rule');

RuleSet = require('./node/statement/declaration/rule/rule-set');

LineComment = require('./node/comment/line');

BlockComment = require('./node/comment/block');

Root = require('./node/root');

SyntaxError = require('./error/syntax');

EOTError = require('./error/eot');

PUNC = Token.PUNC, UNARY_OPERATOR = Token.UNARY_OPERATOR, BINARY_OPERATOR = Token.BINARY_OPERATOR, IDENT = Token.IDENT, UNIT = Token.UNIT, AT_IDENT = Token.AT_IDENT, NUMBER = Token.NUMBER, COLOR = Token.COLOR, REGEXP = Token.REGEXP, UNICODE_RANGE = Token.UNICODE_RANGE, EOT = Token.EOT, BOM = Token.BOM;

Parser = (function(superClass) {
  var ASSOC, DIRECTIVES, PREC;

  extend(Parser, superClass);

  function Parser() {
    return Parser.__super__.constructor.apply(this, arguments);
  }

  PREC = {
    '(': 100,
    '+@': 99,
    '-@': 99,
    '::': 98,
    '.': 98,
    '*': 50,
    '/': 50,
    '+': 45,
    '-': 45,
    '..': 40,
    '<': 30,
    '<=': 30,
    '>': 30,
    '>=': 30,
    'has': 30,
    'hasnt': 30,
    'is': 20,
    'isnt': 20,
    'in': 18,
    '~': 15,
    'not@': 11,
    ' ': 10,
    ',': 9,
    'and': 8,
    'or': 7,
    '=': 5,
    '|=': 5,
    '>>': 2,
    '<<': 2,
    'if': 0,
    'unless': 0
  };

  ASSOC = {
    '+@': 1,
    '-@': 1,
    'not@': 1,
    '+': 0,
    '-': 0,
    '/': 0,
    '*': 0,
    '.': 0,
    '::': 0,
    '(': 0,
    'and': 0,
    'or': 0,
    'is': 0,
    'isnt': 0,
    '>': 0,
    '>=': 0,
    '<': 0,
    '<=': 0,
    '=': 1,
    '|=': 1,
    ',': 0,
    ' ': 0,
    '<<': 0,
    '>>': 0
  };

  DIRECTIVES = ['return', 'break', 'continue', 'import', 'use'];


  /*
  Node maker.
   */

  Parser.prototype.makeNode = function(type, func) {
    var e, error, node, start;
    node = new type;
    start = node.start = this.position;
    if (func) {
      try {
        if (false === func.call(this, node)) {
          this.moveTo(start);
          return;
        }
      } catch (error) {
        e = error;
        this.moveTo(start);
        throw e;
      }
    }
    if (node.end == null) {
      node.end = this.position;
    }
    return node;
  };


  /*
   */

  Parser.prototype.isStartOfBlock = function() {
    return !!(this.peek(PUNC, '{'));
  };


  /*
  Returns `yes` if after current position there's nothing but whitespace
  followed a block end (`}`).
   */

  Parser.prototype.isEndOfBlock = function() {
    return !!(this.peek(PUNC, '}'));
  };


  /*
   */

  Parser.prototype.parseUnaryOperation = function(prec) {
    var op;
    if (prec == null) {
      prec = 0;
    }
    if (op = this.peek(UNARY_OPERATOR)) {
      if (!(op.value === '-' && this.peek(IDENT))) {
        if (PREC[op.value + "@"] >= prec) {
          return this.makeNode(Operation, function(expr) {
            this.moveTo(op.end);
            expr.start = op.start;
            if (expr.right = this.parseExpression(PREC[op.value + "@"], false, false, false)) {
              expr.operator = op.value;
              return expr.end = expr.right.end;
            } else {
              return false;
            }
          });
        }
      }
    }
  };


  /*
   */

  Parser.prototype.parseRightOperation = function(left, prec, blocks, commas, spaces) {
    var next_op, op, ref, right;
    if (blocks == null) {
      blocks = true;
    }
    if (commas == null) {
      commas = true;
    }
    if (spaces == null) {
      spaces = true;
    }
    next_op = this.peek(BINARY_OPERATOR, null, false);
    while (next_op && (PREC[next_op.value] >= prec)) {
      if (!commas && next_op.value === ',') {
        break;
      }
      if (!spaces && next_op.value === ' ') {
        break;
      }
      op = next_op;
      if (next_op.value === '(') {
        this.moveTo(op.end);
        right = this.parseArguments();
        this.expect(PUNC, ')');
      } else {
        this.moveTo(op.end);
        right = this.parsePrimaryExpression(prec, blocks);
      }
      if (!right) {
        if (op.value === ',') {
          if (!((left instanceof List) && (left.separator === ','))) {
            left = new List([left], ',');
          }
          return left;
        } else if (op.value === ' ') {
          return left;
        }
        if (this.peek(EOT)) {
          throw new EOTError("Unexpected EOT before right side of `" + op.value + "` operation");
        } else {
          throw new SyntaxError("Expected right side of `" + op.value + "` operation");
        }
      }
      next_op = this.peek(BINARY_OPERATOR, null, false);
      while (true) {
        if (!(next_op && ((PREC[next_op.value] > PREC[op.value]) || ((ASSOC[next_op.value] === 1) && (PREC[next_op.value] === PREC[op.value]))))) {
          break;
        }
        right = this.parseRightOperation(right, PREC[next_op.value], blocks, commas);
        next_op = this.peek(BINARY_OPERATOR, null, false);
      }
      if ((ref = op.value) === ' ' || ref === ',') {
        if ((left instanceof List) && (op.value === left.separator)) {
          left.body.push(right);
        } else {
          left = new List([left, right], op.value);
        }
      } else {
        left = new Operation(op.value, left, right);
      }
    }
    return left;
  };


  /*
   */

  Parser.prototype.parseCommaList = function() {
    var comma, item, items, start;
    start = this.position;
    items = [];
    while (item = this.parseExpression(null, false, false)) {
      items.push(item);
      if (!(comma = this.eat(PUNC, ','))) {
        break;
      }
    }
    if (items.length) {
      return items;
    } else {
      this.moveTo(start);
    }
  };


  /*
   */

  Parser.prototype.parseFunctionArguments = function() {
    var args, comma, id, name, op, start, val;
    start = this.position;
    if (this.eat(PUNC, '(')) {
      args = [];
      while (id = this.parseUnquotedString()) {
        name = id.value;
        if (op = this.eat(PUNC, ['='])) {
          if ((op.value === ':') && (this.peek(PUNC, ':'))) {
            break;
          }
          if (!(val = this.parseExpression(0, false, false))) {
            break;
          }
        } else {
          val = null;
        }
        args.push({
          name: name,
          value: val
        });
        if (!(comma = this.eat(PUNC, ','))) {
          break;
        }
      }
      if (this.eat(PUNC, ')')) {
        return args;
      }
    }
    return this.moveTo(start);
  };


  /*
   */

  Parser.prototype.parseArguments = function() {
    return this.parseCommaList() || [];
  };


  /*
   */

  Parser.prototype.parseURL = function() {
    var tok;
    if (tok = this.peek(IDENT, 'url')) {
      return this.makeNode(URL, function(url) {
        var val;
        this.moveTo(tok.end);
        if (!this.eat(PUNC, '(')) {
          return false;
        }
        url.start = tok.start;
        val = this.parseQuotedString();
        if (!val) {
          val = this.makeNode(String, function(str) {
            var results;
            str.value = '';
            results = [];
            while (this.char !== ')') {
              if (this.isEndOfLine()) {
                throw new EOTError("Unterminated `url()`");
              }
              str.value += this.char;
              results.push(this.move());
            }
            return results;
          });
        }
        this.expect(PUNC, ')');
        return url.value = val;
      });
    }
  };


  /*
   */

  Parser.prototype.parseIdent = function() {
    var token;
    if (token = this.peek(IDENT)) {
      return this.makeNode(Ident, function(ident) {
        var ref;
        ident.start = token.start;
        ident.name = token.value;
        ident.value = token.value;
        this.moveTo(token.end);
        if (this.read(PUNC, '(', false)) {
          ident["arguments"] = this.parseArguments();
          this.expect(PUNC, ')');
          if ((ref = this.char) === '!' || ref === '?') {
            if (!this.peek(IDENT, null, false)) {
              ident.name += this.char;
              ident.value += this.char;
              return this.move();
            }
          }
        }
      });
    }
  };


  /*
   */

  Parser.prototype.parseThis = function() {
    var token;
    if (token = this.read(PUNC, '&')) {
      return this.makeNode(This, function() {
        return this.moveTo(token.end);
      });
    }
  };


  /*
   */

  Parser.prototype.parseFunction = function() {
    return this.makeNode(Function, function(func) {
      if (!((func["arguments"] = this.parseFunctionArguments()) && (func.block = this.parseBlock()))) {
        return false;
      }
    });
  };


  /*
   */

  Parser.prototype.parseNumber = function() {
    var token;
    if (token = this.peek(NUMBER)) {
      this.moveTo(token.start);
      return this.makeNode(Number, function(num) {
        num.value = parseFloat(token.value);
        num.unit = token.unit;
        return this.moveTo(token.end);
      });
    }
  };


  /*
  Parse a quoted or unquoted string
   */

  Parser.prototype.parseString = function() {
    return this.parseQuotedString() || this.parseUnquotedString();
  };

  Parser.prototype.parseQuotedString = function() {
    var token;
    if (token = this.read(PUNC, ['"', "'", '`'])) {
      return this.makeNode(String, function(str) {
        var chunk, chunks, quote;
        str.start = token.start;
        quote = token.value;
        chunks = [];
        chunk = '';
        while (true) {
          if (this.isEndOfText()) {
            throw new EOTError("Unterminated string");
          }
          if (this.char === quote) {
            this.move();
            break;
          } else if (this.char === '\\') {
            chunk += this.readEscape();
          } else if (this.char === '{') {
            this.move();
            if (chunk !== '') {
              chunks.push(chunk);
            }
            chunks.push(this.parseExpression(0, false));
            this.expect(PUNC, '}');
            chunk = '';
          } else {
            chunk += this.char;
            this.move();
          }
        }
        if (chunk !== '') {
          chunks.push(chunk);
        }
        if (quote !== '`') {
          str.quote = quote;
        }
        return str.value = chunks;
      });
    }
  };

  Parser.prototype.parseUnquotedString = function() {
    var token;
    if (token = this.peek(IDENT)) {
      return this.makeNode(String, function(str) {
        str.start = token.start;
        str.end = token.end;
        str.value = token.value;
        return this.moveTo(token.end);
      });
    }
  };


  /*
   */

  Parser.prototype.parseRegExp = function() {
    var tok;
    if (tok = this.read(REGEXP)) {
      return this.makeNode(RegExp, function(reg) {
        reg.start = tok.start;
        reg.value = tok.value;
        return reg.flags = tok.flags;
      });
    }
  };


  /*
   */

  Parser.prototype.parseColor = function() {
    var token;
    if (token = this.peek(COLOR)) {
      return this.makeNode(Color, function(color) {
        color.start = token.start;
        color.value = token.value;
        return this.moveTo(token.end);
      });
    }
  };


  /*
   */

  Parser.prototype.parseUnicodeRange = function() {
    var token;
    if (token = this.peek(UNICODE_RANGE)) {
      return this.makeNode(UnicodeRange, function(range) {
        range.start = token.start;
        range.name = token.value;
        range.value = token.value;
        return this.moveTo(token.end);
      });
    }
  };


  /*
   */

  Parser.prototype.parseLiteral = function() {
    return this.parseThis() || this.parseQuotedString() || this.parseNumber() || this.parseColor() || this.parseRegExp() || this.parseURL() || this.parseUnicodeRange() || this.parseIdent();
  };


  /*
  Parenthesized expressions.
   */

  Parser.prototype.parseParens = function() {
    var expr, node, token, unit;
    if (token = this.read(PUNC, '(')) {
      node = (expr = this.parseExpression()) ? new Group(expr) : new List;
      this.expect(PUNC, ')');
      if (unit = this.read(UNIT, null, false)) {
        return new Operation('convert', node, new String(unit.value));
      } else {
        return node;
      }
    }
  };


  /*
   */

  Parser.prototype.parsePrimaryExpression = function(prec, blocks) {
    if (prec == null) {
      prec = 0;
    }
    if (blocks == null) {
      blocks = true;
    }
    return (blocks && (this.parseFunction() || this.parseBlock())) || (this.parseUnaryOperation(prec)) || this.parseParens() || this.parseLiteral();
  };


  /*
   */

  Parser.prototype.parseExpression = function(prec, blocks, commas, spaces) {
    var left;
    if (prec == null) {
      prec = null;
    }
    if (blocks == null) {
      blocks = true;
    }
    if (commas == null) {
      commas = true;
    }
    if (spaces == null) {
      spaces = true;
    }
    if (left = this.parsePrimaryExpression(prec, blocks)) {
      return this.parseRightOperation(left, prec, blocks, commas, spaces);
    }
  };

  Parser.prototype.parseAtRule = function() {
    if (this.char === '@') {
      return this.makeNode(AtRule, function(rule) {
        this.move();
        if (!(rule.name = this.parseString())) {
          throw new SyntaxError("Expected At-rule name after @");
        }
        rule["arguments"] = this.readAtRuleArguments();
        return rule.block = this.parseBlock() || null;
      });
    }
  };


  /*
   */

  Parser.prototype.parseRuleSet = function() {
    var selectors, start;
    start = this.position;
    if (selectors = this.readSelectorList()) {
      if (this.isStartOfBlock()) {
        return this.makeNode(RuleSet, function(rule) {
          var i, len, sel;
          rule.start = selectors[0].start;
          rule.selector = [];
          for (i = 0, len = selectors.length; i < len; i++) {
            sel = selectors[i];
            rule.selector.push(sel.value);
          }
          return rule.block = this.parseBlock();
        });
      }
    }
    return this.moveTo(start);
  };


  /*
  Parse a single property name.
   */

  Parser.prototype.parsePropertyName = function() {
    return this.parseString();
  };


  /*
  Parses the left side of a declaration. This should resolve to an ident or to
  a string. As in any ident or string, interpolation is allowed.
   */

  Parser.prototype.parsePropertyNames = function() {
    var names, str;
    names = [];
    while (str = this.parsePropertyName()) {
      names.push(str);
      if (!this.eatAll(PUNC, ',')) {
        break;
      }
    }
    if (names.length) {
      return names;
    }
  };


  /*
  Parses a `property: value` declaration.
   */

  Parser.prototype.parseProperty = function() {
    var names, op, other, start;
    start = this.position;
    if (names = this.parsePropertyNames()) {
      if (op = this.read(PUNC, ['|', ':'], /[ \t]*/)) {
        other = this.peek(PUNC, ':', false);
        while (true) {
          if (op.value === '|') {
            if (!other) {
              break;
            }
            this.moveTo(other.end);
          } else {
            if (other) {
              break;
            }
          }
          return this.makeNode(Property, function(prop) {
            prop.names = names;
            prop.start = names[0].start;
            prop.conditional = op.value === '|';
            if (!(prop.value = this.parseExpression())) {
              return false;
            }
          });
        }
      }
    }
    return this.moveTo(start);
  };

  Parser.prototype.parseDeclaration = function() {
    return this.parseAtRule() || this.parseRuleSet() || this.parseProperty();
  };


  /*
   */

  Parser.prototype.parseLineComment = function() {
    var token;
    if (token = this.peek(LINE_COMMENT)) {
      return this.makeNode(LineComment, function(comment) {
        comment.comment = token.value;
        return this.move(token.length);
      });
    }
  };


  /*
   */

  Parser.prototype.parseBlockComment = function() {
    var token;
    if (token = this.peek(BLOCK_COMMENT)) {
      return this.makeNode(BlockComment, function(comment) {
        comment.comment = token.value;
        return this.move(token.length);
      });
    }
  };


  /*
  Parse a line or block comment.
   */

  Parser.prototype.parseComment = function() {
    return this.parseLineComment() || this.parseBlockComment();
  };


  /*
  Parse the predicate of a `if` or an `unless` statement.
   */

  Parser.prototype.parseConditionalPredicate = function(node) {
    var els, results, tok;
    if (!(node.condition = this.parseExpression(0, false))) {
      throw new SyntaxError('Expected expression after conditional');
    }
    if (!(node.block = this.parseBlock())) {
      throw new SyntaxError('Expected block after conditional expression');
    }
    try {
      results = [];
      while (this.read(IDENT, 'else')) {
        this.skipWhitespace();
        els = {
          negate: false
        };
        if (tok = this.read(IDENT, ['if', 'unless'])) {
          if (!(els.condition = this.parseExpression(0, false))) {
            throw new SyntaxError("\"Expected expression after `else " + tok.value + "`");
          }
          els.negate = tok.value === 'unless';
        }
        if (!(els.block = this.parseBlock())) {
          throw new SyntaxError('Expected block after `else`');
        }
        node.elses.push(els);
        if (!els.condition) {
          break;
        } else {
          results.push(void 0);
        }
      }
      return results;
    } catch (undefined) {}
  };


  /*
  Parse an `if|unless ... [else if|unless...]... [else]` block.
   */

  Parser.prototype.parseConditional = function() {
    var tok;
    if (tok = this.read(IDENT, ['if', 'unless'])) {
      return this.makeNode(Conditional, function(node) {
        node.start = tok.start;
        node.negate = tok.value === 'unless';
        return this.parseConditionalPredicate(node);
      });
    }
  };


  /*
  Parse a `loop|while|until ...` block.
   */

  Parser.prototype.parseLoop = function() {
    var token;
    if (token = this.read(IDENT, ['while', 'until'])) {
      this.moveTo(token.start);
      return this.makeNode(Loop, function(node) {
        this.moveTo(token.end);
        node.negate = token.value === 'until';
        if (!(node.condition = this.parseExpression(0, false))) {
          throw new SyntaxError("Expected expression after `" + token.value + "`");
        }
        if (!(node.block = this.parseBlock())) {
          throw new SyntaxError("Expected block after `" + token.value + "` expression");
        }
        return node.end = node.block.end;
      });
    }
  };


  /*
  Parses a `for .. in ...` block.
   */

  Parser.prototype.parseFor = function() {
    var tok;
    if (tok = this.read(IDENT, 'for')) {
      return this.makeNode(For, function(f) {
        var arg;
        f.start = tok.start;
        this.moveTo(tok.end);
        arg = this.expect(IDENT);
        if (this.eat(PUNC, ',')) {
          f.key = arg;
          f.value = this.expect(IDENT);
        } else {
          f.value = arg;
        }
        this.expect(IDENT, 'in');
        if (!(f.expression = this.parseExpression(0, false))) {
          throw new SyntaxError("Expected expression after for ... in");
        }
        if (!(f.block = this.parseBlock())) {
          throw new SyntaxError("Expected block after for ... in expression");
        }
      });
    }
  };


  /*
   */

  Parser.prototype.parseDirective = function() {
    var tok;
    if (tok = this.read(IDENT, this.directives)) {
      return this.makeNode(Directive, function(dir) {
        dir.start = tok.start;
        dir.name = tok.value;
        dir["arguments"] = this.parseArguments();
        return dir.end = this.position;
      });
    }
  };


  /*
  Inside a block body, any of the valid statements, delimited with new lines or
  semicolons.
   */

  Parser.prototype.parseStatement = function() {
    return this.parseConditional() || this.parseLoop() || this.parseFor() || this.parseDirective() || this.parseDeclaration() || this.parseExpression();
  };

  Parser.prototype.parseBody = function() {
    var stmt, stmts;
    stmts = [];
    while (true) {
      this.eatAll(PUNC, ';');
      this.skipWhitespace();
      if (!(stmt = this.parseStatement())) {
        break;
      }
      stmts.push(stmt);
      if (!(this.isEndOfBlock() || this.isEndOfLine())) {
        this.expect(PUNC, ';');
      }
    }
    return stmts;
  };


  /*
  Parse a block and all its sublocks.
   */

  Parser.prototype.parseBlock = function() {
    var brace;
    if (brace = this.read(PUNC, '{')) {
      return this.makeNode(Block, function(block) {
        block.start = brace.start;
        block.body = this.parseBody();
        return this.expect(PUNC, '}');
      });
    }
  };


  /*
   */

  Parser.prototype.parseRoot = function() {
    return this.makeNode(Root, function(doc) {
      doc.source = this.source;
      if (this.eat(BOM, null, false)) {
        doc.bom = true;
      }
      return doc.body = this.parseBody();
    });
  };

  Parser.prototype.prepare = function(source) {
    Parser.__super__.prepare.apply(this, arguments);
    return this.directives = DIRECTIVES;
  };

  Parser.prototype.parse = function(source) {
    this.prepare(source);
    return this.parseRoot();
  };

  return Parser;

})(Lexer);

module.exports = Parser;


},{"./error/eot":24,"./error/syntax":30,"./lexer":38,"./node/comment/block":43,"./node/comment/line":44,"./node/expression":45,"./node/expression/group":46,"./node/expression/ident":47,"./node/expression/literal/block":49,"./node/expression/literal/color":50,"./node/expression/literal/function":51,"./node/expression/literal/list":52,"./node/expression/literal/number":53,"./node/expression/literal/regexp":54,"./node/expression/literal/string":55,"./node/expression/literal/this":56,"./node/expression/literal/unicode-range":57,"./node/expression/literal/url":58,"./node/expression/operation":59,"./node/root":60,"./node/statement/conditional":62,"./node/statement/declaration/property":64,"./node/statement/declaration/rule/at-rule":66,"./node/statement/declaration/rule/rule-set":67,"./node/statement/directive":68,"./node/statement/for":69,"./node/statement/import":70,"./node/statement/loop":71,"./token":94}],93:[function(require,module,exports){
var Class, Plugin,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Class = require('./class');

Plugin = (function(superClass) {
  extend(Plugin, superClass);

  function Plugin() {
    return Plugin.__super__.constructor.apply(this, arguments);
  }

  Plugin.prototype.use = function(context) {
    return this.NOT_IMPLEMENTED;
  };

  return Plugin;

})(Class);

module.exports = Plugin;


},{"./class":15}],94:[function(require,module,exports){
var Class, Token,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Class = require('./class');

Token = (function(superClass) {
  extend(Token, superClass);

  Token.IDENT = 'Ident';

  Token.UNIT = 'Unit';

  Token.AT_IDENT = 'AtIdent';

  Token.STRING = 'String';

  Token.COLOR = 'Color';

  Token.REGEXP = 'RegExp';

  Token.NUMBER = 'Number';

  Token.PUNC = 'Punc';

  Token.UNARY_OPERATOR = 'UnaryOperator';

  Token.BINARY_OPERATOR = 'BinaryOperator';

  Token.WHITESPACE = 'Whitespace';

  Token.SELECTOR = 'Selector';

  Token.SIMPLE_SELECTOR = 'SimpleSelector';

  Token.COMBINATOR = 'Combinator';

  Token.UNICODE_RANGE = 'UnicodeRange';

  Token.EOT = 'EOT';

  Token.BOM = 'BOM';


  /*
  Returns length of token, if it has a start and an end. Otherwise, returns
  `null`.
   */

  Token.property('length', {
    get: function() {
      if (this.start && this.end) {
        return this.end - this.start;
      } else {
        return null;
      }
    }
  });


  /*
   */

  function Token(type, value, start, end) {
    this.type = type;
    this.value = value != null ? value : null;
    this.start = start != null ? start : null;
    this.end = end != null ? end : null;
  }

  return Token;

})(Class);

module.exports = Token;


},{"./class":15}],95:[function(require,module,exports){
module.exports = (require('../package')).version;


},{"../package":97}],96:[function(require,module,exports){
var Plugin, Visitor,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Plugin = require('./plugin');

Visitor = (function(superClass) {
  extend(Visitor, superClass);

  function Visitor() {
    return Visitor.__super__.constructor.apply(this, arguments);
  }

  Visitor.prototype.use = function(context) {
    return context.useVisitor(this);
  };

  Visitor.prototype.visit = function(node) {
    var method;
    method = "visit" + node.type;
    if (!(method in this)) {
      throw new Error("Don't know how visit node of type " + node.type);
    }
    return this[method].call(this, node);
  };

  return Visitor;

})(Plugin);

module.exports = Visitor;


},{"./plugin":93}],97:[function(require,module,exports){
module.exports = require('../package.json');


},{"../package.json":13}]},{},[14]);
