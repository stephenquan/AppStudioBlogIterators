function* gen() {
  console.log( yield 1 )
  console.log( yield 2 )
  console.log( yield 3 )
}

let iter = gen()
let v = iter.next()
console.log( JSON.stringify(v) )
v = iter.next( v.value * v.value )
console.log( JSON.stringify(v) )
v = iter.next( v.value * v.value )
console.log( JSON.stringify(v) )
v = iter.next( v.value * v.value )
console.log( JSON.stringify(v) )
