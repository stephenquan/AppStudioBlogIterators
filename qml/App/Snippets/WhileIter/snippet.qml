function *cities() {
    yield { name: "Hawaii", distance: 4221.73 }
    yield { name: "Los Angeles", distance: 96.65 }
    yield { name: "New York City", distance: 3853.10 }
    yield { name: "Redlands", distance: 1.12 }
    yield { name: "Seattle", distance: 1566.70 }
}

const iter = cities()
let city = iter.next()
while ( !city.done ) {
    console.log( JSON.stringify( city.value ) )
    city = iter.next()
}
