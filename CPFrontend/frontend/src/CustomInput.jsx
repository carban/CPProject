import React, { Component } from "react";
import { Table, Button, Row, Col, Container } from "reactstrap";

class CustomInput extends Component {
    constructor(props) {
        super(props);
        this.state = {
            m: props.m,
            d: props.d,
            sol: props.sol,
            result: props.result,

            disponibilidad: props.disponibilidad,
            evitar: props.evitar,
            model: props.model
        }
    }

    render() {

        const theHead = (this.state.result) ?
            this.state.sol.map((c, i) => (
                <th key={i}>{c}</th>
            ))
            : this.state.d.map((c, i) => (
                <th key={i}>{i + 1}</th>
            ));

        const theTable = this.state.m.map((r, i) => (
            <tr key={i}>
                {
                    r.map((c, j) => (
                        <td key={j}>

                            {
                                this.state.m[i][j] === 1 || this.state.m[i][j] === 0 ? (
                                    <div className="container">
                                        <input type="checkbox" checked={this.state.m[i][j] === 1 ? "checked" : ""} readOnly />
                                        <span className="checkmark"></span>
                                    </div>
                                ) : (
                                        c
                                    )
                            }
                        </td>
                    ))
                }
            </tr>
        ))

        const TheDuration = this.state.d.map((c, i) => (
            <td key={i}>
                {c}
            </td>
        ))

        const compute = !this.state.result ?
            <center>
                <Button color="primary" onClick={() => this.props.comp(this.state)}> Compute </Button>
            </center>
            : true;

        const dispo = this.state.disponibilidad.map((e, i) => (
            <tr key={i}>
                <td>{e[0]}</td>
                <td>{e[1]}</td>
            </tr>
        ))

        const tableDispo = this.state.model === 2 ? (
            <div>
                <center>
                    <h4 className="grin"><b>Availability</b></h4>
                </center>
                <Table border="1" size="sm" hover responsive bordered >
                    <thead>
                        <tr>
                            <th>Actor</th>
                            <th>Duration</th>
                        </tr>
                    </thead>
                    <tbody>
                        {dispo}
                    </tbody>
                </Table>
            </div>
        ) : true;

        const evi = this.state.evitar.map((e, i) => (
            <tr key={i}>
                <td>{e[0]}</td>
                <td>{e[1]}</td>
            </tr>
        ))

        const tableEvi = this.state.model === 2 ? (
            <div>
                <center>
                    <h4 className="grin"><b>Avoid</b></h4>
                </center>
                <Table border="1" size="sm" hover responsive bordered>
                    <thead>
                        <tr>
                            <th>Actor</th>
                            <th>Actor</th>
                        </tr>
                    </thead>
                    <tbody>
                        {evi}
                    </tbody>
                </Table>
            </div>
        ) : true

        return (
            <div>
                <Table size="md" hover responsive bordered>
                    <thead>
                        <tr>
                            <th>Scenes</th>
                            {theHead}
                            <th>Cost</th>
                        </tr>
                    </thead>
                    <tbody>
                        {theTable}
                        <tr>
                            <td>Duration</td>
                            {TheDuration}
                        </tr>
                    </tbody>
                </Table>
                <Container>
                    <Row md="6">
                        <Col md="6">
                            {tableDispo}
                        </Col>
                        <Col md="6">
                            {tableEvi}
                        </Col>
                    </Row>
                </Container>
                {compute}
            </div >
        )
    }
}

export default CustomInput;