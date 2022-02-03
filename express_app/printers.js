const onListen = (port) => console.log(`Server running : ${port}`)

const onReq = (req, res, next) => {
    console.log(`${req.method} request at ${req.path}`)
    next()
}

const onSuccess = () => console.log('Success')

module.exports = { onListen, onReq, onSuccess }