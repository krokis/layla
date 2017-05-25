Plugin = require '../../plugin'


UNITS =
  '1cm':     '10mm'
  '40q':     '1cm'
  '1in':     '25.4mm'
  '96px':    '1in'
  '72pt':    '1in'
  '1pc':     '12pt'
  '180deg':  "#{Math.PI}rad"
  '1turn':   '360deg'
  '400grad': '1turn'
  '1s':      '1000ms'
  '1kHz':    '1000Hz'
  '1dppx':   '96dpi'
  '1dpcm':   '2.54dpi'


###
###
class CSSUnitsPlugin extends Plugin

  use: (context) ->


module.exports = CSSUnitsPlugin
