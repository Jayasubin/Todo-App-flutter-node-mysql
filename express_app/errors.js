const onDBErr = (res) => {
    console.log('Connection failed')
    return res.status(404).json({ result: 'Fail', info: "Database Error" })
}

const onReqErr = (err, res) => {
    console.log('Operation failed')
    console.log(err)
    return res.status(404).json({ result: 'Fail', info: "Request Error" })
}

const onInvalid = (res) => {
    console.log('Accessed Nonexistent resource')
    return res.status(404).json({ result: 'Fail', info: "That leads nowhere" })
}

module.exports = { onDBErr, onReqErr, onInvalid }