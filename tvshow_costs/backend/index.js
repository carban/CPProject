const path = require('path');
const express = require('express');
const cors = require('cors');
const { exec } = require('child_process');
const bodyParser = require('body-parser')
const app = express();

// Settings
app.use(express.urlencoded({ extended: true }));
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(cors());
app.set('port', process.env.PORT || 3030);

// Listening
const server = app.listen(app.get('port'), () => {
    console.log("Server on port: " + app.get('port'));
});

const pathMini = "/home/carban/PortableApps/MiniZincIDE-2.3.2-bundle-linux/bin/minizinc ";
const pathModel = "/home/carban/Documents/ConstraintProgramming/CPProject/pleaseGodModel3.mzn";
const pathModel2 = "/home/carban/Documents/ConstraintProgramming/CPProject/MOdelPart2.mzn";


app.post('/api/solve/model1/', (req, res) => {

    const { actores, escenas, duracion } = req.body;

    const inpp = ' -D \" ' + actores + ' ' + escenas + ' ' + duracion + '"';

    var command = '/..' + pathMini + ' --solver Chuffed ' + pathModel + inpp;

    // console.log(command);

    // DIRECTO
    try {
        exec(command, (err, stdout, stderr) => {
            if (stdout.length != 24) {

                var fS = stdout.split(";");
                console.log({ sol: fS[0], costo: fS[1] });
                res.json({ sol: fS[0], costo: fS[1] });
            } else {
                console.log('UNSATISFIABLE');
                res.json({ msg: 'UNSATISFIABLE' });
            }
        });
    } catch (error) {
        res.json({ error: error });
    }
})

app.post("/api/solve/model1/fileProcess/", (req, res) => {
    const { file } = req.body;
    try {
        exec("cat "+file, (err, stdout, stderr) => {
            var s = stdout;
            s = s.split("\n").join("");
            s = s.trim();
            s = s.split(";");

            var vals = [];

            for (let i = 0; i < 3; i++) {
                s[i] = s[i].trim();
                var aux = s[i].split("=");
                vals.push(aux[1]);
            }
            res.json({actores: vals[0], escenas: vals[1], duracion: vals[2]});

        });
    } catch (error) {
        res.json({ error: error });
    }

});

app.post('/api/solve/model1/file/', (req, res) => {

    const { file } = req.body;

    var command = '/..' + pathMini + ' --solver Chuffed ' + pathModel + ' ' +file;

    console.log(command);

    // DIRECTO
    try {
        exec(command, (err, stdout, stderr) => {
            if (stdout.length != 24) {

                var fS = stdout.split(";");
                console.log({ sol: fS[0], costo: fS[1] });
                res.json({ sol: fS[0], costo: fS[1] });
            } else {
                console.log('UNSATISFIABLE');
                res.json({ msg: 'UNSATISFIABLE' });
            }
        });
    } catch (error) {
        res.json({ error: error });
    }
})