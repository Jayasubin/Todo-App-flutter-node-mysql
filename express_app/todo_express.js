const express = require("express");
const mysql = require("mysql");
const parser = require("body-parser");
const path = require("path");

//to log
const { onListen, onReq, onSuccess } = require("./printers");
const { onDBErr, onReqErr, onInvalid } = require("./errors");

//to upload image
var multer = require("multer");
var fs = require("fs");
var upload = multer({ dest: "uploads/" });

const expressApp = express();
const port = 2500;

const pool = mysql.createPool({
    connectionLimit: 5,
    host: "localhost",
    user: "todoapp",
    password: "todoapp@1234$",
    database: "todo_express_app",
});

expressApp.use(onReq);
expressApp.use(parser.json());
expressApp.use(parser.urlencoded({ extended: false }));

// expressApp.get('/todo_express/api/todos/all', (req, res) => {
//     pool.getConnection((err, connection) => {
//         if (err) onDBErr(res)

//         else {
//             connection.query('SELECT id, title, time FROM todos', (err, rows) => {
//                 connection.release()
//                 if (err) onReqErr(res)

//                 else {
//                     onSuccess()
//                     return res.status(200).json({ result: 'success', rows })
//                 }
//             })
//         }
//     })
// });

expressApp.get("/todo_express/api/todos/pending", (req, res) => {
    pool.getConnection((err, connection) => {
        if (err) onDBErr(res);
        else {
            connection.query(
                "SELECT id, title, time FROM todos WHERE time IS NULL",
                (err, rows) => {
                    connection.release();
                    if (err) {
                        onReqErr(err, res);
                    } else {
                        onSuccess();
                        return res
                            .status(200)
                            .json({ result: "success", info: "Pending Todos", rows });
                    }
                }
            );
        }
    });
});

expressApp.get("/todo_express/api/todos/completed", (req, res) => {
    pool.getConnection((err, connection) => {
        if (err) onDBErr(res);
        else {
            connection.query(
                "SELECT id, title, time FROM todos WHERE time IS NOT NULL",
                (err, rows) => {
                    connection.release();
                    if (err) {
                        onReqErr(err, res);
                    } else {
                        onSuccess();
                        return res
                            .status(200)
                            .json({ result: "success", info: "Completed Todos", rows });
                    }
                }
            );
        }
    });
});

expressApp.get("/todo_express/api/todos/details/:id", (req, res) => {
    pool.getConnection((err, connection) => {
        if (err) onDBErr(res);
        else {
            connection.query(
                "SELECT * FROM todos WHERE id = ?", [req.params.id],
                (err, rows) => {
                    connection.release();
                    if (err) onReqErr(err, res);
                    else {
                        onSuccess();
                        return res
                            .status(200)
                            .json({ result: "success", info: "Todo Details", rows });
                    }
                }
            );
        }
    });
});

expressApp.post("/todo_express/api/todos", (req, res) => {
    pool.getConnection((err, connection) => {
        if (err) onDBErr(res);
        else {
            const content = req.body;
            connection.query("INSERT INTO todos SET ?", content, (err, rows) => {
                connection.release();
                if (err) onReqErr(err, res);
                else {
                    onSuccess();
                    return res
                        .status(200)
                        .json({ result: "success", info: "Added one item" });
                }
            });
        }
    });
});

expressApp.put("/todo_express/api/todos/edit/:id", (req, res) => {
    pool.getConnection((err, connection) => {
        if (err) onDBErr(res);
        else {
            const { title, description } = req.body;
            connection.query(
                "UPDATE todos SET title = ?, description = ? WHERE id = ?", [title, description, req.params.id],
                (err, rows) => {
                    connection.release();
                    if (err) onReqErr(err, res);
                    else {
                        onSuccess();
                        return res
                            .status(200)
                            .json({ result: "success", info: "Edited one item" });
                    }
                }
            );
        }
    });
});

//file upload request
expressApp.post(
    "/todo_express/api/todos/:id/upload",
    upload.single("picture"),
    function(req, res) {
        var src = fs.createReadStream(req.file.path);

        var pos = req.file.originalname.split(".").length - 1;
        var extension = req.file.originalname.split(".")[pos];

        var dest = fs.createWriteStream(
            "uploads/" + req.params.id + "." + extension
        );
        src.pipe(dest);
        src.on("end", function() {
            fs.unlinkSync(req.file.path);
            //res.status(200).json({ result: "success", info: "Added one " });

            //add path to file in db
            pool.getConnection((err, connection) => {
                if (err) onDBErr(res);
                else {
                    var attachment = path.join(
                        __dirname,
                        `/uploads/${req.params.id}.${extension}`
                    );

                    connection.query(
                        "UPDATE todos SET attachment =? WHERE id=?", [attachment, req.params.id],
                        (err, rows) => {
                            connection.release();
                            if (err) onReqErr(err, res);
                            else {
                                onSuccess();
                                return res.status(200).json({
                                    result: "success",
                                    info: "Added one picture",
                                });
                            }
                        }
                    );
                }
            });
        });
        src.on("error", function(err) {
            res.status(400).json({ result: "fail", info: "Something went wrong" });
            console.log("Failed to upload");
        });
    }
);

expressApp.put("/todo_express/api/todos/update/:id", (req, res) => {
    pool.getConnection((err, connection) => {
        if (err) onDBErr(res);
        else {
            //need logic correction

            const { time } = req.body;
            connection.query(
                "UPDATE todos SET time = ? WHERE id = ?", [time, req.params.id],
                (err, rows) => {
                    connection.release();
                    if (err) onReqErr(err, res);
                    else {
                        onSuccess();
                        return res
                            .status(200)
                            .json({ result: "success", info: "Updated one item" });
                    }
                }
            );
        }
    });
});

expressApp.delete("/todo_express/api/todos/:id", (req, res) => {
    pool.getConnection((err, connection) => {
        if (err) onDBErr(res);
        else {
            connection.query(
                "DELETE FROM todos WHERE id = ?", [req.params.id],
                (err, rows) => {
                    connection.release();
                    if (err) onReqErr(err, res);
                    else {
                        onSuccess();
                        return res
                            .status(200)
                            .json({ result: "success", info: "Deleted one item" });
                    }
                }
            );
        }
    });
});

expressApp.get("*", (req, res) => onInvalid(res));

expressApp.listen(port, onListen(port));