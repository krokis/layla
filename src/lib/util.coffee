module.exports =
  isString: (obj) -> "[object String]" is toString.call obj
