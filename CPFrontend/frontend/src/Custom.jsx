import React, { Component } from "react";
import CustomInput from "./CustomInput.jsx";
import axios from "axios";
import { Input, Button, Col } from "reactstrap";


class Custom extends Component {
    constructor(props) {
        super(props);
        this.state = {
            path: "",
            charged_preview: false,
            result: false,
            sol: [],
            costo: 0,
            m: [],
            d: [],
            solved_m: [],
            solved_d: [],

            model: 1,
            disponibilidad: [],
            evitar: [],
            tiempo: 0
        }
    }

    handleInput = e => {
        this.setState({ [e.target.name]: e.target.value });
    }

    processSol = obj => {
        var { sol, costo } = obj;

        var solution = [];
        var solDuration = [];

        var s = sol.trim();
        s = s.replace("[", "");
        s = s.replace("]", "");
        s = s.split(",");

        for (let i = 0; i < s.length; i++) {
            s[i] = parseInt(s[i]);
        }

        var row = [];
        for (let i = 0; i < this.state.m.length; i++) {
            row.push(this.state.m[i][0]);
            for (let j = 1; j < this.state.d.length + 1; j++) {
                row.push(this.state.m[i][s[j - 1]]);
                // solution[i][j] = this.state.m[i][s[j - 1]];
            }
            row.push(this.state.m[i][this.state.m[0].length - 1]);
            solution.push(row);
            row = [];
        }

        for (let j = 0; j < this.state.d.length; j++) {
            solDuration[j] = this.state.d[s[j] - 1];
        }

        // console.table(solution);
        // console.log(solDuration);

        // MODEL 2 *********************************
        var tempo = 0;
        if (this.state.model === 2) {
            var { tiempo } = obj;
            tempo = tiempo;
        }

        alert("Solved !");
        this.setState({ sol: s, solved_m: solution, solved_d: solDuration, costo: costo, result: true, tiempo: tempo });
    }

    sendPetition = obj => {

        var MODEL1 = "http://localhost:3030/api/solve/model1/file/";
        var MODEL2 = "http://localhost:3030/api/solve/model2/file/"
        var URL = "";

        if (this.state.model === 1) {
            URL = MODEL1;
        } else {
            URL = MODEL2;
        }

        axios.post(URL, { file: this.state.path })
            .then(res => {
                if (res.data.msg === "UNSATISFIABLE") {
                    alert("UNSATISFIABLE");
                }else{
                    this.processSol(res.data);
                }
                
            })
            .catch(err => {
                console.log(err);
            })
    }

    decodeVars = obj => {
        var { model, actores, escenas, duracion } = obj;

        var matrix = [];
        var times = [];

        var a = actores.trim();
        a = a.replace("{", "");
        a = a.replace("}", "");
        a = a.split(",");

        var e = escenas.trim();
        e = e.replace("[", "");
        e = e.replace("]", "");
        e = e.split("|");

        e.splice(0, 1);
        e.splice(e.length - 1, 1);

        var d = duracion.trim();
        d = d.replace("[", "");
        d = d.replace("]", "");
        d = d.split(",");

        var aux = [];
        for (let i = 0; i < a.length; i++) {
            aux.push(a[i].trim());
            var row = e[i].split(",");
            for (let j = 0; j < row.length; j++) {
                aux.push(parseInt(row[j].trim()));
            }
            matrix.push(aux);
            aux = [];
        }

        for (let i = 0; i < d.length; i++) {
            times.push(parseInt(d[i].trim()));
        }

        // MODEL 2 *********************************
        var dispo = [];
        var evito = [];
        if (model === 2) {
            var { disponibilidad, evitar } = obj;

            var di = disponibilidad.trim();
            di = di.replace("[", "");
            di = di.replace("]", "");
            di = di.split("|");

            di.splice(0, 1);
            di.splice(di.length - 1, 1);

            var ro;
            for (let i = 0; i < di.length; i++) {
                di[i] = di[i].trim();
                ro = di[i].split(",");
                dispo.push([ro[0], parseInt(ro[1])]);
            }

            var ev = evitar.trim();
            ev = ev.replace("[", "");
            ev = ev.replace("]", "");
            ev = ev.split("|");

            ev.splice(0, 1);
            ev.splice(ev.length - 1, 1);

            var ro2;
            for (let i = 0; i < ev.length; i++) {
                ev[i] = ev[i].trim();
                ro2 = ev[i].split(",");
                evito.push([ro2[0], ro2[1]]);
            }

            // console.log(dispo);
            // console.log(evito);

        }

        this.setState({ m: matrix, d: times, charged_preview: true, model: model, disponibilidad: dispo, evitar: evito });
    }

    getFormat = () => {
        axios.post("http://localhost:3030/api/fileProcess/", { file: this.state.path })
            .then(res => {
                this.decodeVars(res.data);
            })
            .catch(err => {
                console.log(err);
            })
    }

    preview = () => {
        if (this.state.path !== "") {
            this.setState({ charged_preview: false, result: false });
            this.getFormat();
        }
    }

    render() {
        return (
            <div>
                <center>
                    <Col md="7" sm="12" lg ="7">
                        <Input placeholder="Write the absolute path of your .dzn" className="path" onChange={this.handleInput} vale={this.state.path} name="path" type="text" />
                        <br/>
                        <Button color="success" onClick={this.preview}>Preview</Button>
                    </Col>
                </center>
                <br/>
                {
                    (this.state.charged_preview) ? <CustomInput model={this.state.model} disponibilidad={this.state.disponibilidad} evitar={this.state.evitar} result={false} sol={[]} m={this.state.m} d={this.state.d} comp={this.sendPetition} /> : true
                }
                <hr />
                {
                    (this.state.result) ? <h1>Solution with Cost: {this.state.costo}</h1> : true
                }
                {
                    (this.state.result && this.state.model === 2) ? <h1>Shared Time: {this.state.tiempo}</h1> : true
                }
                {
                    (this.state.result) ? <CustomInput model={this.state.model} disponibilidad={this.state.disponibilidad} evitar={this.state.evitar} result={true} sol={this.state.sol} m={this.state.solved_m} d={this.state.solved_d} comp={this.sendPetition} /> : true
                }
            </div>
        )
    }
}

export default Custom;